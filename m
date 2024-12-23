Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A94A1B4131;
	Mon, 23 Dec 2024 16:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970191; cv=none; b=T6sFVwieov7hGhLZ1T3KCehtEo3+TMljxnjleWtrPtAFo3zKZW3ywb3o0ifcI+Z7X6+jCjUQK0xGPZXRMsWhlhtB8IfenRn9AvoL8jLXuYRbaNrCzLRxGzxmpmiXM2iKT+ZmwiN8wDzWih+QM+WYKi5VCHW8rZ3pCNLDF+6Yq7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970191; c=relaxed/simple;
	bh=K6JuoRONArQ5anEdIyd/bkulhGDCGAE3fhP9h0SxZZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L42C1uJC3ZLr8crPCo/pxdGhUgdG82rIydopQ4LHJrPoGOCKDD5KXXMYmZYd0yxyIyaslW8/e6GLYEFgQiPRrf0nigUHOGuu+oz/adNvFF+LV0SmB/Gg6Pug+yLUrW7NVp15d7cIshPfRE8hcegoexTD/t0yNzx3Re9lUka1+rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSWB/ruw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSWB/ruw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10205C4CED4;
	Mon, 23 Dec 2024 16:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970190;
	bh=K6JuoRONArQ5anEdIyd/bkulhGDCGAE3fhP9h0SxZZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSWB/ruwiN6cC1Mpp5vjYFx9B5Pb9c6BiXUkivECBOMVqS7fBOe9HFBdC6CNxiOvd
	 jMUgcBhbVpOrkjGTengTkW8A9gvH2ZSwoO5TfN2tGr59m/hSTPBvMELSzXJT3ZmMyf
	 fBFGXvz7SW4UHYBJSR3bz9CFqT/N6R7mU5cFEyqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/116] usb: cdns3: Add quirk flag to enable suspend residency
Date: Mon, 23 Dec 2024 16:58:01 +0100
Message-ID: <20241223155359.981220588@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@kernel.org>

[ Upstream commit 0aca19e4037a4143273e90f1b44666b78b4dde9b ]

Some platforms (e.g. ti,j721e-usb, ti,am64-usb) require
this bit to be set to workaround a lockup issue with PHY
short suspend intervals [1]. Add a platform quirk flag
to indicate if Suspend Residency should be enabled.

[1] - https://www.ti.com/lit/er/sprz457h/sprz457h.pdf
i2409 - USB: USB2 PHY locks up due to short suspend

Signed-off-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20240516044537.16801-2-r-gunasekaran@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/core.h |  1 +
 drivers/usb/cdns3/drd.c  | 10 +++++++++-
 drivers/usb/cdns3/drd.h  |  3 +++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/core.h b/drivers/usb/cdns3/core.h
index 81a9c9d6be08..57d47348dc19 100644
--- a/drivers/usb/cdns3/core.h
+++ b/drivers/usb/cdns3/core.h
@@ -44,6 +44,7 @@ struct cdns3_platform_data {
 			bool suspend, bool wakeup);
 	unsigned long quirks;
 #define CDNS3_DEFAULT_PM_RUNTIME_ALLOW	BIT(0)
+#define CDNS3_DRD_SUSPEND_RESIDENCY_ENABLE	BIT(1)
 };
 
 /**
diff --git a/drivers/usb/cdns3/drd.c b/drivers/usb/cdns3/drd.c
index ee917f1b091c..1b4ce2da1e4b 100644
--- a/drivers/usb/cdns3/drd.c
+++ b/drivers/usb/cdns3/drd.c
@@ -389,7 +389,7 @@ static irqreturn_t cdns_drd_irq(int irq, void *data)
 int cdns_drd_init(struct cdns *cdns)
 {
 	void __iomem *regs;
-	u32 state;
+	u32 state, reg;
 	int ret;
 
 	regs = devm_ioremap_resource(cdns->dev, &cdns->otg_res);
@@ -433,6 +433,14 @@ int cdns_drd_init(struct cdns *cdns)
 			cdns->otg_irq_regs = (struct cdns_otg_irq_regs __iomem *)
 					      &cdns->otg_v1_regs->ien;
 			writel(1, &cdns->otg_v1_regs->simulate);
+
+			if (cdns->pdata &&
+			    (cdns->pdata->quirks & CDNS3_DRD_SUSPEND_RESIDENCY_ENABLE)) {
+				reg = readl(&cdns->otg_v1_regs->susp_ctrl);
+				reg |= SUSP_CTRL_SUSPEND_RESIDENCY_ENABLE;
+				writel(reg, &cdns->otg_v1_regs->susp_ctrl);
+			}
+
 			cdns->version  = CDNS3_CONTROLLER_V1;
 		} else {
 			dev_err(cdns->dev, "not supporte DID=0x%08x\n", state);
diff --git a/drivers/usb/cdns3/drd.h b/drivers/usb/cdns3/drd.h
index d72370c321d3..1e2aee14d629 100644
--- a/drivers/usb/cdns3/drd.h
+++ b/drivers/usb/cdns3/drd.h
@@ -193,6 +193,9 @@ struct cdns_otg_irq_regs {
 /* OTGREFCLK - bitmasks */
 #define OTGREFCLK_STB_CLK_SWITCH_EN	BIT(31)
 
+/* SUPS_CTRL - bitmasks */
+#define SUSP_CTRL_SUSPEND_RESIDENCY_ENABLE	BIT(17)
+
 /* OVERRIDE - bitmasks */
 #define OVERRIDE_IDPULLUP		BIT(0)
 /* Only for CDNS3_CONTROLLER_V0 version */
-- 
2.39.5



