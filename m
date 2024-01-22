Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800DA634F8;
	Tue, 23 Jan 2024 01:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975034; cv=none; b=uNWxYCHRgvvn1GOabfFGs4ayKaHg0TPWEAYUKTTds8s42bpUUoo9LjgwIPe2+LObn+nJ+0/osWjtph9shFmdxbR9+QrBVkUg6ZcKHd/XW4PMPGmYZjE13iqXgJ8eLLsf2YhXNQeEMmhq4xIj+XVyRM03/ncGhdnVT9t47/3VLSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975034; c=relaxed/simple;
	bh=JIU0XhtJjoQe0nczUdSZVeG3MVr9mlahzyA5uC0EXTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K8+fD3ZkrgLvWRAFb7VhK0N3AvHUgtZQK6nxHYqNQBPdfRAbwVqEbyg5UBPnILIXZsiGWS8nqGxLPlUrdKHkkm4cxLPStn0ggX/Dq7Y+Tzj6l252+KlIRvX2xYSkoHZbvfqHwI5gevATT3TeZsWfwt0zayu0Jik0S/WmaWH05dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyK6CLa8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyK6CLa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05C6C433F1;
	Tue, 23 Jan 2024 01:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975033;
	bh=JIU0XhtJjoQe0nczUdSZVeG3MVr9mlahzyA5uC0EXTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyK6CLa8FLdUbohhNmBjh5o/ODaeVODkbPhzOVt/weXT9Z7GmQTV6Z/rUEg2QZ/6T
	 JLx6vG4wnBfDlUUIOGnL2KL7CXUsOimcx1UXbj6jxqxZNxEYUKrxRKpLnWDHCynQqx
	 ZrOtmDp0YN1cyBnR9oqrtKUHoEFJMC1Auedvtssc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 333/374] net: ethernet: ti: am65-cpsw: Fix max mtu to fit ethernet frames
Date: Mon, 22 Jan 2024 15:59:49 -0800
Message-ID: <20240122235756.485917015@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanjuán García, Jorge <Jorge.SanjuanGarcia@duagon.com>

[ Upstream commit 64e47d8afb5ca533b27efc006405e5bcae2c4a7b ]

The value of AM65_CPSW_MAX_PACKET_SIZE represents the maximum length
of a received frame. This value is written to the register
AM65_CPSW_PORT_REG_RX_MAXLEN.

The maximum MTU configured on the network device should then leave
some room for the ethernet headers and frame check. Otherwise, if
the network interface is configured to its maximum mtu possible,
the frames will be larger than AM65_CPSW_MAX_PACKET_SIZE and will
get dropped as oversized.

The switch supports ethernet frame sizes between 64 and 2024 bytes
(including VLAN) as stated in the technical reference manual, so
define AM65_CPSW_MAX_PACKET_SIZE with that maximum size.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://lore.kernel.org/r/20240105085530.14070-2-jorge.sanjuangarcia@duagon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 4aa9477ac597..1fa6f0dacd2d 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -53,7 +53,7 @@
 #define AM65_CPSW_MAX_PORTS	8
 
 #define AM65_CPSW_MIN_PACKET_SIZE	VLAN_ETH_ZLEN
-#define AM65_CPSW_MAX_PACKET_SIZE	(VLAN_ETH_FRAME_LEN + ETH_FCS_LEN)
+#define AM65_CPSW_MAX_PACKET_SIZE	2024
 
 #define AM65_CPSW_REG_CTL		0x004
 #define AM65_CPSW_REG_STAT_PORT_EN	0x014
@@ -1985,7 +1985,8 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	eth_hw_addr_set(port->ndev, port->slave.mac_addr);
 
 	port->ndev->min_mtu = AM65_CPSW_MIN_PACKET_SIZE;
-	port->ndev->max_mtu = AM65_CPSW_MAX_PACKET_SIZE;
+	port->ndev->max_mtu = AM65_CPSW_MAX_PACKET_SIZE -
+			      (VLAN_ETH_HLEN + ETH_FCS_LEN);
 	port->ndev->hw_features = NETIF_F_SG |
 				  NETIF_F_RXCSUM |
 				  NETIF_F_HW_CSUM |
-- 
2.43.0



