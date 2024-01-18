Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058E322F06;
	Thu, 18 Jan 2024 10:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575341; cv=none; b=JfZ2lcW43XFvZVR92i9qFlOqy94ifihZ61RpePnuhjrHIK5WYiaqZ0Key9nAL+lrap5tuxN4O7QZFKnsHaTqZL0t9/q34cA9UzJ8EJiu24N5CxHq6OaOlax63GxP295gM9lXo9F7V/U8dMI4Ow0WhdVIK1vv2y+MPRwqnrrLnpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575341; c=relaxed/simple;
	bh=+stfkmM6HttMUDkn+Y2C9S7EeqMGuB+lmTNUwquavAY=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=VhqAQ2taiNvo7vnCEmjoRoiiZs4J0kaPepjFO/DIbAgL+jpQXgRl5YaukCx00G+l62GzQg9MHEbHrpAi0ibx3CYEZ477O7fKyh5jt72GtZDTkt8MzpWpAi/th1++jE4FcNsG0OlgYxyM3aW2XchWDCneQXWLQij8g5qdKbd0Fno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZ2Su9UI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZ2Su9UI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4215DC433F1;
	Thu, 18 Jan 2024 10:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575340;
	bh=+stfkmM6HttMUDkn+Y2C9S7EeqMGuB+lmTNUwquavAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZ2Su9UIGZpstXoRpdCMyewKO6rCKSbQ/JH2UqN3DaWHFTKRaJ6hbjTPUFtTRdCSy
	 SwTatV6Z6xecRDEMNq/HUhB4GPPotUfQf7Keu/3pWWP2Xx0Qwu2+qUYJSDBqBvuGQV
	 5YPTT/lJm01NFzQnIayVECYL9XdPc5G3WOEpqcG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/150] arm64: dts: rockchip: Fix PCI node addresses on rk3399-gru
Date: Thu, 18 Jan 2024 11:48:00 +0100
Message-ID: <20240118104322.666927591@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Rob Herring <robh@kernel.org>

[ Upstream commit c13c823a78b77ea0e5f1f73112d910e259911101 ]

The rk3399-gru PCI node addresses are wrong.

In rk3399-gru-scarlet, the bus number in the address should be 0. This is
because bus number assignment is dynamic and not known up front. For FDT,
the bus number is simply ignored.

In rk3399-gru-chromebook, the addresses are simply invalid. The first
"reg" entry must be the configuration space for the device. The entry
should be all 0s except for device/slot and function numbers. The existing
64-bit memory space (0x83000000) entries are not valid because they must
have the BAR address in the lower byte of the first cell.

Warnings for these are enabled by adding the missing 'device_type = "pci"'
for the root port node.

Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20231130191830.2424361-1-robh@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi  | 3 +--
 arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet-dumo.dts | 4 ++--
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi             | 1 +
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
index 5c1929d41cc0..cacbad35cfc8 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-chromebook.dtsi
@@ -509,8 +509,7 @@ wacky_spi_audio: spi2@0 {
 &pci_rootport {
 	mvl_wifi: wifi@0,0 {
 		compatible = "pci1b4b,2b42";
-		reg = <0x83010000 0x0 0x00000000 0x0 0x00100000
-		       0x83010000 0x0 0x00100000 0x0 0x00100000>;
+		reg = <0x0000 0x0 0x0 0x0 0x0>;
 		interrupt-parent = <&gpio0>;
 		interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
 		pinctrl-names = "default";
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet-dumo.dts b/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet-dumo.dts
index 853e88455e75..9e4b12ed62cb 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet-dumo.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet-dumo.dts
@@ -34,8 +34,8 @@ &mipi_panel {
 &pci_rootport {
 	wifi@0,0 {
 		compatible = "qcom,ath10k";
-		reg = <0x00010000 0x0 0x00000000 0x0 0x00000000>,
-		      <0x03010010 0x0 0x00000000 0x0 0x00200000>;
+		reg = <0x00000000 0x0 0x00000000 0x0 0x00000000>,
+		      <0x03000010 0x0 0x00000000 0x0 0x00200000>;
 		qcom,ath10k-calibration-variant = "GO_DUMO";
 	};
 };
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
index c9bf1d5c3a42..789fd0dcc88b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi
@@ -489,6 +489,7 @@ pci_rootport: pcie@0,0 {
 		#address-cells = <3>;
 		#size-cells = <2>;
 		ranges;
+		device_type = "pci";
 	};
 };
 
-- 
2.43.0



