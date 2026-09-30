Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CC84F3ED7;
	Wed, 30 Sep 2026 16:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784680; cv=none; b=sXQ2CNqZq7DG2+BRje4WTevowoAzQl9hb27CkGXZJ5dDNiRllrryMwBfiZcmlngfK0HqcPPa6771ZonZoUQ9n1j2dsEv/AffrSL6MPmCBn7AmUz9kXPy1jqqjhSPZXAQDUl0X/UfEFjacb2M/WCrdsdV4JOS9i0UjwwYTGlJFFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784680; c=relaxed/simple;
	bh=ZgpdcXwnQCfpOWhE4wKssf8i5Vppn7KgAwYEAY3heSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYKqUOoh/94Fl0Mi0ijZXDY+ALx3F82Gr3m9SZ1Nw9xxCCrcEUTzf6OtJgBOYm9lrivTul76EIy+0g+n9Py1Qx5+wMQFqOs6T8NJycNTXoXej2MIgmySLiZlsxuxV5qcbdqESY3xWCKtafAsroZ8pEWIh++0/hDWSsfcSPtdrOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nDSs/YSe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nDSs/YSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565ED1F00898;
	Wed, 30 Sep 2026 16:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784674;
	bh=ku1ZjEdICL324Odl6hLG/K1FpVhS+Dyj6hhrrOKKd6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nDSs/YSegQ0ACynzsQ7qMZh7Jlk8kDPI8vAfG8uG2ELf7DkLPQUdpjt2U/YAbxcUS
	 x3UpzH2wMry5BNH24eLK5HzvGYcPpfZUhyZTzg193ruga3mgAfSrQy5Prkgt9fLTAL
	 zc+hTrMU5dq2nXiMiMN0t2lorL3cCZ85JoFDzwKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Liu <liuqiang@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 238/982] ksmbd: Fix acl.sd_buf memory leak and invalid sd_size error handling
Date: Wed, 30 Sep 2026 17:16:14 +0200
Message-ID: <20260930152421.907601471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 27a15c9d3cc22..1da397999941a 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1537,7 +1537,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	struct ndr n;
 	struct inode *inode = d_inode(dentry);
 	struct ndr acl_ndr = {0};
-	struct xattr_ntacl acl;
+	struct xattr_ntacl acl = {0};
 	struct xattr_smb_acl *smb_acl = NULL, *def_smb_acl = NULL;
 	__u8 cmp_hash[XATTR_SD_HASH_SIZE] = {0};
 
@@ -1548,7 +1548,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	n.length = rc;
 	rc = ndr_decode_v4_ntacl(&n, &acl);
 	if (rc)
-		goto free_n_data;
+		goto out_free;
 
 	smb_acl = ksmbd_vfs_make_xattr_posix_acl(user_ns, inode,
 						 ACL_TYPE_ACCESS);
@@ -1578,6 +1578,7 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
 	*pntsd = acl.sd_buf;
 	if (acl.sd_size < sizeof(struct smb_ntsd)) {
 		pr_err("sd size is invalid\n");
+		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -1597,8 +1598,6 @@ int ksmbd_vfs_get_sd_xattr(struct ksmbd_conn *conn,
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



