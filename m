Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B50A233D86;
	Mon, 10 Mar 2025 18:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630424; cv=none; b=cj8PpkPAzII139+ca+CHFWIpKzmNXN34FmvwPj8N8q5s53zha2HAyg6kjwiz9W/EvvWlhUUB8bs8qhP8UAvN413WGiXJ0nlwqAuzOKg8/N2XBYBir0On28xlIOjBdDqtBKx4jwGhww5Qm50XTP0yrbl5IeAoVBrS3a09kBfMaJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630424; c=relaxed/simple;
	bh=zpayB7jgpI1oNYvn/tks9gVIHuFivmpkJkesvyg/FfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTAAM7u/2vwU/uSzIH0F1gJV3sdAOkiXWrlNpVEWkyD9zTIiHvcABSRc9a0ICyY+Xoub3mMk0iZG/9FRBztqf0skz8wg5I9KM40kX+21DVkHMS6OoK1fOEq9/q6V+8OqPti11oaZxYwcMk0WwtUiSK9O3x+x8TPqiMJLtejpDWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pUD8RVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pUD8RVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201D7C4CEE5;
	Mon, 10 Mar 2025 18:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630423;
	bh=zpayB7jgpI1oNYvn/tks9gVIHuFivmpkJkesvyg/FfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pUD8RVqHvOvi9wf0jZhQ18X0xQLpHW7XduM4m8T2HjjcYtZK3qYSf2oKSb1kkLHD
	 1T917N37Csf1ejTwONGUbyNquWjMiuwQz++T9Tpt30LfMmA7WlnoogIpA6C/FOBO4n
	 EyVheUAJQUitY3TjqHZhTd6a9Y025y0NG4HcJ+eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 401/620] ipv4: use RCU protection in __ip_rt_update_pmtu()
Date: Mon, 10 Mar 2025 18:04:07 +0100
Message-ID: <20250310170601.421198863@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 139512191bd06f1b496117c76372b2ce372c9a41 ]

__ip_rt_update_pmtu() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: 2fbc6e89b2f1 ("ipv4: Update exception handling for multipath routes via same device")
Fixes: 1de6b15a434c ("Namespaceify min_pmtu sysctl")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250205155120.1676781-8-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 2ae9d2855efab..a4884d434038e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1023,9 +1023,9 @@ out:	kfree_skb(skb);
 static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 {
 	struct dst_entry *dst = &rt->dst;
-	struct net *net = dev_net(dst->dev);
 	struct fib_result res;
 	bool lock = false;
+	struct net *net;
 	u32 old_mtu;
 
 	if (ip_mtu_locked(dst))
@@ -1035,6 +1035,8 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 	if (old_mtu < mtu)
 		return;
 
+	rcu_read_lock();
+	net = dev_net_rcu(dst->dev);
 	if (mtu < net->ipv4.ip_rt_min_pmtu) {
 		lock = true;
 		mtu = min(old_mtu, net->ipv4.ip_rt_min_pmtu);
@@ -1042,9 +1044,8 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 
 	if (rt->rt_pmtu == mtu && !lock &&
 	    time_before(jiffies, dst->expires - net->ipv4.ip_rt_mtu_expires / 2))
-		return;
+		goto out;
 
-	rcu_read_lock();
 	if (fib_lookup(net, fl4, &res, 0) == 0) {
 		struct fib_nh_common *nhc;
 
@@ -1058,14 +1059,14 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 				update_or_create_fnhe(nhc, fl4->daddr, 0, mtu, lock,
 						      jiffies + net->ipv4.ip_rt_mtu_expires);
 			}
-			rcu_read_unlock();
-			return;
+			goto out;
 		}
 #endif /* CONFIG_IP_ROUTE_MULTIPATH */
 		nhc = FIB_RES_NHC(res);
 		update_or_create_fnhe(nhc, fl4->daddr, 0, mtu, lock,
 				      jiffies + net->ipv4.ip_rt_mtu_expires);
 	}
+out:
 	rcu_read_unlock();
 }
 
-- 
2.39.5



