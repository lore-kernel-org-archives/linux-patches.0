Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5754AF80;
	Wed, 20 Dec 2023 16:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SGOZD3jG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B1DC433C8;
	Wed, 20 Dec 2023 16:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088763;
	bh=V0dfdM7AdwA/MWAufcFCkoHf1g5mHBVoAC6ocwE4f8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGOZD3jGq4Gq07Iejv2ekaeNzjYV0SqP5xfS2eXEFI+oqdc3DCiuvJS8rnFsx51im
	 vhRF/+EI7p5WttGdGX/h8O5y/z7rfYY5+rp6IcCFwJH7tR5zB1MIpsqzx2EOc0RK9F
	 9gD/CcEW1BiH+IdAUWNYGEQqZJitzJ50OUcS+pBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 049/159] ksmbd: dont open-code %pD
Date: Wed, 20 Dec 2023 17:08:34 +0100
Message-ID: <20231220160933.610063308@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 369c1634cc7ae8645a5cba4c7eb874755c2a6a07 ]

a bunch of places used %pd with file->f_path.dentry; shorter (and saner)
way to spell that is %pD with file...

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   11 +++++------
 fs/ksmbd/vfs.c     |   14 ++++++--------
 2 files changed, 11 insertions(+), 14 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3939,8 +3939,7 @@ int smb2_query_dir(struct ksmbd_work *wo
 	    inode_permission(file_mnt_user_ns(dir_fp->filp),
 			     file_inode(dir_fp->filp),
 			     MAY_READ | MAY_EXEC)) {
-		pr_err("no right to enumerate directory (%pd)\n",
-		       dir_fp->filp->f_path.dentry);
+		pr_err("no right to enumerate directory (%pD)\n", dir_fp->filp);
 		rc = -EACCES;
 		goto err_out2;
 	}
@@ -6309,8 +6308,8 @@ int smb2_read(struct ksmbd_work *work)
 		goto out;
 	}
 
-	ksmbd_debug(SMB, "filename %pd, offset %lld, len %zu\n",
-		    fp->filp->f_path.dentry, offset, length);
+	ksmbd_debug(SMB, "filename %pD, offset %lld, len %zu\n",
+		    fp->filp, offset, length);
 
 	work->aux_payload_buf = kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
 	if (!work->aux_payload_buf) {
@@ -6574,8 +6573,8 @@ int smb2_write(struct ksmbd_work *work)
 		data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
 				    le16_to_cpu(req->DataOffset));
 
-		ksmbd_debug(SMB, "filename %pd, offset %lld, len %zu\n",
-			    fp->filp->f_path.dentry, offset, length);
+		ksmbd_debug(SMB, "filename %pD, offset %lld, len %zu\n",
+			    fp->filp, offset, length);
 		err = ksmbd_vfs_write(work, fp, data_buf, length, &offset,
 				      writethrough, &nbytes);
 		if (err < 0)
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -376,8 +376,7 @@ int ksmbd_vfs_read(struct ksmbd_work *wo
 
 	if (work->conn->connection_type) {
 		if (!(fp->daccess & (FILE_READ_DATA_LE | FILE_EXECUTE_LE))) {
-			pr_err("no right to read(%pd)\n",
-			       fp->filp->f_path.dentry);
+			pr_err("no right to read(%pD)\n", fp->filp);
 			return -EACCES;
 		}
 	}
@@ -486,8 +485,7 @@ int ksmbd_vfs_write(struct ksmbd_work *w
 
 	if (work->conn->connection_type) {
 		if (!(fp->daccess & FILE_WRITE_DATA_LE)) {
-			pr_err("no right to write(%pd)\n",
-			       fp->filp->f_path.dentry);
+			pr_err("no right to write(%pD)\n", fp->filp);
 			err = -EACCES;
 			goto out;
 		}
@@ -526,8 +524,8 @@ int ksmbd_vfs_write(struct ksmbd_work *w
 	if (sync) {
 		err = vfs_fsync_range(filp, offset, offset + *written, 0);
 		if (err < 0)
-			pr_err("fsync failed for filename = %pd, err = %d\n",
-			       fp->filp->f_path.dentry, err);
+			pr_err("fsync failed for filename = %pD, err = %d\n",
+			       fp->filp, err);
 	}
 
 out:
@@ -1742,11 +1740,11 @@ int ksmbd_vfs_copy_file_ranges(struct ks
 	*total_size_written = 0;
 
 	if (!(src_fp->daccess & (FILE_READ_DATA_LE | FILE_EXECUTE_LE))) {
-		pr_err("no right to read(%pd)\n", src_fp->filp->f_path.dentry);
+		pr_err("no right to read(%pD)\n", src_fp->filp);
 		return -EACCES;
 	}
 	if (!(dst_fp->daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE))) {
-		pr_err("no right to write(%pd)\n", dst_fp->filp->f_path.dentry);
+		pr_err("no right to write(%pD)\n", dst_fp->filp);
 		return -EACCES;
 	}
 


