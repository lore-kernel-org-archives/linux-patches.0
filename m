Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C32193404;
	Wed,  5 Feb 2025 14:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767390; cv=none; b=ZdYflSJfYttNMjMfSICtkjD/e2hA0FynHOO1GVOjd4lJpqew3rXAmSR3KtyHTg3AEBKkl001UK78lB077YZLfmlpM9n/xxLWFfVqJbGwH0IsZzfQlhGB+gk6IcCzw6ydkJOIoQRcy+ZepHZLGqWdF9hpDoLgsJVkBEapay9ACSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767390; c=relaxed/simple;
	bh=/LN8fH9cWnCUxr98pIxwFV0tgG5x/G39lIrEjpLTzJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ju/BqpBzgEM0HR1B7sRkGnNSAQ33ymFTcHSH+hgQFo9MD1s7fIpUloSe572tEqxBA7DwDYvzSNgUIq6JAFtPOqFoLkT011cfI1yhcJMydwUdOlgwT6S1WrqkoWFCMJZhTlffExCJKGBm2LszHBpkj/Mv1YN5fXwdAbSu121lK+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I38lLQVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I38lLQVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF626C4CED1;
	Wed,  5 Feb 2025 14:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767390;
	bh=/LN8fH9cWnCUxr98pIxwFV0tgG5x/G39lIrEjpLTzJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I38lLQVxXGOZt7vjUQI40mA5dgzFKUKsxSMXvsKuz4rVVo7WajBuauj6TYk0/c4Sn
	 2E80xJ99DiKPG6DesYK95Nd4S2CrUIF1SgnY0PBp+vOFdF0U9p1EaNUejc4wIxv8QQ
	 oy7t7B99Mx344Z47AUUV+cPyZoQy51kSrWXai54Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 398/623] arm64: dts: rockchip: Fix sdmmc access on rk3308-rock-s0 v1.1 boards
Date: Wed,  5 Feb 2025 14:42:20 +0100
Message-ID: <20250205134511.448087430@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 26c100232b09ced0857306ac9831a4fa9c9aa231 ]

BootROM leave GPIO4_D6 configured as SDMMC_PWREN function and DW MCI
driver set PRWEN high on MMC_POWER_UP and low on MMC_POWER_OFF.
Similarly U-Boot also set PRWEN high before accessing mmc.

However, HW revision prior to v1.2 must pull GPIO4_D6 low to access
sdmmc. For HW revision v1.2 the state of GPIO4_D6 has no impact.

Model an always-on active low fixed regulator using GPIO4_D6 to fix
use of sdmmc on older HW revisions of the board.

Fixes: adeb5d2a4ba4 ("arm64: dts: rockchip: Add Radxa ROCK S0")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20241119230838.4137130-1-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3308-rock-s0.dts      | 25 ++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-rock-s0.dts b/arch/arm64/boot/dts/rockchip/rk3308-rock-s0.dts
index bd6419a5c20a2..8311af4c8689f 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-rock-s0.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-rock-s0.dts
@@ -74,6 +74,23 @@
 		vin-supply = <&vcc5v0_sys>;
 	};
 
+	/*
+	 * HW revision prior to v1.2 must pull GPIO4_D6 low to access sdmmc.
+	 * This is modeled as an always-on active low fixed regulator.
+	 */
+	vcc_sd: regulator-3v3-vcc-sd {
+		compatible = "regulator-fixed";
+		gpios = <&gpio4 RK_PD6 GPIO_ACTIVE_LOW>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&sdmmc_2030>;
+		regulator-name = "vcc_sd";
+		regulator-always-on;
+		regulator-boot-on;
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		vin-supply = <&vcc_io>;
+	};
+
 	vcc5v0_sys: regulator-5v0-vcc-sys {
 		compatible = "regulator-fixed";
 		regulator-name = "vcc5v0_sys";
@@ -181,6 +198,12 @@
 		};
 	};
 
+	sdmmc {
+		sdmmc_2030: sdmmc-2030 {
+			rockchip,pins = <4 RK_PD6 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
+
 	wifi {
 		wifi_reg_on: wifi-reg-on {
 			rockchip,pins = <0 RK_PA2 RK_FUNC_GPIO &pcfg_pull_none>;
@@ -233,7 +256,7 @@
 	cap-mmc-highspeed;
 	cap-sd-highspeed;
 	disable-wp;
-	vmmc-supply = <&vcc_io>;
+	vmmc-supply = <&vcc_sd>;
 	status = "okay";
 };
 
-- 
2.39.5



