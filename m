Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A223D8905;
	Wed,  8 Apr 2026 18:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674025; cv=none; b=UffvtjgyOZKGKhgjhj6xO248hIDaJM5CpqQVTWPQt1ZX88RqZa4d8aHwKPnCjw27xP0KHRT/kGfuVWCOCiWVF9vLHpjlI8JejEcTNaNOR0gSdbZwQGNpcHMoXJOf/EwFiCmKICRi31ThIrKVvqM+uBIRBAmblE3vXWl6zlnHNNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674025; c=relaxed/simple;
	bh=WuXshUvCa9zx6IPXF2z/LoDXYdpv0DncGDMuCO9uSo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBbdLRIj4/QIVkc1CDqdcNVnQPeVoMnVdPd6YRoso8u+SE/OFR8AGKN8p+bsPY/hCndvZnwTMBrkfFbU6A+2DfSmLp2sUIYHQGHfh3D/VVwO8cxkGuWesQz7uCC6p5uDdupyVwr6wvWdmnq0UGPh5bdagggWh5XqCF/K1LlDINo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3uqQU4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3uqQU4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0753C2BC87;
	Wed,  8 Apr 2026 18:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674025;
	bh=WuXshUvCa9zx6IPXF2z/LoDXYdpv0DncGDMuCO9uSo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p3uqQU4+vRfzpaCGTNhPZrhSYMekTojByV1dlO0JsG275sGKGz6cdXqoe/ZWZA08j
	 o/+H6xNFpsgQklsliV8Skzn+yEwTE3pvS3jgHiBc2Yk4YiOpVTTQOfdDMQC75u0j+d
	 UaYxUzAZ/LcLDXIdrjpnHWYw1dabRSP6Zi33huWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vera <ivanverasantos@gmail.com>,
	Harish Ediga <harish.ediga@amd.com>,
	Harsh Jain <h.jain@amd.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.12 181/242] nvmem: zynqmp_nvmem: Fix buffer size in DMA and memcpy
Date: Wed,  8 Apr 2026 20:03:41 +0200
Message-ID: <20260408175933.858891230@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Ivan Vera <ivanverasantos@gmail.com>

commit f9b88613ff402aa6fe8fd020573cb95867ae947e upstream.

Buffer size used in dma allocation and memcpy is wrong.
It can lead to undersized DMA buffer access and possible
memory corruption. use correct buffer size in dma_alloc_coherent
and memcpy.

Fixes: 737c0c8d07b5 ("nvmem: zynqmp_nvmem: Add support to access efuse")
Cc: stable@vger.kernel.org
Signed-off-by: Ivan Vera <ivanverasantos@gmail.com>
Signed-off-by: Harish Ediga <harish.ediga@amd.com>
Signed-off-by: Harsh Jain <h.jain@amd.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260327131645.3025781-3-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/zynqmp_nvmem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/nvmem/zynqmp_nvmem.c
+++ b/drivers/nvmem/zynqmp_nvmem.c
@@ -66,7 +66,7 @@ static int zynqmp_efuse_access(void *con
 	dma_addr_t dma_buf;
 	size_t words = bytes / WORD_INBYTES;
 	int ret;
-	int value;
+	unsigned int value;
 	char *data;
 
 	if (bytes % WORD_INBYTES != 0) {
@@ -80,7 +80,7 @@ static int zynqmp_efuse_access(void *con
 	}
 
 	if (pufflag == 1 && flag == EFUSE_WRITE) {
-		memcpy(&value, val, bytes);
+		memcpy(&value, val, sizeof(value));
 		if ((offset == EFUSE_PUF_START_OFFSET ||
 		     offset == EFUSE_PUF_MID_OFFSET) &&
 		    value & P_USER_0_64_UPPER_MASK) {
@@ -100,7 +100,7 @@ static int zynqmp_efuse_access(void *con
 	if (!efuse)
 		return -ENOMEM;
 
-	data = dma_alloc_coherent(dev, sizeof(bytes),
+	data = dma_alloc_coherent(dev, bytes,
 				  &dma_buf, GFP_KERNEL);
 	if (!data) {
 		ret = -ENOMEM;
@@ -134,7 +134,7 @@ static int zynqmp_efuse_access(void *con
 	if (flag == EFUSE_READ)
 		memcpy(val, data, bytes);
 efuse_access_err:
-	dma_free_coherent(dev, sizeof(bytes),
+	dma_free_coherent(dev, bytes,
 			  data, dma_buf);
 efuse_data_fail:
 	dma_free_coherent(dev, sizeof(struct xilinx_efuse),


