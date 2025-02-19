Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E97C1E8326;
	Wed, 19 Feb 2025 09:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957494; cv=none; b=oSlooQkAafnZ+EspapVH18NunWQU+Okbe0a5S+BPYJMb+uPVBFrOk2rWQ1OrR0K7kNtlTnkUGINDiNPFNEgV0KzRKiDCsdAEkDNp5gjcoX298v8ce49inkdJwaFY62qNuFLYH5SE78HnnhrIkEMyYVGr8KF+mU8EBrKpieoe4zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957494; c=relaxed/simple;
	bh=GvIyji47UWh5CgbmtwEgP3bcwv8cLKxW0wEKyTYFw6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr8WAJGWab9yNYkHW9+pp5Mmt9LOboW3i5QRZEnfv2Ny3LRKwlKdBSW6HBNc+63+LRIm3mlTTQom2cA2YYZBokmC5kQTj4W+eITJ27c9hobZDjLzbXd4gFbiX+zPLyk5jFk9kApGex2ZQ4TxpoKZJHvL7T9utAw4HPIQotN285U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cH3vTp9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cH3vTp9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC46C4CED1;
	Wed, 19 Feb 2025 09:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957494;
	bh=GvIyji47UWh5CgbmtwEgP3bcwv8cLKxW0wEKyTYFw6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cH3vTp9fFVxaIvaAgt9EFoafzICVVNfFCMzaoGWFjsUPxwOkm3AnUN+sQRNB4QAcq
	 j4tieh8otOm+zlCqmiOklzWx0Pc44XCvFuMumh2jRXLqQKki73P5CBwvJa1hCoapDs
	 6Q4vO6777Dac0nYUnNrO6u2vwjSQzr/EFfPuGFGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 545/578] ipv4: use RCU protection in __ip_rt_update_pmtu()
Date: Wed, 19 Feb 2025 09:29:09 +0100
Message-ID: <20250219082714.406300300@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0bda6916ebcfb..4574dcba9f193 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1020,9 +1020,9 @@ out:	kfree_skb_reason(skb, reason);
 static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 {
 	struct dst_entry *dst = &rt->dst;
-	struct net *net = dev_net(dst->dev);
 	struct fib_result res;
 	bool lock = false;
+	struct net *net;
 	u32 old_mtu;
 
 	if (ip_mtu_locked(dst))
@@ -1032,6 +1032,8 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 	if (old_mtu < mtu)
 		return;
 
+	rcu_read_lock();
+	net = dev_net_rcu(dst->dev);
 	if (mtu < net->ipv4.ip_rt_min_pmtu) {
 		lock = true;
 		mtu = min(old_mtu, net->ipv4.ip_rt_min_pmtu);
@@ -1039,9 +1041,8 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 
 	if (rt->rt_pmtu == mtu && !lock &&
 	    time_before(jiffies, dst->expires - net->ipv4.ip_rt_mtu_expires / 2))
-		return;
+		goto out;
 
-	rcu_read_lock();
 	if (fib_lookup(net, fl4, &res, 0) == 0) {
 		struct fib_nh_common *nhc;
 
@@ -1055,14 +1056,14 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
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



