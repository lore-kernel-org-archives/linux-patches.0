Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57211ABCC4;
	Thu,  6 Jun 2024 14:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683293; cv=none; b=IUefvMp1ddJxXQukNXToTJU65oAjNHJR1jQoDHvX/NPxvAM3mCsWuxMH+zXJfHr5UecAkWXmHX7Yc2EACgZnuD8WnYC3qhZjLL7RPj7UWcoLgifIX1Ri8byKZmizS7Gli5TfrzFHO1PsNBZGsbNBuebdF7mnejOejYfO038PFFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683293; c=relaxed/simple;
	bh=C6DaM1Gom901X9mFeKgU7uINQngOXLTIMFPNE0lU9iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4FpilKwyv2eMLp7nRw7WaYhxlWCC6Hqwa/6aOGJl00a7wCOOJJsVRjN5hcmW5WOaF8G481rYKTDIT28IQ6WvO8y1/ofbWc/ta9y+8jnTHKIS7DGLvuTkZKDyCRGOI6NhXAVbPF27RIZVtqaeKX6vKMuf2Y32QqDdagTX/7JcXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDcwI7mv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDcwI7mv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16E4C32781;
	Thu,  6 Jun 2024 14:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683292;
	bh=C6DaM1Gom901X9mFeKgU7uINQngOXLTIMFPNE0lU9iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDcwI7mvSmq+kLyfigBQEn2X5kPqH1FNWFo2Srq7NR0qe+GPKC28c7s7/wP15eZDT
	 wWsueEj1OSpXCMUB0jN9Ezf2fdeNe0bN7c4pSFqm5heK2h4o2kMRoMj76iI8Yd2MJX
	 rxkCVi5bSrxaTCihcZGpUROyr4WCSvNjbLnJjzTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Erhard Furtner <erhard_f@mailbox.org>
Subject: [PATCH 6.1 169/473] eth: sungem: remove .ndo_poll_controller to avoid deadlocks
Date: Thu,  6 Jun 2024 16:01:38 +0200
Message-ID: <20240606131705.530465638@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4154e68639ace..940e45bf7a2eb 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -948,17 +948,6 @@ static irqreturn_t gem_interrupt(int irq, void *dev_id)
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
@@ -2838,9 +2827,6 @@ static const struct net_device_ops gem_netdev_ops = {
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



