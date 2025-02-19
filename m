Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1A81E98E8;
	Wed, 19 Feb 2025 08:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955285; cv=none; b=ScuzFcQ0G0PyRIGT0rCgc1dWLbRJzS8NXHQLDUikdZLqfMw/ElqXMDLOK598jSZqy2wYps1Uo4YoUFfA6GT5Edk+x287mq1nK/ffVzVkUebg4Sdpbg7oWV3S1vDrcbPNQv66fCrF6RG0EdID4HGHK8R/zBe8WbEXX6DS8WEx6MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955285; c=relaxed/simple;
	bh=SaALOE5ycBD0GUUXJR/xbWiJGBR21FmRQzF+b8r14RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/VAeMhG6Ei6W41tA5BGVrjkI7KHhVDQ4haKEXDPXZbTX2di22A4gIl+9TEF1ybBnM62McaVAW+HC9sNj0ARpBFaCV6RHPmHiesa9ihBr74jjkarW8C/kHkKwD1ogZ7zE93omvwcq0x48JKKG7kMaDk+Dls2vBOH5yxpLmnq2bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQcn4P8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQcn4P8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C072C4CEE6;
	Wed, 19 Feb 2025 08:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955285;
	bh=SaALOE5ycBD0GUUXJR/xbWiJGBR21FmRQzF+b8r14RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQcn4P8owscP59jZTlm3bQ/M18JdY+6B+ufWlXrSfR0YSCaJweSgkUa9Mou4WRoMv
	 49CvaCQ+hVfiZG9Ej6jMbl3p9FXjZA6tKEjuMQJWssSZ4RwKSLhrtxMZzUKcx20InM
	 j/LiUpcrMcuUcSiWzNLXdev/dNxW71ADCGOJTyfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 189/230] ipv4: use RCU protection in __ip_rt_update_pmtu()
Date: Wed, 19 Feb 2025 09:28:26 +0100
Message-ID: <20250219082609.094731819@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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
index f707cdb26ff20..41b320f0c20eb 100644
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



