Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AF3250C1F;
	Wed,  5 Mar 2025 18:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198224; cv=none; b=gkSIkl8iEL+12YJcGhQJS6dtN0+0sxuei/MOJGemspd/yIwUc4rMU5zPk5FqK+Vr72D4ZnbYhF+BDRWQqr/Xbe5f8wgJxkRWAgQDkc9V0pLlbap8gmynwme3phUdh4egrth0PZWz8+uJL8CyAmA/4WiSaGiEDe6RWFwDEo3Cegc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198224; c=relaxed/simple;
	bh=k0VL6eLNEMrgIqJ3Aaozt79B/qVywCnKgBWT7yl2hYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpTLiAwQOzzogrh0c56g+3OsUMjwMBL65ZBAhvqJtvpoKDI+byPa4jp1KsnKHNA9Iw0MGGb6KuPvHg6cHsA60BccOsblPktbyjQTZHRerzpylTIPj9rRHXr3fHm8rZIdrrGHQjOWQehUwNFLvFLd2fNiSq4RzFURWNRCbcrzTpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EyOY8pIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyOY8pIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EA3C4CEE0;
	Wed,  5 Mar 2025 18:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198224;
	bh=k0VL6eLNEMrgIqJ3Aaozt79B/qVywCnKgBWT7yl2hYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyOY8pIslhNpQZWAjUTNg1gdSN9l1+EAvdYF9gYhqHRUg8O2IWOiYgoMHd3YQALpr
	 0vMiZjfc5s8Ur1fny5+kYCpRWcgyKBTgw1Bb6fmqdIb5JBN5XCV9abTVBqWk6941MA
	 YHByGt74fGfCT0D0Bdou4QDwL0c3+s5UemY3Nd8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/150] phy: rockchip: fix Kconfig dependency more
Date: Wed,  5 Mar 2025 18:48:28 +0100
Message-ID: <20250305174506.988497461@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit fcf5d353b09b3fc212ab24b89ef23a7a8f7b308e ]

A previous patch ensured that USB Type C connector support is enabled,
but it is still possible to build the phy driver without enabling
CONFIG_USB (host support) or CONFIG_USB_GADGET (device support), and
in that case the common helper functions are unavailable:

aarch64-linux-ld: drivers/phy/rockchip/phy-rockchip-usbdp.o: in function `rk_udphy_probe':
phy-rockchip-usbdp.c:(.text+0xe74): undefined reference to `usb_get_maximum_speed'

Select CONFIG_USB_COMMON directly here, like we do in some other phy
drivers, to make sure this is available even when actual USB support
is disabled or in a loadable module that cannot be reached from a
built-in phy driver.

Fixes: 9c79b779643e ("phy: rockchip: fix CONFIG_TYPEC dependency")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250122065249.1390081-1-arnd@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/rockchip/Kconfig b/drivers/phy/rockchip/Kconfig
index 2f7a05f21dc59..dcb8e1628632e 100644
--- a/drivers/phy/rockchip/Kconfig
+++ b/drivers/phy/rockchip/Kconfig
@@ -125,6 +125,7 @@ config PHY_ROCKCHIP_USBDP
 	depends on ARCH_ROCKCHIP && OF
 	depends on TYPEC
 	select GENERIC_PHY
+	select USB_COMMON
 	help
 	  Enable this to support the Rockchip USB3.0/DP combo PHY with
 	  Samsung IP block. This is required for USB3 support on RK3588.
-- 
2.39.5



