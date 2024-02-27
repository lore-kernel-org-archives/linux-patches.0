Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF1B78B61;
	Tue, 27 Feb 2024 14:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043470; cv=none; b=jRTPCxRxLngnJCe4jJJX8tYOBhFWkSnL5YzEboVrKUalBPcfBwsdy4wPckOox1B9FBFig941xotk0ykoQs+UyA7l7lAR7fCINuGzed22MAB1R+70sTyegeOID3SXXKQgbqH7qKDHkihPsNuYo5RcgzBcm9VpQDO3QkxhYSOFW6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043470; c=relaxed/simple;
	bh=4Vs1dq0aviVoDrNQrLDSRPu7hfmEe6XBOjvSqzxx87w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+xk30pnns/CJhgurvIGoaVok16gSp134ozh9wTCzxTjcL7oXNTBKCHU1RBCWqiMYLPNzqEJYIbz/nVu7ZdYjP2oRZyYJOErk0gQkO1OdFidgrOyrTW1cJDe83X8TqPflvg5h13hcyhtJJ0TajYJPpaR+J1qZQQMyItO8DHrB98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sMSP54TU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sMSP54TU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F45C433F1;
	Tue, 27 Feb 2024 14:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043470;
	bh=4Vs1dq0aviVoDrNQrLDSRPu7hfmEe6XBOjvSqzxx87w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sMSP54TU8BLA4x+Zsk7xZvON+lPhmdKroQBujPFFQL18CcZY0TjfUYmjOrbkKLoT0
	 gJ2kKc2b8B8hAv4A7U0iHFPqFYqGr8ZSeA52LkBD5iAqusuWKX76LndXEg0lVtevud
	 xTBUf6NEfT8oQEsyXvTh0Jc/JXQ+ZdflMC9IZtEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 6.1 119/195] usb: cdnsp: blocked some cdns3 specific code
Date: Tue, 27 Feb 2024 14:26:20 +0100
Message-ID: <20240227131614.387200751@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

commit 18a6be674306c9acb05c08e5c3fd376ef50a917c upstream.

host.c file has some parts of code that were introduced for CDNS3 driver
and should not be used with CDNSP driver.
This patch blocks using these parts of codes by CDNSP driver.
These elements include:
- xhci_plat_cdns3_xhci object
- cdns3 specific XECP_PORT_CAP_REG register
- cdns3 specific XECP_AUX_CTRL_REG1 register

cc: stable@vger.kernel.org
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20240206104018.48272-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/host.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/usb/cdns3/host.c
+++ b/drivers/usb/cdns3/host.c
@@ -18,6 +18,11 @@
 #include "../host/xhci.h"
 #include "../host/xhci-plat.h"
 
+/*
+ * The XECP_PORT_CAP_REG and XECP_AUX_CTRL_REG1 exist only
+ * in Cadence USB3 dual-role controller, so it can't be used
+ * with Cadence CDNSP dual-role controller.
+ */
 #define XECP_PORT_CAP_REG	0x8000
 #define XECP_AUX_CTRL_REG1	0x8120
 
@@ -57,6 +62,8 @@ static const struct xhci_plat_priv xhci_
 	.resume_quirk = xhci_cdns3_resume_quirk,
 };
 
+static const struct xhci_plat_priv xhci_plat_cdnsp_xhci;
+
 static int __cdns_host_init(struct cdns *cdns)
 {
 	struct platform_device *xhci;
@@ -81,8 +88,13 @@ static int __cdns_host_init(struct cdns
 		goto err1;
 	}
 
-	cdns->xhci_plat_data = kmemdup(&xhci_plat_cdns3_xhci,
-			sizeof(struct xhci_plat_priv), GFP_KERNEL);
+	if (cdns->version < CDNSP_CONTROLLER_V2)
+		cdns->xhci_plat_data = kmemdup(&xhci_plat_cdns3_xhci,
+				sizeof(struct xhci_plat_priv), GFP_KERNEL);
+	else
+		cdns->xhci_plat_data = kmemdup(&xhci_plat_cdnsp_xhci,
+				sizeof(struct xhci_plat_priv), GFP_KERNEL);
+
 	if (!cdns->xhci_plat_data) {
 		ret = -ENOMEM;
 		goto err1;


