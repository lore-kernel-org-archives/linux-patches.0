Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A92421660C;
	Thu, 12 Dec 2024 17:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023764; cv=none; b=k2bLPBadzhoDLlDNaiyYeKPsOf+UuCYSzC1eMORKq/56x5o0213BN/yk9IcdhGmP04DASuc1g9V/HWvDzBzB/QjyNUxNvTXfxbhbg10LxmgH1CJam8o7C0+um0odrE5z8Sk8DRvxrSNU1zqhvy+amqpktSiaXCntkKbG3uaF0pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023764; c=relaxed/simple;
	bh=LxU9oh1nFnEnT3oDBwKoi7k9sqYAT7qI4bT2LCEZM9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kyb+03HBIJaymtlzbZHLJxGQDCX7U/lu+3IswntFoLXg8ArLxTHYKrI+AXg1j5kHYVbi9cCoR2VnRdulT4w5e1nLEACsgGOfZG0tH4vyNs0mzVHDDDQ7W3oQay29AQEkyX17h4RPNn/A32fRi3NylqhVSPgUGN8p5ruIF8xqVjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPAcC8uN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPAcC8uN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FE0C4CECE;
	Thu, 12 Dec 2024 17:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023764;
	bh=LxU9oh1nFnEnT3oDBwKoi7k9sqYAT7qI4bT2LCEZM9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPAcC8uNFsP7nVPufipvisuMObFo7Tk5jRhtVAggBJ97QjGVKY8xb3p37gWQgWevj
	 GfUZ9/ZTf2gNdAbXKmGXBBMYXTW8u96iYpgtygq7C50Tolyi/Dtk7ksA4WyoAVQfj1
	 wIugFcB5Fq8+/934JKD75LXYzFeo8Gcf5/HeWjDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/459] crypto: bcm - add error check in the ahash_hmac_init function
Date: Thu, 12 Dec 2024 15:56:52 +0100
Message-ID: <20241212144256.445334266@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit 19630cf57233e845b6ac57c9c969a4888925467b ]

The ahash_init functions may return fails. The ahash_hmac_init should
not return ok when ahash_init returns error. For an example, ahash_init
will return -ENOMEM when allocation memory is error.

Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/bcm/cipher.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 1cb310a133b3f..b13e33b88d68a 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2417,6 +2417,7 @@ static int ahash_hmac_setkey(struct crypto_ahash *ahash, const u8 *key,
 
 static int ahash_hmac_init(struct ahash_request *req)
 {
+	int ret;
 	struct iproc_reqctx_s *rctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct iproc_ctx_s *ctx = crypto_ahash_ctx(tfm);
@@ -2426,7 +2427,9 @@ static int ahash_hmac_init(struct ahash_request *req)
 	flow_log("ahash_hmac_init()\n");
 
 	/* init the context as a hash */
-	ahash_init(req);
+	ret = ahash_init(req);
+	if (ret)
+		return ret;
 
 	if (!spu_no_incr_hash(ctx)) {
 		/* SPU-M can do incr hashing but needs sw for outer HMAC */
-- 
2.43.0



