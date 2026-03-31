Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCD9423A70;
	Tue, 31 Mar 2026 16:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974651; cv=none; b=SnXf20KOyZDtCChLz9AIXj9ecMvykNVz1Fikv0LYbG/lZoBWC9LKse7N5YArRPl2UHTXAJB41JZxLUrbndnhW/EsFepjk4ksp8Ufxk2tilabevmQ2d62nRQbFl8bLRuKkjCc4GwuBmimX7QsIbfFOUFNmuuOJM1OiZeG7UwzdvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974651; c=relaxed/simple;
	bh=peN9r6y0i7lhXtCKxQ/ZPtw+cwgKUyJ9+74W9qH2XSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEZ3htTqA6KO9mGXYNwYBMNYeMLc8DA8KJbIH3068+qTELNwZlazdemQZxTA0FNCbX1A7QBliKasNt73e9I18nQFtjCwic509FQhZY0IiiqhWle0fPaib+qPOfky2kPOnWMfWcDja5O7hASYoKkCxeyZr1u8SsA6+VRH164ckDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JR6huje0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JR6huje0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56CE5C2BCB1;
	Tue, 31 Mar 2026 16:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974651;
	bh=peN9r6y0i7lhXtCKxQ/ZPtw+cwgKUyJ9+74W9qH2XSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JR6huje0+EcgNTHhMvNGnB1mZ+uJ3irMy/9kvG8l7F3j4r02Y+4zqSKWvmWebCP3h
	 whhrPNax552C8G9CO0zBOm/lrCDFI6pCUcKiTVr7ioPnUEnKo2HxVmZ/tsH+PdXR75
	 El5TZhRwZknjrXmwHulb7IGdRMQ28yZldrpevQAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/175] dmaengine: xilinx: xilinx_dma: Fix unmasked residue subtraction
Date: Tue, 31 Mar 2026 18:22:31 +0200
Message-ID: <20260331161735.932802945@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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
index 17c424e650d2f..89583d6c4de46 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -994,16 +994,16 @@ static u32 xilinx_dma_get_residue(struct xilinx_dma_chan *chan,
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
@@ -1011,8 +1011,8 @@ static u32 xilinx_dma_get_residue(struct xilinx_dma_chan *chan,
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



