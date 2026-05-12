Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4746750276;
	Tue, 12 May 2026 18:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609105; cv=none; b=cLkGFIcVBxIys2uvVS0LoIgFj0JMF6gwVQx6E1obSc3lToMMGqH4fMpHQjvtpOouznAfuSjIOWQF3/H1x5/rtZxl856wAeuDEsfVU18mtycuXFajK6X85A5MivttKKnqZGR2wF3A172HOu9RUITblphoplxjgA8lR4YPTpPQ7hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609105; c=relaxed/simple;
	bh=44CKPZ5nw9xjJne8E6Tas39x4i8eBC3fdo4U3jj7S84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewrTHo1iuCbXMAB+JAcu7N/T2hSyUhipKgS5m/CqvPs3Az9rT/K8JI6fXgQ9E7umQwFvC0ETzoT2QITojFoJtxBWT39+VVR4xR/KmWKDmHzQ7m+EIYT8+3QLiWAkheWHhSC/REXpuK5BF8dcK8rCrOO20NR8SLfsX79jOub+UHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHUCveg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHUCveg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EFFC2BCB0;
	Tue, 12 May 2026 18:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609105;
	bh=44CKPZ5nw9xjJne8E6Tas39x4i8eBC3fdo4U3jj7S84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHUCveg5COwuiNRFZgojANbqJMcf0M13/Urwxpcfp4UXm8yKMJboyPlUiRzyyHiSq
	 haC7jYVUMUfzvviQ90wCk9/BGz7TK+oiAO/RKBfrYd6UXPE3eOUsOcjhXmfRoLswVu
	 N4HwH8bltlAPfARMgKgqkKVqKeqwNJm+8VnL7L7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.0 065/307] selinux: allow multiple opens of /sys/fs/selinux/policy
Date: Tue, 12 May 2026 19:37:40 +0200
Message-ID: <20260512173941.493184298@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <stephen.smalley.work@gmail.com>

commit a02cd6805562305f936e807da83e253b719dd965 upstream.

Currently there can only be a single open of /sys/fs/selinux/policy at
any time. This allows any process to block any other process from
reading the kernel policy. The original motivation seems to have been
a mix of preventing an inconsistent view of the policy size and
preventing userspace from allocating kernel memory without bound, but
this is arguably equally bad. Eliminate the policy_opened flag and
shrink the critical section that the policy mutex is held. While we
are making changes here, drop a couple of extraneous BUG_ONs.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/selinux/20100726193414.19538.64028.stgit@paris.rdu.redhat.com/
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/selinuxfs.c |   27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -76,7 +76,6 @@ struct selinux_fs_info {
 	int *bool_pending_values;
 	struct dentry *class_dir;
 	unsigned long last_class_ino;
-	bool policy_opened;
 	unsigned long last_ino;
 	struct super_block *sb;
 };
@@ -340,44 +339,31 @@ struct policy_load_memory {
 
 static int sel_open_policy(struct inode *inode, struct file *filp)
 {
-	struct selinux_fs_info *fsi = inode->i_sb->s_fs_info;
 	struct policy_load_memory *plm = NULL;
 	int rc;
 
-	BUG_ON(filp->private_data);
-
-	mutex_lock(&selinux_state.policy_mutex);
-
 	rc = avc_has_perm(current_sid(), SECINITSID_SECURITY,
 			  SECCLASS_SECURITY, SECURITY__READ_POLICY, NULL);
 	if (rc)
-		goto err;
+		return rc;
 
-	rc = -EBUSY;
-	if (fsi->policy_opened)
-		goto err;
-
-	rc = -ENOMEM;
 	plm = kzalloc_obj(*plm);
 	if (!plm)
-		goto err;
+		return -ENOMEM;
 
+	mutex_lock(&selinux_state.policy_mutex);
 	rc = security_read_policy(&plm->data, &plm->len);
 	if (rc)
 		goto err;
-
 	if ((size_t)i_size_read(inode) != plm->len) {
 		inode_lock(inode);
 		i_size_write(inode, plm->len);
 		inode_unlock(inode);
 	}
-
-	fsi->policy_opened = 1;
+	mutex_unlock(&selinux_state.policy_mutex);
 
 	filp->private_data = plm;
 
-	mutex_unlock(&selinux_state.policy_mutex);
-
 	return 0;
 err:
 	mutex_unlock(&selinux_state.policy_mutex);
@@ -390,13 +376,8 @@ err:
 
 static int sel_release_policy(struct inode *inode, struct file *filp)
 {
-	struct selinux_fs_info *fsi = inode->i_sb->s_fs_info;
 	struct policy_load_memory *plm = filp->private_data;
 
-	BUG_ON(!plm);
-
-	fsi->policy_opened = 0;
-
 	vfree(plm->data);
 	kfree(plm);
 


