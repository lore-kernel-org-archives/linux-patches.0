Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE371E230D;
	Wed,  6 Nov 2024 12:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897821; cv=none; b=DBR3romTsFBRGRA4908y+by5z17F/+YsIMMJ3L13kOjVgK19RZj7MeK+q6fMRmIMAz3L6jp/RYFtwTRJLcn4LW7/If66shWiyrNC4uhI/grOErfjG85Us5R4rP9qvTPgOB0Hy1724hABe5SJJ1GuRtD7oFH3ujuoR2lpsCdaKy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897821; c=relaxed/simple;
	bh=HO3R2qsWVYAIC3Tbv+wfocibkmyvbLyL+4A6lV6LlZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZgPfF7SBKWtswfDtBDmLUJBBuRwDqZFZRW2q4kcTNKg/O3NaF3/mgamdtwpW405Dq3E0XtprDLQ8vipTItWap+GBekx90LZXje3vWuAwbSzV7x9t8pG7quQAgUYjpQluTC2oI8NT2Eob65gKfVk7l8bOZPJYAKeHTZ39y1HoxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5m0qHh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5m0qHh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DBDC4CECD;
	Wed,  6 Nov 2024 12:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897820;
	bh=HO3R2qsWVYAIC3Tbv+wfocibkmyvbLyL+4A6lV6LlZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5m0qHh9/YNnnvfYHnxKz332P1nuzTwmHgXcFYPrWcGgZVwypkBcbm7KobeAenE9Y
	 Srra0clm4dyACHJAhKVRd0EhRZ5q1FTBMNgGy+/O52VHnvCW4BsBZHdzYE59+EvHmS
	 kFrt98rGLDYCH9/t7FTCz22YLfwQxB8yM9Wv6qQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.4 005/462] arm64: dts: rockchip: override BIOS_DISABLE signal via GPIO hog on RK3399 Puma
Date: Wed,  6 Nov 2024 12:58:18 +0100
Message-ID: <20241106120331.638023738@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -148,6 +148,22 @@
 	drive-impedance-ohm = <33>;
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
@@ -432,9 +448,14 @@
 
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


