Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEC813B2B4;
	Tue, 27 Feb 2024 13:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042163; cv=none; b=V4A/GNa196mZVRhDPnz4o/igdQwu92ZFMqyD/XE0DIeBCFuXetZLNv90g8qxkSy96PEV+GHKl5xINzCnOhVRJMyOqw1OV6NQFOqDU/p3rtPOZKPIj4eBu8501vfJx+9sGrH1DWcq2OyaDa35VZkXDYW5OsJ+D2S0pMx8gvEMbe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042163; c=relaxed/simple;
	bh=cszjtEhGSPo4RCw44BfgpUNhJIKVY5B1pUphwCVdz1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjsKpXiByzH2Oe123J422uoZJBJ9R5+LfsSucetACs5MFMq5md5DoKrtujVMI+JYpSjRQS+N02Y5yMTYbu/UmirL66/4GojcZb5vU/O3RPu87hr3i8Sej8ftRYH3T38Sf+6qx8eOzTzAVfzUXQz8qCciysN6Vw87FF/a0ZsyQeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+rXptCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+rXptCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA65C433C7;
	Tue, 27 Feb 2024 13:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042163;
	bh=cszjtEhGSPo4RCw44BfgpUNhJIKVY5B1pUphwCVdz1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+rXptCI7RGKARZwgaWsqxssy2U9sVMvb8gPzefdlv6peNY9C5JpKnKd7qOqAETFv
	 23uBaBPTIieDLDPZ5npcChqSaKpNz0MNAXCme0sDSj0MXd0rdX+MoyM7BuQHt2kjh+
	 ujiNaWDGq1iEdI+eo1bfGUJLLMkcrFVxUxR4FWao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 6.6 184/299] usb: cdnsp: blocked some cdns3 specific code
Date: Tue, 27 Feb 2024 14:24:55 +0100
Message-ID: <20240227131631.760568546@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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


