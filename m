Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ABD63BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 14:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE70C433EF;
	Mon, 20 Feb 2023 14:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901689;
	bh=w7ivuMPiJfkJTymSHg/3v8lZR4QPyBRC426Jftrj+v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9jNU0f8P0G6HVqJg/5Q2yi+02iUcCy6MmmkMmfCB7w0yhcffuthkY8fEZMikcPpt
	 nefJDNyRWaDdznnAYfMKvZwyoWIkIA+2xGd0PRP0iSfN2/vkI881hJfjXEKAJWJH67
	 r7t9yf+kWPOTLUWaXGGbRvs29qT+2UthAigJKt+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 096/118] net: stmmac: Restrict warning on disabling DMA store and fwd mode
Date: Mon, 20 Feb 2023 14:36:52 +0100
Message-Id: <20230220133604.234923512@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

commit 05d7623a892a9da62da0e714428e38f09e4a64d8 upstream.

When setting 'snps,force_thresh_dma_mode' DT property, the following
warning is always emitted, regardless the status of force_sf_dma_mode:

dwmac-starfive 10020000.ethernet: force_sf_dma_mode is ignored if force_thresh_dma_mode is set.

Do not print the rather misleading message when DMA store and forward
mode is already disabled.

Fixes: e2a240c7d3bc ("driver:net:stmmac: Disable DMA store and forward mode if platform data force_thresh_dma_mode is set.")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20230210202126.877548-1-cristian.ciocaltea@collabora.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -559,7 +559,7 @@ stmmac_probe_config_dt(struct platform_d
 	dma_cfg->mixed_burst = of_property_read_bool(np, "snps,mixed-burst");
 
 	plat->force_thresh_dma_mode = of_property_read_bool(np, "snps,force_thresh_dma_mode");
-	if (plat->force_thresh_dma_mode) {
+	if (plat->force_thresh_dma_mode && plat->force_sf_dma_mode) {
 		plat->force_sf_dma_mode = 0;
 		dev_warn(&pdev->dev,
 			 "force_sf_dma_mode is ignored if force_thresh_dma_mode is set.\n");


