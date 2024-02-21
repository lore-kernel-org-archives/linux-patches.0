Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1520F1E4B2;
	Wed, 21 Feb 2024 13:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522883; cv=none; b=ONCx6HfF5UWtO7bjzi1OIWfvT/NijZiq2/u+LH0IIasMux3GxtVy7x2tSQjD+UXIz5BAYgw1raqRiA9dP9niyvBs01qjXFTuTNTvOljbegt1XkdrQvQAxUaJ621cNOMfyseU5o2V6BpKWZ+CLpW6bwyQ4AyRXJUHwpjukuj+4qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522883; c=relaxed/simple;
	bh=w5eVyc++CIyRIJI4mdaYG1CQGOXWYLeGh7pWfUisCvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tGrMnAoQyHUALirkiGcKjj8x+5JH8pCEDziOx7h+lqmQptquG3uPEu1bM/nBl0Q30trCafo2WE5UCgsBH6VeTny/ROt9CWDyDcuCBUnuUMIw69rTqtuMmsnBOA6e97PhiHU8gV2r8A8D4hu9uuUecouHE8vEgDK2v9cVWKgmYVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdE9sh9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdE9sh9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DE0C433F1;
	Wed, 21 Feb 2024 13:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522883;
	bh=w5eVyc++CIyRIJI4mdaYG1CQGOXWYLeGh7pWfUisCvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdE9sh9X/C/BIj45cXu/O8WMKOM5PfQDL5yucPR3P0OJJBotIPd99DuK3nG9+iEeX
	 tOD9QW4CNRwIPxz3Zw9dkKwV6Ypek+/0Sr8oghVlmRiTeWAq6A17+MBmn85NjuLays
	 4yXHI68dJBlC63MRjAEYnZ7GzqeA46DXV+Dr3MWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 282/476] bridge: mcast: fix disabled snooping after long uptime
Date: Wed, 21 Feb 2024 14:05:33 +0100
Message-ID: <20240221130018.430012099@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Lüssing <linus.luessing@c0d3.blue>

[ Upstream commit f5c3eb4b7251baba5cd72c9e93920e710ac8194a ]

The original idea of the delay_time check was to not apply multicast
snooping too early when an MLD querier appears. And to instead wait at
least for MLD reports to arrive before switching from flooding to group
based, MLD snooped forwarding, to avoid temporary packet loss.

However in a batman-adv mesh network it was noticed that after 248 days of
uptime 32bit MIPS based devices would start to signal that they had
stopped applying multicast snooping due to missing queriers - even though
they were the elected querier and still sending MLD queries themselves.

While time_is_before_jiffies() generally is safe against jiffies
wrap-arounds, like the code comments in jiffies.h explain, it won't
be able to track a difference larger than ULONG_MAX/2. With a 32bit
large jiffies and one jiffies tick every 10ms (CONFIG_HZ=100) on these MIPS
devices running OpenWrt this would result in a difference larger than
ULONG_MAX/2 after 248 (= 2^32/100/60/60/24/2) days and
time_is_before_jiffies() would then start to return false instead of
true. Leading to multicast snooping not being applied to multicast
packets anymore.

Fix this issue by using a proper timer_list object which won't have this
ULONG_MAX/2 difference limitation.

Fixes: b00589af3b04 ("bridge: disable snooping if there is no querier")
Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20240127175033.9640-1-linus.luessing@c0d3.blue
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_multicast.c | 20 +++++++++++++++-----
 net/bridge/br_private.h   |  4 ++--
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index db4f2641d1cd..9765f9f9bf7f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1607,6 +1607,10 @@ static void br_ip6_multicast_querier_expired(struct timer_list *t)
 }
 #endif
 
+static void br_multicast_query_delay_expired(struct timer_list *t)
+{
+}
+
 static void br_multicast_select_own_querier(struct net_bridge_mcast *brmctx,
 					    struct br_ip *ip,
 					    struct sk_buff *skb)
@@ -3024,7 +3028,7 @@ br_multicast_update_query_timer(struct net_bridge_mcast *brmctx,
 				unsigned long max_delay)
 {
 	if (!timer_pending(&query->timer))
-		query->delay_time = jiffies + max_delay;
+		mod_timer(&query->delay_timer, jiffies + max_delay);
 
 	mod_timer(&query->timer, jiffies + brmctx->multicast_querier_interval);
 }
