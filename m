Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F425038F1;
	Thu, 17 Sep 2026 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664955; cv=none; b=raZDKF5fqF0Rqwr2t7JYLCThcGPbhvoEINn12BOW6WELwsTcLXvuuUgFKt8gBeNQgkrSC8+k+4qDaduyoHjBUA5cSdRESWypv0hwABZGLJWwaKuG88HQYGIW4MYLiP6y9lTzry/mai9s7vaylvBEeXoeeilX8oFuqA21fd9Qa4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664955; c=relaxed/simple;
	bh=2dIpg/DnNWVkT47/NGSYjNlkL2Om0eFE2EyQsF0ZhyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+OMGJJuZs5Q/wjslz0RTePt/kl0geaMO6n6LCU318UiZowIuESe0K9iv78R+ZSfDCH7tcUPUgYMPgj8Ed4uoIyQ0V6vUSMS2ogV2DjyxxUlMm6uzlgXN5JEt2GfpAxUIAkIAot12slyJK0aY6JoEGLs5RR9pAhm2Ls9g8ApvtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7z4WEd1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7z4WEd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5421F000FF;
	Thu, 17 Sep 2026 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664954;
	bh=JdI/pOd7RYKPGkMrKMD4ij9flDtZ+ysfH7D36JktyQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7z4WEd1NBvLUeAp5FXiOsUvMmzJPQhs3XeoOa0PFdTUdkyO0EL9tvyvxYiOzd0Xn
	 vdBb0eg8Mov0cJH14lqKuPpEqxXTkBSfwpctMrD0XeHjug6Pc4ApZlsPbiwJra4kvm
	 l4MS4SICKtfc7U6Mm3TajnLcgDTHwI6KFSUuqCYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Vosburgh <trilobyte777@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0543/1250] ksmbd: preserve VFS inherited POSIX ACL mask
Date: Thu, 17 Sep 2026 16:05:38 +0100
Message-ID: <20260917151606.656829107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a8a8cfc8bc69b..ec9d04e4de416 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1971,10 +1971,6 @@ int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
 				const struct path *path, struct inode *parent_inode)
 {
 	struct posix_acl *acls;
-	struct posix_acl_entry *pace;
-	struct dentry *dentry = path->dentry;
-	struct inode *inode = d_inode(dentry);
-	int rc, i;
 
 	if (!IS_ENABLED(CONFIG_FS_POSIX_ACL))
 		return -EOPNOTSUPP;
@@ -1982,27 +1978,7 @@ int ksmbd_vfs_inherit_posix_acl(struct mnt_idmap *idmap,
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



