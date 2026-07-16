Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31652431A47;
	Thu, 16 Jul 2026 14:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212035; cv=none; b=j8/ZnrcvODAoGMAfjXr/oCdacNXDAdjyxIvWMcQORuesiVQNb9nt5Ff4T+z9Ic6RqnYcBqpy+V+OkZisG88LmwEJvuzz8fnLLf7nLuL6/C4SLCo29FeeF+YbVdNcw8y4qrNYC1seaHALHQKPZ9qgFXX98eRV3mJgrnvjLmq/PWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212035; c=relaxed/simple;
	bh=4g/RoDSuutQPKmMXLRDw3vqRXChErEPBI5uhgaenHFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gs8lHI9nt/ZT6tO8BxRD3Nk1Crc0q50bqQ3YtBjBTU9OfJM1GfENZfWdZ5ZtSB3GAD/mkWJGWsBER5IbfRcBYlEHXbhW5L4tnYiSlalIIUND5ssWF1pL1IIDQtorgJdEvIVdKuCt+itNq+0jJa3ZcxR/szZN4iq/Sw1MjUSmY0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCJS6opk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCJS6opk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B161F000E9;
	Thu, 16 Jul 2026 14:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212034;
	bh=AM8afLmzqaMzeEnclAIlHwbM6tXumn8mZft/qFN6ZPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCJS6opk1ZlvR09acbXmHOvuqyTi4oP3t4C090cWXFDw4WonqM1Rrxn/+Lnhrr3Kt
	 WlG8W4HFPMyjKmp2UiEDzAygMXlMyzOEhI5j7faM0txlvZGXCAvzoUEPg8b8/9McZg
	 iXDKXqu2x+G6a81USGeuCIV2CUM6SU2f25Thkc0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Musaab Khan <musaab.khan@protonmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 173/349] ksmbd: use opener credentials for ADS I/O
Date: Thu, 16 Jul 2026 15:31:47 +0200
Message-ID: <20260716133037.249356511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -288,17 +288,20 @@ out:
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
 
@@ -420,6 +423,7 @@ int ksmbd_vfs_read(struct ksmbd_work *wo
 static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 				  size_t count)
 {
+	const struct cred *saved_cred;
 	char *stream_buf = NULL, *wbuf;
 	struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
 	size_t size;
@@ -440,6 +444,7 @@ static int ksmbd_vfs_stream_write(struct
 		count = XATTR_SIZE_MAX - *pos;
 	}
 
+	saved_cred = override_creds(fp->filp->f_cred);
 	v_len = ksmbd_vfs_getcasexattr(idmap,
 				       fp->filp->f_path.dentry,
 				       fp->stream.name,
@@ -448,14 +453,14 @@ static int ksmbd_vfs_stream_write(struct
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
@@ -473,6 +478,8 @@ static int ksmbd_vfs_stream_write(struct
 				 size,
 				 0,
 				 true);
+out_revert:
+	revert_creds(saved_cred);
 	if (err < 0)
 		goto out;
 


