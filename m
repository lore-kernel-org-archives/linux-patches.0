Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D065315CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E479C43140;
	Tue,  8 Nov 2022 14:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916481;
	bh=AlJdWglTy1emvCDKpsZbQ4i1Gp6U66d2ULQ7J+0YKxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dt0xrh5zng4z3oGunKaVbbaCx6QFl6Z/dihMSMtJHCeylsrb3imj6WoCvWQdyGpDW
	 cNyHwTJV1Rqdm44O4VjH1L2t5asaTyDpXqNGIoQy440B3izPBjj9kcj4eYsEAblL34
	 RWTrNyVmbRd1HcShs26skfa3QShd6SSdAQD0SAcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 035/197] net: lan966x: Fix the MTU calculation
Date: Tue,  8 Nov 2022 14:37:53 +0100
Message-Id: <20221108133356.416798662@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 486c292230166c2d61701d3c984bf9143588ea28 ]

When the MTU was changed, the lan966x didn't take in consideration
the L2 header and the FCS. So the HW was configured with a smaller
value than what was desired. Therefore the correct value to configure
the HW would be new_mtu + ETH_HLEN + ETH_FCS_LEN.
The vlan tag is not considered here, because at the time when the
blamed commit was added, there was no vlan filtering support. The
vlan fix will be part of the next patch.

Fixes: d28d6d2e37d1 ("net: lan966x: add port module support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 2 +-
 drivers/net/ethernet/microchip/lan966x/lan966x_main.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index d928b75f3780..989e5f045d7e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -385,7 +385,7 @@ static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
 	int old_mtu = dev->mtu;
 	int err;
 
-	lan_wr(DEV_MAC_MAXLEN_CFG_MAX_LEN_SET(new_mtu),
+	lan_wr(DEV_MAC_MAXLEN_CFG_MAX_LEN_SET(LAN966X_HW_MTU(new_mtu)),
 	       lan966x, DEV_MAC_MAXLEN_CFG(port->chip_port));
 	dev->mtu = new_mtu;
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 2787055c1847..e316bfe186d7 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -24,6 +24,8 @@
 #define LAN966X_BUFFER_MEMORY		(160 * 1024)
 #define LAN966X_BUFFER_MIN_SZ		60
 
+#define LAN966X_HW_MTU(mtu)		((mtu) + ETH_HLEN + ETH_FCS_LEN)
+
 #define PGID_AGGR			64
 #define PGID_SRC			80
 #define PGID_ENTRIES			89
-- 
2.35.1



