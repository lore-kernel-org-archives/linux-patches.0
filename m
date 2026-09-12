Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1AB3563FB;
	Sat, 12 Sep 2026 12:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214839; cv=none; b=DZQmjGNN2wEy4DKlbnkYxiBFX4QNhsfnPHB/Srrz4KbpFJD2jm+ToPucXz/grRqVUmXverwDadjZXe6M7wlI1Xe4mRkYk5msa14DqkNpPRsC2qQMnuJytCOQ6jcm/wHM1bmB+BRaRipoesXzIyCsGtbzaNPih9CHyca3XgXnndg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214839; c=relaxed/simple;
	bh=QLucAwma8sihP2Ej19HjWugZb24wGaiRoRZ4dO0MHbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5wfxyon45uOI4jSptm59BJY29aJOrcCP6VrlWPYV1CD7H1c+03FwQIszAw7GjW82tceoG2xE6EQbNiiKQ9V5IWdSgjnm1IcamRiljKhuIPEcKLRV4MHEDR/JkUK8HGEfOD9GvoDjQ3zaD97PjGQof1WxkxK6PBh8OEZffiBSg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6NHABVj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6NHABVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3DA1F000FF;
	Sat, 12 Sep 2026 12:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214838;
	bh=vhhvEbPIWO2qizUnT47W2+MoF1UNf9nVnj28cX+UMUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k6NHABVjSqHmE2kRFOrnP/eQtD1neRTE3OIZ2ghmqbRkMuQ3TIBSnBxSYZ7UsYJ9+
	 RsslnsJ1hxJpNQEEKqqk1aU5kImnNPMUKTED7DrWEaekiBWN1NJy0RHap8SJi9YH1N
	 o4t7p+vZSRBMlrTJvRxeycsAXtibhcYEb7dMjOdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0407/1376] crypto: rk3288 - fail ahash requests on HASH idle timeout
Date: Sat, 12 Sep 2026 08:47:13 +0200
Message-ID: <20260912065616.613681604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ba26b4db7a608..f726e53df9fed 100644
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



