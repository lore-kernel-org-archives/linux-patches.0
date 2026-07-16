Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5E43148C2;
	Thu, 16 Jul 2026 14:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210916; cv=none; b=e7ClhZaKXtNn3git1XqHfHWLFbZVUJxJQJPQb4Cw1/zQVa/xS///h4uBc1KcKv5k5jehGJPa4mrZ01swhIOfOUiUx6P9np9NX6XjLiUpS7Ej5SAUwnO/tnhq+N3ofPTOQu2oU4to8RIMOzYwuCMYgiTk+zqCXuYHAbsOLmD2Lq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210916; c=relaxed/simple;
	bh=kMZ5U7EeWQXgWRuQlTDN+EKqAKkN3wWpTalB1uz2L3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BX+KAZFtxZbVmogs3fwemmX1gCJx577h8MhQUeC2Ua6k1ggkcDcPMUh/AClqdwbtlKuo8OqMhD2pW/CgdpvNGohzK4FoO4nluCB337rF7vU75fG7GTSfyEVFvifv85iCl5NMfaOqvt2uyCmGt1KHmaf5PvLMhCIhmMmZRtyvP8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Shpmt9wq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Shpmt9wq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D0F1F000E9;
	Thu, 16 Jul 2026 14:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210915;
	bh=nsPotdvgttC4yDrorQWqYRdTGmxKQvNrhS4l3SwOxuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Shpmt9wqJSlAqkFxoZbdwD9IzVw3KImSHZtkCpyMEFS6Bv7+yyQ/nk1WM3Yu1vx6J
	 +4B7uFhUSONA8ZYnHZC6dqUC/0U74bcc6ZTWKoaFO09EBjGlaKEeNk23f1HwzdePDR
	 g1HQ2GaCT+185kU+2VeU9qIvVXUJB+cKyypFcUG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 227/480] ksmbd: use opener credentials for ADS I/O
Date: Thu, 16 Jul 2026 15:29:34 +0200
Message-ID: <20260716133049.724763893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

commit baa5e094886fffa7e6272edcb5e08be5ce28262c upstream.

Alternate data streams are stored as xattrs. Unlike regular file I/O,
their read and write paths therefore call VFS xattr helpers which recheck
inode permissions and LSM policy using the current task credentials.

Run ADS I/O with the credentials captured when the SMB handle was opened.

Cc: stable@vger.kernel.org
Reported-by: Musaab Khan <musaab.khan@protonmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -278,17 +278,20 @@ out:
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
 
@@ -411,6 +414,7 @@ int ksmbd_vfs_read(struct ksmbd_work *wo
 static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 				  size_t count)
 {
+	const struct cred *saved_cred;
 	char *stream_buf = NULL, *wbuf;
 	struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
 	size_t size;
@@ -431,6 +435,7 @@ static int ksmbd_vfs_stream_write(struct
 		count = XATTR_SIZE_MAX - *pos;
 	}
 
+	saved_cred = override_creds(fp->filp->f_cred);
 	v_len = ksmbd_vfs_getcasexattr(idmap,
 				       fp->filp->f_path.dentry,
 				       fp->stream.name,
@@ -439,14 +444,14 @@ static int ksmbd_vfs_stream_write(struct
 	if (v_len < 0) {
 		pr_err("not found stream in xattr : %zd\n", v_len);
 		err = v_len;
-		goto out;
+		goto out_revert;
 	}
 
 	if (v_len < size) {
 		wbuf = kvzalloc(size, KSMBD_DEFAULT_GFP);
 		if (!wbuf) {
 			err = -ENOMEM;
-			goto out;
+			goto out_revert;
 		}
 
 		if (v_len > 0)
@@ -464,6 +469,8 @@ static int ksmbd_vfs_stream_write(struct
 				 size,
 				 0,
 				 true);
+out_revert:
+	revert_creds(saved_cred);
 	if (err < 0)
 		goto out;
 	else


