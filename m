Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0822D7BF;
	Tue, 12 May 2026 17:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608345; cv=none; b=br8Zo9eXZ7/vtoBvEXEiR7u6WmhQOevAWsXCkPl4obYDoevwvqNF/NsCj6UN/brVMzcY8BQYIYqBEgfPv2AMzfBjq78/P5QA98H/jYVbJd6S0jF0LqkdeMEpfY96V0kDRETwETbNzA/VsrIKm598lvhTt9zVWNJWTdxMQsOUu+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608345; c=relaxed/simple;
	bh=OvIUHcW2tXFlVJTiVeA7cJp1J6i8XX6qNbtK+PZ+d2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJlFfgPSWz9KhW0dxt47/s76tFuEZLvaDXW/swu9VbzgN2A8RRzHmEbmqhymM10Hf++QOpkCwRvyyyo7EfNSuiWYWw+1L0oHcjzhctoXWNyPF6nesoNxaCzDDYLkdP0yr/cuKC5wGpvh8WFolctLxMV9bITbLOAnFinVAJyC3Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmS7u3QT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmS7u3QT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A35C2BCB0;
	Tue, 12 May 2026 17:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608345;
	bh=OvIUHcW2tXFlVJTiVeA7cJp1J6i8XX6qNbtK+PZ+d2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmS7u3QTWjIFf/zwG25JM0UDGxzwrL4IcAT5DEZ/oPO5eFf7cToUidGCHg8qrekSM
	 Ow0K9niYk870xRa5EFgonXM0a8TPWEiRzDv5j5EnESpc/uDiX3W97eUPmtnLTY6g0k
	 LpS6quaUPW5pSw1dVwfhTX5Rvcu854z5+8gWb2DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 6.18 044/270] USB: omap_udc: DMA: Dont enable burst 4 mode
Date: Tue, 12 May 2026 19:37:25 +0200
Message-ID: <20260512173939.381275918@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit 3f91484f6c13c434bd573ca6b6779c26adb0ddab upstream.

Commit 65111084c63d7 ("USB: more omap_udc updates (dma and omap1710)")
added setting for DMA burst 4 mode. But I think this should be undone for
two reasons:

- It breaks DMA on 15xx boards - transfers just silently stall.

- On newer OMAP1 boards, like Nokia 770 (omap1710), there is no measurable
performance impact when testing TCP throughput with g_ether with large
15000 byte MTU size.

It's also worth noting that when the original change was made, the
OMAP_DMA_DATA_BURST_4 handling in arch/arm/plat-omap/dma.c was broken, and
actually resulted in the same as the OMAP_DMA_DATA_BURST_DIS i.e. burst
disabled. This was fixed not until a couple kernel releases later in an
unrelated commit 1a8bfa1eb998a ("[ARM] 3142/1: OMAP 2/5: Update files
common to omap1 and omap2").

So based on this it seems there was never really a very good reason to
enable this burst mode in omap_udc, so remove it now to allow 15xx DMA
to work again (it provides 2x throughput compared to PIO mode).

Fixes: 65111084c63d ("[PATCH] USB: more omap_udc updates (dma and omap1710)")
Cc: stable <stable@kernel.org>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Link: https://patch.msgid.link/ad06qHLclWHeSGnV@darkstar.musicnaut.iki.fi
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/omap_udc.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/usb/gadget/udc/omap_udc.c
+++ b/drivers/usb/gadget/udc/omap_udc.c
@@ -733,8 +733,6 @@ static void dma_channel_claim(struct oma
 		if (status == 0) {
 			omap_writew(reg, UDC_TXDMA_CFG);
 			/* EMIFF or SDRC */
-			omap_set_dma_src_burst_mode(ep->lch,
-						OMAP_DMA_DATA_BURST_4);
 			omap_set_dma_src_data_pack(ep->lch, 1);
 			/* TIPB */
 			omap_set_dma_dest_params(ep->lch,
@@ -756,8 +754,6 @@ static void dma_channel_claim(struct oma
 				UDC_DATA_DMA,
 				0, 0);
 			/* EMIFF or SDRC */
-			omap_set_dma_dest_burst_mode(ep->lch,
-						OMAP_DMA_DATA_BURST_4);
 			omap_set_dma_dest_data_pack(ep->lch, 1);
 		}
 	}


