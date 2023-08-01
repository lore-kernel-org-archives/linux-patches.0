Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E028E1F957
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63686C433C8;
	Tue,  1 Aug 2023 09:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882602;
	bh=kHJAGS8iDrf8UGaAGHIsWhQge0GLMRaBsKz8vrTE5aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4UPmKLrsL9xAgX6qHBtdDFPtN8hue/PK6Vl+hyBLgjuCaBQfUvK+sxkMVeeebep8
	 3tPmp9XJmhRSu9UoV0kaRccTO8qNFOh4sb8z+pCiFY1zFQREH8109oP+wkFGYtXKrb
	 mG4RfrLhntD3ju2ofKY8dQhNN4SFM87hUoYFLXfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Ribeiro <mauro.ribeiro@hardkernel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Jakub Vanek <linuxtardis@gmail.com>
Subject: [PATCH 6.1 164/228] Revert "usb: dwc3: core: Enable AutoRetry feature in the controller"
Date: Tue,  1 Aug 2023 11:20:22 +0200
Message-ID: <20230801091928.798616417@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Vanek <linuxtardis@gmail.com>

commit 734ae15ab95a18d3d425fc9cb38b7a627d786f08 upstream.

This reverts commit b138e23d3dff90c0494925b4c1874227b81bddf7.

AutoRetry has been found to sometimes cause controller freezes when
communicating with buggy USB devices.

This controller feature allows the controller in host mode to send
non-terminating/burst retry ACKs instead of terminating retry ACKs
to devices when a transaction error (CRC error or overflow) occurs.

Unfortunately, if the USB device continues to respond with a CRC error,
the controller will not complete endpoint-related commands while it
keeps trying to auto-retry. [3] The xHCI driver will notice this once
it tries to abort the transfer using a Stop Endpoint command and
does not receive a completion in time. [1]
This situation is reported to dmesg:

[sda] tag#29 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD IN
[sda] tag#29 CDB: opcode=0x28 28 00 00 69 42 80 00 00 48 00
xhci-hcd: xHCI host not responding to stop endpoint command
xhci-hcd: xHCI host controller not responding, assume dead
xhci-hcd: HC died; cleaning up

Some users observed this problem on an Odroid HC2 with the JMS578
USB3-to-SATA bridge. The issue can be triggered by starting
a read-heavy workload on an attached SSD. After a while, the host
controller would die and the SSD would disappear from the system. [1]

Further analysis by Synopsys determined that controller revisions
other than the one in Odroid HC2 are also affected by this.
The recommended solution was to disable AutoRetry altogether.
This change does not have a noticeable performance impact. [2]

Revert the enablement commit. This will keep the AutoRetry bit in
the default state configured during SoC design [2].

Fixes: b138e23d3dff ("usb: dwc3: core: Enable AutoRetry feature in the controller")
Link: https://lore.kernel.org/r/a21f34c04632d250cd0a78c7c6f4a1c9c7a43142.camel@gmail.com/ [1]
Link: https://lore.kernel.org/r/20230711214834.kyr6ulync32d4ktk@synopsys.com/ [2]
Link: https://lore.kernel.org/r/20230712225518.2smu7wse6djc7l5o@synopsys.com/ [3]
Cc: stable@vger.kernel.org
Cc: Mauro Ribeiro <mauro.ribeiro@hardkernel.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Suggested-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Jakub Vanek <linuxtardis@gmail.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20230714122419.27741-1-linuxtardis@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   16 ----------------
 drivers/usb/dwc3/core.h |    3 ---
 2 files changed, 19 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1241,22 +1241,6 @@ static int dwc3_core_init(struct dwc3 *d
 		dwc3_writel(dwc->regs, DWC3_GUCTL1, reg);
 	}
 
-	if (dwc->dr_mode == USB_DR_MODE_HOST ||
-	    dwc->dr_mode == USB_DR_MODE_OTG) {
-		reg = dwc3_readl(dwc->regs, DWC3_GUCTL);
-
-		/*
-		 * Enable Auto retry Feature to make the controller operating in
-		 * Host mode on seeing transaction errors(CRC errors or internal
-		 * overrun scenerios) on IN transfers to reply to the device
-		 * with a non-terminating retry ACK (i.e, an ACK transcation
-		 * packet with Retry=1 & Nump != 0)
-		 */
-		reg |= DWC3_GUCTL_HSTINAUTORETRY;
-
-		dwc3_writel(dwc->regs, DWC3_GUCTL, reg);
-	}
-
 	/*
 	 * Must config both number of packets and max burst settings to enable
 	 * RX and/or TX threshold.
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -254,9 +254,6 @@
 #define DWC3_GCTL_GBLHIBERNATIONEN	BIT(1)
 #define DWC3_GCTL_DSBLCLKGTNG		BIT(0)
 
-/* Global User Control Register */
-#define DWC3_GUCTL_HSTINAUTORETRY	BIT(14)
-
 /* Global User Control 1 Register */
 #define DWC3_GUCTL1_DEV_DECOUPLE_L1L2_EVT	BIT(31)
 #define DWC3_GUCTL1_TX_IPGAP_LINECHECK_DIS	BIT(28)


