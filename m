Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A0538F233;
	Sat, 17 Oct 2026 17:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258841; cv=none; b=nVDzflT7EJfiLVW73rK/F+MUJW+8uPnYjjGQd2RiJ/EUGXsep8UHs2hdpPf29n4WQhYlTjc6/8H/IV/ke7xMiImwo2VqQ65ZuT7nwJOXEQtXywPmPCd5f3YbphRkgbUcGAaGwECesx7jvMQkxebor8a/k3Zk5h34r2t1fx3RGLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258841; c=relaxed/simple;
	bh=/Z+hwohgb+R3BZqkSqCCN4laDDG3FDSgNaW+cRzu9+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSnHZMUlMHxTkp8sGlhvytcIHzT7w20votUQCQCKsnSAf8oKK2GR5DeUVVeETx7f2zYTMuGbrdONP+okAwAmbVTGQuRj6Hk2VLeqhZX4ukiV9fzWnTnt63+7yt1TmsPPOCvJJuAcJOZzbBLXXhst0pPcosAgOv29k9h/w4CFR2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJG0toMB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJG0toMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA641F000C4;
	Sat, 17 Oct 2026 17:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258839;
	bh=EXRDZUBEgY0hUUjnoLx/grHGJyBmm6t+0GWxPJYh6u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJG0toMBd6Cl6J5Q/QnevTUWjpzJ9lhd0JLq/RUutvwSX2FT6KuLMIC8jpLL8aIl/
	 2wQaYqNgHxwtyMLQMCdGcX3J883JfbeFP+36d+o/AzEu4w/r6YXDuqUV8DPFWPugIk
	 MIr+DtF1KP6hu2FNNW4dMRCmZdlpE3M6X8/gg5Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0976/1674] selinux: allow multiple opens of /sys/fs/selinux/policy
Date: Sat, 17 Oct 2026 17:54:08 +0200
Message-ID: <20261017160456.177563803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <stephen.smalley.work@gmail.com>

[ Upstream commit a02cd6805562305f936e807da83e253b719dd965 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/selinuxfs.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 3e28fa2444fbd..d425137c0d1bb 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -74,7 +74,6 @@ struct selinux_fs_info {
 	int *bool_pending_values;
 	struct dentry *class_dir;
 	unsigned long last_class_ino;
-	bool policy_opened;
 	struct dentry *policycap_dir;
 	unsigned long last_ino;
 	struct super_block *sb;
@@ -343,44 +342,31 @@ struct policy_load_memory {
 
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
-
-	rc = -EBUSY;
-	if (fsi->policy_opened)
-		goto err;
+		return rc;
 
-	rc = -ENOMEM;
 	plm = kzalloc(sizeof(*plm), GFP_KERNEL);
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
@@ -393,13 +379,8 @@ static int sel_open_policy(struct inode *inode, struct file *filp)
 
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
 
-- 
2.53.0



