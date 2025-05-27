Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AF627CCF0;
	Tue, 27 May 2025 17:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366102; cv=none; b=r9hPW45O/M1aXToVlJPh85xam/oU07z3ggNwQu6CqoCTZVrAlxZ9oVkobvczfdA5vT/yjfPW8YjZwePHoHL74+gaEwFkrP06d8mhSqhqKgw8grB2GcABs3yvP/PodXrbcBXwYo+DaBupFpYrlNN/VFbTV2SzMPNn9r9ddUCzAdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366102; c=relaxed/simple;
	bh=uuMYmEnT1rkog+QumJ8woIP7Oo0BLqScKDHel3ipm0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzLiedZhap9l/CaEnwGIwAmLPpZ9wVaLoF69Ql6QxE774AGi+VXuKQWbP9TpvMkJNjgJVdOb9ELyN2j5Qek1ONIgVjgINi80pP+ncX9RW0tXb8s0yoqItCJcnqxHucn+z8OwBUBXp7vwOxY4PCt5b9aIVaXlZiWhM0QBHyp9Xtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bf1Z5A1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bf1Z5A1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EF4C4CEE9;
	Tue, 27 May 2025 17:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366102;
	bh=uuMYmEnT1rkog+QumJ8woIP7Oo0BLqScKDHel3ipm0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bf1Z5A1hDAlq4iwcFsZGjKIykPRF1qWMDJynjdrvlA5UiA9p4k/B0lCRdRJvysDNs
	 8qKKlTJllLKGZ3HiuCCrkcO9aBiPymqm41tQKYuvdeQqN54Iv3DUwm95VPMlKHIx9s
	 1RAvk4UhYfkacOSIWE2fQLnjHeL8cNzKloky1Kno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Imre Kaloz <kaloz@openwrt.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.12 592/626] arm64: dts: marvell: uDPU: define pinctrl state for alarm LEDs
Date: Tue, 27 May 2025 18:28:05 +0200
Message-ID: <20250527162509.046925227@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

commit b04f0d89e880bc2cca6a5c73cf287082c91878da upstream.

The two alarm LEDs of on the uDPU board are stopped working since
commit 78efa53e715e ("leds: Init leds class earlier").

The LEDs are driven by the GPIO{15,16} pins of the North Bridge
GPIO controller. These pins are part of the 'spi_quad' pin group
for which the 'spi' function is selected via the default pinctrl
state of the 'spi' node. This is wrong however, since in order to
allow controlling the LEDs, the pins should use the 'gpio' function.

Before the commit mentined above, the 'spi' function is selected
first by the pinctrl core before probing the spi driver, but then
it gets overridden to 'gpio' implicitly via the
devm_gpiod_get_index_optional() call from the 'leds-gpio' driver.

After the commit, the LED subsystem gets initialized before the
SPI subsystem, so the function of the pin group remains 'spi'
which in turn prevents controlling of the LEDs.

Despite the change of the initialization order, the root cause is
that the pinctrl state definition is wrong since its initial commit
0d45062cfc89 ("arm64: dts: marvell: Add device tree for uDPU board"),

To fix the problem, override the function in the 'spi_quad_pins'
node to 'gpio' and move the pinctrl state definition from the
'spi' node into the 'leds' node.

Cc: stable@vger.kernel.org # needs adjustment for < 6.1
Fixes: 0d45062cfc89 ("arm64: dts: marvell: Add device tree for uDPU board")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dtsi
@@ -26,6 +26,8 @@
 
 	leds {
 		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi_quad_pins>;
 
 		led-power1 {
 			label = "udpu:green:power";
@@ -82,8 +84,6 @@
 
 &spi0 {
 	status = "okay";
-	pinctrl-names = "default";
-	pinctrl-0 = <&spi_quad_pins>;
 
 	flash@0 {
 		compatible = "jedec,spi-nor";
@@ -108,6 +108,10 @@
 	};
 };
 
+&spi_quad_pins {
+	function = "gpio";
+};
+
 &pinctrl_nb {
 	i2c2_recovery_pins: i2c2-recovery-pins {
 		groups = "i2c2";


