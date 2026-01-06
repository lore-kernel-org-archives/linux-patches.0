Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B892F35F8BD;
	Tue,  6 Jan 2026 17:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721688; cv=none; b=GrnX9aJdNCanTd9PJuXzBtXl7VwzOSlAyY3txGgupivLjpWv/VccU0ruOyfYEDdx382Ii96wQRmU6cQegYab9DK1PVWp8lJqg6KOex74IaAuag0wOnzp1zWm3rnPD+1YL091Fgt11tjXdlRs8BsiMm2CNaVtfuPKDNZ0bWPkxRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721688; c=relaxed/simple;
	bh=SsjFMIs0Q/wInrEdmOAxeG5YoFQHv7Ccr2o6MUttAZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=En8Ubg11PETz5GiBHZ9RKsMWuRPwFVDe529TRDNYw829x2oah3bC4p7vX54j0yGXdZbI0anhlp8uttkxJWK2ohgWaBLBGR4bnVr+2KtH+GEwnv48VZO/7jBNkkkR6svwXyarZH/VjQHxJGIs4NP/AB5zENbm7lXVDll4CCifeEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTm9Y2jR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTm9Y2jR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262FBC116C6;
	Tue,  6 Jan 2026 17:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721688;
	bh=SsjFMIs0Q/wInrEdmOAxeG5YoFQHv7Ccr2o6MUttAZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTm9Y2jREidiM+C0S5EIAOwaNUFu39L16ms7leQ83ehqoIe2XhIuedrlQ7foetGf4
	 ogdKbEk5M8JLLtl9jt9zUkHv2RMVmzBxKm58gpsPm1zT9JiMwDyBzyxB4kyBtNKalD
	 xomYq9pM1OV6HPV/C4a3wWaAD4iSWWyBV/2uXLkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 042/312] net: wangxun: move PHYLINK dependency
Date: Tue,  6 Jan 2026 18:01:56 +0100
Message-ID: <20260106170549.378476221@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b94f11af9d9201426f4d6c8a753493fd58d6ac16 ]

The LIBWX library code is what calls into phylink, so any user of
it has to select CONFIG_PHYLINK at the moment, with NGBEVF missing this:

x86_64-linux-ld: drivers/net/ethernet/wangxun/libwx/wx_ethtool.o: in function `wx_nway_reset':
wx_ethtool.c:(.text+0x613): undefined reference to `phylink_ethtool_nway_reset'
x86_64-linux-ld: drivers/net/ethernet/wangxun/libwx/wx_ethtool.o: in function `wx_get_link_ksettings':
wx_ethtool.c:(.text+0x62b): undefined reference to `phylink_ethtool_ksettings_get'
x86_64-linux-ld: drivers/net/ethernet/wangxun/libwx/wx_ethtool.o: in function `wx_set_link_ksettings':
wx_ethtool.c:(.text+0x643): undefined reference to `phylink_ethtool_ksettings_set'
x86_64-linux-ld: drivers/net/ethernet/wangxun/libwx/wx_ethtool.o: in function `wx_get_pauseparam':
wx_ethtool.c:(.text+0x65b): undefined reference to `phylink_ethtool_get_pauseparam'
x86_64-linux-ld: drivers/net/ethernet/wangxun/libwx/wx_ethtool.o: in function `wx_set_pauseparam':
wx_ethtool.c:(.text+0x677): undefined reference to `phylink_ethtool_set_pauseparam'

Add the 'select PHYLINK' line in the libwx option directly so this will
always be enabled for all current and future wangxun drivers, and remove
the now duplicate lines.

Fixes: a0008a3658a3 ("net: wangxun: add ngbevf build")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20251216213547.115026-1-arnd@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index d138dea7d208..ec278f99d295 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -21,6 +21,7 @@ config LIBWX
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select PAGE_POOL
 	select DIMLIB
+	select PHYLINK
 	help
 	Common library for Wangxun(R) Ethernet drivers.
 
@@ -29,7 +30,6 @@ config NGBE
 	depends on PCI
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select LIBWX
-	select PHYLINK
 	help
 	  This driver supports Wangxun(R) GbE PCI Express family of
 	  adapters.
@@ -48,7 +48,6 @@ config TXGBE
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select MARVELL_10G_PHY
 	select REGMAP
-	select PHYLINK
 	select HWMON if TXGBE=y
 	select SFP
 	select GPIOLIB
@@ -71,7 +70,6 @@ config TXGBEVF
 	depends on PCI_MSI
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select LIBWX
-	select PHYLINK
 	help
 	  This driver supports virtual functions for SP1000A, WX1820AL,
 	  WX5XXX, WX5XXXAL.
-- 
2.51.0



