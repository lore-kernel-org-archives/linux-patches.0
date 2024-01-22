Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0527E13473B;
	Tue, 23 Jan 2024 01:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971934; cv=none; b=r7pVRVxY9JGYU9vOEvoFeJxOjNg5IR2TcUdIO/gpRfvTh5UqITjfu2PVE5X5MXSfOF6JT3x4c2snFpgS8fhE0zkQG7NKF6RriYkXFUF8m7JX21rxgvf67xk2F35+fb0Ne+nW/M7YXW+ji4K8JksOiIpQdUhf1coJbSPEd2CRgeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971934; c=relaxed/simple;
	bh=LcoBS0TYU4mswpTzjJirOeMMNSkoRyu0XkYENFH2T08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pNyw7ulZTX7CcR/ecdOwDucfv099wkNmYLyc/p4ctHStOyiH13oymqWpwOiAht/aRPg/FbNO0A9UR4qNox6XSoDpGgfS+WT91sEcvSdVx87IBQMjRTBH4YoaRsuc3ng3XBUIjwT/3sxuEwTTW3hpmO77bir6boz/0mywdLxsgrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zx4w5chV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zx4w5chV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52E4C433F1;
	Tue, 23 Jan 2024 01:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971933;
	bh=LcoBS0TYU4mswpTzjJirOeMMNSkoRyu0XkYENFH2T08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zx4w5chVbKAqu/aRqWKDCrdhvchWYmsG26E4sKjpACfJJOnnJDNInAuanO7QtKIlm
	 F/z+vnQTcPLF2kQ8o5YrnF+Vm6vhwNvPiWX4IgGqHAGx/M8LzAxBXuXuYyO084fkik
	 TF7CL+787v1dAhSwv1PZmbi5fTDw3a/cB02ISWD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Sanjuan Garcia <jorge.sanjuangarcia@duagon.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 267/286] net: ethernet: ti: am65-cpsw: Fix max mtu to fit ethernet frames
Date: Mon, 22 Jan 2024 15:59:33 -0800
Message-ID: <20240122235742.325183706@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d10324431354..94e36deefe88 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -51,7 +51,7 @@
 #define AM65_CPSW_MAX_PORTS	8
 
 #define AM65_CPSW_MIN_PACKET_SIZE	VLAN_ETH_ZLEN
-#define AM65_CPSW_MAX_PACKET_SIZE	(VLAN_ETH_FRAME_LEN + ETH_FCS_LEN)
+#define AM65_CPSW_MAX_PACKET_SIZE	2024
 
 #define AM65_CPSW_REG_CTL		0x004
 #define AM65_CPSW_REG_STAT_PORT_EN	0x014
@@ -1853,7 +1853,8 @@ static int am65_cpsw_nuss_init_ndev_2g(struct am65_cpsw_common *common)
 	ether_addr_copy(port->ndev->dev_addr, port->slave.mac_addr);
 
 	port->ndev->min_mtu = AM65_CPSW_MIN_PACKET_SIZE;
-	port->ndev->max_mtu = AM65_CPSW_MAX_PACKET_SIZE;
+	port->ndev->max_mtu = AM65_CPSW_MAX_PACKET_SIZE -
+			      (VLAN_ETH_HLEN + ETH_FCS_LEN);
 	port->ndev->hw_features = NETIF_F_SG |
 				  NETIF_F_RXCSUM |
 				  NETIF_F_HW_CSUM |
-- 
2.43.0



