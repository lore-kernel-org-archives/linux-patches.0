Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3413531A069;
	Fri,  9 Jan 2026 12:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963212; cv=none; b=l77H0uHragHbkzb6yXr9tEqksQ69RhjZaTgtHI/T2EhuIF5NcuO+he7kZqcNICv2IDhbFPCCe5N64EZ3N/SUivr8oQf4/W5Ld3rSQHxr+g+hhxjtQb1twR0K5e1AAhxdSPV6uHyc9XqRo/iWCbNyRAEjDug33h8wlKycXBKx5Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963212; c=relaxed/simple;
	bh=R7oRxjIMH2M3eJ9NNio1PQsUzAKBCTUInhcL79QAuGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOs4JN66l8hVPQp4XWYHC2ND01e+qdNV/FOPno9K/H7XZX1SUWBFqcnaiRhiU90P42qXGMH3z4YXxDVIxQX+nX7+KsLKtXM5pn8xiHhE9p44zPJcjfYuXKisft0BI9y6N8uKP3AZFem+C0y7/bYBZmQ0PblJ7VCajF7vN1suh4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWfH5aLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWfH5aLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FC9C4CEF1;
	Fri,  9 Jan 2026 12:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963212;
	bh=R7oRxjIMH2M3eJ9NNio1PQsUzAKBCTUInhcL79QAuGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWfH5aLq7Kb2xT+o5THxqf7rpf/CvF/6kEjK31D2d4CpcPT+LGZbuVVSdsa0Mvkxj
	 Q2IyJziDGbVdQuIKmUVAMUeKoGF0NB0UVZuQVARo6nHgkhwZFN2Z1TNYrAxlxpdDgL
	 Jy5fOuent6L80s5oAHfE9nxJ+WqXbMqfYYZ5OViY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>
Subject: [PATCH 6.1 629/634] usb: gadget: lpc32xx_udc: fix clock imbalance in error path
Date: Fri,  9 Jan 2026 12:45:07 +0100
Message-ID: <20260109112141.303705164@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 782be79e4551550d7a82b1957fc0f7347e6d461f upstream.

A recent change fixing a device reference leak introduced a clock
imbalance by reusing an error path so that the clock may be disabled
before having been enabled.

Note that the clock framework allows for passing in NULL clocks so there
is no risk for a NULL pointer dereference.

Also drop the bogus I2C client NULL check added by the offending commit
as the pointer has already been verified to be non-NULL.

Fixes: c84117912bdd ("USB: lpc32xx_udc: Fix error handling in probe")
Cc: stable@vger.kernel.org
Cc: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Vladimir Zapolskiy <vz@mleia.com>
Link: https://patch.msgid.link/20251218153519.19453-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/lpc32xx_udc.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -3027,7 +3027,7 @@ static int lpc32xx_udc_probe(struct plat
 	pdev->dev.dma_mask = &lpc32xx_usbd_dmamask;
 	retval = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (retval)
-		goto i2c_fail;
+		goto err_put_client;
 
 	udc->board = &lpc32xx_usbddata;
 
@@ -3047,7 +3047,7 @@ static int lpc32xx_udc_probe(struct plat
 		udc->udp_irq[i] = platform_get_irq(pdev, i);
 		if (udc->udp_irq[i] < 0) {
 			retval = udc->udp_irq[i];
-			goto i2c_fail;
+			goto err_put_client;
 		}
 	}
 
@@ -3055,7 +3055,7 @@ static int lpc32xx_udc_probe(struct plat
 	if (IS_ERR(udc->udp_baseaddr)) {
 		dev_err(udc->dev, "IO map failure\n");
 		retval = PTR_ERR(udc->udp_baseaddr);
-		goto i2c_fail;
+		goto err_put_client;
 	}
 
 	/* Get USB device clock */
@@ -3063,14 +3063,14 @@ static int lpc32xx_udc_probe(struct plat
 	if (IS_ERR(udc->usb_slv_clk)) {
 		dev_err(udc->dev, "failed to acquire USB device clock\n");
 		retval = PTR_ERR(udc->usb_slv_clk);
-		goto i2c_fail;
+		goto err_put_client;
 	}
 
 	/* Enable USB device clock */
 	retval = clk_prepare_enable(udc->usb_slv_clk);
 	if (retval < 0) {
 		dev_err(udc->dev, "failed to start USB device clock\n");
-		goto i2c_fail;
+		goto err_put_client;
 	}
 
 	/* Setup deferred workqueue data */
@@ -3172,9 +3172,10 @@ dma_alloc_fail:
 	dma_free_coherent(&pdev->dev, UDCA_BUFF_SIZE,
 			  udc->udca_v_base, udc->udca_p_base);
 i2c_fail:
-	if (udc->isp1301_i2c_client)
-		put_device(&udc->isp1301_i2c_client->dev);
 	clk_disable_unprepare(udc->usb_slv_clk);
+err_put_client:
+	put_device(&udc->isp1301_i2c_client->dev);
+
 	dev_err(udc->dev, "%s probe failed, %d\n", driver_name, retval);
 
 	return retval;
@@ -3199,11 +3200,9 @@ static int lpc32xx_udc_remove(struct pla
 	dma_free_coherent(&pdev->dev, UDCA_BUFF_SIZE,
 			  udc->udca_v_base, udc->udca_p_base);
 
-	if (udc->isp1301_i2c_client)
-		put_device(&udc->isp1301_i2c_client->dev);
-
 	clk_disable_unprepare(udc->usb_slv_clk);
 
+	put_device(&udc->isp1301_i2c_client->dev);
 	return 0;
 }
 


