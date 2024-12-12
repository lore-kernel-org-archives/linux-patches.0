Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39EA216E0B;
	Thu, 12 Dec 2024 17:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025154; cv=none; b=cVQAXWExxDA1nqQ/XUyR9nXLrtRBPaZOOtVd9vk5XywSxKM/BBXXmz7BfUsaE7NIXE6UHzduTN7Yzzw2kO1BsXCkaK5OJyJYjpYR02wCEkqNlWRxlQ/N6zW55DjewBOeCb2O921YzrYZ81R0J/gOqelr2cAeUpHYDwI+4gCbv+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025154; c=relaxed/simple;
	bh=RlogMfDQq7cmzFaNeJ4T4A+GVPJ0tEELX0d5asV0dtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DC1kCQRA23LdrHOJDY29G8vcKe80JVJmR8jz+Jl6AoqBTC3rMQUveGCjb0E2vQ1qFcsWGtEVtG8paee6F4sHK6rLLw3WFOIPpMTLGsn0Z7USok5+ZIxgZzUxcqIIYmqJ8Fqn95C3Lsm1IHKeCjwIYPfQKvLeqgOW35/TQcl+8VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlCSD74w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlCSD74w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27549C4CECE;
	Thu, 12 Dec 2024 17:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025154;
	bh=RlogMfDQq7cmzFaNeJ4T4A+GVPJ0tEELX0d5asV0dtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlCSD74wPJH2d9q8IkUvqges2WawICHn1BboJI22NDOGNj5PyW/ZJvFIIW/3XU46J
	 7q8Hda17gMFH0lnDFimCa4zeOkWPoCmi7LdnSgwsXQZjCUiWUQ66s9w476u1aMICX9
	 mKtkc71c2ahWNHesZfoSvlQn+23DAow2jX4VP8P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/321] crypto: bcm - add error check in the ahash_hmac_init function
Date: Thu, 12 Dec 2024 15:59:22 +0100
Message-ID: <20241212144231.734594471@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 98b8483577ce2..75fdaa311c4a6 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2478,6 +2478,7 @@ static int ahash_hmac_setkey(struct crypto_ahash *ahash, const u8 *key,
 
 static int ahash_hmac_init(struct ahash_request *req)
 {
+	int ret;
 	struct iproc_reqctx_s *rctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct iproc_ctx_s *ctx = crypto_ahash_ctx(tfm);
@@ -2487,7 +2488,9 @@ static int ahash_hmac_init(struct ahash_request *req)
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



