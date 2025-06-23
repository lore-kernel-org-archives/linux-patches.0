Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC6A2F24;
	Mon, 23 Jun 2025 13:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685688; cv=none; b=GIL0cNnJy2xzbg7Q7ch/4mx5lFARaMH2tQTkQjd5Ry6Hf1ToexyIk5V9fZ6ZLNm7NF6pjSlmy1nxvuxqIU+sa8IguwFoUHLcv6Qgm0HJ4w4WMeUfCwhL30AE9G7wdIz1tM9Jr86ovYy6tUnQauCOyBh/u3tvzfJk4CD/twirfkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685688; c=relaxed/simple;
	bh=DxhnOKOfnb1sI544a+94XInGSITEMRhhLsTsAIbdHyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pL9vk6u8MUqe5ajV04iNweBatOiOITEU34TyiCkruo3Ke0pCcnMq9gaheobik+AcYFNVFq+YzxqKIgAJx180KXkbbQN3tqsKTvfbNfs0FPZqjwLnE2lcV8cCD9dcJLaHRnIJiTwB1WSRmOuFv+8ot0VuqYTsmRZEWdX26noMFh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xaKNVtMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xaKNVtMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB83C4CEEA;
	Mon, 23 Jun 2025 13:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685687;
	bh=DxhnOKOfnb1sI544a+94XInGSITEMRhhLsTsAIbdHyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xaKNVtMXX5Qu5CkDH78lIqyrAxU7vc5o4oQF1jlHpsMWfimmzTsgS0N6LW1kXr+Oe
	 k1/U2ZhxU+vNepAXWieHjFRE65uh4bhJpBFXiBoN8/xhrcykFhqGttLKhaOIF/6okT
	 Q3D2IparTORL2LlTOKgtYDc5qo09Nyjn8mEAVZvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Lukasz Czechowski <lukasz.czechowski@thaumatec.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/355] arm64: dts: rockchip: disable unrouted USB controllers and PHY on RK3399 Puma with Haikou
Date: Mon, 23 Jun 2025 15:04:29 +0200
Message-ID: <20250623130628.876084521@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@cherry.de>

[ Upstream commit febd8c6ab52c683b447fe22fc740918c86feae43 ]

The u2phy0_host port is the part of the USB PHY0 (namely the
HOST0_DP/DM lanes) which routes directly to the USB2.0 HOST
controller[1]. The other lanes of the PHY are routed to the USB3.0 OTG
controller (dwc3), which we do use.

The HOST0_DP/DM lanes aren't routed on RK3399 Puma so let's simply
disable the USB2.0 controllers.

USB3 OTG has been known to be unstable on RK3399 Puma Haikou for a
while, one of the recurring issues being that only USB2 is detected and
not USB3 in host mode. Reading the justification above and seeing that
we are keeping u2phy0_host in the Haikou carrierboard DTS probably may
have bothered you since it should be changed to u2phy0_otg. The issue is
that if it's switched to that, USB OTG on Haikou is entirely broken. I
have checked the routing in the Gerber file, the lanes are going to the
expected ball pins (that is, NOT HOST0_DP/DM).
u2phy0_host is for sure the wrong part of the PHY to use, but it's the
only one that works at the moment for that board so keep it until we
figure out what exactly is broken.

No intended functional change.

[1] https://rockchip.fr/Rockchip%20RK3399%20TRM%20V1.3%20Part2.pdf
    Chapter 2 USB2.0 PHY

Fixes: 2c66fc34e945 ("arm64: dts: rockchip: add RK3399-Q7 (Puma) SoM")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
Link: https://lore.kernel.org/r/20250425-onboard_usb_dev-v2-5-4a76a474a010@thaumatec.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
index 3fc761c8d550a..40be64a37c47d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
@@ -246,14 +246,6 @@
 	status = "okay";
 };
 
-&usb_host0_ehci {
-	status = "okay";
-};
-
-&usb_host0_ohci {
-	status = "okay";
-};
-
 &vopb {
 	status = "okay";
 };
-- 
2.39.5



