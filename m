Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEE2267F66;
	Tue, 25 Mar 2025 12:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905870; cv=none; b=bkWckY6PqGXRKmif22V/aDzd+P4R92Z9vef/Ewaiso3WcAX2QvibreQXs94aYIN8ykewqg93u7KN2uHd5qCJ9hKmxBxZGAYMNJkDtyzPvyOSYMXLNqnNrAvasV1WbKrcqynk+fc1yWkdbKg5tES9kp2JftSvymY9HwAnLUx9DbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905870; c=relaxed/simple;
	bh=2RHI+QpSnITbezb3hbgKMZ7WiokvN5ScZ32tJV90Y9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEa6oVxlM09H+UBEf3Qud+xCTZzPMRvQJoihTnV+adISzFuiSAG39CZuTCza2/MPUpT/8DzZb/3Zny5VP0luyC04ei09N36ohGpBSgEU7xs6LtDZ5aJlBZ/9A6D/7vgKTZxoVroPZHVSkWLNnhPK/2NLjrlfvEsbCDtlu3HOhg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhZGkmOV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhZGkmOV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61225C4CEE4;
	Tue, 25 Mar 2025 12:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905870;
	bh=2RHI+QpSnITbezb3hbgKMZ7WiokvN5ScZ32tJV90Y9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhZGkmOV/4Wb0SosmKfaYhzEmABJRxhKzIf+x31zz/nbSY1mDTFUxD78BBAsO0rLp
	 VAZ+kaYh0lc8IZOmBPCpL+VzPt0vw0wrrm+vsbobsja3Q2ewT0mwd0BH9JIKWueoVy
	 bImNgO1QxdwO1T46Y9kmZa/VFhlQ6dmY86lgYdyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 010/119] ARM: dts: bcm2711: Fix xHCI power-domain
Date: Tue, 25 Mar 2025 08:21:08 -0400
Message-ID: <20250325122149.326268808@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



