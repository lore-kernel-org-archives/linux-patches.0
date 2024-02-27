Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8326D13AA2F;
	Tue, 27 Feb 2024 13:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041060; cv=none; b=OM6fvJwXcmMyBP3PcjzUhMpyNDgz5+zt2CjxoP0ZRPkI4IUMf4sd9wftbBDfML2VOuyo6h4Qp+A+iZ/Ga6PT/SYzKDmCxrq6RF3gMKPzkcVpJnytLhbpSBeyvJ6D0uRf0U2HFwbXj3Amk1hZvlFx5RqEhLgwey+P9FOZA1koXqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041060; c=relaxed/simple;
	bh=BSKFrkmqe0wIwvsy0cl0v3aVuBXubAaWFAFIMLOvvB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhA4PKtbAmYOY1847bX8Kmod4Yr6hcPpphKlU/fgG7ymwqFj8IiOtptJ77k+g/V6NVF0G8+crOkx8Sb1iXkf3knuShyL/Cv/989hfDjnj/T1IuhOQ+l+NdBCkhb0Z+BKcaWDxSdcvox74BTF6OlaCHHF64iqi28imzGUf4srRHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlQn3FpT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlQn3FpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC9FC433F1;
	Tue, 27 Feb 2024 13:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041060;
	bh=BSKFrkmqe0wIwvsy0cl0v3aVuBXubAaWFAFIMLOvvB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlQn3FpTU+B17ITI6/sZCD0BG88Q8bn2D8Udrk9IhKSZJ3uol3ThOtXzbmRo0OG3f
	 j/Jq8IDUYVgQYCWg49nh3e4O3WnD2kkQDTXDKGXfRCdaF3xqUxNGdk47fLn+86djEO
	 Ss1+WFlFc2BMmK1X/Sgx+j0ZhG8fTk3AHxGiBFA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 6.7 205/334] usb: cdnsp: blocked some cdns3 specific code
Date: Tue, 27 Feb 2024 14:21:03 +0100
Message-ID: <20240227131637.364643562@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


