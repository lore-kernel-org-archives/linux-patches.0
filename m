Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E11F34252D;
	Sat, 12 Sep 2026 09:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206423; cv=none; b=ZoJROPHC8zS8oeGiKsRuI2uaG6M72T8VcrvqK+Qn9Fo6AfKECoTL68/dVy1mLaWYbzALrEPKzOAwvuGes6yju25FDkmtdqPgKo8gzoZdWcGqnrsLcVv9KMMcgExOSyN9kVwXbh2KSAtfsxPjD3BjKH17GE6xjRV4j4ALrXruero=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206423; c=relaxed/simple;
	bh=3AyKBmm3T1K+c1PIaYZ8Vi1u4pDEco5nlb1O0L1XuNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jnr6wamckojkkMIE+ktkUSpYYCTrwwQEejU0iHLn/gUn/a61P/yjZe94aBYezKypW++9Y6CYEwmIr+pC9QJQW5OYFUhwJio42mEpN21/zOJTNdj00TI2dyC96t7QN3393d97BL//3yTIbPTfDRLL7jqLp/bCtjJyUifNTVVvqis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJdyXxHX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJdyXxHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5941F000FF;
	Sat, 12 Sep 2026 09:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206422;
	bh=NBaGNkmCyM3K8X67OoGNiic21bB/dpl5zJyyA0qIf8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJdyXxHXjJgJqyY82FN/tl2Nd8WoXVZGDE6m53WsQPRtkyW+54E88c294Leg3f5vu
	 9rGhjZW2F++peLna06mDwx+sb5TeB/fMtCDGxGrYadPST42XjutzjI8X9Jy2ABZ0N8
	 pfb2gTBXrF8dmDaKXXj44fw1zG+raJrP2ApRCh5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0204/1518] hwrng: xilinx-trng - propagate timeout before any data is read
Date: Sat, 12 Sep 2026 08:39:33 +0200
Message-ID: <20260912065628.102632722@linuxfoundation.org>
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

[ Upstream commit ba088974419326daf46c5dc03e2cf6ab6ab701f7 ]

xtrng_readblock32() polls for 16-byte chunks but returns the number of
bytes read even when the first poll times out. Its caller then treats a
zero return as a short successful read, and partial reads for full
32-byte blocks can make the tail copy use a fixed block offset rather
than the amount already produced.

Return the poll error when no data has been read, preserve partial
positive returns after some data is available, stop the generator on all
collection exits, and append tail bytes at the current output count.

Fixes: 8979744aca80 ("crypto: xilinx - Add TRNG driver for Versal")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/xilinx/xilinx-trng.c | 32 +++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/xilinx/xilinx-trng.c b/drivers/crypto/xilinx/xilinx-trng.c
index 3b193471cc94c..7f9762ea042bb 100644
--- a/drivers/crypto/xilinx/xilinx-trng.c
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -91,8 +91,8 @@ static void xtrng_softreset(struct xilinx_rng *rng)
 	xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET, TRNG_CTRL_PRNGSRST_MASK, 0);
 }
 
-/* Return no. of bytes read */
-static size_t xtrng_readblock32(void __iomem *rng_base, __be32 *buf, int blocks32, bool wait)
+/* Return no. of bytes read or a negative error before any data is read. */
+static int xtrng_readblock32(void __iomem *rng_base, __be32 *buf, int blocks32, bool wait)
 {
 	int read = 0, ret;
 	int timeout = 1;
@@ -107,8 +107,11 @@ static size_t xtrng_readblock32(void __iomem *rng_base, __be32 *buf, int blocks3
 		ret = readl_poll_timeout(rng_base + TRNG_STATUS_OFFSET, val,
 					 (val & TRNG_STATUS_QCNT_MASK) ==
 					 TRNG_STATUS_QCNT_16_BYTES, !!wait, timeout);
-		if (ret)
+		if (ret) {
+			if (!read)
+				return ret;
 			break;
+		}
 
 		for (idx = 0; idx < TRNG_READ_4_WORD; idx++) {
 			*(buf + read) = cpu_to_be32(ioread32(rng_base + TRNG_CORE_OUTPUT_OFFSET));
@@ -123,27 +126,40 @@ static int xtrng_collect_random_data(struct xilinx_rng *rng, u8 *rand_gen_buf,
 {
 	u8 randbuf[TRNG_SEC_STRENGTH_BYTES];
 	int byteleft, blocks, count = 0;
+	int full_blocks_bytes;
 	int ret;
 
 	byteleft = no_of_random_bytes & (TRNG_SEC_STRENGTH_BYTES - 1);
 	blocks = no_of_random_bytes >> TRNG_SEC_STRENGTH_SHIFT;
+	full_blocks_bytes = blocks * TRNG_SEC_STRENGTH_BYTES;
 	xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET, TRNG_CTRL_PRNGSTART_MASK,
 			  TRNG_CTRL_PRNGSTART_MASK);
 	if (blocks) {
 		ret = xtrng_readblock32(rng->rng_base, (__be32 *)rand_gen_buf, blocks, wait);
-		if (!ret)
-			return 0;
+		if (ret <= 0) {
+			count = ret;
+			goto out_stop;
+		}
 		count += ret;
+		if (ret < full_blocks_bytes)
+			goto out_stop;
 	}
 
 	if (byteleft) {
 		ret = xtrng_readblock32(rng->rng_base, (__be32 *)randbuf, 1, wait);
+		if (ret < 0) {
+			if (!count)
+				count = ret;
+			goto out_stop;
+		}
 		if (!ret)
-			return count;
-		memcpy(rand_gen_buf + (blocks * TRNG_SEC_STRENGTH_BYTES), randbuf, byteleft);
-		count += byteleft;
+			goto out_stop;
+		ret = min(ret, no_of_random_bytes - count);
+		memcpy(rand_gen_buf + count, randbuf, ret);
+		count += ret;
 	}
 
+out_stop:
 	xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET,
 			  TRNG_CTRL_PRNGMODE_MASK | TRNG_CTRL_PRNGSTART_MASK, 0U);
 
-- 
2.53.0



