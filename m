Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8E23EEAC7;
	Tue, 21 Jul 2026 19:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661268; cv=none; b=KGPzURxpJRsEr0pdlywITTHnMQZ+g0aKmVF8YfEC7Fe9BrQ0LeVZN4wZQDQQp7I4vZwGFJTJxv2hXMB8EfAbA9hVnTmuoH483d8l1iTaL9St6YewQ+kPdFyM7kRS4ulghYeTZI0+kCPlLbockpXdSJ+mbyYR6c2b/T83pufJyeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661268; c=relaxed/simple;
	bh=hQNbGioVTC9nFKhB3qEbXKaUUbwhiSGlUjsqO8rLsnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcbjX+lEKDc2Q+ZRr9tG3MlJtabhaBxlNWsYxtGXQiMtCKc0ZuocrVkS/SJZHc/G0ZiVITZA+3/6ruNbjEBGYqS9gtrc/w2jv0KwJC759S2x3+9LfZ17XCpJlo+NuF+yXTI/avl++NnzfU8DCLSFrKg+ndoqCGrUNtGqCQR2yq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+D+sr7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+D+sr7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D421F000E9;
	Tue, 21 Jul 2026 19:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661266;
	bh=w7Ymc4+luAsXNwme2onWi9qY1TNCgG9LcdvV06UEUAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S+D+sr7vSGK/LDpstY4ltc244f4DUKSXqwSOdarqpEy05Vkd5qOPMMcCEJf3h2Q2w
	 I1GiSIPpX/uKHDU+I/JDnrWZMf5z/wBKpCg9oysoElv4Z/VS1/HBNJQ0B2FGlnv0RU
	 kmPiqH8Nenum8VIiETkGmve3w6diBrT0HFR8vQ8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1251/2077] net: do not acquire dev->tx_global_lock in netdev_watchdog_up()
Date: Tue, 21 Jul 2026 17:15:24 +0200
Message-ID: <20260721152622.318978517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d09a78a2a469e4fab75108325efb813c49520809 ]

Marek Szyprowski reported a deadlock during system resume when virtio_net
driver is used.

The deadlock occurs because netif_device_attach() is called while holding
dev->tx_global_lock (via netif_tx_lock_bh() in virtnet_restore_up()).
netif_device_attach() calls __netdev_watchdog_up(), which now also tries
to acquire dev->tx_global_lock to synchronize with dev_watchdog().

This recursive lock acquisition results in a deadlock.

Fix this by removing the tx_global_lock acquisition from netdev_watchdog_up().

The critical state (watchdog_timer and watchdog_ref_held) is already
protected by dev->watchdog_lock, which was introduced in the blamed commit.

Fixes: 8eed5519e496 ("net: watchdog: fix refcount tracking races")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/netdev/a443376e-5187-4268-93b3-58047ef113a8@samsung.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260622110108.69541-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 3a0f3bb6a1ff4e..fe73ac40d409e8 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -594,9 +594,8 @@ void netdev_watchdog_up(struct net_device *dev)
 		return;
 	if (dev->watchdog_timeo <= 0)
 		dev->watchdog_timeo = 5*HZ;
-	spin_lock_bh(&dev->tx_global_lock);
 
-	spin_lock(&dev->watchdog_lock);
+	spin_lock_bh(&dev->watchdog_lock);
 	if (!mod_timer(&dev->watchdog_timer,
 		       round_jiffies(jiffies + dev->watchdog_timeo))) {
 		if (!dev->watchdog_ref_held) {
@@ -605,9 +604,7 @@ void netdev_watchdog_up(struct net_device *dev)
 			dev->watchdog_ref_held = true;
 		}
 	}
-	spin_unlock(&dev->watchdog_lock);
-
-	spin_unlock_bh(&dev->tx_global_lock);
+	spin_unlock_bh(&dev->watchdog_lock);
 }
 EXPORT_SYMBOL_GPL(netdev_watchdog_up);
 
-- 
2.53.0



