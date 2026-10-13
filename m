Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFD14F475B;
	Tue, 13 Oct 2026 12:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895023; cv=none; b=QVlgz85JZRYP+inRkeW7TiWmJRgk5On0H7L2H4gFfCSYQSsmkO5KYXGePpyJQuLP9Zn6Iyup9uAXqco02kNjLe+96VNNNoUIdlU0b4rn4gog2Vn8YfJqZcC3AZQZ99qy6SSYqAQh6vtvM2hYjUBihD6YGXPHOrwdD+Vn15O5cUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895023; c=relaxed/simple;
	bh=IwlCIA7/0XqbmnIut8BvC4Qdfk+MCQFKcAIJ3ObSxnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldAMuw5OEWE0Bjdewn1pEoTTrxi6v2m34A3nDcQoZ7BA6liTPwcIpCY2UVO2r5tGo4i0SidG/2haGNSfA+UZZca0Rr/p5TWlJXjkRXtWxbWE6s0mJqFBt1tGd9Am0++SP3bEp2YZm2gA9zG3RRojaF6z/u5JvcOPQax1LZWV91A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSW4Uqzc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSW4Uqzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601751F00893;
	Tue, 13 Oct 2026 12:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895022;
	bh=241cbVCCOupJ7d7sYbeSVMAa1zghH74z3k0m8GE9WWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lSW4UqzceMZGMb9/Wpk1YwJqHuaQhVRiCGJ3LyJQFQvgpUXYKyio1PI8se8oePv3M
	 xx6QNy4gJ0NJXBI1c2TQyoq1njvvjAyRDzjOqKkJCy5a3UDxmQIAqsk674mG7NpqP/
	 vltA3jTW0NQXWI8+HQW13JNVWPNI1Fu8MtDpjJ2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/497] net: bcmgenet: fix NULL dereference in set_coalesce before first open
Date: Tue, 13 Oct 2026 13:34:18 +0200
Message-ID: <20261013112910.050447772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 14e891db97ea8..7da4a2114a771 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4075,8 +4075,11 @@ static int bcmgenet_probe(struct platform_device *pdev)
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



