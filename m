Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83ED155C8A;
	Mon, 16 Sep 2024 12:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488250; cv=none; b=ETVybEPz41TM5LDOj4raMP+ooglWHGGOg1yPrIgAa5G6q0WvRr6w1ZP5F7KYzd1s4YsOd9evzTfMwN2FBIYKoGTDyRSfW1kMHs8uCkufBywUtREdDzGxoQoRKCzznBdGJkQ9EN2739b2sFOoKtGY+leY2yaMsL80t5hpMUueVlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488250; c=relaxed/simple;
	bh=z5rBVNoRkIGgLZ8hJx//wHBkD8Szl5Y0VlAFAsHIEYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fa6dpIBMXyQc6L0nPyejCtpuac+Yf12b4CevEMS4XFFGyM6XAzblx8uUpJTFewLecNb1Ff8Pex67Re+y+M32aGxFsJPitI0BcEdv0lkoY67i1Qh7btHVd4CcJ8+x+08glbC2XiuWUcYCLhAPQskgp3W2QkTOIKc7V/9q6j1x/+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RstYhIc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RstYhIc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535ACC4CEC4;
	Mon, 16 Sep 2024 12:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488250;
	bh=z5rBVNoRkIGgLZ8hJx//wHBkD8Szl5Y0VlAFAsHIEYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RstYhIc4LMk60ErwV68/BzTKBl5KLCfstzr5zs2u9pxn0gAr81nNiyREBis0Ydy/g
	 If86Lb6y7TKOZW4+oAM9PlBkHQ/6z8nIXX2F4OgeRQBJVIXt2wfosXlKaQtU+c4CSg
	 9CSFFHLwZWWA+CTa7p81TxPjRVGnLKWRhqFfFbYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.10 048/121] arm64: dts: rockchip: override BIOS_DISABLE signal via GPIO hog on RK3399 Puma
Date: Mon, 16 Sep 2024 13:43:42 +0200
Message-ID: <20240916114230.711538375@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@cherry.de>

commit 741f5ba7ccba5d7ae796dd11c320e28045524771 upstream.

The Qseven BIOS_DISABLE signal on the RK3399-Q7 keeps the on-module eMMC
and SPI flash powered-down initially (in fact it keeps the reset signal
asserted). BIOS_DISABLE_OVERRIDE pin allows to override that signal so
that eMMC and SPI can be used regardless of the state of the signal.

Let's make this GPIO a hog so that it's reserved and locked in the
proper state.

At the same time, make sure the pin is reserved for the hog and cannot
be requested by another node.

Cc: stable@vger.kernel.org
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://lore.kernel.org/r/20240731-puma-emmc-6-v1-2-4e28eadf32d0@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -154,6 +154,22 @@
 	};
 };
 
+&gpio3 {
+	/*
+	 * The Qseven BIOS_DISABLE signal on the RK3399-Q7 keeps the on-module
+	 * eMMC and SPI flash powered-down initially (in fact it keeps the
+	 * reset signal asserted). BIOS_DISABLE_OVERRIDE pin allows to override
+	 * that signal so that eMMC and SPI can be used regardless of the state
+	 * of the signal.
+	 */
+	bios-disable-override-hog {
+		gpios = <RK_PD5 GPIO_ACTIVE_LOW>;
+		gpio-hog;
+		line-name = "bios_disable_override";
+		output-high;
+	};
+};
+
 &gmac {
 	assigned-clocks = <&cru SCLK_RMII_SRC>;
 	assigned-clock-parents = <&clkin_gmac>;
@@ -458,9 +474,14 @@
 
 &pinctrl {
 	pinctrl-names = "default";
-	pinctrl-0 = <&q7_thermal_pin>;
+	pinctrl-0 = <&q7_thermal_pin &bios_disable_override_hog_pin>;
 
 	gpios {
+		bios_disable_override_hog_pin: bios-disable-override-hog-pin {
+			rockchip,pins =
+				<3 RK_PD5 RK_FUNC_GPIO &pcfg_pull_down>;
+		};
+
 		q7_thermal_pin: q7-thermal-pin {
 			rockchip,pins =
 				<0 RK_PA3 RK_FUNC_GPIO &pcfg_pull_up>;


