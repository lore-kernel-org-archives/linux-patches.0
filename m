Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DE13D8134;
	Wed,  8 Apr 2026 18:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672018; cv=none; b=kFEsWI2m1lwZdiCzW0Q6O+/0W4w2XuQqLnYhJReS0GouJA2sdl3wCNPuKF/l7BD7HElENa9OaXSxRG3a6TH9M937uuKKME2R8OExNmPxE5vDmpD8aC0F6eXkowap3NqUoR9THjvPf572oHv4ittu+mI7HOfR6QH143FdAvGkcUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672018; c=relaxed/simple;
	bh=isxb2WXsfIC3ysQinBQrAKhFL19tQrqcLo9wNMMxn0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBUmaEZsO7o/uVNwj1owJhpH0/VsL1PNVZDSfzyxhRSPbJkzGt4Cgxflf41soAG4a9kjHcIO3IXcR07V0IrrCZjTQm+0WhsY32Eb8kOU/uZNr0+se7kBr/ZnL9NsedbN+VIBXifjULK9FYhLUQUGRfqLuMH5YPQ+xYA8tBmFB5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10/4xmp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10/4xmp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08534C19421;
	Wed,  8 Apr 2026 18:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672018;
	bh=isxb2WXsfIC3ysQinBQrAKhFL19tQrqcLo9wNMMxn0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10/4xmp1GNL43KAQPGBDXxZHhJHV0BZrLyPa2SXoZG/ylDbVykyjL4UNthKvLCWgo
	 naZzpmmbO8NfEre3s8FUR5gAkxaL7INlBZlTCLcxOSRtd/OttJ6ERILf3qldB+VEnB
	 XkvcsM56pUnCSzWG9lvXNkEcHwEGvFO3eWZlQnsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/312] dmaengine: xilinx: xilinx_dma: Fix dma_device directions
Date: Wed,  8 Apr 2026 20:00:42 +0200
Message-ID: <20260408175938.436875443@linuxfoundation.org>
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

[ Upstream commit e9cc95397bb7da13fe8a5b53a2f23cfaf9018ade ]

Unlike chan->direction , struct dma_device .directions field is a
bitfield. Turn chan->direction into a bitfield to make it compatible
with struct dma_device .directions .

Fixes: 7e01511443c3 ("dmaengine: xilinx_dma: Set dma_device directions")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://patch.msgid.link/20260316221728.160139-1-marex@nabladev.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 8402dc3d3a352..ce5f4bedf059d 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2860,7 +2860,7 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 		return -EINVAL;
 	}
 
-	xdev->common.directions |= chan->direction;
+	xdev->common.directions |= BIT(chan->direction);
 
 	/* Request the interrupt */
 	chan->irq = of_irq_get(node, chan->tdest);
-- 
2.53.0



