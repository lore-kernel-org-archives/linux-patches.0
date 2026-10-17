Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3663B9927;
	Sat, 17 Oct 2026 17:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259113; cv=none; b=Bh/5JbBmU4cttyBSMYqoe0rpOxD28qt/j1NcMrYa0pWwp1DC6WubP4RUeXe0BuNcQuU4xeyY7kjSy6xXtHnOALiKCcICva2/2cYjh5R4+jK6Jn3uCjk4pIhKMU74vxmKAWP7AmfjGV9L5IlwdDUu/jyZv7TqYELZClrrTP6gwbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259113; c=relaxed/simple;
	bh=TCZbFRYNXvEzu/AB5W2BTMFh5ToRRzB0nGZSISDFjfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PM0UgGLrjZsOb9Sq6Qk4RHUX3i/601kJyqfHDy2XJhHnkZYf0+xZsHHdeFjSag53k1YocPY2Sa0OmEMwp5Znhn6mTVxf8RXaU9ULelApG5EcXS6qpUD/92p5d8vq50kWDrPGz/zcTDN7uMQH2rC9ZRorTxDZIXhFlDOD1osVuqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHl9Up2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHl9Up2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AA31F000C4;
	Sat, 17 Oct 2026 17:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259112;
	bh=pgY1NSAshwW/xuvaQg3g5kVtRbOR4ZRv3/l9AZFLQeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mHl9Up2FLH3TdfxswoEvOfIM4/rRg6XJfU4b7lK6NPPG3Qe1jB9n+/NI5TntwyJAA
	 ZC4KHY+yzNYa4Fb6xePUQYKaP/XyTrA46qgsa2IVNFOUpL9nlcAFqI0o1DqltmCW4u
	 sKDKov8Munw3Y7f1prCMlbjiGRcPar5FBPrnEBww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1065/1674] ksmbd: use opener credentials for ADS I/O
Date: Sat, 17 Oct 2026 17:55:37 +0200
Message-ID: <20261017160458.462756592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

[ Upstream commit baa5e094886fffa7e6272edcb5e08be5ce28262c ]

Alternate data streams are stored as xattrs. Unlike regular file I/O,
their read and write paths therefore call VFS xattr helpers which recheck
inode permissions and LSM policy using the current task credentials.

Run ADS I/O with the credentials captured when the SMB handle was opened.

Cc: stable@vger.kernel.org
Reported-by: Musaab Khan <musaab.khan@protonmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 2bea89fc9ecdd..583ee58753838 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -288,17 +288,20 @@ static ssize_t ksmbd_vfs_getcasexattr(struct mnt_idmap *idmap,
 static int ksmbd_vfs_stream_read(struct ksmbd_file *fp, char *buf, loff_t *pos,
 				 size_t count)
 {
+	const struct cred *saved_cred;
 	ssize_t v_len;
 	char *stream_buf = NULL;
 
 	ksmbd_debug(VFS, "read stream data pos : %llu, count : %zd\n",
 		    *pos, count);
 
+	saved_cred = override_creds(fp->filp->f_cred);
 	v_len = ksmbd_vfs_getcasexattr(file_mnt_idmap(fp->filp),
 				       fp->filp->f_path.dentry,
 				       fp->stream.name,
 				       fp->stream.size,
 				       &stream_buf);
+	revert_creds(saved_cred);
 	if ((int)v_len <= 0)
 		return (int)v_len;
 
@@ -417,6 +420,7 @@ int ksmbd_vfs_read(struct ksmbd_work *work, struct ksmbd_file *fp, size_t count,
 static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 				  size_t count)
 {
+	const struct cred *saved_cred;
 	char *stream_buf = NULL, *wbuf;
 	struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
 	size_t size;
@@ -437,6 +441,7 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 		count = XATTR_SIZE_MAX - *pos;
 	}
 
+	saved_cred = override_creds(fp->filp->f_cred);
 	v_len = ksmbd_vfs_getcasexattr(idmap,
 				       fp->filp->f_path.dentry,
 				       fp->stream.name,
@@ -445,14 +450,14 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 	if (v_len < 0) {
 		pr_err("not found stream in xattr : %zd\n", v_len);
 		err = v_len;
-		goto out;
+		goto out_revert;
 	}
 
 	if (v_len < size) {
 		wbuf = kvzalloc(size, GFP_KERNEL);
 		if (!wbuf) {
 			err = -ENOMEM;
-			goto out;
+			goto out_revert;
 		}
 
 		if (v_len > 0)
@@ -470,6 +475,8 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 				 size,
 				 0,
 				 true);
+out_revert:
+	revert_creds(saved_cred);
 	if (err < 0)
 		goto out;
 
-- 
2.53.0



