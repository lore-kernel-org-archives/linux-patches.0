Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366061CDFAC;
	Sun,  7 Sep 2025 20:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275778; cv=none; b=hmHW9aT72eWoY/pUTaXWzyUo3siLwk0yJWldCc7SLJtJr4kSXWBbw6TRTQ5wZFJ51LVtLcz/0XymHkg8hvB72Xll/g4Lb4J9CLV/II4Pm6YUl3GeH5RYWzO1FW9q8O3ROZXm86bs+1yFv+9jlnekyGQuv3b0ng+4CeT4Mk+ky+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275778; c=relaxed/simple;
	bh=64aOqgjix7/IQbXz6rq8sO+Rg8yvUWmKrfqemUnMDbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioWTUeXmAM6L0QtpF88RoOF60gBJYSBbMVi3VbFHu0tk6u44YykYYbQYgSP9AnVmu6pTLCZI4xLOYp6yC5SSm5xm0teT49S6YmsqaOIfbS9nDwYKCfRgd0cj/hpTNwFlpNmaUgUwbz4e52zw2RtVAfcYS4QBTPqg1aFWxLByIhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4EFgQuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4EFgQuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AF0C4CEF0;
	Sun,  7 Sep 2025 20:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275776;
	bh=64aOqgjix7/IQbXz6rq8sO+Rg8yvUWmKrfqemUnMDbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4EFgQuzZk69rLvWmVUx86lRw6UTiprH4XWvIy1xMW4AFLhsy3NLMjWnJ2d2VjgUh
	 pGPQ2aEL9zJfGVi4rxUy7QEmBnkYHwstsRi5sZnbs2HSSQzaTEkISexmhjloNMXMLe
	 Fr/voyKlK2xN/IeivmME12rC4+l7COvvDKPGG2Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Imre Kaloz <kaloz@openwrt.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 39/52] arm64: dts: marvell: uDPU: define pinctrl state for alarm LEDs
Date: Sun,  7 Sep 2025 21:57:59 +0200
Message-ID: <20250907195603.106100079@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit b04f0d89e880bc2cca6a5c73cf287082c91878da ]

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
[ Applied to .dts instead of .dtsi ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts
@@ -28,8 +28,9 @@
 	};
 
 	leds {
-		pinctrl-names = "default";
 		compatible = "gpio-leds";
+		pinctrl-names = "default";
+		pinctrl-0 = <&spi_quad_pins>;
 
 		power1 {
 			label = "udpu:green:power";
@@ -96,8 +97,6 @@
 
 &spi0 {
 	status = "okay";
-	pinctrl-names = "default";
-	pinctrl-0 = <&spi_quad_pins>;
 
 	m25p80@0 {
 		compatible = "jedec,spi-nor";
@@ -117,6 +116,10 @@
 	};
 };
 
+&spi_quad_pins {
+	function = "gpio";
+};
+
 &pinctrl_nb {
 	i2c1_recovery_pins: i2c1-recovery-pins {
 		groups = "i2c1";


