Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E206224F6;
	Tue,  8 Apr 2025 11:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110635; cv=none; b=alRrja70g4vr9g9GHpaicJuiziBnaz8qmoySPL0Qa9J0QpSLIPrtCXOSOWrEK/yoNTCrhE4bC6JwnANxJAGBtiuovYxHL55iHBZx9ez2CvJStTqawwLXBIoMYUB8StvP1ttTC+oDJ17XVSvvu86NK6XdtFuMerWMQ9vEHv+3Jvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110635; c=relaxed/simple;
	bh=z4msoySezph61v2FJi5vURHUUQ7G8XJifCob8iEvc7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnapob0hmBb8KWtqefZP6Z403TyTG9HteDb0g1lw1Q5KBfYhLobsE4jNbFa1/aCBGX3FrocRoURVjdzyajK0K+zOQCLbM0ortnUiChAsCttXTYYZ0iX5uL2xL9OCWePCEa54A0MXsG94hqD57BXY6L8ZvrUrCWpKDPjruA3x5Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UdX2Vday; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UdX2Vday"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9F7C4CEE5;
	Tue,  8 Apr 2025 11:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110634;
	bh=z4msoySezph61v2FJi5vURHUUQ7G8XJifCob8iEvc7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UdX2Vdayfiw2q8yQ6r4Phm50km07PRDFvhHwmaHhKoCz3hm/5Z1z2OfcOoQ2aCBE/
	 1Iy6nMplctKlFKYKwxLlF5Ee0eNflpaZGog8mc1oFtDHHxU4z8S1Bo/yptRl+b4zmW
	 wHPLx7rph81babjxIt1v2LKmVlmMg0QstJto0Zww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 138/731] arm64: dts: ti: k3-am62p: fix pinctrl settings
Date: Tue,  8 Apr 2025 12:40:35 +0200
Message-ID: <20250408104917.488370365@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 33bab9d84e52188cf73c3573fd7cf3ec0e01d007 ]

It appears that pinctrl-single is misused on this SoC to control both
the mux and the input and output and bias settings. This results in
non-working pinctrl configurations for GPIOs within the device tree.

This is what happens:
 (1) During startup the pinctrl settings are applied according to the
     device tree. I.e. the pin is configured as output and with
     pull-ups enabled.
 (2) During startup a device driver requests a GPIO.
 (3) pinctrl-single is applying the default GPIO setting according to
     the pinctrl-single,gpio-range property.

This would work as expected if the pinctrl-single is only controlling
the function mux, but it also controls the input/output buffer enable,
the pull-up and pull-down settings etc (pinctrl-single,function-mask
covers the entire pad setting instead of just the mux field).

Remove the pinctrl-single,gpio-range property, so that no settings are
applied during a gpio_request() call.

Fixes: d72d73a44c3c ("arm64: dts: ti: k3-am62p: Add gpio-ranges properties")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Link: https://lore.kernel.org/r/20250221091447.595199-1-mwalle@kernel.org
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/ti/k3-am62p-j722s-common-mcu.dtsi     |  8 --------
 arch/arm64/boot/dts/ti/k3-am62p-main.dtsi          | 14 --------------
 2 files changed, 22 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p-j722s-common-mcu.dtsi b/arch/arm64/boot/dts/ti/k3-am62p-j722s-common-mcu.dtsi
index b33aff0d65c9d..bd6a00d13aea7 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p-j722s-common-mcu.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p-j722s-common-mcu.dtsi
@@ -12,15 +12,7 @@
 		#pinctrl-cells = <1>;
 		pinctrl-single,register-width = <32>;
 		pinctrl-single,function-mask = <0xffffffff>;
-		pinctrl-single,gpio-range =
-			<&mcu_pmx_range 0 21 PIN_GPIO_RANGE_IOPAD>,
-			<&mcu_pmx_range 23 1 PIN_GPIO_RANGE_IOPAD>,
-			<&mcu_pmx_range 32 2 PIN_GPIO_RANGE_IOPAD>;
 		bootph-all;
-
-		mcu_pmx_range: gpio-range {
-			#pinctrl-single,gpio-range-cells = <3>;
-		};
 	};
 
 	mcu_esm: esm@4100000 {
diff --git a/arch/arm64/boot/dts/ti/k3-am62p-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62p-main.dtsi
index 4b47b07743305..6aea9d3f134e4 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p-main.dtsi
@@ -62,20 +62,6 @@
 	};
 };
 
-&main_pmx0 {
-	pinctrl-single,gpio-range =
-		<&main_pmx0_range 0 32 PIN_GPIO_RANGE_IOPAD>,
-		<&main_pmx0_range 33 38 PIN_GPIO_RANGE_IOPAD>,
-		<&main_pmx0_range 72 22 PIN_GPIO_RANGE_IOPAD>,
-		<&main_pmx0_range 137 5 PIN_GPIO_RANGE_IOPAD>,
-		<&main_pmx0_range 143 3 PIN_GPIO_RANGE_IOPAD>,
-		<&main_pmx0_range 149 2 PIN_GPIO_RANGE_IOPAD>;
-
-	main_pmx0_range: gpio-range {
-		#pinctrl-single,gpio-range-cells = <3>;
-	};
-};
-
 &main_gpio0 {
 	gpio-ranges = <&main_pmx0 0 0 32>, <&main_pmx0 32 33 38>,
 			<&main_pmx0 70 72 22>;
-- 
2.39.5



