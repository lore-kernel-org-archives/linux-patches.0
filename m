Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B4C145343;
	Tue, 27 Feb 2024 14:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042801; cv=none; b=bukhESmb3BdOpps+kfTyN0u8XUj+gwgNECGYQrBBkK0+kvlXhcsENRvpxZCPWn8UPUIf+EUdecBP+5RRCNRNYhQCpozS0WKKwr0qPbM5FUTmp7/Htye9u09RimTGFNjkIoFLnpNroMGjx5HeM1goXmOVFcbf8piPEJXlPmTdQfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042801; c=relaxed/simple;
	bh=HccAKJMt0kMq0NzhS3k550acQbddfNXf+Spf4r+KpB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfTx+SHouDU0bNHC1JwO7ku9lhLksNmZYJmCnfYNasn3cxxcAr0C7YoGKU3MrRyjTiZU8iZbfxp8vSQ3x7o7/ZgluPXM4GovAa/Ywl2hF/VIpggoCSxr+lWUDhmclOeSAdSVKFT15kZLxCd7pZUN80g0iOnif3y9hD+kM6Hcvuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsKfgBna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsKfgBna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC5CC433F1;
	Tue, 27 Feb 2024 14:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042801;
	bh=HccAKJMt0kMq0NzhS3k550acQbddfNXf+Spf4r+KpB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsKfgBnaon+5iKmC3Cb08hjV4MXwX9jE9zv71kiSFQHw0HnCc0o2Gbe0egXdzhcDs
	 jnhP7CM3fywKlQ+kOJ6do11eVG/vcbqreKESgRxvgHAzB40S5fP80T2dIgMp8/FQbR
	 W1BpkjBfQkX7/qmAAPbstA2pC12F9G/TqVQYbeZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 5.15 097/245] usb: cdnsp: blocked some cdns3 specific code
Date: Tue, 27 Feb 2024 14:24:45 +0100
Message-ID: <20240227131618.367360817@linuxfoundation.org>
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
@@ -17,6 +17,11 @@
 #include "../host/xhci.h"
 #include "../host/xhci-plat.h"
 
+/*
+ * The XECP_PORT_CAP_REG and XECP_AUX_CTRL_REG1 exist only
+ * in Cadence USB3 dual-role controller, so it can't be used
+ * with Cadence CDNSP dual-role controller.
+ */
 #define XECP_PORT_CAP_REG	0x8000
 #define XECP_AUX_CTRL_REG1	0x8120
 
@@ -56,6 +61,8 @@ static const struct xhci_plat_priv xhci_
 	.resume_quirk = xhci_cdns3_resume_quirk,
 };
 
+static const struct xhci_plat_priv xhci_plat_cdnsp_xhci;
+
 static int __cdns_host_init(struct cdns *cdns)
 {
 	struct platform_device *xhci;
@@ -80,8 +87,13 @@ static int __cdns_host_init(struct cdns
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


