Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB66301EE6;
	Sat, 28 Feb 2026 17:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301409; cv=none; b=dTuS78dGbhk0qYk/faoQ2AHgChT9JSLSs0OAKfQmzcsQCZl9euYl9RgleQ7hnGEdfDA+6NHlLz0kf6Hwdp+E/SlPA4RJXV+4mdY2jRMRcrBIe2sk+1NP677HjGfn/Oi2Q0Pl6t1fzEiVlDitMWRJlPxK0SeIlmY81Y0dAYd73sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301409; c=relaxed/simple;
	bh=ztlT3saRJbDT5bqLP6NFt7aq6pAsT7FeK9qce3Gfwuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlOvoiUFVjEPrVwOlD09cPYwnHn7iXilxQJNz8cQBm8Sc/7/SWT1ff1F14BTABye8yj2rqdbnjEoCMzucOCl2wcob2sZucPE8Z1gkzN0d7cuSCfMbnYiZnT3Rq+rGqBp3U4EcSpp7etG/Eh+V/Ota6/4JerS59iPEyKXboJzLro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QR81EpcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QR81EpcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740F2C19423;
	Sat, 28 Feb 2026 17:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301409;
	bh=ztlT3saRJbDT5bqLP6NFt7aq6pAsT7FeK9qce3Gfwuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QR81EpcNHQhCgLgPIM/3YCXqAYQwpAEPwDjy6MH/H8zIyV04Rrjo4kcvXgv2cD/Nt
	 yQz4PQlPVcujqENrdTuLtSurl+Qvv17go5sSw/chwd0x4Al0eR31GvbfdnFjAWHDrc
	 +hTsb/VwHjjgbxVwFDebFCK0P3pf7F0RdwI5SrujsEqj26RJteRsF8N5utQL1A5DQk
	 aZ06eX2mOXR7a1uCcyXI4LlnKx7/bVH/BOmxK6puI5N91HVK8HBjek/fMwoJmHZy0s
	 F097CGz/8KrWXXxVlu83q/YM9SV2DKZdkLaoNwr3J7A2CTv8sImPSD+JBg0CIe8VWd
	 BDKnBRodMj3mw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexey Charkov <alchark@gmail.com>,
	stable@vger.kernel.org,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 598/752] arm64: dts: rockchip: Explicitly request UFS reset pin on RK3576
Date: Sat, 28 Feb 2026 12:45:09 -0500
Message-ID: <20260228174750.1542406-598-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alexey Charkov <alchark@gmail.com>

[ Upstream commit 79a3286e61829fc43abdd6e3beb31b24930c7af6 ]

Rockchip RK3576 UFS controller uses a dedicated pin to reset the connected
UFS device, which can operate either in a hardware controlled mode or as a
GPIO pin.

Power-on default is GPIO mode, but the boot ROM reconfigures it to a
hardware controlled mode if it uses UFS to load the next boot stage.

Given that existing bindings (and rk3576.dtsi) expect a GPIO-controlled
device reset, request the required pin config explicitly.

The pin is requested with pull-down enabled, which is in line with the
SoC power-on default and helps ensure that the attached UFS chip stays
in reset until the driver takes over the control of the respective
GPIO line.

This doesn't appear to affect Linux, but it does affect U-boot:

Before:
=> md.l 0x2604b398
2604b398: 00000011 00000000 00000000 00000000  ................
< ... snip ... >
=> ufs init
ufshcd-rockchip ufshc@2a2d0000: [RX, TX]: gear=[3, 3], lane[2, 2], pwr[FASTAUTO_MODE, FASTAUTO_MODE], rate = 2
=> md.l 0x2604b398
2604b398: 00000011 00000000 00000000 00000000  ................

After:
=> md.l 0x2604b398
2604b398: 00000011 00000000 00000000 00000000  ................
< ... snip ...>
=> ufs init
ufshcd-rockchip ufshc@2a2d0000: [RX, TX]: gear=[3, 3], lane[2, 2], pwr[FASTAUTO_MODE, FASTAUTO_MODE], rate = 2
=> md.l 0x2604b398
2604b398: 00000010 00000000 00000000 00000000  ................

(0x2604b398 is the respective pin mux register, with its BIT0 driving the
mode of UFS_RST: unset = GPIO, set = hardware controlled UFS_RST)

This helps ensure that GPIO-driven device reset actually fires when the
system requests it, not when whatever black box magic inside the UFSHC
decides to reset the flash chip.

Cc: stable@vger.kernel.org
Fixes: c75e5e010fef ("scsi: arm64: dts: rockchip: Add UFS support for RK3576 SoC")
Reported-by: Quentin Schulz <quentin.schulz@cherry.de>
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Alexey Charkov <alchark@gmail.com>
Link: https://patch.msgid.link/20260121-ufs-rst-v3-1-35839bcb4ca7@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3576-pinctrl.dtsi | 7 +++++++
 arch/arm64/boot/dts/rockchip/rk3576.dtsi         | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576-pinctrl.dtsi b/arch/arm64/boot/dts/rockchip/rk3576-pinctrl.dtsi
index 0b0851a7e4ea9..98c9f8013158c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576-pinctrl.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3576-pinctrl.dtsi
@@ -5228,6 +5228,13 @@ ufs_rst: ufs-rst {
 				/* ufs_rstn */
 				<4 RK_PD0 1 &pcfg_pull_none>;
 		};
+
+		/omit-if-no-ref/
+		ufs_rstgpio: ufs-rstgpio {
+			rockchip,pins =
+				/* ufs_rstn */
+				<4 RK_PD0 RK_FUNC_GPIO &pcfg_pull_down>;
+		};
 	};
 
 	ufs_testdata0 {
diff --git a/arch/arm64/boot/dts/rockchip/rk3576.dtsi b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
index c72343e7a0456..70e67d4dccb8a 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
@@ -1826,7 +1826,7 @@ ufshc: ufshc@2a2d0000 {
 			assigned-clock-parents = <&cru CLK_REF_MPHY_26M>;
 			interrupts = <GIC_SPI 361 IRQ_TYPE_LEVEL_HIGH>;
 			power-domains = <&power RK3576_PD_USB>;
-			pinctrl-0 = <&ufs_refclk>;
+			pinctrl-0 = <&ufs_refclk &ufs_rstgpio>;
 			pinctrl-names = "default";
 			resets = <&cru SRST_A_UFS_BIU>, <&cru SRST_A_UFS_SYS>,
 				 <&cru SRST_A_UFS>, <&cru SRST_P_UFS_GRF>;
-- 
2.51.0

