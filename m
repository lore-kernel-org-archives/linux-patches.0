Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F0B2571AC;
	Tue, 25 Mar 2025 12:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906238; cv=none; b=NbTgI+aBbCsVM9yHu/H45kBqFTIkPIKWUL/k3oZRgQ/gTosv4x+RifrLzGslsvhuG6UB/gwZkjM2jA20rV57cDqaPFEsi93CCDGfEiWGIOmrbIc6FghU0o1B11a7euAH6iJQvV3hxa1h3bRPkJXqUWqxVbDn/aIUZpZjeO7Rfus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906238; c=relaxed/simple;
	bh=Z0FHriZyfOfPd+JeTtmDeKwRHHE3IrR4xiltfermZJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yd48362H3Wk/6YIBRkMVnGLvY0sE2aJFWEHnaDRTBljouz4v54evMCVvtO60a+rg3OoU1K3kyw2yQS2cTN4fTeuY4j6mCqAh69KhHt911SThBGyqp6ftf9udgjsVyObkbfHZluDLPg1IFaj7SIAXalVlbSGhalbD3QPOd6W9A6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WanBZNws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WanBZNws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C417AC4CEE4;
	Tue, 25 Mar 2025 12:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906238;
	bh=Z0FHriZyfOfPd+JeTtmDeKwRHHE3IrR4xiltfermZJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WanBZNwst6NOlsqFiG/nJVyGkn1dMZWt68SxafVE73IHm/Gg/Mr0e28dka5d2nnTt
	 dXmWcf0w2GGfWDMVBzlJ2qqHrkBH3LeWo0Hz8FtA+s7Bka7GrgKWNwn4dMNxPruEMJ
	 BKjqoRH1sWovIop8rRlKoSpGN1OB1yR8ewsSCwlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/116] ARM: dts: bcm2711: Fix xHCI power-domain
Date: Tue, 25 Mar 2025 08:21:38 -0400
Message-ID: <20250325122149.503416693@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit f44fa354a0715577ca32b085f6f60bcf32c748dd ]

During s2idle tests on the Raspberry CM4 the VPU firmware always crashes
on xHCI power-domain resume:

root@raspberrypi:/sys/power# echo freeze > state
[   70.724347] xhci_suspend finished
[   70.727730] xhci_plat_suspend finished
[   70.755624] bcm2835-power bcm2835-power: Power grafx off
[   70.761127]  USB: Set power to 0

[   74.653040]  USB: Failed to set power to 1 (-110)

This seems to be caused because of the mixed usage of
raspberrypi-power and bcm2835-power at the same time. So avoid
the usage of the VPU firmware power-domain driver, which
prevents the VPU crash.

Fixes: 522c35e08b53 ("ARM: dts: bcm2711: Add BCM2711 xHCI support")
Link: https://github.com/raspberrypi/linux/issues/6537
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20250201112729.31509-1-wahrenst@gmx.net
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm2711-rpi.dtsi | 5 -----
 arch/arm/boot/dts/broadcom/bcm2711.dtsi     | 1 +
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm2711-rpi.dtsi b/arch/arm/boot/dts/broadcom/bcm2711-rpi.dtsi
index 6bf4241fe3b73..c78ed064d1667 100644
--- a/arch/arm/boot/dts/broadcom/bcm2711-rpi.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm2711-rpi.dtsi
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include "bcm2835-rpi.dtsi"
 
-#include <dt-bindings/power/raspberrypi-power.h>
 #include <dt-bindings/reset/raspberrypi,firmware-reset.h>
 
 / {
@@ -101,7 +100,3 @@ &v3d {
 &vchiq {
 	interrupts = <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>;
 };
-
-&xhci {
-	power-domains = <&power RPI_POWER_DOMAIN_USB>;
-};
diff --git a/arch/arm/boot/dts/broadcom/bcm2711.dtsi b/arch/arm/boot/dts/broadcom/bcm2711.dtsi
index e4e42af21ef3a..5eaec6c6a1df3 100644
--- a/arch/arm/boot/dts/broadcom/bcm2711.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm2711.dtsi
@@ -610,6 +610,7 @@ xhci: usb@7e9c0000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
 			interrupts = <GIC_SPI 176 IRQ_TYPE_LEVEL_HIGH>;
+			power-domains = <&pm BCM2835_POWER_DOMAIN_USB>;
 			/* DWC2 and this IP block share the same USB PHY,
 			 * enabling both at the same time results in lockups.
 			 * So keep this node disabled and let the bootloader
-- 
2.39.5



