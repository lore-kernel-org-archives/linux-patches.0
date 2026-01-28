Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DA3136349;
	Wed, 28 Jan 2026 15:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614236; cv=none; b=UC9n/jbeTk+jkE9yRdpQo/YMSAYC72263bnDk54PVgzS2YkxwO0JGzr7fQBfGqCMn97x1nfK5PiYcvIHvggOS3UDgULT2btXHLKUJIWCOcW6ZfmWokP4JER+cw5ftoX3vGlwVbIwS0d2iCct+UIttP97C7Rt5YRn8Bx89psQYyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614236; c=relaxed/simple;
	bh=dC+mlfxp/nz8Q7EL5Y3mLzDdYVcIcR9Sxd1t5MXEYvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmjxxbuOqbskn9749OGR4VKayURb5lNm4mxZ6tk7449a2tj1K508xzCAMfIsxUgbWezad0kotsPpeIBDEfbB53Zph91EOef0HlSF+YIBwvEpp8wlZYA/xDeKGe+ZyEiZfeW5qGLYwYCLoAJAm1mDpb07fyDPww/7FhAQmQmkaBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/GxTdgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/GxTdgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AE3C4CEF1;
	Wed, 28 Jan 2026 15:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614236;
	bh=dC+mlfxp/nz8Q7EL5Y3mLzDdYVcIcR9Sxd1t5MXEYvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/GxTdgDJuBQYrrSMDqyo3Wb/RQbeN2wLy4vmh28YgbrethN0upBXgKhmbhzmgKGJ
	 n4TAGWCj5W+irMxn/RKaZjclFLosrSAPtRrhZKOAdlYOjAaQ02BlKe2EXIdcmoIxHp
	 F2vH9tHRc9CD+p4OwURkpGS2gOoPjMtabiXQS6Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Folker Schwesinger <dev@folker-schwesinger.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/254] dmaengine: xilinx_dma: Fix uninitialized addr_width when "xlnx,addrwidth" property is missing
Date: Wed, 28 Jan 2026 16:20:10 +0100
Message-ID: <20260128145345.929360348@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Suraj Gupta <suraj.gupta2@amd.com>

[ Upstream commit c0732fe78728718c853ef8e7af5bbb05262acbd1 ]

When device tree lacks optional "xlnx,addrwidth" property, the addr_width
variable remained uninitialized with garbage values, causing incorrect
DMA mask configuration and subsequent probe failure. The fix ensures a
fallback to the default 32-bit address width when this property is missing.

Signed-off-by: Suraj Gupta <suraj.gupta2@amd.com>
Fixes: b72db4005fe4 ("dmaengine: vdma: Add 64 bit addressing support to the driver")
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Reviewed-by: Folker Schwesinger <dev@folker-schwesinger.de>
Link: https://patch.msgid.link/20251021183006.3434495-1-suraj.gupta2@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 14c4c5031b556..176cac3f37a73 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -128,6 +128,7 @@
 #define XILINX_MCDMA_MAX_CHANS_PER_DEVICE	0x20
 #define XILINX_DMA_MAX_CHANS_PER_DEVICE		0x2
 #define XILINX_CDMA_MAX_CHANS_PER_DEVICE	0x1
+#define XILINX_DMA_DFAULT_ADDRWIDTH		0x20
 
 #define XILINX_DMA_DMAXR_ALL_IRQ_MASK	\
 		(XILINX_DMA_DMASR_FRM_CNT_IRQ | \
@@ -3057,7 +3058,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 	struct device_node *node = pdev->dev.of_node;
 	struct xilinx_dma_device *xdev;
 	struct device_node *child, *np = pdev->dev.of_node;
-	u32 num_frames, addr_width, len_width;
+	u32 num_frames, addr_width = XILINX_DMA_DFAULT_ADDRWIDTH, len_width;
 	int i, err;
 
 	/* Allocate and initialize the DMA engine structure */
@@ -3131,7 +3132,9 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 
 	err = of_property_read_u32(node, "xlnx,addrwidth", &addr_width);
 	if (err < 0)
-		dev_warn(xdev->dev, "missing xlnx,addrwidth property\n");
+		dev_warn(xdev->dev,
+			 "missing xlnx,addrwidth property, using default value %d\n",
+			 XILINX_DMA_DFAULT_ADDRWIDTH);
 
 	if (addr_width > 32)
 		xdev->ext_addr = true;
-- 
2.51.0



