Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AE08635D;
	Tue, 26 Aug 2025 13:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214583; cv=none; b=XUJ5ZVGM9VA8BbhRL1D7SPSeclAejLEBJxzETF7wlf3aAmSjE6WzlhY+VvdTzGoE/QM8z7ed8ZmstKm7ZOnzhWrF6K/wF+uG2/TQoCC+au0JHKkPFGQyGekcyhMzTmBhgbID6zGlfbL0oKPj3h9UZOibPA4PKPXAcgyzBga0zVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214583; c=relaxed/simple;
	bh=ccjjb+h39qGgZDo9fg+Veogoid87Drp5ELwmcaowrKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KauYLgs7OLURat1U2hckw9488m6P6tavHw5iOGXA9WXEGDhU+Sr8aU86fhfk1F8iX8cCY3kyLv0ghHCNQS+KZPKjQg4VyHY8eKLKCI7uMBGN0FPEWjPvq+ROb5haKVkQz8MYPS+iEJyycf2ACgSCunCTNFHE5pkxuanAZJkJhmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/Tsw8IC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/Tsw8IC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A653C113CF;
	Tue, 26 Aug 2025 13:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214582;
	bh=ccjjb+h39qGgZDo9fg+Veogoid87Drp5ELwmcaowrKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/Tsw8ICIVCcCswme+Ldv0FdUD6SEaLdeH65Gt/5ruym5YyS4OgyF1QEnDZy6jhel
	 8MS1Bxkyp0rgI0FBeyvT/CLDhgfI3xo3/WpcunspXb/yWUZiF8OCLj3HpylYrAzZ+V
	 NxtsiQvALCdcrKsKq7oxIEbupP8qU4JZd2ZKxggE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/482] dmaengine: stm32-dma: configure next sg only if there are more than 2 sgs
Date: Tue, 26 Aug 2025 13:07:26 +0200
Message-ID: <20250826110935.569150361@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/dma/stm32-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/stm32-dma.c b/drivers/dma/stm32-dma.c
index 7abcd7f2848e..34a906e4b1ff 100644
--- a/drivers/dma/stm32-dma.c
+++ b/drivers/dma/stm32-dma.c
@@ -745,7 +745,7 @@ static void stm32_dma_handle_chan_done(struct stm32_dma_chan *chan, u32 scr)
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



