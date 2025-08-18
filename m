Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFA3322543;
	Mon, 18 Aug 2025 13:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524191; cv=none; b=LFI0ddhUwO6go7qZ4eNbLCfc3ogx0Zh67izP2I6XEYETuelQJ8Tku0ID0tSQW99UDao0EoGNKCd/d+ik5xF3gfO/67qbUIEttbnc2gXsDYYXG0Fw9uOIZFbKgYTWySP0/Z9kIpGfhjYRnC/BKZNgs287Qz2txSNbKCq8bbnBar8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524191; c=relaxed/simple;
	bh=AFdpWxCDNs+BAjdP4+qk4l5f8l7gJBrTt/JiH8v6SjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnY8kx11OjAYsYuvlsq2ScnL9Su3IQO+/Qn1Rb4KnpKNQK/mQwNuUgtwTv3zB4biaNHCXyQ9OBjRcc/jwA1arDYa3u9Rjx3TFjNiM9mf5sPgrmER5OVxofrQeWX9iInC02CDQ7iX7D1WBy4LO+Rf9ObDgJH+IVs6mex8rlvZsnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WY3dc2CS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WY3dc2CS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAABAC4CEEB;
	Mon, 18 Aug 2025 13:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524191;
	bh=AFdpWxCDNs+BAjdP4+qk4l5f8l7gJBrTt/JiH8v6SjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WY3dc2CSa64yIQPj3S5fcrIgC4xXG0vgu3VvXnmN8t+U+iXEzvvwYYmOEuvTM8g4g
	 fMG3Aj6PIuvFbZ/6J91V0px/iPjZaDqZ59ezA1LrLqc0pan29hp8z/SyOLjd275eaq
	 ENZGYFN90u+muyOX5nSesB4EpD1RVehsDMiCaoW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 363/515] dmaengine: stm32-dma: configure next sg only if there are more than 2 sgs
Date: Mon, 18 Aug 2025 14:45:49 +0200
Message-ID: <20250818124512.379596882@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit e19bdbaa31082b43dab1d936e20efcebc30aa73d ]

DMA operates in Double Buffer Mode (DBM) when the transfer is cyclic and
there are at least two periods.
When DBM is enabled, the DMA toggles between two memory targets (SxM0AR and
SxM1AR), indicated by the SxSCR.CT bit (Current Target).
There is no need to update the next memory address if two periods are
configured, as SxM0AR and SxM1AR are already properly set up before the
transfer begins in the stm32_dma_start_transfer() function.
This avoids unnecessary updates to SxM0AR/SxM1AR, thereby preventing
potential Transfer Errors. Specifically, when the channel is enabled,
SxM0AR and SxM1AR can only be written if SxSCR.CT=1 and SxSCR.CT=0,
respectively. Otherwise, a Transfer Error interrupt is triggered, and the
stream is automatically disabled.

Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20250624-stm32_dma_dbm_fix-v1-1-337c40d6c93e@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32/stm32-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/stm32/stm32-dma.c b/drivers/dma/stm32/stm32-dma.c
index 917f8e922373..0e39f99bce8b 100644
--- a/drivers/dma/stm32/stm32-dma.c
+++ b/drivers/dma/stm32/stm32-dma.c
@@ -744,7 +744,7 @@ static void stm32_dma_handle_chan_done(struct stm32_dma_chan *chan, u32 scr)
 		/* cyclic while CIRC/DBM disable => post resume reconfiguration needed */
 		if (!(scr & (STM32_DMA_SCR_CIRC | STM32_DMA_SCR_DBM)))
 			stm32_dma_post_resume_reconfigure(chan);
-		else if (scr & STM32_DMA_SCR_DBM)
+		else if (scr & STM32_DMA_SCR_DBM && chan->desc->num_sgs > 2)
 			stm32_dma_configure_next_sg(chan);
 	} else {
 		chan->busy = false;
-- 
2.39.5



