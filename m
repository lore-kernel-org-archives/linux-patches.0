Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CBF262BE;
	Mon, 27 May 2024 19:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838198; cv=none; b=f0YnFZgvKBaUPN3DyOKDXJJ4XC+uCvOsbqM5xap7TQTE3iyp0ZVCxgzsyVo0LMEm48A/pBjSnkg9w1uhr19E9gxktiPo8gwxAkn8/o5IZhKbmERFkuK1ji8/55zTdsUURzMYTvXjaMpMEWYYeuenVNbQYzYe2YTzA24vLUQmpm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838198; c=relaxed/simple;
	bh=Y/w899UY0GnUZT/m8Krast6HzyiwiKBabKGe23z7pJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbNnqu7A52lXb9CYzzQan3jzCsetUsPvPcmUKfjmTLTpISTPZ7G/2qE2dQ6ASu1UYxlSFoBFD6wRVVF1kzfiaz4mJsPljKrndSWda0hwaLseb5365J2NkbGjuKYiw+hY9zyvkFlVorEUvmwaQk90QW08U9BtsI2CQqAuJ2dwlHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRKQCZYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRKQCZYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40320C2BBFC;
	Mon, 27 May 2024 19:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838198;
	bh=Y/w899UY0GnUZT/m8Krast6HzyiwiKBabKGe23z7pJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRKQCZYrCtLBHPPXGLptJwMsGaiLFaOfPQDBTAN3BRtJ+SlD4R4HWJdQzlukKf/h+
	 GOvpLP8rNJf5fn3ajRGBAmyGp28iUyqXOxi9ToC1QQDMagHwFlpXEx+c/0wopM/LdL
	 ZnlgatF+3KEVw21d35AmbLVzeHYRSAXK8FWn3FxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Erhard Furtner <erhard_f@mailbox.org>
Subject: [PATCH 6.8 302/493] eth: sungem: remove .ndo_poll_controller to avoid deadlocks
Date: Mon, 27 May 2024 20:55:04 +0200
Message-ID: <20240527185640.180792789@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



