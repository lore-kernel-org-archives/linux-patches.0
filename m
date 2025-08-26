Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92867319858;
	Tue, 26 Aug 2025 11:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207188; cv=none; b=swk4exOQqF82wKAW8b0n3gDAxlOTM47dPBY3/uqFcfzROFoycDV2DpllPU+mHph+QuOr/d20o/+/zA9wbW5fH/Fd/xEcDW8p3w0pcyQN7RtWnRxRhPe1mzsK1GVb2al03L4nYDrOhvxlcchvcjxx8dLu3C7iraeb4G40YNSp+V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207188; c=relaxed/simple;
	bh=qizmUg1M6vB6Z1bRPMa8fO1stp0koCRbK8XBqXTbOq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/0dmFk8p1CZf7w4xvntn07g31rRnPlsunFnmsi0A1y+Vf/RlJp/RrdebV31z4bWNpiZaNyVZHHKt5PsS30Pj/zX2h8vie+cnT2v9bGHU2MPzu9smnx5t/2qxBrSsqBkh41g0dQAlBaJLn/4rwOkStb1FYSTYoMGO9gIbac28xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxGnw2v8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxGnw2v8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C94C4CEF1;
	Tue, 26 Aug 2025 11:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207188;
	bh=qizmUg1M6vB6Z1bRPMa8fO1stp0koCRbK8XBqXTbOq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxGnw2v8qBPjOG9CxzA6A3bw3DYqZXjZAg+88PT1c269JrWn1D6E/TJ2KdhfGynZw
	 gkdqPDsPPwvBRxpF/pRg3tVF+B7sjf2mew0nuZnMO2ruKzurpPp8MHLDf5YKrmCJs9
	 B2vLDZk0I8shQ7xC0NyPwUBKYIQiQXYVp4Xy4T0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.16 053/457] arm64: dts: rockchip: Add HDMI PHY PLL clock source to VOP2 on rk3576
Date: Tue, 26 Aug 2025 13:05:37 +0200
Message-ID: <20250826110938.663703449@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

commit 4ab8b8ac952fb08d03655e1da0cfee07589e428f upstream.

Since commit c871a311edf0 ("phy: rockchip: samsung-hdptx: Setup TMDS
char rate via phy_configure_opts_hdmi"), the workaround of passing the
rate from DW HDMI QP bridge driver via phy_set_bus_width() became
partially broken, as it cannot reliably handle mode switches anymore.

Attempting to fix this up at PHY level would not only introduce
additional hacks, but it would also fail to adequately resolve the
display issues that are a consequence of the system CRU limitations.

Instead, proceed with the solution already implemented for RK3588: make
use of the HDMI PHY PLL as a better suited DCLK source for VOP2. This
will not only address the aforementioned problem, but it should also
facilitate the proper operation of display modes up to 4K@60Hz.

It's worth noting that anything above 4K@30Hz still requires high TMDS
clock ratio and scrambling support, which hasn't been mainlined yet.

Fixes: d74b842cab08 ("arm64: dts: rockchip: Add vop for rk3576")
Cc: stable@vger.kernel.org
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Tested-By: Detlev Casanova <detlev.casanova@collabora.com>
Tested-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Link: https://lore.kernel.org/r/20250612-rk3576-hdmitx-fix-v1-3-4b11007d8675@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3576.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576.dtsi b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
index 9fc18384f609..1fec0ecea91d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3576.dtsi
@@ -1155,12 +1155,14 @@
 				 <&cru HCLK_VOP>,
 				 <&cru DCLK_VP0>,
 				 <&cru DCLK_VP1>,
-				 <&cru DCLK_VP2>;
+				 <&cru DCLK_VP2>,
+				 <&hdptxphy>;
 			clock-names = "aclk",
 				      "hclk",
 				      "dclk_vp0",
 				      "dclk_vp1",
-				      "dclk_vp2";
+				      "dclk_vp2",
+				      "pll_hdmiphy0";
 			iommus = <&vop_mmu>;
 			power-domains = <&power RK3576_PD_VOP>;
 			rockchip,grf = <&sys_grf>;
-- 
2.50.1



