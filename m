Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0B61DF27F;
	Wed, 19 Feb 2025 08:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954493; cv=none; b=JNXfS+hICMbdYXLy910t5xuQh74lGPWgf6YkXmR6/nqpTFFalgtwh+jeyPkI0SYMJhTfZYj1r2GY4E42sYX7VsIwaYVmrsoamjbNKuZWp3o5biNlTAhe60/WhpgKd3OaYEJmYkR+Q2rC6MUcLyV/1yZmADlsdxC1RkoK4TIZvsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954493; c=relaxed/simple;
	bh=Zg+ftvf6LvHJjBTGJrNT+qaWgkGov0gjwHaRPJAAeXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfWtYOOWDnPEs452oP4nst52Vis+dJOf+tGIwSeGKHy4jJx9Lb/V5pM+xhTOad4NiQRPgV/nhZ5KqX4MDWp4e3afeKFqcbWm76RH/vXr7uKV6E8A03LxyXbjVs2zcLok3J/eZwSbuUyZvgYumheiHezHND/2Zn2lq7I7jpH3l+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kow0qVRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kow0qVRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCB7C4CEE7;
	Wed, 19 Feb 2025 08:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954493;
	bh=Zg+ftvf6LvHJjBTGJrNT+qaWgkGov0gjwHaRPJAAeXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kow0qVRdEC2LKPiwFPu5GGXjizS1V9LrhUArFZWq8uBGfZEVsb+9hxDhjsKGOqn2X
	 oungxS8v17YiFzSvhVXv/YP9R2qdjdjpmXpWvnLOePch3my1w4p2f1EcKHo5p3vsx8
	 fG8aJW/sIj71g++rCk0vDJDr41d7aHXmZ68XVmMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 220/274] ipv4: use RCU protection in __ip_rt_update_pmtu()
Date: Wed, 19 Feb 2025 09:27:54 +0100
Message-ID: <20250219082618.187227685@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 152697459e918..cf84704af25c3 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1008,9 +1008,9 @@ out:	kfree_skb_reason(skb, reason);
 static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 {
 	struct dst_entry *dst = &rt->dst;
-	struct net *net = dev_net(dst->dev);
 	struct fib_result res;
 	bool lock = false;
+	struct net *net;
 	u32 old_mtu;
 
 	if (ip_mtu_locked(dst))
@@ -1020,6 +1020,8 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 	if (old_mtu < mtu)
 		return;
 
+	rcu_read_lock();
+	net = dev_net_rcu(dst->dev);
 	if (mtu < net->ipv4.ip_rt_min_pmtu) {
 		lock = true;
 		mtu = min(old_mtu, net->ipv4.ip_rt_min_pmtu);
@@ -1027,9 +1029,8 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 
 	if (rt->rt_pmtu == mtu && !lock &&
 	    time_before(jiffies, dst->expires - net->ipv4.ip_rt_mtu_expires / 2))
-		return;
+		goto out;
 
-	rcu_read_lock();
 	if (fib_lookup(net, fl4, &res, 0) == 0) {
 		struct fib_nh_common *nhc;
 
@@ -1043,14 +1044,14 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
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



