Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D617B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FF4C433C1;
	Wed, 23 Nov 2022 08:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193948;
	bh=xgVPU+roTiY3lq8wwHqlqta0cuZXORGBp20GZ7jDlw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5R/DdfHQAHoG5Lb2fIvxIzNFvvqRdZcbdr/0whAJrUxFWmX3JKDTkvUIC5vOnKys
	 fqOlRnRh4PUVizGnTD8UrrP4BA6eOv3d8t3u7617msvBwxLDszAbF+GivziuH1h2sa
	 4obOxz8mzsw+vx3iupYczdmS/Ei7DifZGX61pBjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Rosin <peda@axentia.se>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.14 29/88] dmaengine: at_hdmac: Dont allow CPU to reorder channel enable
Date: Wed, 23 Nov 2022 09:50:26 +0100
Message-Id: <20221123084549.493640121@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 580ee84405c27d6ed419abe4d2b3de1968abdafd upstream.

at_hdmac uses __raw_writel for register writes. In the absence of a
barrier, the CPU may reorder the register operations.
Introduce a write memory barrier so that the CPU does not reorder the
channel enable, thus the start of the transfer, without making sure that
all the pre-required register fields are already written.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Reported-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-14-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -252,6 +252,8 @@ static void atc_dostart(struct at_dma_ch
 		       ATC_SPIP_BOUNDARY(first->boundary));
 	channel_writel(atchan, DPIP, ATC_DPIP_HOLE(first->dst_hole) |
 		       ATC_DPIP_BOUNDARY(first->boundary));
+	/* Don't allow CPU to reorder channel enable. */
+	wmb();
 	dma_writel(atdma, CHER, atchan->mask);
 
 	vdbg_dump_regs(atchan);


