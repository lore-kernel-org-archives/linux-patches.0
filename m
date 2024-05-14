Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68DCF9D4;
	Tue, 14 May 2024 11:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687933; cv=none; b=qNVSMJqbgJL4tjUrZmAn4/eifspz6N2DxgDd87zewIy4XVGX/tR2NZaN7fm/c1fTK/GrhOavOVbD5dsEvpOqWpGiMeSCsbMSDoqpbMHBRP38C+0ESQIrz2CpPZ98ZM4Y/WduTsxdpHV9vfplwWp+o8ePzoJDhUM2TPxVdtxXkKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687933; c=relaxed/simple;
	bh=j3T/pnDzDNXKdv6SpYDtO2SbYRlo8T5ebPsPPzlTeB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mba1NgsSqRPOtGZ9xk8MQ3fPbjd8VyXZEadO1somFXo7V7IgwkVFmqMl3oy8pQHOAQgaXBaDKNa0/aGwDW1dMZ6w2lEtZ0laUHiMycnbI3mw2WQYB4sYy0kzQSRetgLa/tD1D3cSQy1TszPB2MfUcavxpI7k19xjHrnPETUu9BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0l6dA9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0l6dA9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38002C2BD10;
	Tue, 14 May 2024 11:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687933;
	bh=j3T/pnDzDNXKdv6SpYDtO2SbYRlo8T5ebPsPPzlTeB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0l6dA9/lFGnsxmuDCctvBIvoDx7PGrG5WN75XcQVLMR/rPHan63iOVOAdBxDmb0q
	 +sUxb0swr7nis1oAtbjON8KqVtDl81uUWzajVBTZ66YS1JrOtaO/SAMRVdHTqmKfDn
	 Oe/HztGZ2bchSNJPBwXcJTiFTjSPANwc7b8HFe9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 156/168] net: bcmgenet: synchronize use of bcmgenet_set_rx_mode()
Date: Tue, 14 May 2024 12:20:54 +0200
Message-ID: <20240514101012.649232544@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Berger <opendmb@gmail.com>

commit 2dbe5f19368caae63b1f59f5bc2af78c7d522b3a upstream.

The ndo_set_rx_mode function is synchronized with the
netif_addr_lock spinlock and BHs disabled. Since this
function is also invoked directly from the driver the
same synchronization should be applied.

Fixes: 72f96347628e ("net: bcmgenet: set Rx mode before starting netif")
Cc: stable@vger.kernel.org
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2,7 +2,7 @@
 /*
  * Broadcom GENET (Gigabit Ethernet) controller driver
  *
- * Copyright (c) 2014-2020 Broadcom
+ * Copyright (c) 2014-2024 Broadcom
  */
 
 #define pr_fmt(fmt)				"bcmgenet: " fmt
@@ -3310,7 +3310,9 @@ static void bcmgenet_netif_start(struct
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
 	/* Start the network engine */
+	netif_addr_lock_bh(dev);
 	bcmgenet_set_rx_mode(dev);
+	netif_addr_unlock_bh(dev);
 	bcmgenet_enable_rx_napi(priv);
 
 	umac_enable_set(priv, CMD_TX_EN | CMD_RX_EN, true);


