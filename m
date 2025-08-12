Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25042F4A0A;
	Tue, 12 Aug 2025 18:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023593; cv=none; b=kfi4ieVEJn10XEIuPih8VBtFRx9tJfXgPbwYTw9mPBOmeYgfiHcJjZsT4LijfNDaGiozXlYXWpsSED4/Vx6sdsX9U3jrHYPsLMZLUGx8ReQGgxsnvubnaOFJErgUavuUZZF+H8e1gNO37aqa+OaGtfnRWr6+CqyeOggHLsfeZ8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023593; c=relaxed/simple;
	bh=xHRRSuFE76k+dUciJ49s3WmV1nD0r/xHIulQiIKoF+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YC0F/fXiVSuQ+n4dK3Y6XGw7AO9U2JuIxIW7SMWbELH9aRW53CJ4lxAu70iQOa2g4anxaONT5QmEzZa1QagqRGMtK17rsYvqrWrIGR5Rnxr+OPE5Q4RCmQYD0midENXtk7VERjqXBq4eOtgPDmEC3yGqv6KtjY3tIcbMqKgkOsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtGlpZ5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtGlpZ5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F74CC4CEF0;
	Tue, 12 Aug 2025 18:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023593;
	bh=xHRRSuFE76k+dUciJ49s3WmV1nD0r/xHIulQiIKoF+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtGlpZ5svVlG7xFgeVNfgiUUAlFj0XJYCMmObt2O9HE4ZFZBQwjGIcS2eKbS5iwlS
	 vFc76uZ4L+oV5pBzUjzBcZqAgJXY78jTiE5uMP4clvE5NH37oj0CQrJD3AZK/iyeFC
	 ejPKv5pV3kryjp7gc2J55q8ZaKy14UFfpcrqiWV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 098/627] arm64: dts: rockchip: fix PHY handling for ROCK 4D
Date: Tue, 12 Aug 2025 19:26:33 +0200
Message-ID: <20250812173423.044154924@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit cd803da7c033e376a66793a43ee98e136bc6cc25 ]

Old revisions of the ROCK 4D board have a dedicated crystal to
supply the RTL8211F PHY's 25MHz clock input. At least some newer
revisions instead use REFCLKO25M_GMAC0_OUT. The DT already has
this half-prepared, but there are some issues:

1. The DT relies on auto-selecting the right PHY driver, which
   requires that it works good enough to read the ID registers.
   This does not work without the clock, which is handled by
   the PHY driver. By updating the compatible to contain the
   RTL8211F IDs, so that the operating system can choose the
   right PHY driver without relying on a pre-powered PHY.

2. Despite the name REFCLKO25M_GMAC0_OUT could also provide a
   different frequency, so ensure it is explicitly set to 25
   MHz as expected by the PHY.

3. While at it switch from deprecated "enable-gpio" to standard
   "enable-gpios".

Fixes: a0fb7eca9c09 ("arm64: dts: rockchip: Add Radxa ROCK 4D device tree")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20250704-rk3576-rock4d-phy-handling-fixes-v1-1-1d64130c4139@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3576-rock-4d.dts | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576-rock-4d.dts b/arch/arm64/boot/dts/rockchip/rk3576-rock-4d.dts
index 6756403111e7..0a93853cdf43 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576-rock-4d.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3576-rock-4d.dts
@@ -641,14 +641,16 @@ hym8563: rtc@51 {
 
 &mdio0 {
 	rgmii_phy0: ethernet-phy@1 {
-		compatible = "ethernet-phy-ieee802.3-c22";
+		compatible = "ethernet-phy-id001c.c916";
 		reg = <0x1>;
 		clocks = <&cru REFCLKO25M_GMAC0_OUT>;
+		assigned-clocks = <&cru REFCLKO25M_GMAC0_OUT>;
+		assigned-clock-rates = <25000000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&rtl8211f_rst>;
 		reset-assert-us = <20000>;
 		reset-deassert-us = <100000>;
-		reset-gpio = <&gpio2 RK_PB5 GPIO_ACTIVE_LOW>;
+		reset-gpios = <&gpio2 RK_PB5 GPIO_ACTIVE_LOW>;
 	};
 };
 
-- 
2.39.5



