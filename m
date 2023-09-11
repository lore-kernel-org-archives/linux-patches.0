Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BC81170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C537CC433C8;
	Mon, 11 Sep 2023 14:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442422;
	bh=nlPWUEXLrhthKCsLaM1EPENVpnz+UFgxEKt2cvXdKr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqqXlc6ywbcyhmURm5wzmAYqoR4W8CNwjGDyuamx+yAQ9dtpkpAUg/143WUI2M+3o
	 7txODXpvsJ8Uw8snyVOKjaTlQFirOV4Q5oWyWWcRQsaYUgLOON4FjOG9UUUzMDcyc4
	 7EW9wm1TnmTIET9hp0NXJw4YgcnpB2tKmny7ocFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Ming <machel@vivo.com>,
	Tom Talpey <tom@talpey.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 003/737] ksmbd: Fix unsigned expression compared with zero
Date: Mon, 11 Sep 2023 15:37:42 +0200
Message-ID: <20230911134650.396046322@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 911cb3d294b86..93f73c35a9c5c 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -423,7 +423,8 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 {
 	char *stream_buf = NULL, *wbuf;
 	struct mnt_idmap *idmap = file_mnt_idmap(fp->filp);
-	size_t size, v_len;
+	size_t size;
+	ssize_t v_len;
 	int err = 0;
 
 	ksmbd_debug(VFS, "write stream data pos : %llu, count : %zd\n",
@@ -440,9 +441,9 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
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
 
-- 
2.40.1



