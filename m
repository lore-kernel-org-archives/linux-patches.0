Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5101FDE31;
	Sat, 17 Oct 2026 16:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256378; cv=none; b=H6KyiGWV1m2cz733p3CsZP1wLNbHDAoFsBsnatxui9nZ5Nk2oEUabYXwqtFdAOBUflthruz0nUKJ+pCtUxhS2SPmimX6/CrReMAvZ2Z9ejqskEJGsoEhmn1d4E4FLJ9D4xl/celi87fIY4QWaf2p7IMQYQNjeSX1t1XXzGiyS44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256378; c=relaxed/simple;
	bh=eo+QhaxGCCMoJ3dUhK//PklcCRGr93IGp7u8lYlkBls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxZZOjHcKIkH6eT/64obsUaZj28TYAmR8V1Z3+RWaIx55QYZ0VXJ89RqTZ67vNeqcwGAZo4TPvXpswrzGiltQ/B1IMqozZugHXk2wDOpAzH4Ric0QGo+GVVVo22MhG55+XLCkEatRdFNFs5NI5ma+ySZOsbCmwXxCHzDlc5G/IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCRsEDsG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCRsEDsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434461F000C4;
	Sat, 17 Oct 2026 16:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256376;
	bh=+voWtSmOu7jvzQDQrcqXPX5S4X5r88XwNpj8/7Utouo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCRsEDsGpmb8KkhYVR+YhWkrzAF6LxeZWnEMvtdR/6EZTVQHKus2VbB7eh5rl9yke
	 ljr6WtKL7LMuSRA2M9uhis8MDCa6VEgjnsULa0NSiucIGSfdTmYFMHS9zVqZVoHwMr
	 4bkeuNV2U4OKvIiqqhpcJ9mEeepPhpFApwlwynNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0217/1674] net: bcmgenet: fix NULL dereference in set_coalesce before first open
Date: Sat, 17 Oct 2026 17:41:29 +0200
Message-ID: <20261017160436.720287534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 19419faf58dfe5bcc8a9e60e622976c5f8e3ddc1 ]

The Rx ring priv and index are only set in bcmgenet_init_rx_ring(),
which runs at open. Setting the Rx coalescing parameters on an interface
that was never opened, e.g. "ethtool -C eth0 rx-usecs 50", dereferences
a NULL ring->priv. The oops happens with RTNL held, so networking
stays stuck until a reboot:

  Unable to handle kernel paging request at virtual address 0000000000002788
  pc : bcmgenet_set_rx_coalesce.isra.0+0x10/0x88
  lr : bcmgenet_set_coalesce+0xe8/0x180
  Call trace:
   bcmgenet_set_rx_coalesce.isra.0+0x10/0x88 (P)
   __ethnl_set_coalesce.isra.0+0x490/0x570
   ethnl_set_coalesce+0x48/0xc0
   ethnl_default_set_doit+0xf4/0x230
   genl_family_rcv_msg_doit+0xe8/0x160
   genl_rcv_msg+0x220/0x2a0
   netlink_rcv_skb+0x68/0x140
   genl_rcv+0x40/0x60
   netlink_unicast+0x338/0x3c0
   netlink_sendmsg+0x19c/0x3f8
   __sock_sendmsg+0x64/0xc0
   __sys_sendto+0x124/0x198
   __arm64_sys_sendto+0x30/0x48

Set priv and index at probe. Writing the registers while the interface
is down is harmless because open resets the MAC and
bcmgenet_init_rx_coalesce() reapplies the stored values.

It was observed on a Raspberry Pi CM4, but should apply to all other
genet devices.

Fixes: 9f4ca05827a2 ("net: bcmgenet: Add support for adaptive RX coalescing")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260928105642.856210-1-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 14b28d0c93de3..affac9887f160 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4084,8 +4084,11 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	netif_set_real_num_rx_queues(priv->dev, priv->hw_params->rx_queues + 1);
 
 	/* Set default coalescing parameters */
-	for (i = 0; i <= priv->hw_params->rx_queues; i++)
+	for (i = 0; i <= priv->hw_params->rx_queues; i++) {
+		priv->rx_rings[i].priv = priv;
+		priv->rx_rings[i].index = i;
 		priv->rx_rings[i].rx_max_coalesced_frames = 1;
+	}
 
 	/* Initialize u64 stats seq counter for 32bit machines */
 	for (i = 0; i <= GENET_MAX_MQ_CNT; i++) {
-- 
2.53.0



