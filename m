Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A331626B0A4;
	Thu, 13 Feb 2025 15:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459541; cv=none; b=KYv35gZfNz1FTCRHPVfzk4obnEaQBsMPeA8oW/IwDAnYTid/tlv2KfKAO2pabkc3jdn2d3UIBXVWg8+ikwb0v1RM5R1Th0XZAG93M287Ni28eR+Pa/87QLqtOPv/o/hGToMzLM/twir/O+LLW0pB3EhoQ1o7zegETr7WU3PwUDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459541; c=relaxed/simple;
	bh=xibdVeQxM3avhIZyAdpgRkSlfVAbDyg8p7tbBo+6iFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ae576+Y/d0QMl8+zfLl6SdDqxrjkT/fnPB7yVOiXFSbGPUtFmLwGTnSatrELUrdtlbKVeQrK+6VhsZW9viJ/hm6O0Gc0uAmN527Y5j6MQQqCq4U+MtaBRcnmOy3FB0Au9Ixw5A72PtsgF4ATftk3ntUCJ3dibeqmkBTKL0H5nlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FaTVrULw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FaTVrULw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C804C4CED1;
	Thu, 13 Feb 2025 15:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459541;
	bh=xibdVeQxM3avhIZyAdpgRkSlfVAbDyg8p7tbBo+6iFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FaTVrULwY5H2IKj//wuqjNYol9VmmnV209lIb2U/iJi7bPA+t/BPQqlB9o3Tkenjr
	 ccrry/6qFoGMKHeYCR6B1wELEMJgMt/yGv3IbBENe+ss24gF7T/5KYFsFzLZrYgBya
	 T5tIaMxfsNV3Ic72WIRJzyvZwFzFnB68tsDx+KJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Roger Quadros <rogerq@kernel.org>,
	Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 6.13 295/443] ARM: dts: ti/omap: gta04: fix pm issues caused by spi module
Date: Thu, 13 Feb 2025 15:27:40 +0100
Message-ID: <20250213142451.999269271@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

From: Andreas Kemnade <andreas@kemnade.info>

commit 0cfbd7805fe13406500e6a6f2aa08f198d5db4bd upstream.

Despite CM_IDLEST1_CORE and CM_FCLKEN1_CORE behaving normal,
disabling SPI leads to messages like when suspending:
Powerdomain (core_pwrdm) didn't enter target state 0
and according to /sys/kernel/debug/pm_debug/count off state is not
entered. That was not connected to SPI during the discussion
of disabling SPI. See:
https://lore.kernel.org/linux-omap/20230122100852.32ae082c@aktux/

The reason is that SPI is per default in slave mode. Linux driver
will turn it to master per default. It slave mode, the powerdomain seems to
be kept active if active chip select input is sensed.

Fix that by explicitly disabling the SPI3 pins which used to be muxed by
the bootloader since they are available on an optionally fitted header
which would require dtb overlays anyways.

Fixes: a622310f7f01 ("ARM: dts: gta04: fix excess dma channel usage")
CC: stable@vger.kernel.org
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20241204174152.2360431-1-andreas@kemnade.info
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/ti/omap/omap3-gta04.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/arm/boot/dts/ti/omap/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/ti/omap/omap3-gta04.dtsi
@@ -446,6 +446,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <
 			&hsusb2_2_pins
+			&mcspi3hog_pins
 	>;
 
 	hsusb2_2_pins: hsusb2-2-pins {
@@ -459,6 +460,15 @@
 		>;
 	};
 
+	mcspi3hog_pins: mcspi3hog-pins {
+		pinctrl-single,pins = <
+			OMAP3630_CORE2_IOPAD(0x25dc, PIN_OUTPUT_PULLDOWN | MUX_MODE4)	/* etk_d0 */
+			OMAP3630_CORE2_IOPAD(0x25de, PIN_OUTPUT_PULLDOWN | MUX_MODE4)	/* etk_d1 */
+			OMAP3630_CORE2_IOPAD(0x25e0, PIN_OUTPUT_PULLDOWN | MUX_MODE4)	/* etk_d2 */
+			OMAP3630_CORE2_IOPAD(0x25e2, PIN_OUTPUT_PULLDOWN | MUX_MODE4)	/* etk_d3 */
+		>;
+	};
+
 	spi_gpio_pins: spi-gpio-pinmux-pins {
 		pinctrl-single,pins = <
 			OMAP3630_CORE2_IOPAD(0x25d8, PIN_OUTPUT | MUX_MODE4) /* clk */


