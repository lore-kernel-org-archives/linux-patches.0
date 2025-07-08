Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DE02E49A8;
	Tue,  8 Jul 2025 16:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992886; cv=none; b=HLOqDmeZdHlK0Dyp9ZljaT18jDlK8NOXPXibcR8Asu4N5P5859uxr2W5vpSnURGeoUQ5ELGnHtNxFDejBwryoI1IZrL+M0sSo5R5eKQSTlcbfyhor6pJUTMg+TR3IP4OnBZsxo8jDiy8bqp4ypk9s+PHnhQoyvR5tfvQi2EASfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992886; c=relaxed/simple;
	bh=kwYCKBLwZ7leQSjcDzkNwfqxX6EZBm/smVJtjnZGQMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r95X/Ml1TVlxWgeHaRO3o+0sSgp06kdsNbgjJxn5tC1bu/o0ZlrxYA5wDdRfImUyLZXGzyjfVBpUYZkwJ6Sn7ESJOOBSfJSZjPva5/0rS69bQH8iCKd8Svon8WeRJxAUXb7pcvHKUhuAwij8nc2AQ3sBqQlpWP5pctcT8g6Skbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSMQC088; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSMQC088"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B61C4CEED;
	Tue,  8 Jul 2025 16:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992886;
	bh=kwYCKBLwZ7leQSjcDzkNwfqxX6EZBm/smVJtjnZGQMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSMQC088lVnT0VjgCfWupALCwOvjOSja6XNcP7zbizs+p0Gv6J5Bc0RPhga0t+jFI
	 QA0Jcg66vGmj0/i6S15V3lbA/dt8GxOcDBiD/t9x9b1/E2HgUoau4py9+8211wjBm1
	 Dls09K5+6y2XoDUFrpG1cE+iDW9HdWNmdPzHT3Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/232] crypto: zynqmp-sha - Add locking
Date: Tue,  8 Jul 2025 18:21:33 +0200
Message-ID: <20250708162243.986359807@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit c7e68043620e0d5f89a37e573c667beab72d2937 ]

The hardwrae is only capable of one hash at a time, so add a lock
to make sure that it isn't used concurrently.

Fixes: 7ecc3e34474b ("crypto: xilinx - Add Xilinx SHA3 driver")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/xilinx/zynqmp-sha.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
index 1bcec6f46c9c7..9b5345068604f 100644
--- a/drivers/crypto/xilinx/zynqmp-sha.c
+++ b/drivers/crypto/xilinx/zynqmp-sha.c
@@ -3,18 +3,19 @@
  * Xilinx ZynqMP SHA Driver.
  * Copyright (c) 2022 Xilinx Inc.
  */
-#include <linux/cacheflush.h>
 #include <crypto/hash.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sha3.h>
-#include <linux/crypto.h>
+#include <linux/cacheflush.h>
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/err.h>
 #include <linux/firmware/xlnx-zynqmp.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/spinlock.h>
 #include <linux/platform_device.h>
 
 #define ZYNQMP_DMA_BIT_MASK		32U
@@ -43,6 +44,8 @@ struct zynqmp_sha_desc_ctx {
 static dma_addr_t update_dma_addr, final_dma_addr;
 static char *ubuf, *fbuf;
 
+static DEFINE_SPINLOCK(zynqmp_sha_lock);
+
 static int zynqmp_sha_init_tfm(struct crypto_shash *hash)
 {
 	const char *fallback_driver_name = crypto_shash_alg_name(hash);
@@ -124,7 +127,8 @@ static int zynqmp_sha_export(struct shash_desc *desc, void *out)
 	return crypto_shash_export(&dctx->fbk_req, out);
 }
 
-static int zynqmp_sha_digest(struct shash_desc *desc, const u8 *data, unsigned int len, u8 *out)
+static int __zynqmp_sha_digest(struct shash_desc *desc, const u8 *data,
+			       unsigned int len, u8 *out)
 {
 	unsigned int remaining_len = len;
 	int update_size;
@@ -159,6 +163,12 @@ static int zynqmp_sha_digest(struct shash_desc *desc, const u8 *data, unsigned i
 	return ret;
 }
 
+static int zynqmp_sha_digest(struct shash_desc *desc, const u8 *data, unsigned int len, u8 *out)
+{
+	scoped_guard(spinlock_bh, &zynqmp_sha_lock)
+		return __zynqmp_sha_digest(desc, data, len, out);
+}
+
 static struct zynqmp_sha_drv_ctx sha3_drv_ctx = {
 	.sha3_384 = {
 		.init = zynqmp_sha_init,
-- 
2.39.5



