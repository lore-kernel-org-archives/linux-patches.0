Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D684219E4;
	Wed, 21 Jan 2026 18:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020581; cv=none; b=PRRldg3nSOHAGhnOvkV+plOM32a6QTEy7wVnH86o1BQjES8W+Ny+NmNOCn3ggy4sYP6TSdegtXicjB7Q4WR7HdFCvx2Vgs7v9W5V+UTIM3EVEJLZVrDeQBHdL+Hkfzs+sZqHN/P9gArD6P4WNA2b8d9gtYJysA7cu9DuX0nERFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020581; c=relaxed/simple;
	bh=pHyICvrHfmUhTGuwgupmIUTHs5FGLcE1/eT0GPXMX+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naRUBcCWLEHSO2l0+uOZNCir5TZU8ovoZk0P8IB9BWj9kkIEZdFjuUgIALfyQUxdbqC1T7W31NqaqBofU1YNnepishPcAVBHHKnJr/lDcwte/iwcMEFqKORAB9XC4hrJeEARmRx7dCHeaF6dJwlPSBpp0/xy9Dsr/8iAnVtxMXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlhGzfDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlhGzfDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9C3C19422;
	Wed, 21 Jan 2026 18:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020580;
	bh=pHyICvrHfmUhTGuwgupmIUTHs5FGLcE1/eT0GPXMX+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QlhGzfDrrPBQTstKsVaLZzNMAmiAMtsuBYGsshzVkU4tg41YNFsEj+PChwed3EI7H
	 MZDj1GwpuHfBm5neJrfV0eB5pln191jMViISdzd6kdLZezBocwnTFGjBxi6M5xZKC8
	 fbjp5yBq25drMXNpHvHudZGMm2nRKg5wk2vjP6XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>,
	Johan Hovold <johan@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 175/198] dmaengine: lpc32xx-dmamux: fix device leak on route allocation
Date: Wed, 21 Jan 2026 19:16:43 +0100
Message-ID: <20260121181424.847941295@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit d9847e6d1d91462890ba297f7888fa598d47e76e upstream.

Make sure to drop the reference taken when looking up the DMA mux
platform device during route allocation.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Fixes: 5d318b595982 ("dmaengine: Add dma router for pl08x in LPC32XX SoC")
Cc: stable@vger.kernel.org	# 6.12
Cc: Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Vladimir Zapolskiy <vz@mleia.com>
Link: https://patch.msgid.link/20251117161258.10679-9-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/lpc32xx-dmamux.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/dma/lpc32xx-dmamux.c
+++ b/drivers/dma/lpc32xx-dmamux.c
@@ -95,11 +95,12 @@ static void *lpc32xx_dmamux_reserve(stru
 	struct lpc32xx_dmamux_data *dmamux = platform_get_drvdata(pdev);
 	unsigned long flags;
 	struct lpc32xx_dmamux *mux = NULL;
+	int ret = -EINVAL;
 	int i;
 
 	if (dma_spec->args_count != 3) {
 		dev_err(&pdev->dev, "invalid number of dma mux args\n");
-		return ERR_PTR(-EINVAL);
+		goto err_put_pdev;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(lpc32xx_muxes); i++) {
@@ -111,20 +112,20 @@ static void *lpc32xx_dmamux_reserve(stru
 	if (!mux) {
 		dev_err(&pdev->dev, "invalid mux request number: %d\n",
 			dma_spec->args[0]);
-		return ERR_PTR(-EINVAL);
+		goto err_put_pdev;
 	}
 
 	if (dma_spec->args[2] > 1) {
 		dev_err(&pdev->dev, "invalid dma mux value: %d\n",
 			dma_spec->args[1]);
-		return ERR_PTR(-EINVAL);
+		goto err_put_pdev;
 	}
 
 	/* The of_node_put() will be done in the core for the node */
 	dma_spec->np = of_parse_phandle(ofdma->of_node, "dma-masters", 0);
 	if (!dma_spec->np) {
 		dev_err(&pdev->dev, "can't get dma master\n");
-		return ERR_PTR(-EINVAL);
+		goto err_put_pdev;
 	}
 
 	spin_lock_irqsave(&dmamux->lock, flags);
@@ -133,7 +134,8 @@ static void *lpc32xx_dmamux_reserve(stru
 		dev_err(dev, "dma request signal %d busy, routed to %s\n",
 			mux->signal, mux->muxval ? mux->name_sel1 : mux->name_sel1);
 		of_node_put(dma_spec->np);
-		return ERR_PTR(-EBUSY);
+		ret = -EBUSY;
+		goto err_put_pdev;
 	}
 
 	mux->busy = true;
@@ -148,7 +150,14 @@ static void *lpc32xx_dmamux_reserve(stru
 	dev_dbg(dev, "dma request signal %d routed to %s\n",
 		mux->signal, mux->muxval ? mux->name_sel1 : mux->name_sel1);
 
+	put_device(&pdev->dev);
+
 	return mux;
+
+err_put_pdev:
+	put_device(&pdev->dev);
+
+	return ERR_PTR(ret);
 }
 
 static int lpc32xx_dmamux_probe(struct platform_device *pdev)


