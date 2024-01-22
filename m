Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F891487F4;
	Tue, 23 Jan 2024 00:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969177; cv=none; b=aJfkSz2ryfSF1oGLOICWOhhjueY8w35igvvG4N2+Z/ailCnQeKfhvT+aHVBPTObA7iXpGZ3sRl1Y1QwOo61F0x37WoJPh3Lb0Pp1acMgzFwlyhtLeEFDMegKdZv0+6WsBS4GrVuHzv26zbu6eRY4qI+cCLV3V9CTsRC79ayXOJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969177; c=relaxed/simple;
	bh=1mtKUiMCq22peQmMtKHAp2z7SMRkS9knynAIQButmoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiMDreTkWu0+PyZ1njjaOa7l/DeUwa6RCL2B6u3rGPV8IDKYitAOsdrdUCqKGOcrXohrkecyQFt7n8gFlDNiDNiRlAwsAPNDp+27ODDnPrBGtkTRU49VgKDHIDoaNFZZ59uEKhzL+1ioSsbbtBligWIBBT2wBtQp68dsu0SRCs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCeIYUn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCeIYUn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FABAC433F1;
	Tue, 23 Jan 2024 00:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969177;
	bh=1mtKUiMCq22peQmMtKHAp2z7SMRkS9knynAIQButmoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCeIYUn3B+hNjQbW+golLtK1W6zAkC+ZyGeb/XXnWo1tMFo4n/cdkCakIlpEbsh1b
	 3zjODfopGVxpzarQEZULfti6vKKgufWLDIh5tQhflOc120OVV5iA+JXk4Z9eLklTmL
	 38orRCYPyKBdrkuVe5kM3ggoqw2aP8j4ZTVkjrsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 076/641] crypto: sahara - handle zero-length aes requests
Date: Mon, 22 Jan 2024 15:49:40 -0800
Message-ID: <20240122235820.413558036@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 0771c7160c47..78666b82ac80 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -676,6 +676,9 @@ static int sahara_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct sahara_dev *dev = dev_ptr;
 	int err = 0;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (unlikely(ctx->keylen != AES_KEYSIZE_128))
 		return sahara_aes_fallback(req, mode);
 
-- 
2.43.0



