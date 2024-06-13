Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD9F1428EF;
	Thu, 13 Jun 2024 12:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281947; cv=none; b=U50OYm/xpaCOUtbd6mbVURprSQVLdKhEBUdRqkJ+0A8HNUn1NlTk76dwBuMrALBG3ZoQ1O7D2ZQXUEBdP8Dp6Tmkhw4YhgWG6b+CpH12e+jVJhZarRGzr25xVfr1pjXnGRuS8tmE+6Bv/SxrsFK1YYt1SLXhjtJr+jDrX/5V8hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281947; c=relaxed/simple;
	bh=3VGf+8LQLFuHaqfdqEACU7LqtVoa05isFx/Phxx5P7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2KmSE8YbBiJW2kOwL194FcBAMhS4VVqiOru6Fi3b2i6I4eUEbNh+NJA5lgDAlEUo1o3UsNAaOmQ14ybfiziHGsS03cvipD6ncnf/q4lwo7wVUcVINsQXP1hoW4eQlvfnBQR4wapUAweMULpsIcrLKTAJ2K6F9dM+RUS7ApDZkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUi6sWiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUi6sWiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3DCC2BBFC;
	Thu, 13 Jun 2024 12:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281947;
	bh=3VGf+8LQLFuHaqfdqEACU7LqtVoa05isFx/Phxx5P7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUi6sWiUwD7F8bdnzMv6PjlqWRbXECRikjRO7fPc1LJFh7w6EiOE+/+ccbSBuJrLT
	 wiIGjbBiln7xZUR1GQ7+JISEfPy2ixOT24ZWxdh5VCBPI9nr5gj/FQyrjzUXToRAZw
	 yX/M4OWyMuSuFCCM2DecuD6gq2Gr0a88buWfvemc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Erhard Furtner <erhard_f@mailbox.org>
Subject: [PATCH 5.15 110/402] eth: sungem: remove .ndo_poll_controller to avoid deadlocks
Date: Thu, 13 Jun 2024 13:31:07 +0200
Message-ID: <20240613113306.420707088@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
index d72018a60c0f7..e14c1ac767baa 100644
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
@@ -2836,9 +2825,6 @@ static const struct net_device_ops gem_netdev_ops = {
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



