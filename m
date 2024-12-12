Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14512210DE;
	Thu, 12 Dec 2024 15:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018971; cv=none; b=V1zlS7AtM54TnscjKY1G+ar9rnqqqtvUDVpDngeN5HrdowOl8VtwMveoEsquAlJVGj1Q6I7Sqv/TaaeW+kplbpxMT8XspOZy+doq4ms/Ifw8qIX0/gZPw6/6RSiKXpAEqEM8O3XSlVUp1yN6/byexN9yS4az8W0KSwNkKqYe0qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018971; c=relaxed/simple;
	bh=1GsqqWc/mEKRt8/0//tZUMAKim1u7GUU/PeC8D1pRuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyFZ6aM4B6YAYQKyQA4AEQDeu3sGybyo1UL2ST2o3rrqpsNCx98CBps83XQG0C77x1idwcr9PNWx8biPC8ZZKQ+X73ryz5A6YHp5VbmmmdAnTR4uyFehsoxVtWHuY2LwMwJ+o6geiG6dhS+EA2IYQKooHpuaZ+R2WXRXxRnbxhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9xSEWl0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9xSEWl0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15D8C4CECE;
	Thu, 12 Dec 2024 15:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018971;
	bh=1GsqqWc/mEKRt8/0//tZUMAKim1u7GUU/PeC8D1pRuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9xSEWl0u9gevDslWuuBjmi/CRpNQjBpSsl+i7qfz7VJVm3OtsH0CJ6qlh1Tfen6Z
	 cCYOvZpcvUcDYIj+q3l/YAo8iULBvbI3Q7SD7Cp0kzI/r5QUfNoOQdrLcnhjeWqcn9
	 3feZiMK43wfB6oYVrTbLF1ippv5UY4MlKUsJO+tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/772] crypto: bcm - add error check in the ahash_hmac_init function
Date: Thu, 12 Dec 2024 15:50:27 +0100
Message-ID: <20241212144353.328124551@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c8c799428fe0b..9a3e4d76acf75 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -2415,6 +2415,7 @@ static int ahash_hmac_setkey(struct crypto_ahash *ahash, const u8 *key,
 
 static int ahash_hmac_init(struct ahash_request *req)
 {
+	int ret;
 	struct iproc_reqctx_s *rctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct iproc_ctx_s *ctx = crypto_ahash_ctx(tfm);
@@ -2424,7 +2425,9 @@ static int ahash_hmac_init(struct ahash_request *req)
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



