Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F300F3B1EE2;
	Tue, 12 May 2026 17:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607821; cv=none; b=V8RxwfwEV85qTfI6USB/sYrDbfA8KzCbZeGgZV6PDa9HV2ekZOF0cQs8StfUnQgHZ2yr/sD/XdK9HCHWDv3sf/1qugQznb7SpVH59XhPwzGFIZUnlZJAcUspZ3wHqyhZK9mRAEWH/pgNqZgHl1LFXq4KLNkCGvOxj4F7iIv/Y2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607821; c=relaxed/simple;
	bh=JHFJ9y+N9rPOYo29dVlWQ7S6QNXyhUdcGykB0o+x5A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+ON+XR5rhNFcSuAaZRd7MttJ+G4R7ivbc+FLhHflAd24o8goVNNMl8ppXYxEMcyaGD04yGrY2RJ0wM74tE4sa0sqCEJgSV2fKDwNXSO7TiLNVWtEZ/o2+mZk0Th3yFKcg+tgjEoHqslI5z6VR/ZUNSanz13u4o9qPIlVSkOX2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15p/gDBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15p/gDBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EEEC2BCB0;
	Tue, 12 May 2026 17:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607820;
	bh=JHFJ9y+N9rPOYo29dVlWQ7S6QNXyhUdcGykB0o+x5A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15p/gDBTTdi/Gu45EJ/qBfLoFbRO0eTWwYvocQ2qWiVVL76sAq8kUZJ9vMk5qDgpN
	 yk9oXsf1VgBiTeeUH1kmigmygJSx8UmBfEhuGBNlWbj2v5D2Dn3lhsrVwtVaKCPAph
	 s4isbMD27uNPx8m7GIPg+aCOCcp9NuPuwphsoe1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 6.12 047/206] USB: omap_udc: DMA: Dont enable burst 4 mode
Date: Tue, 12 May 2026 19:38:19 +0200
Message-ID: <20260512173933.833279225@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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
@@ -732,8 +732,6 @@ static void dma_channel_claim(struct oma
 		if (status == 0) {
 			omap_writew(reg, UDC_TXDMA_CFG);
 			/* EMIFF or SDRC */
-			omap_set_dma_src_burst_mode(ep->lch,
-						OMAP_DMA_DATA_BURST_4);
 			omap_set_dma_src_data_pack(ep->lch, 1);
 			/* TIPB */
 			omap_set_dma_dest_params(ep->lch,
@@ -755,8 +753,6 @@ static void dma_channel_claim(struct oma
 				UDC_DATA_DMA,
 				0, 0);
 			/* EMIFF or SDRC */
-			omap_set_dma_dest_burst_mode(ep->lch,
-						OMAP_DMA_DATA_BURST_4);
 			omap_set_dma_dest_data_pack(ep->lch, 1);
 		}
 	}


