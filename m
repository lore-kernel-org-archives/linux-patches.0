Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7BF377A97;
	Sat, 17 Oct 2026 16:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253992; cv=none; b=ak91Bi9vIqZaWYTjk0xn4dvWd12zEVK9ok2hKVbEnkkykVJpxNS8tME+F1lwmqvSJ4boAmb4RGYo6di05WotgKpbehUBiyrYahacWcK4fl6NkVW98wVXCoz+Uj8wX+w489WySPE6/n+5E7gZoQWS47pY8QEgg2eB6SubUkrxAHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253992; c=relaxed/simple;
	bh=QeZXtO11HADtLjOCbU+QdA5S03fI3H8cdEuQ8dfG/7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZ++irfUwRPb5QBvvT13a3yCJg1NKp0d18XIXU+FNoapu0uLePEkXcY6iAIbcWOaLg9Tpc/Qa4us1J+SbcsCXOHFJHUWXD/PuUaGgjFaKkORtsoYo5bamgy/Y1z++zB1Cl7aRC3OFCmjWVnIWGQjg3KVV2i33TixzqIaGmo7ZYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9CTlSAO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9CTlSAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D991F000C4;
	Sat, 17 Oct 2026 16:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253991;
	bh=DLcCQrDKsnqCYxIEvsBRMna8exXjG0uQPdDbSPupQCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9CTlSAOXVvmDNCYlPkFpIwWj3N+h82vNMiEWldxwmeQaVwRvrLIO5JTm9QJ/W25u
	 vlZFO8vgzZ0Q9ArdlU08PO5P+kQ+CHuiOY/aR4wQbWAxvz5SyN67zTMeioU4jgQjAs
	 kxu2azhW1pEeeC87C0MChoILnMsw1HZ0JQ6FCdLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 301/869] selinux: allow multiple opens of /sys/fs/selinux/policy
Date: Sat, 17 Oct 2026 17:52:22 +0200
Message-ID: <20261017160044.791601129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ec3030614ab26..1ee472482c8ae 100644
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
@@ -390,13 +376,8 @@ static int sel_open_policy(struct inode *inode, struct file *filp)
 
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



