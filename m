Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A37E4E3254;
	Thu, 17 Sep 2026 15:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660382; cv=none; b=mJptcdu5f+kAiyFBqdY2iGrqxbiOA7+2wLfEhTR8/SUPNtFDYgUhY2GhOMxO8g/CmSq7hnjYVFiv1TyId76fmjGXDLjUZ3a83c9YIXbpZBblrt3FfzdkXrCPxXaa9wcnpGW1AaLIFO7qiHdpfwrF72rmU0/jLS+ZOaHHhxtc1jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660382; c=relaxed/simple;
	bh=FtEnFossfPEEaZJS0a3qXTrhkeAkih2BrP491459fO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dNU7mfc7bHl9LpA6/WFbRvxx2Z53qmtGR8vzSkQDLao86Pq7ZuzhJgNAT/rpktBgzqAIPic954Ti5zi2DKK1//jCYqRh+TO81hf1hXJxIut/+r4x7oRP0yrVK//Zbr9LS3s049NT8V4qqekR7wFROhBxPp9s9S00AC68qiisTlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2ZzUqWQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2ZzUqWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E751F000FF;
	Thu, 17 Sep 2026 15:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660381;
	bh=hwjK85WqO+mrXCIPmaXRLQJk3aI2Ba8ecOCV+43Usf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2ZzUqWQS3iomVTvJArHWI/uAsXr7P8TyRh7NCiOKLga4zHsIZS3bdtcdvoeuzzBQ
	 OaNIj0v7RNONbM+Ol5nz+NB+Ta2fgwfrKWqs+RsMW94c9elTX9xiXnxvIJp4YZF+1Z
	 z8GMJVK2NAB5GUAvvTIAkBx9ViSDLm+XpK4vj7Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 7.2 572/733] landlock: Fix use-after-free of the sources parent directory
Date: Thu, 17 Sep 2026 16:14:40 +0100
Message-ID: <20260917151406.610551390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit 2c6dc792538260a8087ac5b22c31b3b8e47c85d6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/fs.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -1222,11 +1222,12 @@ static int current_check_refer_path(stru
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
 	allow_parent1 = collect_domain_accesses(subject->domain, mnt_dir.dentry,
@@ -1235,8 +1236,10 @@ static int current_check_refer_path(stru
 	allow_parent2 = collect_domain_accesses(subject->domain, mnt_dir.dentry,
 						new_dir->dentry,
 						&layer_masks_parent2);
-	if (allow_parent1 && allow_parent2)
+	if (allow_parent1 && allow_parent2) {
+		dput(old_parent);
 		return 0;
+	}
 
 	/*
 	 * To be able to compare source and destination domain access rights,
@@ -1248,8 +1251,10 @@ static int current_check_refer_path(stru
 		    subject->domain, &mnt_dir, access_request_parent1,
 		    &layer_masks_parent1, &request1, old_dentry,
 		    access_request_parent2, &layer_masks_parent2, &request2,
-		    exchange ? new_dentry : NULL))
+		    exchange ? new_dentry : NULL)) {
+		dput(old_parent);
 		return 0;
+	}
 
 	if (request1.access) {
 		request1.audit.u.path.dentry = old_parent;
@@ -1259,6 +1264,7 @@ static int current_check_refer_path(stru
 		request2.audit.u.path.dentry = new_dir->dentry;
 		landlock_log_denial(subject, &request2);
 	}
+	dput(old_parent);
 
 	/*
 	 * This prioritizes EACCES over EXDEV for all actions, including


