Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3D43F8D6;
	Wed, 20 Dec 2023 16:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VnXxlTkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8212C433C7;
	Wed, 20 Dec 2023 16:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088942;
	bh=QMNqwAf8J0Qv/L5nWjdLSnh5DRO5AMGO6VzJIalYiFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VnXxlTkUoxo+ffRxdWMkWc2HWke5XL+2pvpFBN7qZYoGahg6r+S8Tg1s41snbOklT
	 AxJ2onOxVW7Or1xah6PzsmkqT7uIDgoesa8whazU1YjkJYj7uK8Nb9BZYmQT4Eq7bo
	 /Fl8UIjksKgYSr93m0DJQVSiBtnAlY9Nwez7cByk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Ming <machel@vivo.com>,
	Tom Talpey <tom@talpey.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 114/159] ksmbd: Fix unsigned expression compared with zero
Date: Wed, 20 Dec 2023 17:09:39 +0100
Message-ID: <20231220160936.658898527@linuxfoundation.org>
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

From: Wang Ming <machel@vivo.com>

[ Upstream commit 0266a2f791294e0b4ba36f4a1d89b8615ea3cac0 ]

The return value of the ksmbd_vfs_getcasexattr() is signed.
However, the return value is being assigned to an unsigned
variable and subsequently recasted, causing warnings. Use
a signed type.

Signed-off-by: Wang Ming <machel@vivo.com>
Acked-by: Tom Talpey <tom@talpey.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/vfs.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -412,7 +412,8 @@ static int ksmbd_vfs_stream_write(struct
 {
 	char *stream_buf = NULL, *wbuf;
 	struct user_namespace *user_ns = file_mnt_user_ns(fp->filp);
-	size_t size, v_len;
+	size_t size;
+	ssize_t v_len;
 	int err = 0;
 
 	ksmbd_debug(VFS, "write stream data pos : %llu, count : %zd\n",
@@ -429,9 +430,9 @@ static int ksmbd_vfs_stream_write(struct
 				       fp->stream.name,
 				       fp->stream.size,
 				       &stream_buf);
-	if ((int)v_len < 0) {
+	if (v_len < 0) {
 		pr_err("not found stream in xattr : %zd\n", v_len);
-		err = (int)v_len;
+		err = v_len;
 		goto out;
 	}
 


