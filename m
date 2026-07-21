Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8057346D2B3;
	Tue, 21 Jul 2026 17:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655616; cv=none; b=jGdHZeOMB8QICdeATJQsEGqZimSlvFKeGsZnf4Yz4hZoyM6AOrn7qGVXzS2a16sPNydcHjNzBYxDEhavfj/W8reLnL9Efw/Ck3+iHf9c8FYFTJUOLXgfU2sFjxiqalWwUKq0bkusCbYTClxZCkP+mbTzWWKxHySbMMq++CPdIi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655616; c=relaxed/simple;
	bh=xWmVAyOHbwDc2/A6WRvQPKZxctYVwAF24pmzQQasZ6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGIugS7o9XkTDIXThHlAbIThilCRljnT3/DpUbQEXOCHFvy1/FZIg+xqd0wlrX9PpoYwNe2ItxYOLeG8ZUaiM2SIPEffscGitt1kiyUfOqpWbf/T2o7Ub8UQcHysb02fVsdWCdfSqcrwUCX+39bd0EYmsDzuDASTeGha7kDYz10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/naqywx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/naqywx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E724D1F00A3A;
	Tue, 21 Jul 2026 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655615;
	bh=i9gf8IG966CnTA9aMerFA2Js+6BSf47u7piTrPQ5KjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/naqywx4mO5WyUaksKNlyVGrKxq5CImgMf6xtKYChx05FVQGdoA805F/bVroRUf8
	 +rj2NqPGsgmw4kMdh2SL7/0T2MCRAqwJN2nJ/LDaaJGBACplKfpqc4otnA3E3u57jl
	 X2t051SruEJtsZgZT072M1p7RGEwsonkoOevpj9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0076/1611] arm64: dts: rockchip: fix Ethernet PHY not found on PX30 Cobra
Date: Tue, 21 Jul 2026 17:03:12 +0200
Message-ID: <20260721152516.550831334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@cherry.de>

[ Upstream commit 6598ed3586a4b1cc79423666e66b9861631a6c7e ]

When not passing the PHY ID with an ethernet-phy-idX.Y compatible
property, the MDIO bus will attempt to auto-detect the PHY by reading
its registers and then probing the appropriate driver. For this to work,
the PHY needs to be in a working state.

Unfortunately, the net subsystem doesn't control the PHY reset GPIO when
attempting to auto-detect the PHY. This means the PHY needs to be in a
working state when entering the Linux kernel. This historically has been
the case for this device, but only because the bootloader was taking
care of initializing the Ethernet controller even when not using it.
We're attempting to support the removal of the network stack in the
bootloader, which means the Linux kernel will be entered with the PHY
still in reset and now Ethernet doesn't work anymore.

The devices in the field only ever had a TI DP83825, so let's simply
bypass the auto-detection mechanism entirely by passing the appropriate
PHY IDs via the compatible.

Fixes: bb510ddc9d3e ("arm64: dts: rockchip: add px30-cobra base dtsi and board variants")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://patch.msgid.link/20260421-px30-eth-phy-v2-1-68c375b120fd@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/px30-cobra.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/px30-cobra.dtsi b/arch/arm64/boot/dts/rockchip/px30-cobra.dtsi
index b7e669d8ba4d14..add917af5de783 100644
--- a/arch/arm64/boot/dts/rockchip/px30-cobra.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-cobra.dtsi
@@ -397,7 +397,7 @@ &io_domains {
 
 &mdio {
 	dp83825: ethernet-phy@0 {
-		compatible = "ethernet-phy-ieee802.3-c22";
+		compatible = "ethernet-phy-id2000.a140";
 		reg = <0x0>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&phy_rst>;
-- 
2.53.0



