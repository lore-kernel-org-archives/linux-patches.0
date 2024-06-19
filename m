Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A347714373E;
	Wed, 19 Jun 2024 13:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803751; cv=none; b=QbWpTlSqnXye0olMAN02DSSdIuLS7IGeX6d98obDbOuBfgwgcz+UGH9MvGHGhDQGCY0a6bc4plVimRrlBVsiVGR07TrYQk/0qEC9RnVbMdAXPv9O130d0qS4LTTnQfY+Saezi0rx+XeqDQvEpQM2AIIGY0o5mblCzGHSWkvSaPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803751; c=relaxed/simple;
	bh=LGktxfdLIZvAODVn27qdG+nfbfqAn4jilRJybCvGiUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HlxR1kvkRb09QgtsHdtF9+O1w7qkQFXxn5A0zVNF6OpJqCqdelCJWLNe7hWlOztCNkk/cz75zWj/tySmYTLNG9T5LmtGSV/Rj71JJdpj+Ohr4HQjDkAvLNJGLa9nn6sfxsTbBtLDWyNtRqfc6+WzkhJEWt6gU6LLJpUmLCRwMwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5r5f50T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5r5f50T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF1CC2BBFC;
	Wed, 19 Jun 2024 13:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803751;
	bh=LGktxfdLIZvAODVn27qdG+nfbfqAn4jilRJybCvGiUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5r5f50Tt1UYdiVCbYoHUK3VfBC6QQZJcmgLj/eHUVTE/PZ+9yrtwfghWlvZwCNP4
	 hA8N2/PDAulo2/L48L1v76SVKHGm51epmD6f1LzXLjEfHA4S6sJMxsOn0Dk4BRW+qb
	 2VDPviiHsJyKijKViKc/cRPgg/bI3bIoKM0QPrUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Paul Moore <paul@paul-moore.com>,
	syzbot+bf4903dc7e12b18ebc87@syzkaller.appspotmail.com,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.1 091/217] landlock: Fix d_parent walk
Date: Wed, 19 Jun 2024 14:55:34 +0200
Message-ID: <20240619125600.199822604@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -824,6 +824,7 @@ static int current_check_refer_path(stru
 	bool allow_parent1, allow_parent2;
 	access_mask_t access_request_parent1, access_request_parent2;
 	struct path mnt_dir;
+	struct dentry *old_parent;
 	layer_mask_t layer_masks_parent1[LANDLOCK_NUM_ACCESS_FS] = {},
 		     layer_masks_parent2[LANDLOCK_NUM_ACCESS_FS] = {};
 
@@ -870,9 +871,17 @@ static int current_check_refer_path(stru
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


