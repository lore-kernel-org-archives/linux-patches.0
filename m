Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2936C343893;
	Sat, 12 Sep 2026 09:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206428; cv=none; b=Wt5MRBhjtyTLWe5noVAOqZM8VIq52n4cak46K+poJK2MLC8VcmRT5kp6nrV8qVKPR6hdjpo0G3yag2F6k8G1vVn2+M8PICIjUVZjhlWQibpDKQwed3r51T0SDIcVb+bD8ayW3CHIXOhx5bBzXon36H3RXfKslkxcluKYe+GaPjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206428; c=relaxed/simple;
	bh=F4vu5WGlQSlrRd0GJWBJleFZJb/tl2ji62sxE/7+CVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIXpUG4l/1kOMJWheUng2dDRsJM42WlMGiM8SS9+YG3VEwJX96u5vbXVqf/PGsMPQgYn+D9wigNklfO9SgPUxUF/ODL48oOizcUX+c0UN2K5rW1RWIYFmeM8YrkXoPUsXr9wMI4vdLt1442jgoE3HequhCefmUJ4dsUEYzzBLUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BVVRZpT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BVVRZpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9718E1F000FF;
	Sat, 12 Sep 2026 09:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206426;
	bh=+i0XefTrooBqxQFqj2Pe5zn6VOKIA9oCHuUhMo32Ll0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1BVVRZpT7TLmPCVB0km71XFnI0WPxxswz7YJ73TmBlaTS/SZaS8Kioi1PI4qCUmO0
	 LPImMsSYm1Z12O6NsTG7zTDPMIAMUgykwQp3alCnqTkJZIwAJEF44UgKStbE+Fic2k
	 EwUwceC96dRdxuGnC5RnRMyCiN+ffEsJz8a8wzgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0205/1518] crypto: rk3288 - fail ahash requests on HASH idle timeout
Date: Sat, 12 Sep 2026 08:39:34 +0200
Message-ID: <20260912065628.125392364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit ae150db7826f21e8d19e54fb6243169628809c4d ]

rk_hash_run() waits for RK_CRYPTO_HASH_STS to become idle after the
final DMA transfer, but ignores the poll result. If the hash engine
never becomes idle, the driver still reads the digest registers and
finalizes the request with the previous success value.

Store the poll result and finalize the request with the timeout error
before reading the digest registers.

Fixes: 37bc22159c45 ("crypto: rockchip - use read_poll_timeout")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index b9f5a8b42e661..d3482619aa2f1 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -324,7 +324,12 @@ static int rk_hash_run(struct crypto_engine *engine, void *breq)
 	 * efficiency, and make it response quickly when dma
 	 * complete.
 	 */
-	readl_poll_timeout(rkc->reg + RK_CRYPTO_HASH_STS, v, v == 0, 10, 1000);
+	err = readl_poll_timeout(rkc->reg + RK_CRYPTO_HASH_STS, v,
+				 v == 0, 10, 1000);
+	if (err) {
+		dev_err(rkc->dev, "HASH idle timeout\n");
+		goto theend;
+	}
 
 	for (i = 0; i < crypto_ahash_digestsize(tfm) / 4; i++) {
 		v = readl(rkc->reg + RK_CRYPTO_HASH_DOUT_0 + i * 4);
-- 
2.53.0



