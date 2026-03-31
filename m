Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAF133E367;
	Tue, 31 Mar 2026 16:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975521; cv=none; b=KjF4dTHdGLIGdButfZV5OnQBUkSfWN0IWhno33GQlPXGsUXqOKx8+FyrA2XuEjek35+JwhYXRO2UG1q3EppUEg5BcUcCoz9cATwl+v3i85sWZEJsb2kf+oHmwD9I90ymBzknQeIIHjLvbt6RB8S301SXdt6RWUuSNRPYsXMNJdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975521; c=relaxed/simple;
	bh=JqoEaRJqH2V0xsP+ifCNFW51LoM2Ecj5PdCMbs6HF9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgoK0+7PpDaadZp6/YVoX8tQheBMQ9YNlQJnErdidNxaCKSWehFcTXlMYE2TGmVkXUlXi4M8y2OIF1FQ41GGWoNrqeBcsTWT0FAQemrc3y4rkyBnRjQleSapz+4RQPmExzd9KHBPlsth3xKFwbikQ0L1Zn4P3Lj3kbb7I0B+1Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3hOAMiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3hOAMiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8EFC19423;
	Tue, 31 Mar 2026 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975521;
	bh=JqoEaRJqH2V0xsP+ifCNFW51LoM2Ecj5PdCMbs6HF9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3hOAMiE/nWy/A/nayc/Dy4vdgsiQyI8vjwj58f+Yrhm2TYuB2sawlTvnPaCeClvt
	 VeJkX8q7tugclQteatmw4OaSlY35sUCE2oxtWPZ2EmMCa92iY3jjv9OfSRlMCQrwqk
	 1YWqhFjfIh8ZNX+eRWMCYhhuPweU4WweMrqQ+Shg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 327/342] dmaengine: xilinx: xilinx_dma: Fix unmasked residue subtraction
Date: Tue, 31 Mar 2026 18:22:40 +0200
Message-ID: <20260331161810.942244122@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index ccfcc2b801f82..7b24d0a18ea53 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -997,16 +997,16 @@ static u32 xilinx_dma_get_residue(struct xilinx_dma_chan *chan,
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
@@ -1014,8 +1014,8 @@ static u32 xilinx_dma_get_residue(struct xilinx_dma_chan *chan,
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



