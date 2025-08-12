Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7D826FA77;
	Tue, 12 Aug 2025 19:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025557; cv=none; b=VshvInB8bJILHmqGEKDy9wwHVmxdkIUpLs1pb3O9n1BNG9RPL6lkyEeQUcOMKbk8M4xi/b2iLNSLzbVbxCqzYufHan4wcxCmZdg+UGMeo5TqkUi4c9jI8oMwJgped+kC9xd/yAgW4DShtKhbK86Weh5n60B7NWuXdGBtjgvYppc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025557; c=relaxed/simple;
	bh=VDcJZu0xQTmww32wOaTYWDM2I5S1ZohMSHtHRkSrXAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdmHtu+syDRAfjs+iWuX+QZD5SSoIWLrgMPXsWfnkl+0mfEQr5VJaoM+sucr5JLwR6u2oqsJpBYx8QpsB7abLaWtnLRKmj4dNdds4iVzeitLsTDs9GzUvOiHnEqb5AgFTE6dkFjsQMkyCTh+N4asKBa4nqgrhfPYUytI4fPWPAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWlDb5MS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWlDb5MS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19765C4CEF0;
	Tue, 12 Aug 2025 19:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025557;
	bh=VDcJZu0xQTmww32wOaTYWDM2I5S1ZohMSHtHRkSrXAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWlDb5MSzPQBYtHqPe7OAb5TBwaD1lDF1otCxVNLU6P8L6WBFUZV82A9gH0dAq4J8
	 WDjC5GZnItgs+Mbc68tklQdtvmlNMAp59WZzt2DhSl9bbxT/tCg8WCUfG8fTsorei/
	 WhC5aw25t73hgM7qZNH+WPnS8bPNlA0ryapzTZ1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 075/480] arm64: dts: rockchip: fix PHY handling for ROCK 4D
Date: Tue, 12 Aug 2025 19:44:43 +0200
Message-ID: <20250812174400.534990856@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