@@ -3867,13 +3871,11 @@ void br_multicast_ctx_init(struct net_bridge *br,
 	brmctx->multicast_querier_interval = 255 * HZ;
 	brmctx->multicast_membership_interval = 260 * HZ;
 
-	brmctx->ip4_other_query.delay_time = 0;
 	brmctx->ip4_querier.port_ifidx = 0;
 	seqcount_spinlock_init(&brmctx->ip4_querier.seq, &br->multicast_lock);
 	brmctx->multicast_igmp_version = 2;
 #if IS_ENABLED(CONFIG_IPV6)
 	brmctx->multicast_mld_version = 1;
-	brmctx->ip6_other_query.delay_time = 0;
 	brmctx->ip6_querier.port_ifidx = 0;
 	seqcount_spinlock_init(&brmctx->ip6_querier.seq, &br->multicast_lock);
 #endif
@@ -3882,6 +3884,8 @@ void br_multicast_ctx_init(struct net_bridge *br,
 		    br_ip4_multicast_local_router_expired, 0);
 	timer_setup(&brmctx->ip4_other_query.timer,
 		    br_ip4_multicast_querier_expired, 0);
+	timer_setup(&brmctx->ip4_other_query.delay_timer,
+		    br_multicast_query_delay_expired, 0);
 	timer_setup(&brmctx->ip4_own_query.timer,
 		    br_ip4_multicast_query_expired, 0);
 #if IS_ENABLED(CONFIG_IPV6)
@@ -3889,6 +3893,8 @@ void br_multicast_ctx_init(struct net_bridge *br,
 		    br_ip6_multicast_local_router_expired, 0);
 	timer_setup(&brmctx->ip6_other_query.timer,
 		    br_ip6_multicast_querier_expired, 0);
+	timer_setup(&brmctx->ip6_other_query.delay_timer,
+		    br_multicast_query_delay_expired, 0);
 	timer_setup(&brmctx->ip6_own_query.timer,
 		    br_ip6_multicast_query_expired, 0);
 #endif
@@ -4023,10 +4029,12 @@ static void __br_multicast_stop(struct net_bridge_mcast *brmctx)
 {
 	del_timer_sync(&brmctx->ip4_mc_router_timer);
 	del_timer_sync(&brmctx->ip4_other_query.timer);
+	del_timer_sync(&brmctx->ip4_other_query.delay_timer);
 	del_timer_sync(&brmctx->ip4_own_query.timer);
 #if IS_ENABLED(CONFIG_IPV6)
 	del_timer_sync(&brmctx->ip6_mc_router_timer);
 	del_timer_sync(&brmctx->ip6_other_query.timer);
+	del_timer_sync(&brmctx->ip6_other_query.delay_timer);
 	del_timer_sync(&brmctx->ip6_own_query.timer);
 #endif
 }
@@ -4469,13 +4477,15 @@ int br_multicast_set_querier(struct net_bridge_mcast *brmctx, unsigned long val)
 	max_delay = brmctx->multicast_query_response_interval;
 
 	if (!timer_pending(&brmctx->ip4_other_query.timer))
-		brmctx->ip4_other_query.delay_time = jiffies + max_delay;
+		mod_timer(&brmctx->ip4_other_query.delay_timer,
+			  jiffies + max_delay);
 
 	br_multicast_start_querier(brmctx, &brmctx->ip4_own_query);
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (!timer_pending(&brmctx->ip6_other_query.timer))
-		brmctx->ip6_other_query.delay_time = jiffies + max_delay;
+		mod_timer(&brmctx->ip6_other_query.delay_timer,
+			  jiffies + max_delay);
 
 	br_multicast_start_querier(brmctx, &brmctx->ip6_own_query);
 #endif
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index bd218c2b2cd9..ff10ddeeb50f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -77,7 +77,7 @@ struct bridge_mcast_own_query {
 /* other querier */
 struct bridge_mcast_other_query {
 	struct timer_list		timer;
-	unsigned long			delay_time;
+	struct timer_list		delay_timer;
 };
 
 /* selected querier */
@@ -1066,7 +1066,7 @@ __br_multicast_querier_exists(struct net_bridge_mcast *brmctx,
 		own_querier_enabled = false;
 	}
 
-	return time_is_before_jiffies(querier->delay_time) &&
+	return !timer_pending(&querier->delay_timer) &&
 	       (own_querier_enabled || timer_pending(&querier->timer));
 }
 
-- 
2.43.0



