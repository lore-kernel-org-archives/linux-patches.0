Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72501C6B0;
	Wed,  3 Jan 2024 16:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZXzMWW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A935C433C8;
	Wed,  3 Jan 2024 16:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301058;
	bh=gllEr/kBa5S+jNT9XIaTvhcdBbVcAzAphwKxJcLzIT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZXzMWW1wNpxIXjCzHiGCFTQz3qXVOrHvjweEcjyGDC7tC3Jiv+5A2EQ+jmZN4EpR
	 3D51lJGuMTSKcpkWXdbYY/8SwlWqNSNmgvjWp1wDTqjTK3HQy/JZRRDXHxQnS6BoIN
	 r+q62NpW2rIXLV2hRnNQGGpxNMHD55LkLbPHbv88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Hongfei <luhongfei@vivo.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/100] ksmbd: Change the return value of ksmbd_vfs_query_maximal_access to void
Date: Wed,  3 Jan 2024 17:54:16 +0100
Message-ID: <20240103164900.183323821@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Hongfei <luhongfei@vivo.com>

[ Upstream commit ccb5889af97c03c67a83fcd649602034578c0d61 ]

The return value of ksmbd_vfs_query_maximal_access is meaningless,
it is better to modify it to void.

Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 +---
 fs/smb/server/vfs.c     | 6 +-----
 fs/smb/server/vfs.h     | 2 +-
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f35e06ae25b3b..e8d2c6fc3f37c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2891,11 +2891,9 @@ int smb2_open(struct ksmbd_work *work)
 		if (!file_present) {
 			daccess = cpu_to_le32(GENERIC_ALL_FLAGS);
 		} else {
-			rc = ksmbd_vfs_query_maximal_access(user_ns,
+			ksmbd_vfs_query_maximal_access(user_ns,
 							    path.dentry,
 							    &daccess);
-			if (rc)
-				goto err_out;
 			already_permitted = true;
 		}
 		maximal_access = daccess;
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index d0a85774a496a..178bcd4d0b209 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -122,11 +122,9 @@ static int ksmbd_vfs_path_lookup_locked(struct ksmbd_share_config *share_conf,
 	return -ENOENT;
 }
 
-int ksmbd_vfs_query_maximal_access(struct user_namespace *user_ns,
+void ksmbd_vfs_query_maximal_access(struct user_namespace *user_ns,
 				   struct dentry *dentry, __le32 *daccess)
 {
-	int ret = 0;
-
 	*daccess = cpu_to_le32(FILE_READ_ATTRIBUTES | READ_CONTROL);
 
 	if (!inode_permission(user_ns, d_inode(dentry), MAY_OPEN | MAY_WRITE))
@@ -143,8 +141,6 @@ int ksmbd_vfs_query_maximal_access(struct user_namespace *user_ns,
 
 	if (!inode_permission(user_ns, d_inode(dentry->d_parent), MAY_EXEC | MAY_WRITE))
 		*daccess |= FILE_DELETE_LE;
-
-	return ret;
 }
 
 /**
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 0a4eb1e1a79a9..3e3c92d22e3eb 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -72,7 +72,7 @@ struct ksmbd_kstat {
 };
 
 int ksmbd_vfs_lock_parent(struct dentry *parent, struct dentry *child);
-int ksmbd_vfs_query_maximal_access(struct user_namespace *user_ns,
+void ksmbd_vfs_query_maximal_access(struct user_namespace *user_ns,
 				   struct dentry *dentry, __le32 *daccess);
 int ksmbd_vfs_create(struct ksmbd_work *work, const char *name, umode_t mode);
 int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode);
-- 
2.43.0



