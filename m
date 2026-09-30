Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AC01CAA6C;
	Wed, 30 Sep 2026 19:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794845; cv=none; b=aoxQ+yrQRTib0lG8w8oc3dl+TCflcZHelEIDLL7Vgm92RE3ddgm/j+Lvo1fzxBfj97Vum+L5/dXeh1oV0nHs/w7xxqiEkVjS9q/HK0s+KLBDbzDnqBWhL2Ujd8rAkmpgcHKJKRDwMAIdzxb1SXTPOf+M3o4G69nWAp4uk2Bssl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794845; c=relaxed/simple;
	bh=bK+xYu/OqJcrr3vqEdWrRAnwrKi/Sv3ZeauFB8eo1IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0x+G5SZKv6UAlupT3S93zokEMILMX/ubBqefYZJdV1res4DTk0vbbQ9z5r8vYZx7zwMIG86YUA04VX0lkkLLrsvv5yavdtanNHbJJkdbKFhc4tXOvOTvxFgjDuFpYDyim797S+BEH4XLfgJcn1n9qNXZenNNN2EbRA9fMF1hRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppnTYQs9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppnTYQs9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085CE1F000FF;
	Wed, 30 Sep 2026 19:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794844;
	bh=EDE+8VJ4wEMcUhUNJppLO05GAltZwTuCTwoYN/MYdwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppnTYQs9bCbhzePipRkjoc5z3VcBqQZo++S7Yju/Y+sBAj5+St344HKU4K5QmJhGT
	 X9uwIfyk8feRrKgMrT0vwXB3aQEYc2B+FrzZ20e7D535XBfOrNt3ma0l+m26JkhsDl
	 Iv+yS5PR48tgm3XuziC9Pd7DRoNDWb41DR6KcIgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Vosburgh <trilobyte777@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0326/1193] ksmbd: preserve VFS inherited POSIX ACL mask
Date: Wed, 30 Sep 2026 17:16:50 +0200
Message-ID: <20260930152441.383850589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e148e567a9252643baa125cb65d7ae9c2c6cf68a ]

The VFS initializes a child's POSIX ACL from the parent's default ACL and
the requested creation mode. Do not mutate the parent ACL or overwrite the
child's VFS-computed access and default ACLs afterwards.

This preserves restrictive ACL_MASK entries and prevents SMB object creation
from widening effective permissions.

Reported-by: Charles Vosburgh <trilobyte777@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 2bbac0977f500..2bea89fc9ecdd 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1943,10 +1943,6 @@ int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
 				struct path *path, struct inode *parent_inode)
 {
 	struct posix_acl *acls;
-	struct posix_acl_entry *pace;
-	struct dentry *dentry = path->dentry;
-	struct inode *inode = d_inode(dentry);
-	int rc, i;
 
 	if (!IS_ENABLED(CONFIG_FS_POSIX_ACL))
 		return -EOPNOTSUPP;
@@ -1954,27 +1950,7 @@ int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
 	acls = get_inode_acl(parent_inode, ACL_TYPE_DEFAULT);
 	if (IS_ERR_OR_NULL(acls))
 		return -ENOENT;
-	pace = acls->a_entries;
-
-	for (i = 0; i < acls->a_count; i++, pace++) {
-		if (pace->e_tag == ACL_MASK) {
-			pace->e_perm = 0x07;
-			break;
-		}
-	}
-
-	rc = set_posix_acl(idmap, dentry, ACL_TYPE_ACCESS, acls);
-	if (rc < 0)
-		ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_ACCESS) failed, rc : %d\n",
-			    rc);
-	if (S_ISDIR(inode->i_mode)) {
-		rc = set_posix_acl(idmap, dentry, ACL_TYPE_DEFAULT,
-				   acls);
-		if (rc < 0)
-			ksmbd_debug(SMB, "Set posix acl(ACL_TYPE_DEFAULT) failed, rc : %d\n",
-				    rc);
-	}
 
 	posix_acl_release(acls);
-	return rc;
+	return 0;
 }
-- 
2.53.0



