Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9203B26C3A4;
	Tue, 26 Aug 2025 11:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208879; cv=none; b=qVSO4lp7XEpLbcQBbqmQnKgsYrqiD2ARZNwd0yFEN1FchX4wZj+BLgDuXtr464xcQbONr5uEBgeVckuhuvfVcyl90yiitJ2SsYMqX0S4TkZnLa/9ecHxJqHZ2bVd9vIG9OvRMtddniSke8XnzY9MyZuhChQo3CZv6BfEv1s0fpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208879; c=relaxed/simple;
	bh=9sgWwNasB7qs8rHSCbKT6Inr/0S7MknTHi6ikeradD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aH/r94W0vGXyaTuNGgIhZVtT7tYotvKz+Ls5dVA85+rDM6NZxSNfMF9XvsRThyrI4oXUNoS9j0aUaHF1bPJ18cKQGtuf8x9sqZmibk6Ms8SE5waEM+ByqIQvZxfK1zGt+cG52ywjAdyxQgyvdEcoQunUmWb8T9PuDcij1v3lsc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waSjKMsW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waSjKMsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B13C4CEF1;
	Tue, 26 Aug 2025 11:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208879;
	bh=9sgWwNasB7qs8rHSCbKT6Inr/0S7MknTHi6ikeradD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=waSjKMsWHnM5nnUukNieacPZUDQKjXyCq3yn+Q5FEbuih5rGUq4w2JCPlqEyyGIk7
	 E2C19k8UStCDt9FOomNhnR5cJKzD3eYtnh2bFURc85z08kFXyPuxxP5SO2gdMyVjkb
	 LUqcT1NUfr4m0nFX17ZOnda9TqVEn1a1/oJjTFiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Wang Liang <wangliang74@huawei.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 273/322] net: bridge: fix soft lockup in br_multicast_query_expired()
Date: Tue, 26 Aug 2025 13:11:28 +0200
Message-ID: <20250826110922.667132475@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit d1547bf460baec718b3398365f8de33d25c5f36f ]

When set multicast_query_interval to a large value, the local variable
'time' in br_multicast_send_query() may overflow. If the time is smaller
than jiffies, the timer will expire immediately, and then call mod_timer()
again, which creates a loop and may trigger the following soft lockup
issue.

  watchdog: BUG: soft lockup - CPU#1 stuck for 221s! [rb_consumer:66]
  CPU: 1 UID: 0 PID: 66 Comm: rb_consumer Not tainted 6.16.0+ #259 PREEMPT(none)
  Call Trace:
   <IRQ>
   __netdev_alloc_skb+0x2e/0x3a0
   br_ip6_multicast_alloc_query+0x212/0x1b70
   __br_multicast_send_query+0x376/0xac0
   br_multicast_send_query+0x299/0x510
   br_multicast_query_expired.constprop.0+0x16d/0x1b0
   call_timer_fn+0x3b/0x2a0
   __run_timers+0x619/0x950
   run_timer_softirq+0x11c/0x220
   handle_softirqs+0x18e/0x560
   __irq_exit_rcu+0x158/0x1a0
   sysvec_apic_timer_interrupt+0x76/0x90
   </IRQ>

This issue can be reproduced with:
  ip link add br0 type bridge
  echo 1 > /sys/class/net/br0/bridge/multicast_querier
  echo 0xffffffffffffffff >
  	/sys/class/net/br0/bridge/multicast_query_interval
  ip link set dev br0 up

The multicast_startup_query_interval can also cause this issue. Similar to
the commit 99b40610956a ("net: bridge: mcast: add and enforce query
interval minimum"), add check for the query interval maximum to fix this
issue.

Link: https://lore.kernel.org/netdev/20250806094941.1285944-1-wangliang74@huawei.com/
Link: https://lore.kernel.org/netdev/20250812091818.542238-1-wangliang74@huawei.com/
Fixes: d902eee43f19 ("bridge: Add multicast count/interval sysfs entries")
Suggested-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250813021054.1643649-1-wangliang74@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_multicast.c | 16 ++++++++++++++++
 net/bridge/br_private.h   |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 733ff6b758f6..0a00c3f57815 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4808,6 +4808,14 @@ void br_multicast_set_query_intvl(struct net_bridge_mcast *brmctx,
 		intvl_jiffies = BR_MULTICAST_QUERY_INTVL_MIN;
 	}
 
+	if (intvl_jiffies > BR_MULTICAST_QUERY_INTVL_MAX) {
+		br_info(brmctx->br,
+			"trying to set multicast query interval above maximum, setting to %lu (%ums)\n",
+			jiffies_to_clock_t(BR_MULTICAST_QUERY_INTVL_MAX),
+			jiffies_to_msecs(BR_MULTICAST_QUERY_INTVL_MAX));
+		intvl_jiffies = BR_MULTICAST_QUERY_INTVL_MAX;
+	}
+
 	brmctx->multicast_query_interval = intvl_jiffies;
 }
 
@@ -4824,6 +4832,14 @@ void br_multicast_set_startup_query_intvl(struct net_bridge_mcast *brmctx,
 		intvl_jiffies = BR_MULTICAST_STARTUP_QUERY_INTVL_MIN;
 	}
 
+	if (intvl_jiffies > BR_MULTICAST_STARTUP_QUERY_INTVL_MAX) {
+		br_info(brmctx->br,
+			"trying to set multicast startup query interval above maximum, setting to %lu (%ums)\n",
+			jiffies_to_clock_t(BR_MULTICAST_STARTUP_QUERY_INTVL_MAX),
+			jiffies_to_msecs(BR_MULTICAST_STARTUP_QUERY_INTVL_MAX));
+		intvl_jiffies = BR_MULTICAST_STARTUP_QUERY_INTVL_MAX;
+	}
+
 	brmctx->multicast_startup_query_interval = intvl_jiffies;
 }
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 6a1bce8959af..5026a256bf92 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -31,6 +31,8 @@
 #define BR_MULTICAST_DEFAULT_HASH_MAX 4096
 #define BR_MULTICAST_QUERY_INTVL_MIN msecs_to_jiffies(1000)
 #define BR_MULTICAST_STARTUP_QUERY_INTVL_MIN BR_MULTICAST_QUERY_INTVL_MIN
+#define BR_MULTICAST_QUERY_INTVL_MAX msecs_to_jiffies(86400000) /* 24 hours */
+#define BR_MULTICAST_STARTUP_QUERY_INTVL_MAX BR_MULTICAST_QUERY_INTVL_MAX
 
 #define BR_HWDOM_MAX BITS_PER_LONG
 
-- 
2.50.1



