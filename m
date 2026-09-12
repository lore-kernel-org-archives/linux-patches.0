Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B9E340400;
	Sat, 12 Sep 2026 15:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225705; cv=none; b=IZl03L6VWhGEEN7NLLiRLSsMpWuEqVKXrgyP+ZF1HhBbbl8XXkwgllGaCwjQmsiVjQI7scPJfbZRgVWqrTCSpF8Ew/+JKBJc6wDrm3wwhRmKfTB1kEB2SsiVjyy+SbJkAR7t7RBYVdNYLQr3GS/4m1CqkqCBPgaF7J+4zj54DMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225705; c=relaxed/simple;
	bh=CaHdWylbO3RS8tKtREGg62uQsCS6TF7XaveUV7Pk6CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtsQvFCHq+mo65oRMTcUKekmG5ksEFfxZB68Ib2s63bEiBgOO8lmJ+5WFlZmo7z++PUZMFvUAwSvOL7Sh9XHYV1Vtta0u/lpe6+Sgg7l5+QGiT1BdmlTd9SPIXpCAa8deb3LemcssbMo4h3WvOK8Z+jnFZy5WEJM7iWF4i0v5yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbteXy1g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbteXy1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8611F000FF;
	Sat, 12 Sep 2026 15:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225704;
	bh=k/TelgA8+e6uPmSXiGuqVR0bK0jdUzsScOGfN9asdMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BbteXy1gaAy47IwwLXYqiBLdvyVEwEjsFO5i3zfzn/gnBSpr5sZUI+Rog+BRArU80
	 ka4fBZTw3WacCrjiS0zVJqBjEp9ycstq3jKxQyuM++HxhDLk20r4GCuFr52i/+yomQ
	 fkcBc93cPN0xBa/kSf3c/RWoUzbzojGAtoudLU/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1252/1424] smb/server: preserve error status in smb2_handle_negotiate()
Date: Sat, 12 Sep 2026 09:01:24 +0200
Message-ID: <20260912065635.320693196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit 73541bd2bab77e7e8e89b1edb5d342f4190dd4d0 ]

smb2_handle_negotiate() records specific failures such as
STATUS_INVALID_PARAMETER or STATUS_NOT_SUPPORTED.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index dd9aadea61af7..807bfcebb5c24 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1163,7 +1163,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 				GFP_KERNEL);
 		if (!conn->preauth_info) {
 			rc = -ENOMEM;
-			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 			goto err_out;
 		}
 
@@ -1260,7 +1260,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	ksmbd_conn_set_need_setup(conn);
 
 err_out:
-	if (rc)
+	if (rc && rsp->hdr.Status == STATUS_SUCCESS)
 		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 
 	if (!rc)
-- 
2.53.0



