Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39489547078;
	Thu, 17 Sep 2026 18:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668295; cv=none; b=b6F7R3f/d2m0jP0+52udsZVccQ5YdW9ZUr+TiyAUZI2oABorZEYdvemMutC9kFM/PB+53pziYqZZWyQWJShUga+rOxEjZ8QEf1VKNytVwz1KOh66UcShZgsIZGImzJ6v4ptJVsXhwTbPmSAjMEcCRUSljtmf16Rp2UP50iIgOaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668295; c=relaxed/simple;
	bh=FAJfdU3BOG3QoBlXiEq7sgZkpi3Dk9qX829eCvQ9OSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTesxI9TQQ8nAg7zF1189dhoW54ZL9vQaQqy8MA8zGqpiJHmoXvNdWQhL19ONkDsCetLLoANrM4/wi4mZwhYwuLp6TAkDppyHyNfljP5k1VES/eHdgjoINA0nb03fjljzDJk8dM3fgYRMXwIE2JNdDHmWC9Qr/tVbi5QVanFlzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzvuD+eP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzvuD+eP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8719B1F000FF;
	Thu, 17 Sep 2026 18:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668294;
	bh=ZX1FVYrHCMJM3l4JH5g5rpq1cKwbTJs0+FpzLEtVyxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EzvuD+ePfTAcgEq0nowpVmgMFZSitP4vlXBMmi+OKn19+FHz6OccOAt+KsmhyD/ba
	 qsg14c1hcFW5SboPA/vou+I6L2wNNIq1Y35fA6hhAFWvNyblxLqj6JCT5A6WhYR1JO
	 vR/yoVKr7VSGVaUYV29TuEGWXaa8MCvKpn2ChuyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0378/1102] ksmbd: Fix acl.sd_buf memory leak and invalid sd_size error handling
Date: Thu, 17 Sep 2026 16:05:21 +0100
Message-ID: <20260917151549.142946543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 5904aa3aa63b5..13cb68135d1a1 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1583,7 +1583,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	struct ndr n;
 	struct inode *inode = d_inode(dentry);
 	struct ndr acl_ndr = {0};
-	struct xattr_ntacl acl;
+	struct xattr_ntacl acl = {0};
 	struct xattr_smb_acl *smb_acl = NULL, *def_smb_acl = NULL;
 	__u8 cmp_hash[XATTR_SD_HASH_SIZE] = {0};
 
@@ -1594,7 +1594,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	n.length = rc;
 	rc = ndr_decode_v4_ntacl(&n, &acl);
 	if (rc)
-		goto free_n_data;
+		goto out_free;
 
 	smb_acl = ksmbd_vfs_make_xattr_posix_acl(idmap, inode,
 						 ACL_TYPE_ACCESS);
@@ -1624,6 +1624,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	*pntsd = acl.sd_buf;
 	if (acl.sd_size < sizeof(struct smb_ntsd)) {
 		pr_err("sd size is invalid\n");
+		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -1643,8 +1644,6 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
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



