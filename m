Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21137C08C;
	Mon,  8 Apr 2024 14:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584883; cv=none; b=iiSc4IQJ6p2RYc953A1/AgYAcGcz08uKeVdkD65oU5zny16Lhnw3JLBut+7GryUD5NUzhuUX1VLGc8ni7TdltEP9vlYnyaoelXKpqYPgq6r2tIfPdUzeeAgw0bpdUZHNmOGiDxtGm+tKX6pDYxqQ/OljRe5dCTBZUKGRxFVPRj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584883; c=relaxed/simple;
	bh=Qzbs50LPbw0L0YaKv3wrmFHvwbeJ7eCHjQCqqqoBs5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDSamhG9bu/XVOufsJmNyBmbaAOXAPQQtmZ/eHTYqjkKMW3Dtpis43vEn1M82lzXpDPDmsMw+AZVexRETLh0CVHJfrGQpmJKHdWHT86t+Zqc33IyeMsTFXUxeIAOObQ4mrBWv+bvX9uS6aJOhUBI80p12ZU18vuyikFNFi3Mljs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYNHuP8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYNHuP8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA55C433F1;
	Mon,  8 Apr 2024 14:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584882;
	bh=Qzbs50LPbw0L0YaKv3wrmFHvwbeJ7eCHjQCqqqoBs5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYNHuP8frI5SOIT/gVIF5YTqfMveRqC4SS6qEWbkXFNXG1BnSHHXekFCW3/cq2rAl
	 5bDFHwVXUsaumxRngopWnnjXRbY+2E87saV1evUsOti8+018117EVIBSPmUnRrZAWE
	 tqhUk5OLkTACmDU9/skh+fJi8Efhn7qCQgsXeyvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 5.15 590/690] usb: dwc2: gadget: LPM flow fix
Date: Mon,  8 Apr 2024 14:57:36 +0200
Message-ID: <20240408125420.958814908@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit 5d69a3b54e5a630c90d82a4c2bdce3d53dc78710 upstream.

Added functionality to exit from L1 state by device initiation
using remote wakeup signaling, in case when function driver queuing
request while core in L1 state.

Fixes: 273d576c4d41 ("usb: dwc2: gadget: Add functionality to exit from LPM L1 state")
Fixes: 88b02f2cb1e1 ("usb: dwc2: Add core state checking")
CC: stable@vger.kernel.org
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/b4d9de5382375dddbf7ef6049d9a82066ad87d5d.1710166393.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/core.h      |    1 
 drivers/usb/dwc2/core_intr.c |   65 ++++++++++++++++++++++++++++---------------
 drivers/usb/dwc2/gadget.c    |    4 ++
 3 files changed, 48 insertions(+), 22 deletions(-)

