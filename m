Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AB81AC44F;
	Thu,  6 Jun 2024 14:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683327; cv=none; b=Rh60XMv4/Uuf5y+08LVuupO9vNxEdgVtiltMA48geH82j2XTjgBaL4n8CRaAG4MxmJ62J2lnYBTZi2AgY/HTJ6hnn0VbKeWAmEMHgr1n3BElsx66I3ber1toB6otDkPkFieU/xD1XfEUCbVXoSU0NMzU81nuTZW01wJWGJ5Cwug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683327; c=relaxed/simple;
	bh=AGSJeRARp39mKLL1CnSQvrElsyInvdntORaIMrRR7qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bPDe4PDC7yQfTnhb9UhiGvhRKCy4c+1R1vamn9paxdy/nQupMu+hD8FXcYSifYPERPjwlTMhBdzWnPXqT13MTO4mk6KSSegQAu2ohOMu5TkdxOFoRi/HZAtVbseFzz5COx4gKobD2yyRGdoc6/7oOXSKKUOgDAaED9IPRIWVwXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gK8lsGDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gK8lsGDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429DCC32782;
	Thu,  6 Jun 2024 14:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683327;
	bh=AGSJeRARp39mKLL1CnSQvrElsyInvdntORaIMrRR7qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gK8lsGDS2aZQjERQh2jriW/xQJaDKd6pE4dX4bD/FfHmJQ80FrhC3L7Ljmn+0GEA8
	 n3B0tPlKxzOeQOr4LLV7dos3TOzB/70+Lr+ZVW1/kjaw7rOYOg7pI8jl7Mm0l0NOhO
	 brhinurKqmnQ+CZnRnExat7WVgmPGEmV2gSe1WCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Erhard Furtner <erhard_f@mailbox.org>
Subject: [PATCH 6.6 238/744] eth: sungem: remove .ndo_poll_controller to avoid deadlocks
Date: Thu,  6 Jun 2024 15:58:30 +0200
Message-ID: <20240606131740.035117561@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ac0a230f719b02432d8c7eba7615ebd691da86f4 ]

Erhard reports netpoll warnings from sungem:

  netpoll_send_skb_on_dev(): eth0 enabled interrupts in poll (gem_start_xmit+0x0/0x398)
  WARNING: CPU: 1 PID: 1 at net/core/netpoll.c:370 netpoll_send_skb+0x1fc/0x20c

gem_poll_controller() disables interrupts, which may sleep.
We can't sleep in netpoll, it has interrupts disabled completely.
Strangely, gem_poll_controller() doesn't even poll the completions,
and instead acts as if an interrupt has fired so it just schedules
NAPI and exits. None of this has been necessary for years, since
netpoll invokes NAPI directly.

Fixes: fe09bb619096 ("sungem: Spring cleaning and GRO support")
Reported-and-tested-by: Erhard Furtner <erhard_f@mailbox.org>
Link: https://lore.kernel.org/all/20240428125306.2c3080ef@legion
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240508134504.3560956-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/sungem.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 9bd1df8308d24..d3a2fbb14140e 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -949,17 +949,6 @@ static irqreturn_t gem_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-#ifdef CONFIG_NET_POLL_CONTROLLER
-static void gem_poll_controller(struct net_device *dev)
-{
-	struct gem *gp = netdev_priv(dev);
-
-	disable_irq(gp->pdev->irq);
-	gem_interrupt(gp->pdev->irq, dev);
-	enable_irq(gp->pdev->irq);
-}
-#endif
-
 static void gem_tx_timeout(struct net_device *dev, unsigned int txqueue)
 {
 	struct gem *gp = netdev_priv(dev);
@@ -2839,9 +2828,6 @@ static const struct net_device_ops gem_netdev_ops = {
 	.ndo_change_mtu		= gem_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address    = gem_set_mac_address,
-#ifdef CONFIG_NET_POLL_CONTROLLER
-	.ndo_poll_controller    = gem_poll_controller,
-#endif
 };
 
 static int gem_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
-- 
2.43.0



