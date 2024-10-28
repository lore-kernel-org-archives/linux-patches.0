Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD0315B10D;
	Mon, 28 Oct 2024 06:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097366; cv=none; b=WB528AItvSn0BAh09Kzd8soB6E9pjuGPG0TS+KNfu/yXxdMzoOy8+qNDFGrxzDvsvSHgUSbU1VfUpZxTipj7NsiCz7kkrejtPKjBcct3HOnObrA7A1qubIWcbnh8Vrw0RPdeHL4Lrk3Ngk5BNEY+NeMDHBWzeZoj1Sx5csvhF+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097366; c=relaxed/simple;
	bh=c2KuNknOkhKvNX7lann2uNBfXj9vGj6/7KYm5SWhruE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fd3fdq7IrILDCTWHZgDSfaLE3jd7nCXfLbWdYSCiydzBbyQBFj1ZBq7/HN4FRtBjbks8Y3nFiq+9+zCGgTkk1Ah0bLzxFsiKn9bUmAbg+c2zqurDdcynmMI9mh2DfrsCf6pZsMnfKlTWuDiS0zk2T2167oIdU9iFtcaBVvRlVtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uU6eLS1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uU6eLS1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376DDC4CEC3;
	Mon, 28 Oct 2024 06:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097366;
	bh=c2KuNknOkhKvNX7lann2uNBfXj9vGj6/7KYm5SWhruE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uU6eLS1VqJWmg20qFBFEsw3S4T6/7fqjBLfxff2xXBpBUFW7/sZxAc/tELarXpsJj
	 vJ6ANoY/yBJiSbsMX/3StZ2HA/c9dW1nXu2csGGKv+mW+LKnTg4sSvEx6tDyu5DkXD
	 cKmekqRzOCdvnuSZIN7IPIJoio2qzD+IlizfheZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praveen Kumar Kannoju <praveen.kannoju@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/137] net/sched: adjust device watchdog timer to detect stopped queue at right time
Date: Mon, 28 Oct 2024 07:25:35 +0100
Message-ID: <20241028062301.466631413@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>

[ Upstream commit 33fb988b67050d9bb512f77f08453fa00088943c ]

Applications are sensitive to long network latency, particularly
heartbeat monitoring ones. Longer the tx timeout recovery higher the
risk with such applications on a production machines. This patch
remedies, yet honoring device set tx timeout.

Modify watchdog next timeout to be shorter than the device specified.
Compute the next timeout be equal to device watchdog timeout less the
how long ago queue stop had been done. At next watchdog timeout tx
timeout handler is called into if still in stopped state. Either called
or not called, restore the watchdog timeout back to device specified.

Signed-off-by: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
Link: https://lore.kernel.org/r/20240508133617.4424-1-praveen.kannoju@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 95ecba62e2fd ("net: fix races in netdev_tx_sent_queue()/dev_watchdog()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 6ab9359c1706f..7f0c8df7b63e0 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -505,19 +505,22 @@ static void dev_watchdog(struct timer_list *t)
 			unsigned int timedout_ms = 0;
 			unsigned int i;
 			unsigned long trans_start;
+			unsigned long oldest_start = jiffies;
 
 			for (i = 0; i < dev->num_tx_queues; i++) {
 				struct netdev_queue *txq;
 
 				txq = netdev_get_tx_queue(dev, i);
 				trans_start = READ_ONCE(txq->trans_start);
-				if (netif_xmit_stopped(txq) &&
-				    time_after(jiffies, (trans_start +
-							 dev->watchdog_timeo))) {
+				if (!netif_xmit_stopped(txq))
+					continue;
+				if (time_after(jiffies, trans_start + dev->watchdog_timeo)) {
 					timedout_ms = jiffies_to_msecs(jiffies - trans_start);
 					atomic_long_inc(&txq->trans_timeout);
 					break;
 				}
+				if (time_after(oldest_start, trans_start))
+					oldest_start = trans_start;
 			}
 
 			if (unlikely(timedout_ms)) {
@@ -530,7 +533,7 @@ static void dev_watchdog(struct timer_list *t)
 				netif_unfreeze_queues(dev);
 			}
 			if (!mod_timer(&dev->watchdog_timer,
-				       round_jiffies(jiffies +
+				       round_jiffies(oldest_start +
 						     dev->watchdog_timeo)))
 				release = false;
 		}
-- 
2.43.0



