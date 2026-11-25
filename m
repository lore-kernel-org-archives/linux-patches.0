Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622824;
	b=GL/C0EHTXpDR5qbKCqH2dAPmr8+f5y3+e/UdxFRKx+t5BS2CV1Kxsyyrwpoq/g0DZzcR
	 Quhg96Xc2wQE+pEibnpNy3g6Iyn7Ge0/+pgJxHkpb+kf7RUmJ5D9ECZXYVaFrfgKvYIPu
	 j0ppUdRGKAJbEEekYCVd4PpDBNXUvrr7kipF0lut4OmuzMor/2dMXctETkRqfd9g30CGP
	 DXfef3SphSenuDlj5Y5Z+yPDBZaVyfUr1nrfreohq2uKhx25gcEVYpHQ5Epp7tz5g4Gvo
	 KHG8d5vbiIA+uDUp/Fo6Osp9SEYX59BTPw4rL5u3i4yABepU+vIDLRgc0SXTX4glXAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P85L8jdG7Z8QT19cZMmxpnA7p8fNQNOGvLv4sf9LG3g=;
	b=sp0c1Uh4ctasbcaPIpZ9gjYp5ecObG9IsOgMbQdcyhLu57VHKjiVZBGH0mWZygQ6wfOD
	 oOarKuZ5XF9TBPc0Ua1F2saJO2DjW0Qxs7U0yD/mDrpw2g7wj55p5A7KgERKxLuDEZxQJ
	 GXNGYxHuDGGRPxExWQga9Cd1rTieEuIRB8zdiLme03Ylyahu4MtJ0tTBBYhoL1JJJY5KF
	 aXwyRrkZVNW1775HjjHZDMUJul3+gd/QTeJoQn9YZoy+NaRXPOUejXJn159IfqhBPb5nJ
	 40RIH1Kaq0TKmzkwh8E43cmpAwmCMDm57fmTv3R7fq9nDgJaSkd4TDQow4eoMiqc7+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLZZcytn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0DF606A685;
	Wed, 25 Nov 2026 16:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLZZcytn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908C51F000D4;
	Wed, 25 Nov 2026 16:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622824;
	bh=P85L8jdG7Z8QT19cZMmxpnA7p8fNQNOGvLv4sf9LG3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLZZcytnyGtDuoCgX15yn5DwmmD5gJujjlsrnwRlr2RQTgS2yCdd2+Z8aQykXXGR0
	 se9OrlOoLJ+uhRvJK40OJi0Z+YU1R++ZDwwVphE2VhJKc2qdF5G9ONdYAVRUQhKb/z
	 QVp8F0w7pdzL//4AuFOrRXTRRWxHTZMiQNyoMiFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anfernee Cao <anferneemelokc5@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 661/990] mmc: sunxi: fix clock and runtime PM leaks on probe failure
Date: Wed, 25 Nov 2026 15:33:48 +0100
Message-ID: <20261125143837.573159382@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anfernee Cao <anferneemelokc5@gmail.com>

commit e35e360bd66898a977c296ab71fe4bae17ddceb7 upstream.

sunxi_mmc_resource_request() enables the bus, card, output and sample
clocks before returning. Several failure paths later in
sunxi_mmc_probe() leave them running:

 - If devm_request_threaded_irq() fails, the clocks enabled by
   sunxi_mmc_enable() are never disabled.
 - If dma_alloc_coherent(), mmc_of_parse() or sunxi_mmc_init_host()
   fails, probe only frees the DMA buffer and the mmc_host.
 - If mmc_add_host() fails, runtime PM has already been enabled, but
   pm_runtime_disable() is never called.

Besides leaking the clocks, this leaves the clock enable counts
unbalanced, so a reprobe (for example after -EPROBE_DEFER) calls
clk_prepare_enable() on the same clocks again.

Disable the IRQ and the clocks in the probe error path, and disable
runtime PM on the mmc_add_host() failure path. Also handle a failure of
devm_request_threaded_irq() in sunxi_mmc_resource_request().

Tested with QEMU's orangepi-pc machine: with forced sunxi_mmc_init_host()
and mmc_add_host() failures the MMC clocks stay disabled in clk_summary,
and a normal probe with an emulated SD card still works.

This issue was found by manual code inspection.

Fixes: 3cbcb16095f9 ("mmc: sunxi: Add driver for SD/MMC hosts found on Allwinner sunxi SoCs")
Fixes: 9a8e1e8cc2c0 ("mmc: sunxi: Add runtime_pm support")
Cc: stable@vger.kernel.org # v4.18+
Signed-off-by: Anfernee Cao <anferneemelokc5@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sunxi-mmc.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/mmc/host/sunxi-mmc.c
+++ b/drivers/mmc/host/sunxi-mmc.c
@@ -1355,8 +1355,13 @@ static int sunxi_mmc_resource_request(st
 		goto error_disable_mmc;
 	}
 
-	return devm_request_threaded_irq(&pdev->dev, host->irq, sunxi_mmc_irq,
-			sunxi_mmc_handle_manual_stop, 0, "sunxi-mmc", host);
+	ret = devm_request_threaded_irq(&pdev->dev, host->irq, sunxi_mmc_irq,
+					sunxi_mmc_handle_manual_stop, 0,
+					"sunxi-mmc", host);
+	if (ret)
+		goto error_disable_mmc;
+
+	return 0;
 
 error_disable_mmc:
 	sunxi_mmc_disable(host);
@@ -1386,9 +1391,11 @@ static int sunxi_mmc_probe(struct platfo
 
 	host->sg_cpu = dma_alloc_coherent(&pdev->dev, PAGE_SIZE,
 					  &host->sg_dma, GFP_KERNEL);
-	if (!host->sg_cpu)
-		return dev_err_probe(&pdev->dev, -ENOMEM,
-				     "Failed to allocate DMA descriptor mem\n");
+	if (!host->sg_cpu) {
+		ret = dev_err_probe(&pdev->dev, -ENOMEM,
+				    "Failed to allocate DMA descriptor mem\n");
+		goto error_disable_mmc;
+	}
 
 	if (host->cfg->ccu_has_timings_switch) {
 		/*
@@ -1468,7 +1475,7 @@ static int sunxi_mmc_probe(struct platfo
 
 	ret = mmc_add_host(mmc);
 	if (ret)
-		goto error_free_dma;
+		goto error_disable_rpm;
 
 	dev_info(&pdev->dev, "initialized, max. request size: %u KB%s\n",
 		 mmc->max_req_size >> 10,
@@ -1476,8 +1483,13 @@ static int sunxi_mmc_probe(struct platfo
 
 	return 0;
 
+error_disable_rpm:
+	pm_runtime_disable(&pdev->dev);
 error_free_dma:
 	dma_free_coherent(&pdev->dev, PAGE_SIZE, host->sg_cpu, host->sg_dma);
+error_disable_mmc:
+	disable_irq(host->irq);
+	sunxi_mmc_disable(host);
 	return ret;
 }
 


