Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923AB12E71;
	Sat,  3 Feb 2024 04:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933468; cv=none; b=J8mIQ+kpSVBJBHqLqf+qjRaYotHH09nhYvQCEQFs5QBD6bryGSuw41/iKP5WD5WCCRQ9NQG3a/KnsI99cXfM3D04IPWKPs7tix8E6PlCOr9bc14jkHzvpKoqWCrihOpn4guvgZLmo1gPK5257xT1DhIYcXszLyxcji6Wua4+zdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933468; c=relaxed/simple;
	bh=tQIIz2CupsFokNQ6O869pLju6BeLAm6vP47rwcK1wwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N7slQsE2D1I3r4wY36RX2ViV5xIKSS+PApd4ltboMeScamlzYo3m9FgQiFdHqfw1HKgkibKGswv4PCr8lyEWXj9LuKTfUNwY5fCNe98HlVWVmsK8X1ABGtU3FmjhukUeWnJBanVC7CtwwK5uzYCoSKq7JeW4NwPbjmBxwqNrbXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smC9Krgo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smC9Krgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9EDC433F1;
	Sat,  3 Feb 2024 04:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933468;
	bh=tQIIz2CupsFokNQ6O869pLju6BeLAm6vP47rwcK1wwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smC9KrgoY/r1V5H1A2dCry9eHizn5El+MSHlj7vgoC9ZyjvNrbHkbIlTm/srTeGNU
	 dLeGR7fLEKfJryIXQ1LCP0AMoJOy+MkbNfRRIgsmAkS4gapB8bbKePf3zyh4/WgK7E
	 LzKBMPNluMy8I1aWhOJjNNbjzPhHHSeAkPOUyR58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 201/219] bridge: mcast: fix disabled snooping after long uptime
Date: Fri,  2 Feb 2024 20:06:14 -0800
Message-ID: <20240203035345.396818181@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 06e5f6faa431..51d010f64e06 100644
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
@@ -1083,7 +1083,7 @@ __br_multicast_querier_exists(struct net_bridge_mcast *brmctx,
 		own_querier_enabled = false;
 	}
 
-	return time_is_before_jiffies(querier->delay_time) &&
+	return !timer_pending(&querier->delay_timer) &&
 	       (own_querier_enabled || timer_pending(&querier->timer));
 }
 
-- 
2.43.0



