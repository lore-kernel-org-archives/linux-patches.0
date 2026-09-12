Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3458237757A;
	Sat, 12 Sep 2026 07:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197534; cv=none; b=bZ9CQnlApIB1RJHgRYK/NzVuW0+Gz0W+3cTvlPbCE0a+CZLWt3n36V0dea9haEGqFf1ghmySCl/1eMTRCBkw+jnuMjcEduc/BwotOiZ01I/A5pDrtLowNeLm675ZDZ0iD68/C+DNHAZmnLxfQBlLAbiTt4tglOzBwi5OIEXRyeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197534; c=relaxed/simple;
	bh=womAdhC3bOIg9DSdMxbxiN9BR8U2Mgtpw4pGeKR+5Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwLWhFK2PaY62HABbWOMLE5sZHRW9zdj6IguJW12kw1Qm9OrQ8nDHwjFWuYGGw7g9qhMJuV3yBBTxYTvcwL3EzdM1EpIrm5OZ1QyQsq1Cx3Bx7a7oFR62mAVucS/AOrrJdf1LMCBcFTa+6BFQ144jaVTSWL+UboAA1ZkOuQe8rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6+5gcRR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6+5gcRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4F01F000FF;
	Sat, 12 Sep 2026 07:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197533;
	bh=cD8JZFQggZpfKR2WmQ2H7P2kCIfClAkLeaz8L46axIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6+5gcRRjDdmw/BhMIbyNHGxUdHJ8cjKJpQMYCztzW06jK4mSSx2zw/AmCUSr6LEB
	 ekRffJIXpbDwUfVj2klwNznS01fKhk06IGPOam/kApBZCTpkm0hpUaQ409P+YHWumt
	 w0G6NQj3MyfYxkyuE/oxLZ+dDn+OzPSgcAwcqNNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0195/1815] crypto: rk3288 - fail ahash requests on HASH idle timeout
Date: Sat, 12 Sep 2026 08:32:25 +0200
Message-ID: <20260912065653.576950391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



