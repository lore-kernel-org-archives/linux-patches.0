Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00661A76C4;
	Tue, 30 Jul 2024 17:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360576; cv=none; b=Ie5zjbmCpCpJTO10umrE9Oe3gi5drkugYSAV7GyatIuCS2y87W32KHN+zAUxvLx+PYSao4e6IJ8GSx3/TAqXyzPnNnSTaFC6/chNvElEXveIWauo4qYkMS6SI3VWJN1A1Y1lov4QvzzxRKn1UPfbGmMQgDREEW8TbT/vWfirmN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360576; c=relaxed/simple;
	bh=bE8zQGDoe/3dA+wVtTCg7V6TVVbRF1aww3cX7clRTo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DfVUckDPULp0k0karbOy/FKnuWFT4RHK0j/EEC4vD68/SV+uXPNHR/1uJMryETrYixwnmHv/ch8KjtJBb1CHtnbz7xPMnGjMJVOCPUI1KwK4Q8hINujgBbZdk57OlwSvbSZqFnUFVFAeSSr85PbBRvFroH4Uf8hocOktS5T7tDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D17u6UVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D17u6UVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687EDC32782;
	Tue, 30 Jul 2024 17:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360576;
	bh=bE8zQGDoe/3dA+wVtTCg7V6TVVbRF1aww3cX7clRTo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D17u6UVswe0nExCAmaR0KjXSeVwaJwk1w4JKE4FE8f5niKxUuvhSFK9GPSox8we4q
	 lGEyS6Yf5RWARpTpwydLcAZtrJYMb/jxCTRP5sg4bJ/mvLo1CAsNuQ9xEeIXqh4OqR
	 AB6j6YJgz/daE9ByA87/nS7x6wFmODDN8hiKIMp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 742/809] phy: phy-rockchip-samsung-hdptx: Select CONFIG_MFD_SYSCON
Date: Tue, 30 Jul 2024 17:50:18 +0200
Message-ID: <20240730151754.259702317@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit edf9e04955d2387032beac54ebf20b43aaca2adf ]

Compile testing configurations without REGMAP support enabled results in
a bunch of errors being reported:

  ../drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c:569:21: error: variable ‘rk_hdptx_phy_regmap_config’ has initializer but incomplete type
    569 | static const struct regmap_config rk_hdptx_phy_regmap_config = {
        |                     ^~~~~~~~~~~~~
  ../drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c:570:10: error: ‘const struct regmap_config’ has no member named ‘reg_bits’
    570 |         .reg_bits = 32,
        |          ^~~~~~~~

Note that selecting REGMAP alone is not enough, because of the following
liker error:

  phy-rockchip-samsung-hdptx.c:(.text+0x10c): undefined reference to `__devm_regmap_init_mmio_clk'

Instead of the obvious fix to enable REGMAP_MMIO, select MFD_SYSCON,
which implicitly enables REGMAP_MMIO as well.  The rationale is that the
driver has been already relying on the syscon functionality.

Moreover, without MFD_SYSCON enabled, the test coverage is reduced,
since the linker might not detect any potential undefined references
following syscon_regmap_lookup_by_phandle() invocation in
rk_hdptx_phy_probe() body.  That is because the function would
unconditionally return -ENOTSUP, hence the compiler is free to optimize
out any unreachable code.

Finally ensure PHY_ROCKCHIP_SAMSUNG_HDPTX depends on HAS_IOMEM, as
required by MFD_SYSCON.

Fixes: 553be2830c5f ("phy: rockchip: Add Samsung HDMI/eDP Combo PHY driver")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20240629-rk-hdptx-compile-test-fix-v1-1-c86675ba8070@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/rockchip/Kconfig b/drivers/phy/rockchip/Kconfig
index 08b0f43457606..490263375057b 100644
--- a/drivers/phy/rockchip/Kconfig
+++ b/drivers/phy/rockchip/Kconfig
@@ -86,7 +86,9 @@ config PHY_ROCKCHIP_PCIE
 config PHY_ROCKCHIP_SAMSUNG_HDPTX
 	tristate "Rockchip Samsung HDMI/eDP Combo PHY driver"
 	depends on (ARCH_ROCKCHIP || COMPILE_TEST) && OF
+	depends on HAS_IOMEM
 	select GENERIC_PHY
+	select MFD_SYSCON
 	select RATIONAL
 	help
 	  Enable this to support the Rockchip HDMI/eDP Combo PHY
-- 
2.43.0



