Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F40145B23;
	Tue, 27 Feb 2024 14:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042803; cv=none; b=Nu/Iyz5k5N+aXJCGLLsb+Uc5e8kRwjccqcm/OyqatvKQpHPL/YilqhBgrcFBw4BJyRcK0TFL48O7hpEzb5ez9/LAlC0746qiRT45lUn9ebvhB1b6CPiPRhEU+vbrPELz1ZUXvkHlABx+L9mPL0Ts9golR/YzL/UjHv8BlA2QvlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042803; c=relaxed/simple;
	bh=dWaAoJROR2DvqZABTersWUKELtGHI1dmPbHFwUDYH+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFR+oOIZYr4mrBITCEgww593bshQq+QiMOy3LRVG8NDnOKsvpOT3jrdXwHUCwOgk4uHgH3cM3e5s/Kb1tykFFortBtaXTgoUK1KBe1DgRrrfUwHW50pG9Ozx77CdH5DU2w3Wr8TVziYjAIqxV5c1owlddYFIE3I9V6niu+FJGTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aapVMYhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aapVMYhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61268C433C7;
	Tue, 27 Feb 2024 14:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042803;
	bh=dWaAoJROR2DvqZABTersWUKELtGHI1dmPbHFwUDYH+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aapVMYhRxheLwx8L1vJpO1UJbeS1vruGRbFShsFc1RHjuy8Y4ep2RS8EEj2xSqIjV
	 4EqhEA6QuW6MLIwJN0DFTRmF2avXdFjABjvRet0jqZEE4y4Og3rm9mZ8wd6eefhC1q
	 GzAZqAatABbW2MxkKuwwgp6immI9ajhe0C2zJBto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 5.15 098/245] usb: cdnsp: fixed issue with incorrect detecting CDNSP family controllers
Date: Tue, 27 Feb 2024 14:24:46 +0100
Message-ID: <20240227131618.406231484@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

commit 47625b018c6bc788bc10dd654c82696eb0a5ef11 upstream.

Cadence have several controllers from 0x000403xx family but current
driver suuport detecting only one with DID equal 0x0004034E.
It causes that if someone uses different CDNSP controller then driver
will use incorrect version and register space.
Patch fix this issue.

cc: stable@vger.kernel.org
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20240215121609.259772-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/core.c |    1 -
 drivers/usb/cdns3/drd.c  |   13 +++++++++----
 drivers/usb/cdns3/drd.h  |    6 +++++-
 3 files changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/usb/cdns3/core.c
+++ b/drivers/usb/cdns3/core.c
@@ -394,7 +394,6 @@ pm_put:
 	return ret;
 }
 
-
 /**
  * cdns_wakeup_irq - interrupt handler for wakeup events
  * @irq: irq number for cdns3/cdnsp core device
--- a/drivers/usb/cdns3/drd.c
+++ b/drivers/usb/cdns3/drd.c
@@ -156,7 +156,8 @@ bool cdns_is_device(struct cdns *cdns)
  */
 static void cdns_otg_disable_irq(struct cdns *cdns)
 {
-	writel(0, &cdns->otg_irq_regs->ien);
+	if (cdns->version)
+		writel(0, &cdns->otg_irq_regs->ien);
 }
 
 /**
@@ -418,15 +419,20 @@ int cdns_drd_init(struct cdns *cdns)
 
 		cdns->otg_regs = (void __iomem *)&cdns->otg_v1_regs->cmd;
 
-		if (readl(&cdns->otg_cdnsp_regs->did) == OTG_CDNSP_DID) {
+		state = readl(&cdns->otg_cdnsp_regs->did);
+
+		if (OTG_CDNSP_CHECK_DID(state)) {
 			cdns->otg_irq_regs = (struct cdns_otg_irq_regs __iomem *)
 					      &cdns->otg_cdnsp_regs->ien;
 			cdns->version  = CDNSP_CONTROLLER_V2;
-		} else {
+		} else if (OTG_CDNS3_CHECK_DID(state)) {
 			cdns->otg_irq_regs = (struct cdns_otg_irq_regs __iomem *)
 					      &cdns->otg_v1_regs->ien;
 			writel(1, &cdns->otg_v1_regs->simulate);
 			cdns->version  = CDNS3_CONTROLLER_V1;
+		} else {
+			dev_err(cdns->dev, "not supporte DID=0x%08x\n", state);
+			return -EINVAL;
 		}
 
 		dev_dbg(cdns->dev, "DRD version v1 (ID: %08x, rev: %08x)\n",
@@ -479,7 +485,6 @@ int cdns_drd_exit(struct cdns *cdns)
 	return 0;
 }
 
-
 /* Indicate the cdns3 core was power lost before */
 bool cdns_power_is_lost(struct cdns *cdns)
 {
--- a/drivers/usb/cdns3/drd.h
+++ b/drivers/usb/cdns3/drd.h
@@ -79,7 +79,11 @@ struct cdnsp_otg_regs {
 	__le32 susp_timing_ctrl;
 };
 
-#define OTG_CDNSP_DID	0x0004034E
+/* CDNSP driver supports 0x000403xx Cadence USB controller family. */
+#define OTG_CDNSP_CHECK_DID(did) (((did) & GENMASK(31, 8)) == 0x00040300)
+
+/* CDNS3 driver supports 0x000402xx Cadence USB controller family. */
+#define OTG_CDNS3_CHECK_DID(did) (((did) & GENMASK(31, 8)) == 0x00040200)
 
 /*
  * Common registers interface for both CDNS3 and CDNSP version of DRD.


