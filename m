Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB91F1C6891;
	Tue, 27 Aug 2024 15:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771891; cv=none; b=Hc2QdM3ucHMgKzJEkcwcAbeyecNay7G0GL8K1wxpgv8iKdGcNH+adBOxN3Q6kSMWgx1epO3rzXLhNyuEqq1jzXMsTE8qyTW035Qi6Ehd/Bn8q0O14UR5kClb/pXNbPv4+wBErAkv/WJtZ1SdKSdecXv+F6axwlDDmUj6xdgVsTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771891; c=relaxed/simple;
	bh=D3mcmCH3G/5rv4HUKo5MOqprbM3TaPZXpaVqtpszJNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzJj2u13f0iDPfJX0utoW1Fi6QqANxbbgYer3L7/DG8dMGXUF6nanZePOnC/5IEzlskQtE/S1un6VyYR5vaxmNw4AXODYFQyLiXzl3mEUMiul9vsPxVEl4/xWTk0szAMEEJV3oyx6wwRljsXstF/P5/1JHAo3iGA0VIDyAFNHg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkJQYl+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkJQYl+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6F5C4AF11;
	Tue, 27 Aug 2024 15:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771891;
	bh=D3mcmCH3G/5rv4HUKo5MOqprbM3TaPZXpaVqtpszJNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkJQYl+4h8iV63KHljR3mykZEnzCLvW9Wk/SVnIGsGgLQf4FiFZ9Lf2kToDh8e5dA
	 BBCzufTQ2/5L7yoDjfRCTDYXxpPW72Fq+ajTHd7SRLGsGWSjCcV/U4JYVkwPzQhQeE
	 m4ByKaeti48p0KJGS9fjEY27udLcMl//SzWWrpoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yajun Deng <yajun.deng@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/321] net: sched: Print msecs when transmit queue time out
Date: Tue, 27 Aug 2024 16:35:59 +0200
Message-ID: <20240827143840.177737675@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit 2f0f9465ad9fa9c93f30009184c10da0f504f313 ]

The kernel will print several warnings in a short period of time
when it stalls. Like this:

First warning:
[ 7100.097547] ------------[ cut here ]------------
[ 7100.097550] NETDEV WATCHDOG: eno2 (xxx): transmit queue 8 timed out
[ 7100.097571] WARNING: CPU: 8 PID: 0 at net/sched/sch_generic.c:467
                       dev_watchdog+0x260/0x270
...

Second warning:
[ 7147.756952] rcu: INFO: rcu_preempt self-detected stall on CPU
[ 7147.756958] rcu:   24-....: (59999 ticks this GP) idle=546/1/0x400000000000000
                      softirq=367      3137/3673146 fqs=13844
[ 7147.756960]        (t=60001 jiffies g=4322709 q=133381)
[ 7147.756962] NMI backtrace for cpu 24
...

We calculate that the transmit queue start stall should occur before
7095s according to watchdog_timeo, the rcu start stall at 7087s.
These two times are close together, it is difficult to confirm which
happened first.

To let users know the exact time the stall started, print msecs when
the transmit queue time out.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e316dd1cf135 ("net: don't dump stack on queue timeout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 7053c0292c335..4023c955036b1 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -502,7 +502,7 @@ static void dev_watchdog(struct timer_list *t)
 		if (netif_device_present(dev) &&
 		    netif_running(dev) &&
 		    netif_carrier_ok(dev)) {
-			int some_queue_timedout = 0;
+			unsigned int timedout_ms = 0;
 			unsigned int i;
 			unsigned long trans_start;
 
@@ -514,16 +514,16 @@ static void dev_watchdog(struct timer_list *t)
 				if (netif_xmit_stopped(txq) &&
 				    time_after(jiffies, (trans_start +
 							 dev->watchdog_timeo))) {
-					some_queue_timedout = 1;
+					timedout_ms = jiffies_to_msecs(jiffies - trans_start);
 					atomic_long_inc(&txq->trans_timeout);
 					break;
 				}
 			}
 
-			if (unlikely(some_queue_timedout)) {
+			if (unlikely(timedout_ms)) {
 				trace_net_dev_xmit_timeout(dev, i);
-				WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out\n",
-				       dev->name, netdev_drivername(dev), i);
+				WARN_ONCE(1, "NETDEV WATCHDOG: %s (%s): transmit queue %u timed out %u ms\n",
+					  dev->name, netdev_drivername(dev), i, timedout_ms);
 				netif_freeze_queues(dev);
 				dev->netdev_ops->ndo_tx_timeout(dev, i);
 				netif_unfreeze_queues(dev);
-- 
2.43.0



