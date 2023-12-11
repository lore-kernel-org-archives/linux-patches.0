Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FC0C2D0;
	Mon, 11 Dec 2023 18:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m97dRBVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E5AC433C8;
	Mon, 11 Dec 2023 18:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319495;
	bh=n3PJZnSQJY8am6EfFg6eyl8GCu7O7rCbiXLUseXVZjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m97dRBVdsve9EQ7cCLjCdX0TvNr4fACsRl2EaIz1rS+eitX8uicNdfgPDb5QJLEAS
	 ShB1E96ZdzuLsxF9d0pRcGNfrFrkHG2qbYQdMmBEBjVXfnrhUWmFqYQch+25lB93ZM
	 YdZ4uEViy3H7rU60N6CqHF+54NqWguX4MI01TDbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Edwards <CFSworks@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 126/244] arm64: dts: rockchip: Fix eMMC Data Strobe PD on rk3588
Date: Mon, 11 Dec 2023 19:20:19 +0100
Message-ID: <20231211182051.468710881@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Sam Edwards <cfsworks@gmail.com>

[ Upstream commit 37f3d6108730713c411827ab4af764909f4dfc78 ]

JEDEC standard JESD84-B51 defines the eMMC Data Strobe line, which is
currently used only in HS400 mode, as a device->host clock signal that
"is used only in read operation. The Data Strobe is always High-Z (not
driven by the device and pulled down by RDS) or Driven Low in write
operation, except during CRC status response." RDS is a pull-down
resistor specified in the 10K-100K ohm range. Thus per the standard, the
Data Strobe is always pulled to ground (by the eMMC and/or RDS) during
write operations.

Evidently, the eMMC host controller in the RK3588 considers an active
voltage on the eMMC-DS line during a write to be an error.

The default (i.e. hardware reset, and Rockchip BSP) behavior for the
RK3588 is to activate the eMMC-DS pin's builtin pull-down. As a result,
many RK3588 board designers do not bother adding a dedicated RDS
resistor, instead relying on the RK3588's internal bias. The current
devicetree, however, disables this bias (`pcfg_pull_none`), breaking
HS400-mode writes for boards without a dedicated RDS, but with an eMMC
chip that chooses to High-Z (instead of drive-low) the eMMC-DS line.
(The Turing RK1 is one such board.)

Fix this by changing the bias in the (common) emmc_data_strobe case to
reflect the expected hardware/BSP behavior. This is unlikely to cause
regressions elsewhere: the pull-down is only relevant for High-Z eMMCs,
and if this is redundant with a (dedicated) RDS resistor, the effective
result is only a lower resistance to ground -- where the range of
tolerance is quite high. If it does, it's better fixed in the specific
devicetrees.

Fixes: d85f8a5c798d5 ("arm64: dts: rockchip: Add rk3588 pinctrl data")
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
Link: https://lore.kernel.org/r/20231205202900.4617-2-CFSworks@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-pinctrl.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-pinctrl.dtsi b/arch/arm64/boot/dts/rockchip/rk3588s-pinctrl.dtsi
index 48181671eacb0..0933652bafc30 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-pinctrl.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-pinctrl.dtsi
@@ -369,7 +369,7 @@
 		emmc_data_strobe: emmc-data-strobe {
 			rockchip,pins =
 				/* emmc_data_strobe */
-				<2 RK_PA2 1 &pcfg_pull_none>;
+				<2 RK_PA2 1 &pcfg_pull_down>;
 		};
 	};
 
-- 
2.42.0



