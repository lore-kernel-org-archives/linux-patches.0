Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB28424728E;
	Mon, 23 Jun 2025 13:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685820; cv=none; b=F9zPHkagPm2/lheE6RW3jhx0O11pOzvoi75KVqY9p1nqn/sT3QtLrmxCU96UE8RqEXQ+YnPg0nabIgwFrBE5TdqwTYbNbcJJ5WTU4hDxEkupok1AZybruAXCd82SscsW2oC9Y7Z2sfv2GY/Cjm96vvSon0yLgpN/DprWVnL0XJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685820; c=relaxed/simple;
	bh=bpO4WG9njeH75gx6K5SiMJAq3tC955uFKu8H+EJT3xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oltqeEHfdNVCgdBRoTzh45kpwUI6KJc5jQ/2DEi7cL3sQwdVFW4t/Ub/WbKonNURoC2LeZ6L9l62wqJqcV9Lw9uO2Psmd6ebNZ8OkeLVa31aFzkbMxSq4YurrXn6qB+GOryW5C7fNAKpZ91MIhhEdkl0nSP6ZjDab0QkzvhJ1PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlqCzRLK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlqCzRLK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E23C4CEEA;
	Mon, 23 Jun 2025 13:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685820;
	bh=bpO4WG9njeH75gx6K5SiMJAq3tC955uFKu8H+EJT3xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlqCzRLK0Yla7CwcnZAIuW1E5djhfixz9JjxG9+zNmFKFJ5IJl6jgtXov6A1Ybl9b
	 gGUct2gL+mGlpxyyhCpe0lpOlMEwEN9fQX9W6R6VjspdGc38SmIHg4o/oVv9EQKbIp
	 GMMK0RSqcqCzK5gjxwoSAq9lj3Ljx0sNJhZ4+u78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Lukasz Czechowski <lukasz.czechowski@thaumatec.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/411] arm64: dts: rockchip: disable unrouted USB controllers and PHY on RK3399 Puma with Haikou
Date: Mon, 23 Jun 2025 15:03:49 +0200
Message-ID: <20250623130635.557598367@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f07f4b8231f91..f9f9ff5628ac6 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma-haikou.dts
@@ -251,14 +251,6 @@
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



