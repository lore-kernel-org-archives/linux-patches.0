Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FBC82871;
	Wed, 19 Jun 2024 13:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802208; cv=none; b=rGoY9h7BTi8eukZSX7UVRyZ61NFDuyLjZ9GtYA9tr/ePpJG4HCcVbf7u3JfDXMuOOtuiBb7DkZi6dM/8HMQ3Dd5fx06X2y8LnNoKS8EFHEdakHNO7LHj9cNLQPNAAR1ZekDVmTcc3XnFZR3l1ewTP1he+9Yw7DHqQlfqbXY7hjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802208; c=relaxed/simple;
	bh=IY8XecQT/fIsxzctvn33gizZA09IQTGDdTgmWxmAK/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ReBt6dG+NsnEzaiALdz8bD7H5gn/zCsXH1mLEonQ8CstRCHJ2YSduvmCNoVa38EYvg780SX7G+MUsxRmf5W4nCPRg4d9cP77pLRruFCtARHSice8R3QkWVXUrngiHKajBX3xqlXo+kWtjM1hrxrvdFaEsqi1D9G7UsrPuhZ5Gvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2EEgAVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2EEgAVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD8CC2BBFC;
	Wed, 19 Jun 2024 13:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802208;
	bh=IY8XecQT/fIsxzctvn33gizZA09IQTGDdTgmWxmAK/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2EEgAVIl/cUFP3AZ0pOUhb03d1WU7JUtgHe3i+25O55iP5LCVtxj3g6A+p1oSLk2
	 oahWIGMaBBj8SVyTI/0BT+G6TNO/SHsiWbp/LvUVmzsuWNKV2JupE9n2UuTUbHcqhy
	 qqSgtMv1rM5h8BjdBaJeTC0C+He+X6468Uv+oWn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Paul Moore <paul@paul-moore.com>,
	syzbot+bf4903dc7e12b18ebc87@syzkaller.appspotmail.com,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.6 087/267] landlock: Fix d_parent walk
Date: Wed, 19 Jun 2024 14:53:58 +0200
Message-ID: <20240619125609.689806867@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit 88da52ccd66e65f2e63a6c35c9dff55d448ef4dc upstream.

The WARN_ON_ONCE() in collect_domain_accesses() can be triggered when
trying to link a root mount point.  This cannot work in practice because
this directory is mounted, but the VFS check is done after the call to
security_path_link().

Do not use source directory's d_parent when the source directory is the
mount point.

Cc: Günther Noack <gnoack@google.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: stable@vger.kernel.org
Reported-by: syzbot+bf4903dc7e12b18ebc87@syzkaller.appspotmail.com
Fixes: b91c3e4ea756 ("landlock: Add support for file reparenting with LANDLOCK_ACCESS_FS_REFER")
Closes: https://lore.kernel.org/r/000000000000553d3f0618198200@google.com
Link: https://lore.kernel.org/r/20240516181935.1645983-2-mic@digikod.net
[mic: Fix commit message]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/fs.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -820,6 +820,7 @@ static int current_check_refer_path(stru
 	bool allow_parent1, allow_parent2;
 	access_mask_t access_request_parent1, access_request_parent2;
 	struct path mnt_dir;
+	struct dentry *old_parent;
 	layer_mask_t layer_masks_parent1[LANDLOCK_NUM_ACCESS_FS] = {},
 		     layer_masks_parent2[LANDLOCK_NUM_ACCESS_FS] = {};
 
@@ -867,9 +868,17 @@ static int current_check_refer_path(stru
 	mnt_dir.mnt = new_dir->mnt;
 	mnt_dir.dentry = new_dir->mnt->mnt_root;
 
+	/*
+	 * old_dentry may be the root of the common mount point and
+	 * !IS_ROOT(old_dentry) at the same time (e.g. with open_tree() and
+	 * OPEN_TREE_CLONE).  We do not need to call dget(old_parent) because
+	 * we keep a reference to old_dentry.
+	 */
+	old_parent = (old_dentry == mnt_dir.dentry) ? old_dentry :
+						      old_dentry->d_parent;
+
 	/* new_dir->dentry is equal to new_dentry->d_parent */
-	allow_parent1 = collect_domain_accesses(dom, mnt_dir.dentry,
-						old_dentry->d_parent,
+	allow_parent1 = collect_domain_accesses(dom, mnt_dir.dentry, old_parent,
 						&layer_masks_parent1);
 	allow_parent2 = collect_domain_accesses(
 		dom, mnt_dir.dentry, new_dir->dentry, &layer_masks_parent2);


