Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4032EF652;
	Sat, 30 May 2026 18:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165929; cv=none; b=Zr5pOlYot7Vm0l8/oLOgq5q2kGdoR5wDuYm8J2K3kgjFw7rk4ctsr36XWssCfrZfO58x08/P6gko1fhSfRyN0jIwgZU1pGMgjxrNKGWyz9TDJ8/tPZG/OdC/6C0OOdUUMD7T6JO7Uaj5rkKpucvyxsD8C+IE0bxHDzD5H7LhlQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165929; c=relaxed/simple;
	bh=ZqBNJh+eqieTx0Erc00F3lDv2YVcbIbejAefWKLX/gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDLjYxQ/LnZq9f6A7XsSIe04ajCY8BYUbJ9xnm0Kh0EQTKJueiRzuY8PcCDnIEl6uQKGxh0GGdXmav5G+SLP7avohgTusOcPjAu7I0x1kUXynSGXSB4964LK8Px1LoWS4MWi9LH1Q7tL5fi6y4at+ycKSr3SrPAJ14bP0DsVVoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnVG7E2e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnVG7E2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990E61F00893;
	Sat, 30 May 2026 18:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165928;
	bh=Uu7myFk927t1dp2Ly0IVkaNIobtlltCnMiUMYq7W7nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnVG7E2eWkiK/9y+u0zVFaXmU33AFiwMZf/4d9bPjsa4tvqpp1ZBJqAAQp/yUPmss
	 MvYwURVEbnimQbwOC2hn8Ry+MGmOFi2yXaoIPRrf/MIZRFqLdiOqcxtyG3DubswU6f
	 FP5z3jSeNj7p0OVdMVsDGyHcQTrR73GI3mjUwoX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 5.10 224/589] USB: omap_udc: DMA: Dont enable burst 4 mode
Date: Sat, 30 May 2026 18:01:45 +0200
Message-ID: <20260530160230.868812671@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -731,8 +731,6 @@ static void dma_channel_claim(struct oma
 		if (status == 0) {
 			omap_writew(reg, UDC_TXDMA_CFG);
 			/* EMIFF or SDRC */
-			omap_set_dma_src_burst_mode(ep->lch,
-						OMAP_DMA_DATA_BURST_4);
 			omap_set_dma_src_data_pack(ep->lch, 1);
 			/* TIPB */
 			omap_set_dma_dest_params(ep->lch,
@@ -754,8 +752,6 @@ static void dma_channel_claim(struct oma
 				UDC_DATA_DMA,
 				0, 0);
 			/* EMIFF or SDRC */
-			omap_set_dma_dest_burst_mode(ep->lch,
-						OMAP_DMA_DATA_BURST_4);
 			omap_set_dma_dest_data_pack(ep->lch, 1);
 		}
 	}


