Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7013C386C0D;
	Sat, 12 Sep 2026 09:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205069; cv=none; b=m6xXYJfyni4BZEsBoHhzfsxqrrqKrWajRDlqQw2zlWyo0HveeCpmiyURzKAXp96wUsGsXk3VYZ1WnCc1kVchthiMnY2sLfXi2XpEQlROpqD7QFfUxCDfl0haB/GQRbdFAZ8k1wIABVVRNt4OIHIk2Rg59CV1+kEDMqHy8FBsBSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205069; c=relaxed/simple;
	bh=AqEnTk8rHoXsU7h8I8ZRBWEi8Dmqxjk8WKiojLzIxRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEvY0SUo71tHQgOz+VyMYjI+JXyl+6o9H5DXaZki4UbIM6fSNaaJh5nPy25H2ZYPdKrAt1mzE2XFlhHfZ7Tp3TdXQoqksfsZ9ZqkuCcuwBpcGs9DzRd330gEqVS9A3EiR3HbWxS7QckpTCorUPOEgyCY3qEhR9mHucLEv5qvhnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZUnWkiW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZUnWkiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7A01F000FF;
	Sat, 12 Sep 2026 09:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205068;
	bh=w2/FGCPgsAWMgjO1ndOiLRifq4iXgI0XFoNCssLB4lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZUnWkiW/kYJ+oM0W4m1mI6NQkuXVCXbK6snzE9zJqa7WwzChNJJOt1jppySCxtzP
	 ZlxO6DXKjhZDVjpCWXY/6KpboNT70X0FatjsvYPNuG2EMD6N9qJtj0cTHqGV6i3HTW
	 x9JwQEdTPcI/RebWJdhRK+xYRjYpIYP0DfmTpU2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1699/1815] net: sparx5: fix sleep in atomic context in MAC table access
Date: Sat, 12 Sep 2026 08:57:29 +0200
Message-ID: <20260912065728.866732306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit b62793a7baeea9cf20209c9fd2e333311aaf3b8d ]

sparx5_set_rx_mode() runs with netif_addr_lock_bh held and iterates
dev->mc via __dev_mc_sync(), which per address calls sparx5_mc_sync() /
sparx5_mc_unsync() -> sparx5_mact_learn() / sparx5_mact_forget().  These
take sparx5->lock, a mutex, and then poll the MAC access command
register with readx_poll_timeout(). A mutex may block, which is not
allowed from atomic context.

Convert the driver to the new .ndo_set_rx_mode_async callback introduced
in commit 3554b4345d85 ("net: introduce ndo_set_rx_mode_async and
netdev_rx_mode_work"). The async callback is invoked from process
context, so the mutex and sleeping completion poll can remain.

Observed with CONFIG_PROVE_LOCKING, CONFIG_DEBUG_SPINLOCK,
CONFIG_DEBUG_MUTEXES and CONFIG_DEBUG_ATOMIC_SLEEP enabled:

  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:591
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 217, name: ip
  preempt_count: 201, expected: 0
  Call trace:
   __might_resched+0x144/0x248
   __might_sleep+0x48/0x7c
   __mutex_lock+0x74/0x850
   mutex_lock_nested+0x24/0x30
   sparx5_mact_learn+0x78/0x100
   sparx5_mc_sync+0x40/0x54
   __hw_addr_sync_dev+0xc4/0x170
   sparx5_set_rx_mode+0x4c/0x58
   __dev_set_rx_mode+0x64/0xa4
   __dev_open+0x1ec/0x26c

Fixes: d6fce5141929 ("net: sparx5: add switching support")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20260817-misc-fixes-sparx5-lan969x-v3-2-c7c7fef723a8@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index 1d34af78166a3..4dedf5d926416 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -162,13 +162,18 @@ static int sparx5_port_stop(struct net_device *ndev)
 	return 0;
 }
 
-static void sparx5_set_rx_mode(struct net_device *dev)
+static int sparx5_set_rx_mode(struct net_device *dev,
+			      struct netdev_hw_addr_list *uc,
+			      struct netdev_hw_addr_list *mc)
 {
 	struct sparx5_port *port = netdev_priv(dev);
 	struct sparx5 *sparx5 = port->sparx5;
 
 	if (!test_bit(port->portno, sparx5->bridge_mask))
-		__dev_mc_sync(dev, sparx5_mc_sync, sparx5_mc_unsync);
+		return __hw_addr_sync_dev(mc, dev, sparx5_mc_sync,
+					  sparx5_mc_unsync);
+
+	return 0;
 }
 
 static int sparx5_port_get_phys_port_name(struct net_device *dev,
@@ -249,7 +254,7 @@ static const struct net_device_ops sparx5_port_netdev_ops = {
 	.ndo_open               = sparx5_port_open,
 	.ndo_stop               = sparx5_port_stop,
 	.ndo_start_xmit         = sparx5_port_xmit_impl,
-	.ndo_set_rx_mode        = sparx5_set_rx_mode,
+	.ndo_set_rx_mode_async  = sparx5_set_rx_mode,
 	.ndo_get_phys_port_name = sparx5_port_get_phys_port_name,
 	.ndo_set_mac_address    = sparx5_set_mac_address,
 	.ndo_validate_addr      = eth_validate_addr,
-- 
2.53.0



