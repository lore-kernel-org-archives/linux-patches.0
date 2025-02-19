Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333141BD9C6;
	Wed, 19 Feb 2025 09:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957500; cv=none; b=KK/aKm0e11GLFhUqVqlqutwc52T8SMLhjrP8kCCzoo9hVZGmyK3RWYMFpYcHGrFniXu/16mEKJ/xbE1+T81rKzIUB7cA+RPLxfpxPdqJ7g+2dawhNKtEPSoyjE24H6zqaZROnZTf/HahDs2Vuo2UMaVshCV0Zw/Wm0h3ZJUFr/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957500; c=relaxed/simple;
	bh=xXJYytYvp+hNZuO3qk34j4PkmjZJChpopLJLG8CKepY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sD6MgUL60pLYT9l1/tbPqAJRxb9RhLtmVGzvTet5xa/Ft+bhaAhb5TDLOYGHXlwAfsZBscsstLO+foDTjWtX9V2013jzl5JwOJxPxQC6iFSMzI+va1/Fr5E/QLpKKKcwaGSSBSVLqGzmrUCYrZX3xPN/gzwptJ9RCWhVXYqefFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=og/qujKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="og/qujKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5937EC4CED1;
	Wed, 19 Feb 2025 09:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957499;
	bh=xXJYytYvp+hNZuO3qk34j4PkmjZJChpopLJLG8CKepY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=og/qujKWZ894MBRbeytZGcGDECGpglFY4osqXWg2CcW2bBkiiQBHbakkKbsG8on9d
	 hwVJ/9R6v7MjlGWkqzdJ1TAH9V4LUpWsfNNurkLYSxlywO9YgPMUwPudORmf6tsvJN
	 a7eY6s1OIMWdzCSqXxCpRP3g24Aedq00M9dtPmmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 547/578] flow_dissector: use RCU protection to fetch dev_net()
Date: Wed, 19 Feb 2025 09:29:11 +0100
Message-ID: <20250219082714.483504907@linuxfoundation.org>
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

[ Upstream commit afec62cd0a4191cde6dd3a75382be4d51a38ce9b ]

__skb_flow_dissect() can be called from arbitrary contexts.

It must extend its RCU protection section to include
the call to dev_net(), which can become dev_net_rcu().

This makes sure the net structure can not disappear under us.

Fixes: 9b52e3f267a6 ("flow_dissector: handle no-skb use case")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-10-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index fba8eb1bb2815..de17f13232381 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1004,10 +1004,12 @@ bool __skb_flow_dissect(const struct net *net,
 					      FLOW_DISSECTOR_KEY_BASIC,
 					      target_container);
 
+	rcu_read_lock();
+
 	if (skb) {
 		if (!net) {
 			if (skb->dev)
-				net = dev_net(skb->dev);
+				net = dev_net_rcu(skb->dev);
 			else if (skb->sk)
 				net = sock_net(skb->sk);
 		}
@@ -1018,7 +1020,6 @@ bool __skb_flow_dissect(const struct net *net,
 		enum netns_bpf_attach_type type = NETNS_BPF_FLOW_DISSECTOR;
 		struct bpf_prog_array *run_array;
 
-		rcu_read_lock();
 		run_array = rcu_dereference(init_net.bpf.run_array[type]);
 		if (!run_array)
 			run_array = rcu_dereference(net->bpf.run_array[type]);
@@ -1046,17 +1047,17 @@ bool __skb_flow_dissect(const struct net *net,
 			prog = READ_ONCE(run_array->items[0].prog);
 			result = bpf_flow_dissect(prog, &ctx, n_proto, nhoff,
 						  hlen, flags);
-			if (result == BPF_FLOW_DISSECTOR_CONTINUE)
-				goto dissect_continue;
-			__skb_flow_bpf_to_target(&flow_keys, flow_dissector,
-						 target_container);
-			rcu_read_unlock();
-			return result == BPF_OK;
+			if (result != BPF_FLOW_DISSECTOR_CONTINUE) {
+				__skb_flow_bpf_to_target(&flow_keys, flow_dissector,
+							 target_container);
+				rcu_read_unlock();
+				return result == BPF_OK;
+			}
 		}
-dissect_continue:
-		rcu_read_unlock();
 	}
 
+	rcu_read_unlock();
+
 	if (dissector_uses_key(flow_dissector,
 			       FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
 		struct ethhdr *eth = eth_hdr(skb);
-- 
2.39.5



