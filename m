Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F6E1A3159;
	Tue, 27 May 2025 17:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367489; cv=none; b=tErVqDSKGzKRpHSaiYMTdcpkl/KR6q9VdIl3QkJDqkkGbRkR4JJomDQ8NryS+JwbvRkeapui8V5bxBbeW+rOLKmTs6Pyn+I3KCw8I9RG0zv32daIh5rp6gq5yJclEuIbsB/wJLGnvigSUwnbPNBJi5hyEC93udcHjy75TtTDopo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367489; c=relaxed/simple;
	bh=PyI3PQ4nY4ruNenz+J0OnFKGXJ3vQrrjDgvJGHbLpKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJ6/YCV0iCRe6gL14hQZBwJE/QUsQmzx8m9km6uPpryhH6e4hd3/d1BAPL/auH/VktP2KqYzQrOPwYXC/PDAF7BD6c4vpER42M2ClG3wiW1ndEOSfhJDUtpa5w3mm1S2kH0GuxDtn4XMFAD++vzX6gIlIXfEq8sShnwS5RwM+wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcZ5Rf2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcZ5Rf2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3839C4CEE9;
	Tue, 27 May 2025 17:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367489;
	bh=PyI3PQ4nY4ruNenz+J0OnFKGXJ3vQrrjDgvJGHbLpKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcZ5Rf2bKiPfIKv4lon+0n59yHVgTmtj2UEBUppFZRNYd7jy4rHH2KgD99/lCc1Vv
	 egI1mb+Kpk/R03I81gHcH9fEhbqTXeq5IHViktfUiOgEVGJjPBmxfRfhes95IubQgI
	 NMPycsKlCU9Vvn1ek+GG61BOkBsrHMCONiJZdGLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 404/783] netdevsim: call napi_schedule from a timer context
Date: Tue, 27 May 2025 18:23:21 +0200
Message-ID: <20250527162529.550781200@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit bf3624cf1c3708284c53ed99a1c43f2e104dc2dd ]

The netdevsim driver was experiencing NOHZ tick-stop errors during packet
transmission due to pending softirq work when calling napi_schedule().
This issue was observed when running the netconsole selftest, which
triggered the following error message:

  NOHZ tick-stop error: local softirq work is pending, handler #08!!!

To fix this issue, introduce a timer that schedules napi_schedule()
from a timer context instead of calling it directly from the TX path.

Create an hrtimer for each queue and kick it from the TX path,
which then schedules napi_schedule() from the timer context.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20250219-netdevsim-v3-1-811e2b8abc4c@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/netdev.c    | 21 ++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |  1 +
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 42f247cbdceec..e4c0d77849b82 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -87,7 +87,8 @@ static netdev_tx_t nsim_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(nsim_forward_skb(peer_dev, skb, rq) == NET_RX_DROP))
 		goto out_drop_cnt;
 
-	napi_schedule(&rq->napi);
+	if (!hrtimer_active(&rq->napi_timer))
+		hrtimer_start(&rq->napi_timer, us_to_ktime(5), HRTIMER_MODE_REL);
 
 	rcu_read_unlock();
 	u64_stats_update_begin(&ns->syncp);
@@ -426,6 +427,22 @@ static int nsim_init_napi(struct netdevsim *ns)
 	return err;
 }
 
+static enum hrtimer_restart nsim_napi_schedule(struct hrtimer *timer)
+{
+	struct nsim_rq *rq;
+
+	rq = container_of(timer, struct nsim_rq, napi_timer);
+	napi_schedule(&rq->napi);
+
+	return HRTIMER_NORESTART;
+}
+
+static void nsim_rq_timer_init(struct nsim_rq *rq)
+{
+	hrtimer_init(&rq->napi_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	rq->napi_timer.function = nsim_napi_schedule;
+}
+
 static void nsim_enable_napi(struct netdevsim *ns)
 {
 	struct net_device *dev = ns->netdev;
@@ -615,11 +632,13 @@ static struct nsim_rq *nsim_queue_alloc(void)
 		return NULL;
 
 	skb_queue_head_init(&rq->skb_queue);
+	nsim_rq_timer_init(rq);
 	return rq;
 }
 
 static void nsim_queue_free(struct nsim_rq *rq)
 {
+	hrtimer_cancel(&rq->napi_timer);
 	skb_queue_purge_reason(&rq->skb_queue, SKB_DROP_REASON_QUEUE_PURGE);
 	kfree(rq);
 }
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 96d54c08043d3..e757f85ed8617 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -97,6 +97,7 @@ struct nsim_rq {
 	struct napi_struct napi;
 	struct sk_buff_head skb_queue;
 	struct page_pool *page_pool;
+	struct hrtimer napi_timer;
 };
 
 struct netdevsim {
-- 
2.39.5



