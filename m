Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063408;
	b=KQNx5crmDn25PVUQ2Hd/B/6UIvvcqwyocG/nBgXb0pdPEHrXM46TNiRoPT4CVw8wLdry
	 DyWkToBukn2MPUqTX5TfRyyYzH2XhBG88PSx//0jwvZvpEIejPKRR6YofrUebF2a5cXbi
	 kpxIVPC0S5v2wlYW9OKCtHbaNkVZztpN53I8g+KSMF5BEucXAT94K3+LpGft7ACBC77YH
	 CLyqz/s4OxHkFXcRnnoSTb6W2/UxOyZHB86CVSomQfiSdMNGasyMcGBj2ygq6DB2e7ogy
	 9wLEemYWcV4c8NasPiJo8aNdDkCWtcZn6pxy8sGwVMG4B53qYr/xFfxcvL7IZNjH3NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A4dLTONXQS2Xwx0yYaG6GghPr6T+JgReMXnZf6mY4e0=;
	b=r+kJGcsw4b2KK+5NWLoRDDYLso+ookz262khjreWmVGlcdE1ZHJqBCFFgpb2+TNpNSlb
	 K6pkJRFD1xhR3e6BDS2YQSiNxb90dpN03VkQqefr4J2ouKsrTRpS2CCWlfAH7O6X3ohXw
	 6018lNsV0Ft34JOzQnzMsQ8GOznj2wyKvsz1x+ZDHUG90XJkNurr8AcnRKT0OcgzOvgSu
	 2HuGGFCOXiotbE4LHtFXVmNV8joIHvFNojfBMMVBHc2e+xD/kbZTYTY8GZ8dyHhiviVHc
	 FCgn27zhyMLW3tFYeoV4mMXBIqvV2e0C/fyBRdeKKJIHLLJO+M1MfIvg104PQ7m6VRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cmyhz3EU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA1B606EEA8;
	Sat,  7 Nov 2026 14:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cmyhz3EU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D07501F008A1;
	Sat,  7 Nov 2026 14:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063408;
	bh=A4dLTONXQS2Xwx0yYaG6GghPr6T+JgReMXnZf6mY4e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmyhz3EU07xOfIvXTImpoDpzvIEbnIpjIpVcg1atxowCD/PYc12xSmVsxF6Z9veK0
	 +0jaqHzexRpNgN5VJ0lPLtbnlGl7Kpwmmszq+hrXUmkonCz0h0NYvlZubHW3h8cVLV
	 3m0uUoG1mabPdbHrYkfFybodu3WFxvZPa9pw1Ko0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Radu Rendec <radu@rendec.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 577/869] irqchip/imx-intmux: Fix runtime PM teardown on remove
Date: Sat,  7 Nov 2026 08:54:19 -0500
Message-ID: <20261107134912.769778437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit b167c1a30e9e020e4c5e102c7a555943742c024b ]

imx_intmux_probe() enables the IPG clock and then drops its runtime PM
reference with pm_runtime_put(). With CONFIG_PM enabled, the runtime
suspend callback disables the IPG clock. With CONFIG_PM disabled, the
clock remains enabled after probe.

imx_intmux_remove() accesses the CHANIER registers without first making
sure that the device is runtime active. The device may therefore be
runtime suspended with the IPG clock disabled when these registers are
accessed. In addition, the remove path only calls pm_runtime_disable()
and does not balance the clock enable when CONFIG_PM is disabled.

Resume the device and acquire a runtime PM reference before accessing
the registers. If resume fails, skip the register accesses but still
tear down the chained handlers and IRQ domains. Disable runtime PM
afterwards, drop the acquired reference without triggering another
runtime suspend, and explicitly disable the IPG clock.

This keeps the clock enabled while the hardware registers are accessed
and balances the clk_prepare_enable() performed during probe for both
CONFIG_PM configurations.

This issue was found by manual code inspection.

Fixes: bb403111e017 ("irqchip/imx-intmux: Implement intmux runtime power management")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Radu Rendec <radu@rendec.net>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260914134211.1734163-1-lgs201920130244@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-imx-intmux.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-imx-intmux.c b/drivers/irqchip/irq-imx-intmux.c
index 5f9b204d350b2..18e214e5b1b59 100644
--- a/drivers/irqchip/irq-imx-intmux.c
+++ b/drivers/irqchip/irq-imx-intmux.c
@@ -289,12 +289,16 @@ static int imx_intmux_probe(struct platform_device *pdev)
 static void imx_intmux_remove(struct platform_device *pdev)
 {
 	struct intmux_data *data = platform_get_drvdata(pdev);
-	int i;
+	int i, ret;
+
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret < 0)
+		dev_warn(&pdev->dev, "failed to resume device: %d\n", ret);
 
 	for (i = 0; i < data->channum; i++) {
 		/* disable all interrupt sources of this channel */
-		writel_relaxed(0, data->regs + CHANIER(i));
-
+		if (ret >= 0)
+			writel_relaxed(0, data->regs + CHANIER(i));
 		irq_set_chained_handler_and_data(data->irqchip_data[i].irq,
 						 NULL, NULL);
 
@@ -302,6 +306,11 @@ static void imx_intmux_remove(struct platform_device *pdev)
 	}
 
 	pm_runtime_disable(&pdev->dev);
+	if (ret >= 0) {
+		pm_runtime_put_noidle(&pdev->dev);
+		clk_disable_unprepare(data->ipg_clk);
+		pm_runtime_set_suspended(&pdev->dev);
+	}
 }
 
 #ifdef CONFIG_PM
-- 
2.53.0



