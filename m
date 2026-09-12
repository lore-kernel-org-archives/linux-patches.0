Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14C8346E75;
	Sat, 12 Sep 2026 07:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197524; cv=none; b=KR7qynP/pR1aA6m7XbrTAWdvZ6tjvW+d4I85gp07PH7TiYG1+H0xLA1QBRfdra86hEobuwZx1eS9CCTCzx2uIwv7CyUuYbwE/gSNGhIiHWUD+CjiPCM19ZW2g0qkhCQ+LAgpuCdlilAlLOiULuq12+kqeWq7lyC1fTuy3/cN9xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197524; c=relaxed/simple;
	bh=OweIowaJ5p9yZ0CcflI42irG/YoAgLg5RXDrycKfMjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfYK6dCmbcM1xZQOcBP6oySWrYqPW3lVTwLxDA2AieGxVKlzfV3sKJX2XtxJDpclccy6+K7jojAaBmnmX46yUB4UNUJMNmxLLpjxV4gqLdyluOa5g1o5iSvlRZs+2qY8SfYNxOFwCVopGsZ0KAGy7jkb5oZNLeQTX8iB4X3mWYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4JeoTq+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4JeoTq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE91A1F000FF;
	Sat, 12 Sep 2026 07:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197523;
	bh=TRjkktj8nN+V9qiV1feiXdjX+U65V5LPtsx6TqjHiGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4JeoTq+cYaU0400mN6w9OtNDarQ+oJwRzfBAT+VlbY0izYFptyN1c2VMsiHtp0Nf
	 qlRP0SSjIhtcy8nmqsFDVBwlFAgNt5BJK15gMVX3+i1nIsbRU1tjVR0Lax+WQWLf/Y
	 uczzrlKHfOluwiQO4UJIqzNUMX6D4zqJD8QFYl8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0193/1815] hwrng: xilinx-trng - propagate timeout before any data is read
Date: Sat, 12 Sep 2026 08:32:23 +0200
Message-ID: <20260912065653.531112599@linuxfoundation.org>
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
 drivers/char/hw_random/xilinx-trng.c | 32 +++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/xilinx-trng.c b/drivers/char/hw_random/xilinx-trng.c
index 0fbc22c38fbc7..290bf5bc82db8 100644
--- a/drivers/char/hw_random/xilinx-trng.c
+++ b/drivers/char/hw_random/xilinx-trng.c
@@ -86,8 +86,8 @@ static void xtrng_softreset(struct xilinx_rng *rng)
 	xtrng_readwrite32(rng->rng_base + TRNG_CTRL_OFFSET, TRNG_CTRL_PRNGSRST_MASK, 0);
 }
 
-/* Return no. of bytes read */
-static size_t xtrng_readblock32(void __iomem *rng_base, __be32 *buf, int blocks32, bool wait)
+/* Return no. of bytes read or a negative error before any data is read. */
+static int xtrng_readblock32(void __iomem *rng_base, __be32 *buf, int blocks32, bool wait)
 {
 	int read = 0, ret;
 	int timeout = 1;
@@ -102,8 +102,11 @@ static size_t xtrng_readblock32(void __iomem *rng_base, __be32 *buf, int blocks3
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
@@ -118,27 +121,40 @@ static int xtrng_collect_random_data(struct xilinx_rng *rng, u8 *rand_gen_buf,
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



