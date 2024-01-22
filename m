Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E109223BD;
	Tue, 23 Jan 2024 01:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972186; cv=none; b=EsHZbXihOzOiLW+IT23viT+AIgkYilgRnM69ApaaEBr9PBxUOk+JcFdBE4MYOj4OvOssaTZW0UrM+jGQGQ2V64ug7+xvGfADy2BaGldQU7QAMBGNvFeCwqmZ8HOWgmj+sQT4IzeH+jE1r4BMFGw3NyGUu6y9LbdK8Fnsk1xb0dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972186; c=relaxed/simple;
	bh=lVaStt9n67MkAkIQqmflBTNcRfssoAbzq6Yp+SizIb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQj8QaBzbKcs8F49TTBTk7lKheJL9POF+2FxzIn/QRYypzQpGG2hSK+g3g2lG17SUpy5aR+UVQ/oexscocCJ1Ay6wbmF1jtPRa/wBR4NYsGyQ71M+cku+ZO5fgmbMZO+O89ksxchqI1/THxkm5PUnnxwcVOnXYUo3ZYcK6mJCZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2V3mmZ0h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2V3mmZ0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD82C433A6;
	Tue, 23 Jan 2024 01:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972185;
	bh=lVaStt9n67MkAkIQqmflBTNcRfssoAbzq6Yp+SizIb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2V3mmZ0hzat4ox5X3awQ4kHIC2sGRCiZdItf2QDzlYVXKUL7syfy3yNyOWZT9s/xH
	 BM2BSjTMbQatWlQ8dQ9Un26wXh5vs8RsM+wSVphtRnYJ0p+ndbFUCk3VC7kNx5Aqan
	 hE0+S+CPqqsrdHT5WFhlwp+IbMGwib+gafqhuRAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/374] crypto: sahara - handle zero-length aes requests
Date: Mon, 22 Jan 2024 15:56:04 -0800
Message-ID: <20240122235748.377521962@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit d1d6351e37aac14b32a291731d0855996c459d11 ]

In case of a zero-length input, exit gracefully from sahara_aes_crypt().

Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index bbd2c6474b50..3229dd180d0c 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -677,6 +677,9 @@ static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct sahara_dev *dev = dev_ptr;
 	int err = 0;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128))
 		return sahara_aes_fallback(req, mode);
 
-- 
2.43.0



