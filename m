Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9C23BBFC7;
	Sat, 17 Oct 2026 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255651; cv=none; b=ODVJ50Kat2vA3MbAIDAJY1SpHSg+GtAQzKl912b3TA1syyctmvQhUAca+MUPaAtFb+/WANDUuVoKMvnCBes6fLOf0iTzrx5XzISTsYFlGZPeQGZe4FQ13FyNkgP48t824YiZQBPtQ5SQWgRfEAVH34EvNGxiiYl9cf+CoDhS32I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255651; c=relaxed/simple;
	bh=CECMdUD4hW2Ct/ioV/e86V4/txM43Xl7RLVACSy2cJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNUCCdZdl3OOqTzJzeMbUZQlpb1JfZDiOixIAsFXWDEWXWWGjHq7toP+C1eNGA9n9blT2gfCSPjhNOmNa37fAPqNZO6cQeV7RsZmVkePxVRk7963bWPzcqrDRaccIUOkmji2jtQMAGYBIE33mgGBP3a1OdRx6Dj6VPhizNgFsx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFS0/oHj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFS0/oHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6E91F000C4;
	Sat, 17 Oct 2026 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255650;
	bh=AVnK8Vf6lOnxvzCWgb61I9yuDy+tftEdn7e2z478o1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mFS0/oHjsycINgMCHRm+ACC3LLIEK27bhj+DCmJkFHCNFAb8AtwUv5/9/Z3swkax6
	 jcHvwHjzxeXtsCj+qYqssq77t6NzrAEtdpGR0JDU8JML0ve5Ni16Vin+PdFDIlaOfs
	 Pfg9LC6RfHnHlowDdKUAbywgp/Ai6qCfIfM9FA6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 847/869] net: do not acquire dev->tx_global_lock in netdev_watchdog_up()
Date: Sat, 17 Oct 2026 18:01:28 +0200
Message-ID: <20261017160058.581365431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 7ec650ff9daae..681e0ab6019fb 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -568,9 +568,8 @@ void __netdev_watchdog_up(struct net_device *dev)
 		return;
 	if (dev->watchdog_timeo <= 0)
 		dev->watchdog_timeo = 5*HZ;
-	spin_lock_bh(&dev->tx_global_lock);
 
-	spin_lock(&dev->watchdog_lock);
+	spin_lock_bh(&dev->watchdog_lock);
 	if (!mod_timer(&dev->watchdog_timer,
 		       round_jiffies(jiffies + dev->watchdog_timeo))) {
 		if (!dev->watchdog_ref_held) {
@@ -579,9 +578,7 @@ void __netdev_watchdog_up(struct net_device *dev)
 			dev->watchdog_ref_held = true;
 		}
 	}
-	spin_unlock(&dev->watchdog_lock);
-
-	spin_unlock_bh(&dev->tx_global_lock);
+	spin_unlock_bh(&dev->watchdog_lock);
 }
 EXPORT_SYMBOL_GPL(__netdev_watchdog_up);
 
-- 
2.53.0



