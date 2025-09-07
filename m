Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9B01B424F;
	Sun,  7 Sep 2025 20:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276063; cv=none; b=byIl3fvKUiGZVc397RSgT3gPyeCMVgRTACSIZgo0ab5NuB+5SJxi4T8eU6x4MFMYX3ro32RyEybG6WghAW7E81ghPmJFDsrfP/4Csrr51r9q8WPUXF6UIcrU0FjyFBBafJ1mGmQsjR+nrl+Y7cSuESNxV/2nOgzpA8lXAK9ERHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276063; c=relaxed/simple;
	bh=rQKhdC2TiiWzyuggWW4PwjZi3omNH1OzJOG4Zdmzh04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbp79wAhJYhKn5a6b+LrSER0C1uRwNSdyRL98V+KMJAMXTurvawQ8LYkEI6Oqzfjy0vGxu8uHQFD14/5ptPqY97DUCIqosC77zYgf4aK+i1Idabg2DYgDQXa+zCyhflF4jajhgHWjEPHttaqjjKPoynbhPjsg3QK6vYdwhFHiJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aeFnui24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeFnui24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9628CC4CEF0;
	Sun,  7 Sep 2025 20:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276063;
	bh=rQKhdC2TiiWzyuggWW4PwjZi3omNH1OzJOG4Zdmzh04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aeFnui24mF0X4+SAhjdbdMikNg5/wlHplYJVmhfcOHA3cQPSso8XozrpPo/+WEfSY
	 ElHyCs7DtlrmH983gskwfBFOJxSFc6xGFgLC4nEKABoni3dIAsT4VCU7BnwwvnK9aL
	 +IZNxi0fJTEi+bfOmn3eCxEv9dadqCe3B2Q5cqYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Imre Kaloz <kaloz@openwrt.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 51/64] arm64: dts: marvell: uDPU: define pinctrl state for alarm LEDs
Date: Sun,  7 Sep 2025 21:58:33 +0200
Message-ID: <20250907195604.818724879@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195603.394640159@linuxfoundation.org>
References: <20250907195603.394640159@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


