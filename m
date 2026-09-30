Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB62F51A73A;
	Wed, 30 Sep 2026 17:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791100; cv=none; b=EdKJlzZhug2fB6EqlsDLDbsJDtPYZR7FtiJFUyiFtdOO2MZuJgqb/QHEjeYcRgkZ/A5HLAZFAzQYjJsMQy3lc7zg5OVc5hxqlYsRvwi+ms5vZPAfrc6PprmLJEEWvkTjqarAxLsjxK/n3WRBf+HP/oGrneYTbwqOddK2v13O+y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791100; c=relaxed/simple;
	bh=Xi+DvkJ7+32ElFLKMCU4H6tJIRINJGZcSsYT3DmLVMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmRLPnaEtM1JvXraMOT/DG49HsohDe2bFLSFwTdMjoJfolAd4ITSf/uuJoJHusaZ6g0IAqDuORsh/U4SUt8apCT7u2ovKA1zQzSv5QruolmMbXh3msOF+4XVZJG6+u74BG8+upz09EGjs+rsptkLsOTE5umgpBzFMs87pAP9gUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQzGp1LG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQzGp1LG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B101F000FF;
	Wed, 30 Sep 2026 17:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791099;
	bh=5JaGRPdxEef8xoSt3IDfG86zGVF/4CpB6yMb/ZrD8Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQzGp1LGrr+iDSaFxiImcr4JisswL/86Oh5giTyBlkrGJAUwrb0DqYqpPQpGDI+M8
	 q1QUC6fDrQOx8Qu6eM6gde63jghIcOySpO4/FVnnORxwSc0E10MZ+a95oJY8ldsY5x
	 Sx3j3sJt8xJY7zqzyyXMlCesvzRZdGyO+1M7Z5QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 185/752] ksmbd: Fix acl.sd_buf memory leak and invalid sd_size error handling
Date: Wed, 30 Sep 2026 17:20:55 +0200
Message-ID: <20260930152402.210180745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/vfs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index e643cd1ee87fc..aff2d0f22c8fb 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1527,7 +1527,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	struct ndr n;
 	struct inode *inode = d_inode(dentry);
 	struct ndr acl_ndr = {0};
-	struct xattr_ntacl acl;
+	struct xattr_ntacl acl = {0};
 	struct xattr_smb_acl *smb_acl = NULL, *def_smb_acl = NULL;
 	__u8 cmp_hash[XATTR_SD_HASH_SIZE] = {0};
 
@@ -1538,7 +1538,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	n.length = rc;
 	rc = ndr_decode_v4_ntacl(&n, &acl);
 	if (rc)
-		goto free_n_data;
+		goto out_free;
 
 	smb_acl = ksmbd_vfs_make_xattr_posix_acl(user_ns, inode,
 						 ACL_TYPE_ACCESS);
@@ -1568,6 +1568,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	*pntsd = acl.sd_buf;
 	if (acl.sd_size < sizeof(struct smb_ntsd)) {
 		pr_err("sd size is invalid\n");
+		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -1587,8 +1588,6 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
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



