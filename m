Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565FC2D47F1;
	Sat, 12 Sep 2026 14:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222714; cv=none; b=UHlTXb9eRC+gFmwxWp7biLOp9HmfY2Gy5iCE4/1iMuBHuOrumcvFvG5XRPeBF1G8nhJPIH3yYw210wgFAFs44qZUmQwejZMGxfffLjA3GO18Z420Bm9l69FhosxGcu2NLaIqslv9lPTJi1eDNrPmUMixoSpfYrffR8qKAd6oAfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222714; c=relaxed/simple;
	bh=bQaKAxwcJWG/PudhhH/v8NYpgYYGdCFm++2wMYEsEn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMO2lUwDT9uMxSd+/zs8P+x+1QSmpHJdjTlMP0dFPdjqNo/k34RTaHO37tIsfGjlcuxSSL/7S4EQuhDt1092pyXe9WinBQquHLMxAbxEo0o+pWlMAIT6vOuVmkfLYFyeKHeMxPHD4+eT+LJMpPjuzcCuMogT+t8N533q8YtsNWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnShQGns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnShQGns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FB91F000FF;
	Sat, 12 Sep 2026 14:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222713;
	bh=mL+BAUOGH42ELggbWOhoxy3Z2VC6WgF4RI0xllxvAg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RnShQGnsWM8vBgb7Ye4SAQqRk/xD7E3yX9RVx7C53Ww1fwk3wAOaBctJYa6KbIt1d
	 n6Dl7mSLxn0NnX0B8hyImW/ZUyf/oA3UnH8XLW+Ny7wUojsvyaey6j7gEVr189UZRL
	 xRsl62MAcvR6jY9vGzbFF+ORDUtEQ+JUaf5NsEzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0643/1424] crypto: rk3288 - fail ahash requests on HASH idle timeout
Date: Sat, 12 Sep 2026 08:51:15 +0200
Message-ID: <20260912065621.689798586@linuxfoundation.org>
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
index 8f3406289df43..da71dfb345dfc 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -322,7 +322,12 @@ static int rk_hash_run(struct crypto_engine *engine, void *breq)
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



