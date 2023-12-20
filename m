Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18EC40BFC;
	Wed, 20 Dec 2023 16:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8c0DiQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3D9C433C7;
	Wed, 20 Dec 2023 16:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088920;
	bh=ZgNPOha2AfhQLq9RGiop+8c/GlRH2IjuwDBcMm6nTpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8c0DiQ89+tRT4pOpyPyFLvt2dGPK6RN6/dypC1xqgljCWAeFm0rQRz0CVHvTNt+h
	 qDz5RCDkh6+ClzAJUbJ3u1kha1eDKGFfgnhadIG18y3dbRGwqlI2Nut78E/z25CMvU
	 Wsi18J/YQoEfdfYOrqZvwHEX5RtrtczJSq4xGCRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Hongfei <luhongfei@vivo.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 107/159] ksmbd: Change the return value of ksmbd_vfs_query_maximal_access to void
Date: Wed, 20 Dec 2023 17:09:32 +0100
Message-ID: <20231220160936.336980673@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Hongfei <luhongfei@vivo.com>

[ Upstream commit ccb5889af97c03c67a83fcd649602034578c0d61 ]

The return value of ksmbd_vfs_query_maximal_access is meaningless,
it is better to modify it to void.

Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    4 +---
 fs/ksmbd/vfs.c     |    6 +-----
 fs/ksmbd/vfs.h     |    2 +-
 3 files changed, 3 insertions(+), 9 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2877,11 +2877,9 @@ int smb2_open(struct ksmbd_work *work)
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
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -121,11 +121,9 @@ err_out:
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
@@ -142,8 +140,6 @@ int ksmbd_vfs_query_maximal_access(struc
 
 	if (!inode_permission(user_ns, d_inode(dentry->d_parent), MAY_EXEC | MAY_WRITE))
 		*daccess |= FILE_DELETE_LE;
-
-	return ret;
 }
 
 /**
--- a/fs/ksmbd/vfs.h
+++ b/fs/ksmbd/vfs.h
@@ -111,7 +111,7 @@ struct ksmbd_kstat {
 };
 
 int ksmbd_vfs_lock_parent(struct dentry *parent, struct dentry *child);
-int ksmbd_vfs_query_maximal_access(struct user_namespace *user_ns,
+void ksmbd_vfs_query_maximal_access(struct user_namespace *user_ns,
 				   struct dentry *dentry, __le32 *daccess);
 int ksmbd_vfs_create(struct ksmbd_work *work, const char *name, umode_t mode);
 int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode);


