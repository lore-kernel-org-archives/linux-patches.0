Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24AD65192;
	Wed, 30 Sep 2026 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790225; cv=none; b=qCO56TrI32BzvMZyy7/RBlYM3SxbibZUrvJoQQ9OAiKm2bNYp9GF12V9t+HmobG7mqb1QtzyOLjox8Lm7ccQKvxXoRFLT7aMB5jlL2hSIMglD7StYjzLw2MA5npoYlVgvYlWPgi+yMPbawGxEpZSYC2Q9qBhPDTXwtrjmiYZqPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790225; c=relaxed/simple;
	bh=WR1A9zm4skBWveTqTXaTzjMiaewSEc6tMLmroB7nfeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fLDbF6701gDWlfgPJXta9MiMCuDk5dK0xGUGEDBLLhUfwqmHFAnSUChCYnl3Rj5XT9As5vVT7nigWfr2Fmr0INQMSB7RGoat4qcs3MFbwKkoInUkHLAML2dGuSdjn1qg4AYfyiplaUO/dzN1sJYmYBQNkR66PVoeikP78cY/NQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMp+zvvK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMp+zvvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096C91F000FF;
	Wed, 30 Sep 2026 17:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790224;
	bh=totW2jo6aXDihgLjBEigUDU705BxNflKqDTFLSY2S74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMp+zvvKSUrZqnTrPP6Y5W7wYqgV2HyNyBOQ+WWpbDHFPJZr73JIjM4NPluXXo5xG
	 XPsoiznVfHppFRogVrhIdL5eDVM5HLuoq+kUW931sfwo+MxbZzsaV5J5ANzNY5arF+
	 Ejww9kXIcMVO9+gj9OkzqrB1HFoVvI10bBjwNVtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 754/877] landlock: Fix use-after-free of the sources parent directory
Date: Wed, 30 Sep 2026 17:27:45 +0200
Message-ID: <20260930152430.968364253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

[ Upstream commit 2c6dc792538260a8087ac5b22c31b3b8e47c85d6 ]

current_check_refer_path() reads old_dentry->d_parent without holding a
reference nor a lock on it, and then dereferences it in
collect_domain_accesses() and in the audit record.

A reference on a child does not pin its parent: __d_move() reassigns
dentry->d_parent and drops the reference the child held on its former
parent.  hook_path_rename() is not affected because the rename path
calls lock_rename() before the hook, so the source cannot be reparented
under it.  hook_path_link() has no such protection: filename_linkat()
holds a reference on the source dentry but neither locks nor references
its parent, so a concurrent rename(2) can reparent the source while
security_path_link() runs, and the former parent can then be removed and
freed while the hook walks it.

A process can trigger this after entering a Landlock domain that handles
at least one filesystem access right.  The process can then race a
linkat(2) loop against rename(2) and rmdir(2):

  BUG: KASAN: slab-use-after-free in collect_domain_accesses+0x278/0x290
  Read of size 4 at addr ffff888160bd53f4 by task llrepro2/549
   collect_domain_accesses+0x278/0x290
   current_check_refer_path+0x952/0x1120
   security_path_link+0x1be/0x320
   filename_linkat+0x342/0x6d0
   __x64_sys_linkat+0xfa/0x150
  Freed by task 562:
   kmem_cache_free+0x139/0x4c0
   i_callback+0x4b/0x80
   rcu_core+0x7dc/0x10a0

Take a reference on the dentry selected as the source parent, using
dget() for the common-mount-root case and dget_parent() otherwise.
Release it after the hierarchy walk and synchronous audit logging.

Cc: stable@vger.kernel.org
Fixes: b91c3e4ea756 ("landlock: Add support for file reparenting with LANDLOCK_ACCESS_FS_REFER")
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Tested-by: Günther Noack <gnoack3000@gmail.com>
Link: https://patch.msgid.link/E9CDD9E6-E960-4DE2-B1AC-5667D52ABB3E@doyensec.com
[mic: Clarify the caller, reachability, and reference handling]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
[ adapted to older Landlock helpers using dom and lacking audit arguments. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/fs.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -1192,11 +1192,12 @@ static int current_check_refer_path(stru
 	/*
 	 * old_dentry may be the root of the common mount point and
 	 * !IS_ROOT(old_dentry) at the same time (e.g. with open_tree() and
-	 * OPEN_TREE_CLONE).  We do not need to call dget(old_parent) because
-	 * we keep a reference to old_dentry.
+	 * OPEN_TREE_CLONE).  Pin the dentry used as old_parent in either case.
+	 * Otherwise, dget_parent() safely fetches and pins the current parent
+	 * against a concurrent rename(2).
 	 */
-	old_parent = (old_dentry == mnt_dir.dentry) ? old_dentry :
-						      old_dentry->d_parent;
+	old_parent = (old_dentry == mnt_dir.dentry) ? dget(old_dentry) :
+						      dget_parent(old_dentry);
 
 	/* new_dir->dentry is equal to new_dentry->d_parent */
 	allow_parent1 = collect_domain_accesses(dom, mnt_dir.dentry, old_parent,
@@ -1204,8 +1205,10 @@ static int current_check_refer_path(stru
 	allow_parent2 = collect_domain_accesses(
 		dom, mnt_dir.dentry, new_dir->dentry, &layer_masks_parent2);
 
-	if (allow_parent1 && allow_parent2)
+	if (allow_parent1 && allow_parent2) {
+		dput(old_parent);
 		return 0;
+	}
 
 	/*
 	 * To be able to compare source and destination domain access rights,
@@ -1216,8 +1219,11 @@ static int current_check_refer_path(stru
 	if (is_access_to_paths_allowed(
 		    dom, &mnt_dir, access_request_parent1, &layer_masks_parent1,
 		    old_dentry, access_request_parent2, &layer_masks_parent2,
-		    exchange ? new_dentry : NULL))
+		    exchange ? new_dentry : NULL)) {
+		dput(old_parent);
 		return 0;
+	}
+	dput(old_parent);
 
 	/*
 	 * This prioritizes EACCES over EXDEV for all actions, including


