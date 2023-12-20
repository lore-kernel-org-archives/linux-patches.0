Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFCA4A9B9;
	Wed, 20 Dec 2023 16:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBdatekZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9EDC433C7;
	Wed, 20 Dec 2023 16:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088768;
	bh=tVRCzQ/pl240/v2MSm886cK89dFF82KXFr5W03aZyOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBdatekZlUa+1oSe+52zArih2l2j3OJoyOtA+GSCViPBZUwV0Z/Ya5yaLmF6sKi9/
	 P6gSXD9bWITlT/JwYtZWn8ESP2DxVcjCrmj8hlb4QRsCGh2S1NaeQ0PRzKOFdT5OHW
	 vmA4L7v4vcYcisiBOSHdK/1M8SeVmpFbOOiFBkHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 051/159] ksmbd: remove generic_fillattr use in smb2_open()
Date: Wed, 20 Dec 2023 17:08:36 +0100
Message-ID: <20231220160933.714855265@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 823d0d3e2b05791ba8cbab22574b947c21f89c18 ]

Removed the use of unneeded generic_fillattr() in smb2_open().

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2809,7 +2809,6 @@ int smb2_open(struct ksmbd_work *work)
 	} else {
 		file_present = true;
 		user_ns = mnt_user_ns(path.mnt);
-		generic_fillattr(user_ns, d_inode(path.dentry), &stat);
 	}
 	if (stream_name) {
 		if (req->CreateOptions & FILE_DIRECTORY_FILE_LE) {
@@ -2818,7 +2817,8 @@ int smb2_open(struct ksmbd_work *work)
 				rsp->hdr.Status = STATUS_NOT_A_DIRECTORY;
 			}
 		} else {
-			if (S_ISDIR(stat.mode) && s_type == DATA_STREAM) {
+			if (file_present && S_ISDIR(d_inode(path.dentry)->i_mode) &&
+			    s_type == DATA_STREAM) {
 				rc = -EIO;
 				rsp->hdr.Status = STATUS_FILE_IS_A_DIRECTORY;
 			}
@@ -2835,7 +2835,8 @@ int smb2_open(struct ksmbd_work *work)
 	}
 
 	if (file_present && req->CreateOptions & FILE_NON_DIRECTORY_FILE_LE &&
-	    S_ISDIR(stat.mode) && !(req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)) {
+	    S_ISDIR(d_inode(path.dentry)->i_mode) &&
+	    !(req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)) {
 		ksmbd_debug(SMB, "open() argument is a directory: %s, %x\n",
 			    name, req->CreateOptions);
 		rsp->hdr.Status = STATUS_FILE_IS_A_DIRECTORY;
@@ -2845,7 +2846,7 @@ int smb2_open(struct ksmbd_work *work)
 
 	if (file_present && (req->CreateOptions & FILE_DIRECTORY_FILE_LE) &&
 	    !(req->CreateDisposition == FILE_CREATE_LE) &&
-	    !S_ISDIR(stat.mode)) {
+	    !S_ISDIR(d_inode(path.dentry)->i_mode)) {
 		rsp->hdr.Status = STATUS_NOT_A_DIRECTORY;
 		rc = -EIO;
 		goto err_out;


