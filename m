Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FE714884C;
	Wed,  5 Mar 2025 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198570; cv=none; b=PVTgzqubyFZnbsgAAnEbSrDOMNTOjTvkjcdI0t46o1T0TkiPH4drL4xZ7w/dwhwJGnCfWQB9MWLJ+SkDsiPYiN+b7pY1NgGo16jQw56qo+2DezlzXs5Azoq03WylXSh0ruh1AlEwTzQv8vOZUFOTJsl0k8uowPo4eOYFTBB1FVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198570; c=relaxed/simple;
	bh=1E5E8yKNhyKaquklQe1o5DZWIKYWqch2BhwdolLpv6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqOf8R59k057cGeXXfkdxwYuPOP9cUEywbt96NI/YB/TYamuwYv1ICraHWVzHSrk63TJ9E+q6c45EJ1Q9LWPpWznLl2o7r1NPE6Llzn6dddEyJsmaF/hnIYxowX/fHvFeKAt6eWWEE6rZ2/oY3fE0TR360FaMRzwBNW1QQE6W3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvIAzdl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvIAzdl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B897C4CED1;
	Wed,  5 Mar 2025 18:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198570;
	bh=1E5E8yKNhyKaquklQe1o5DZWIKYWqch2BhwdolLpv6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvIAzdl881hI0Rni7/KHDimtkvmanTODjbBRZrf0tpTh+5ZNgBT2Bff1kNSIZnFBV
	 +piW8/7y9v8xocp5wL+UWnHjEgMkb2OAgEse66jvQR2CFUAIBSEFZIH3n4xBSjwW4b
	 WgQ3vmP86cFF9RvD48eQ6+CSTcva2nPj+DNROsXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 074/157] phy: rockchip: fix Kconfig dependency more
Date: Wed,  5 Mar 2025 18:48:30 +0100
Message-ID: <20250305174508.278528771@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



