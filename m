Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923E43AEF45;
	Wed,  8 Apr 2026 18:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672023; cv=none; b=AFV7vVLIjP1b8OnRNVIHUOTdBMjM6pMWhzn4W+8o01ESoobTXKvNVDCDciMC14uzPZtTPfux1d3IHh5T9jJsN1aQ8HddXG/i+UcxmqES9hDBxxxU3cMxqxb8FyeMeQED4zgZRZ4Lz2FLu7xS8GsH6qm9ZqC1SkF6LJ9/Pm2qm5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672023; c=relaxed/simple;
	bh=nC0CERooFW4/PlSwD3BbsbjPTGulq3dwlOxlcrEMurY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+63I6TYeuvcgk1iz2ClpQfim5YLuGgjHNqJfA1jWfLHwGV4qTif22EIkGZ7JzfU/e6KEA2s4lfjGcEqVcPKGE0tyjjerO67ajBaO9nlhRNW0A8q1+IwKLYHvq46+uv+0uuYCSa/LT4aeGqdmLKWmas1JOXT80MnsPTaAmruOYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1s5Dh4ov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1s5Dh4ov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E95C19421;
	Wed,  8 Apr 2026 18:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672023;
	bh=nC0CERooFW4/PlSwD3BbsbjPTGulq3dwlOxlcrEMurY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1s5Dh4ovp9ELXpMeMD3PVG/0z70NO9JpJI5oCtn8zTBPrAsVUrRpGuStwCFewxrvx
	 laabX+YnfMqKuEmzb5Wc/HBS6wZtAvujiGQckCWGBPK03myFAdeUKNAdXKfA+iGEGx
	 cn/d3y1uhCn8FB7mfLCxW1PxML77fIGW6NVyGkVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/312] dmaengine: xilinx: xilinx_dma: Fix unmasked residue subtraction
Date: Wed,  8 Apr 2026 20:00:44 +0200
Message-ID: <20260408175938.515810646@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

[ Upstream commit c7d812e33f3e8ca0fa9eeabf71d1c7bc3acedc09 ]

The segment .control and .status fields both contain top bits which are
not part of the buffer size, the buffer size is located only in the bottom
max_buffer_len bits. To avoid interference from those top bits, mask out
the size using max_buffer_len first, and only then subtract the values.

Fixes: a575d0b4e663 ("dmaengine: xilinx_dma: Introduce xilinx_dma_get_residue")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://patch.msgid.link/20260316222530.163815-1-marex@nabladev.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 2d734fea053d9..405638f5fc62c 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -964,16 +964,16 @@ static u32 xilinx_dma_get_residue(struct xilinx_dma_chan *chan,
 					      struct xilinx_cdma_tx_segment,
 					      node);
 			cdma_hw = &cdma_seg->hw;
-			residue += (cdma_hw->control - cdma_hw->status) &
-				   chan->xdev->max_buffer_len;
+			residue += (cdma_hw->control & chan->xdev->max_buffer_len) -
+			           (cdma_hw->status & chan->xdev->max_buffer_len);
 		} else if (chan->xdev->dma_config->dmatype ==
 			   XDMA_TYPE_AXIDMA) {
 			axidma_seg = list_entry(entry,
 						struct xilinx_axidma_tx_segment,
 						node);
 			axidma_hw = &axidma_seg->hw;
-			residue += (axidma_hw->control - axidma_hw->status) &
-				   chan->xdev->max_buffer_len;
+			residue += (axidma_hw->control & chan->xdev->max_buffer_len) -
+			           (axidma_hw->status & chan->xdev->max_buffer_len);
 		} else {
 			aximcdma_seg =
 				list_entry(entry,
@@ -981,8 +981,8 @@ static u32 xilinx_dma_get_residue(struct xilinx_dma_chan *chan,
 					   node);
 			aximcdma_hw = &aximcdma_seg->hw;
 			residue +=
-				(aximcdma_hw->control - aximcdma_hw->status) &
-				chan->xdev->max_buffer_len;
+				(aximcdma_hw->control & chan->xdev->max_buffer_len) -
+				(aximcdma_hw->status & chan->xdev->max_buffer_len);
 		}
 	}
 
-- 
2.53.0



