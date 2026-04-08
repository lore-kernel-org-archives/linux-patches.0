Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1062BD030;
	Wed,  8 Apr 2026 18:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673415; cv=none; b=jR1+TLipNmWw0IKUpCEYu5VpUdQP2/w2M4qdnsTkbQhNI37lVJgtC3416nwH2FYhM2O3uOIODLNjEkz4hw5oB5sE1lvVLpWRmlxoiXdcq8DYVtqnIeHm53dRlPzOQELlSF9sRnwjMOb+A+bQMvM92ESqXlo83+yR6JBj3N/ke/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673415; c=relaxed/simple;
	bh=VR8dn0fxucyoRzPiNpv+GQajfan2kSmOwMvtlYDkyLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rk4KJ8pZYbkCtlN1t3OHdVL8atybBA0QqD/Qe9zR7QMyCzr3aAbSHCuvi126eQimtUCQFVteA4T5/5KSRaSqUCtHIlgT51ii8IBeZuZKCDTTO3cLM7yoP56AkiJ1UVanI+69vDWy/BYt8V5QbwFw8jx+TtjUWPMarlUiq/oZX3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqGEylvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqGEylvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45620C19421;
	Wed,  8 Apr 2026 18:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673415;
	bh=VR8dn0fxucyoRzPiNpv+GQajfan2kSmOwMvtlYDkyLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vqGEylvSrvguj9vcaBWEwHzUUbNLamBXTRj1WshDMsaSWRSpu6acxG9i4nkkmVcvj
	 5yC9B4vvjTbIGg7GMkc5QnqXdFk6GoiA/V8kCe5rQnqWZhXp43axevaM3n2Tvsy323
	 6VyquEdUhkTx9K6BgCT59GlkSGAcN/bi27H2ykm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vera <ivanverasantos@gmail.com>,
	Harish Ediga <harish.ediga@amd.com>,
	Harsh Jain <h.jain@amd.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.18 224/277] nvmem: zynqmp_nvmem: Fix buffer size in DMA and memcpy
Date: Wed,  8 Apr 2026 20:03:29 +0200
Message-ID: <20260408175942.220516183@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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


