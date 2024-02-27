Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DFF13B2B8;
	Tue, 27 Feb 2024 13:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041209; cv=none; b=JlX4LQieDMRMvT0XuirtBogTadeBWMK7Xe78ffgSDPY/x1gbV5dEZ7o+udJAOQMkd6lMvlP4hR3zDLfnG3jQmqnFyg6k6HHacz8/fRSAPdRFu+A7gYkLJUDE2wAW2Daw2ZZJUa1ktBA7J0GQ2KDRq3yk52JtCv8ODVkZEqYYjuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041209; c=relaxed/simple;
	bh=MAf/yw3Qdn5tKkz2mk2dHRhx+P6zgmGPFRzO5hW5dig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDhBEujSNF9znNHfnMQl9KQbYI09Wl36om2OXNH7SZpXnV/ufzaLf4KMjcMFScPeBCZIitxdTyVAb8vxKyKewWWlc0vtoaoHjq3gHGK9RT+GXpIWj5JP0gfeEbRwD+frEYKjAnCPcRKv7gY6L+uYGJXvrjO9qK7BMjcyxlE9ENk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6+PT4Md; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6+PT4Md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44F5C433C7;
	Tue, 27 Feb 2024 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041209;
	bh=MAf/yw3Qdn5tKkz2mk2dHRhx+P6zgmGPFRzO5hW5dig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6+PT4MdD5Rmw75M5NdV8dmf+svXjiW+FfYOzqveaLnTefMxblhexFGThlc625Jbv
	 ZwE5lhaecQBa2BQkslJWzIldrhwZgLqzskpd+0J5Rb46ZLU91FeansYeb/oewqoBhS
	 MAHs6ByxnyLY86QX1PYpPFFB3sgBA3p3yveYExvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	Lennart Franzen <lennart@lfdomain.com>,
	Alexandru Tachici <alexandru.tachici@analog.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	Nuno Sa <nuno.sa@analog.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 260/334] net: ethernet: adi: requires PHYLIB support
Date: Tue, 27 Feb 2024 14:21:58 +0100
Message-ID: <20240227131639.320153289@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit a9f80df4f51440303d063b55bb98720857693821 ]

This driver uses functions that are supplied by the Kconfig symbol
PHYLIB, so select it to ensure that they are built as needed.

When CONFIG_ADIN1110=y and CONFIG_PHYLIB=m, there are multiple build
(linker) errors that are resolved by this Kconfig change:

   ld: drivers/net/ethernet/adi/adin1110.o: in function `adin1110_net_open':
   drivers/net/ethernet/adi/adin1110.c:933: undefined reference to `phy_start'
   ld: drivers/net/ethernet/adi/adin1110.o: in function `adin1110_probe_netdevs':
   drivers/net/ethernet/adi/adin1110.c:1603: undefined reference to `get_phy_device'
   ld: drivers/net/ethernet/adi/adin1110.c:1609: undefined reference to `phy_connect'
   ld: drivers/net/ethernet/adi/adin1110.o: in function `adin1110_disconnect_phy':
   drivers/net/ethernet/adi/adin1110.c:1226: undefined reference to `phy_disconnect'
   ld: drivers/net/ethernet/adi/adin1110.o: in function `devm_mdiobus_alloc':
   include/linux/phy.h:455: undefined reference to `devm_mdiobus_alloc_size'
   ld: drivers/net/ethernet/adi/adin1110.o: in function `adin1110_register_mdiobus':
   drivers/net/ethernet/adi/adin1110.c:529: undefined reference to `__devm_mdiobus_register'
   ld: drivers/net/ethernet/adi/adin1110.o: in function `adin1110_net_stop':
   drivers/net/ethernet/adi/adin1110.c:958: undefined reference to `phy_stop'
   ld: drivers/net/ethernet/adi/adin1110.o: in function `adin1110_disconnect_phy':
   drivers/net/ethernet/adi/adin1110.c:1226: undefined reference to `phy_disconnect'
   ld: drivers/net/ethernet/adi/adin1110.o: in function `adin1110_adjust_link':
   drivers/net/ethernet/adi/adin1110.c:1077: undefined reference to `phy_print_status'
   ld: drivers/net/ethernet/adi/adin1110.o: in function `adin1110_ioctl':
   drivers/net/ethernet/adi/adin1110.c:790: undefined reference to `phy_do_ioctl'
   ld: drivers/net/ethernet/adi/adin1110.o:(.rodata+0xf60): undefined reference to `phy_ethtool_get_link_ksettings'
   ld: drivers/net/ethernet/adi/adin1110.o:(.rodata+0xf68): undefined reference to `phy_ethtool_set_link_ksettings'

Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202402070626.eZsfVHG5-lkp@intel.com/
Cc: Lennart Franzen <lennart@lfdomain.com>
Cc: Alexandru Tachici <alexandru.tachici@analog.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/adi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/adi/Kconfig b/drivers/net/ethernet/adi/Kconfig
index da3bdd3025022..c91b4dcef4ec2 100644
--- a/drivers/net/ethernet/adi/Kconfig
+++ b/drivers/net/ethernet/adi/Kconfig
@@ -7,6 +7,7 @@ config NET_VENDOR_ADI
 	bool "Analog Devices devices"
 	default y
 	depends on SPI
+	select PHYLIB
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
-- 
2.43.0