--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -1358,6 +1358,7 @@ int dwc2_backup_global_registers(struct
 int dwc2_restore_global_registers(struct dwc2_hsotg *hsotg);
 
 void dwc2_enable_acg(struct dwc2_hsotg *hsotg);
+void dwc2_wakeup_from_lpm_l1(struct dwc2_hsotg *hsotg, bool remotewakeup);
 
 /* This function should be called on every hardware interrupt. */
 irqreturn_t dwc2_handle_common_intr(int irq, void *dev);
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -353,10 +353,11 @@ static void dwc2_handle_session_req_intr
  * @hsotg: Programming view of DWC_otg controller
  *
  */
-static void dwc2_wakeup_from_lpm_l1(struct dwc2_hsotg *hsotg)
+void dwc2_wakeup_from_lpm_l1(struct dwc2_hsotg *hsotg, bool remotewakeup)
 {
 	u32 glpmcfg;
-	u32 i = 0;
+	u32 pcgctl;
+	u32 dctl;
 
 	if (hsotg->lx_state != DWC2_L1) {
 		dev_err(hsotg->dev, "Core isn't in DWC2_L1 state\n");
@@ -365,37 +366,57 @@ static void dwc2_wakeup_from_lpm_l1(stru
 
 	glpmcfg = dwc2_readl(hsotg, GLPMCFG);
 	if (dwc2_is_device_mode(hsotg)) {
-		dev_dbg(hsotg->dev, "Exit from L1 state\n");
+		dev_dbg(hsotg->dev, "Exit from L1 state, remotewakeup=%d\n", remotewakeup);
 		glpmcfg &= ~GLPMCFG_ENBLSLPM;
-		glpmcfg &= ~GLPMCFG_HIRD_THRES_EN;
+		glpmcfg &= ~GLPMCFG_HIRD_THRES_MASK;
 		dwc2_writel(hsotg, glpmcfg, GLPMCFG);
 
-		do {
-			glpmcfg = dwc2_readl(hsotg, GLPMCFG);
-
-			if (!(glpmcfg & (GLPMCFG_COREL1RES_MASK |
-					 GLPMCFG_L1RESUMEOK | GLPMCFG_SLPSTS)))
-				break;
+		pcgctl = dwc2_readl(hsotg, PCGCTL);
+		pcgctl &= ~PCGCTL_ENBL_SLEEP_GATING;
+		dwc2_writel(hsotg, pcgctl, PCGCTL);
+
+		glpmcfg = dwc2_readl(hsotg, GLPMCFG);
+		if (glpmcfg & GLPMCFG_ENBESL) {
+			glpmcfg |= GLPMCFG_RSTRSLPSTS;
+			dwc2_writel(hsotg, glpmcfg, GLPMCFG);
+		}
 
-			udelay(1);
-		} while (++i < 200);
+		if (remotewakeup) {
+			if (dwc2_hsotg_wait_bit_set(hsotg, GLPMCFG, GLPMCFG_L1RESUMEOK, 1000)) {
+				dev_warn(hsotg->dev, "%s: timeout GLPMCFG_L1RESUMEOK\n", __func__);
+				goto fail;
+				return;
+			}
+
+			dctl = dwc2_readl(hsotg, DCTL);
+			dctl |= DCTL_RMTWKUPSIG;
+			dwc2_writel(hsotg, dctl, DCTL);
+
+			if (dwc2_hsotg_wait_bit_set(hsotg, GINTSTS, GINTSTS_WKUPINT, 1000)) {
+				dev_warn(hsotg->dev, "%s: timeout GINTSTS_WKUPINT\n", __func__);
+				goto fail;
+				return;
+			}
+		}
 
-		if (i == 200) {
-			dev_err(hsotg->dev, "Failed to exit L1 sleep state in 200us.\n");
+		glpmcfg = dwc2_readl(hsotg, GLPMCFG);
+		if (glpmcfg & GLPMCFG_COREL1RES_MASK || glpmcfg & GLPMCFG_SLPSTS ||
+		    glpmcfg & GLPMCFG_L1RESUMEOK) {
+			goto fail;
 			return;
 		}
-		dwc2_gadget_init_lpm(hsotg);
+
+		/* Inform gadget to exit from L1 */
+		call_gadget(hsotg, resume);
+		/* Change to L0 state */
+		hsotg->lx_state = DWC2_L0;
+		hsotg->bus_suspended = false;
+fail:		dwc2_gadget_init_lpm(hsotg);
 	} else {
 		/* TODO */
 		dev_err(hsotg->dev, "Host side LPM is not supported.\n");
 		return;
 	}
-
-	/* Change to L0 state */
-	hsotg->lx_state = DWC2_L0;
-
-	/* Inform gadget to exit from L1 */
-	call_gadget(hsotg, resume);
 }
 
 /*
@@ -416,7 +437,7 @@ static void dwc2_handle_wakeup_detected_
 	dev_dbg(hsotg->dev, "%s lxstate = %d\n", __func__, hsotg->lx_state);
 
 	if (hsotg->lx_state == DWC2_L1) {
-		dwc2_wakeup_from_lpm_l1(hsotg);
+		dwc2_wakeup_from_lpm_l1(hsotg, false);
 		return;
 	}
 
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -1416,6 +1416,10 @@ static int dwc2_hsotg_ep_queue(struct us
 		ep->name, req, req->length, req->buf, req->no_interrupt,
 		req->zero, req->short_not_ok);
 
+	if (hs->lx_state == DWC2_L1) {
+		dwc2_wakeup_from_lpm_l1(hs, true);
+	}
+
 	/* Prevent new request submission when controller is suspended */
 	if (hs->lx_state != DWC2_L0) {
 		dev_dbg(hs->dev, "%s: submit request only in active state\n",


