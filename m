Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050B04F96BD;
	Thu, 17 Sep 2026 17:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664766; cv=none; b=gnVjJ+0bCobi3q0AT7ecel8QCu5xC6sElloJbxk7F7nKOlUB5RPkghCPqsCi5qP/Abp1dHAbqUkXdjNtMG7t4a5ryKMsdLEDQIiWPrq76z5A+C54Y7xVlap+4+xi4ZHwTW2qjxT1A1TCBdssJCUCu7A1jdNlIsGshFFgX7ri2ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664766; c=relaxed/simple;
	bh=daA91vGXas6H2qRdIt1h1blYFDYUpWvQH7oOASwb+QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ebvu1tUoQJ5gdk5eFGr2jxZMEMmZ692uhLZnMxEwpQlIa1dwlHkB9vIr4Cq6uN/uSciz0s/4m0dQ00yHHXAqo8Q2wQYPK/4pDjnps+OK3tAM+CgGo3P97eBiJp3g6Ub8Lswy+J1D0wTQgT07luIFfeWSlVrRxVDhhBV3KSUDXEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aoS9AqFp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aoS9AqFp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0061F000FF;
	Thu, 17 Sep 2026 17:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664764;
	bh=pVqGGGb42IELJ6kPhDsm36AwH6t+PIY3TkWKo27iI6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aoS9AqFpsM0ncQFgvecZLx8AsfdGQ/ZHMTNRBW9DLUDvl4MkmwZh5cVFisGJ3ba/B
	 QnQgqcav9Bi/9M5HFtJGRQXmJXppdcn+oYd7ZDkOuOPxbm4Ipb2T0lV5GLUB/m0Cg+
	 DivS4cqYEcPnKEXsMjjA5gHvl/wBmKyxnYUQCo3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0482/1250] ksmbd: Fix acl.sd_buf memory leak and invalid sd_size error handling
Date: Thu, 17 Sep 2026 16:04:37 +0100
Message-ID: <20260917151605.029716211@linuxfoundation.org>
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

From: Qiang Liu <liuqiang@kylinos.cn>

[ Upstream commit d708a36634bb7b6f94d0e76d587d2ec50b2b93b5 ]

1. When ndr_decode_v4_ntacl() fails, the code jumped to free_n_data
   which only freed n.data, skipping kfree(acl.sd_buf) and leaking
   the buffer. Zero-initialize struct xattr_ntacl acl, reorder error
   labels to out_free to release acl.sd_buf on all error paths.

2. if (acl.sd_size < sizeof(struct smb_ntsd)) is true, original code
   returned success without freeing sd_buf and left stale *pntsd.
   Set rc = -EINVAL before jumping to out_free to return error code and
   free buffer.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 4c9d46c50b600..a8a8cfc8bc69b 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1589,7 +1589,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	struct ndr n;
 	struct inode *inode = d_inode(dentry);
 	struct ndr acl_ndr = {0};
-	struct xattr_ntacl acl;
+	struct xattr_ntacl acl = {0};
 	struct xattr_smb_acl *smb_acl = NULL, *def_smb_acl = NULL;
 	__u8 cmp_hash[XATTR_SD_HASH_SIZE] = {0};
 
@@ -1600,7 +1600,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	n.length = rc;
 	rc = ndr_decode_v4_ntacl(&n, &acl);
 	if (rc)
-		goto free_n_data;
+		goto out_free;
 
 	smb_acl = ksmbd_vfs_make_xattr_posix_acl(idmap, inode,
 						 ACL_TYPE_ACCESS);
@@ -1626,6 +1626,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	*pntsd = acl.sd_buf;
 	if (acl.sd_size < sizeof(struct smb_ntsd)) {
 		pr_err("sd size is invalid\n");
+		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -1645,8 +1646,6 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 		kfree(acl.sd_buf);
 		*pntsd = NULL;
 	}
-
-free_n_data:
 	kfree(n.data);
 	return rc;
 }
-- 
2.53.0



