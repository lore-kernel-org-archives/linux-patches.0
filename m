Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850991EA7FC;
	Wed, 19 Feb 2025 08:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955291; cv=none; b=SNxMSaZJ1DPz3pP7ByIoQe6feYQk26fFyeK9NDLZ5mHsHLVoA/nTCeYYZBfrq0tpuOyCmLyRflddZBp2A4O7VyENX8rhuiQTgvjWij5AGoqq22wZsfxfwod+LYj8tH8DbPBnaHyNFzm2lWpU+1jPvlVSoP9qdRwRq9w5iJJWTQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955291; c=relaxed/simple;
	bh=oN8SAyp5r34LtbOuL4EHi0H/SLodEqgBUyVYekcFZ1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRH+f/uk9a2vRjqaClpI3kVEMD8Djkt3v3Z6Fp6Oy4+FjI9dyQbf3XICP8vBpwtZgJwi8Xr+lf5j4jOXcOBI/ux8mxPu0BYgqZJ6q/9vmonvs2kmsKUeLEnBf/zCn6Ksvt0KozSDgfnJKHSwIB8AFVXn0zzEIghXR1SiTzPB5II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoL1O0LZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoL1O0LZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCC1C4CEE7;
	Wed, 19 Feb 2025 08:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955291;
	bh=oN8SAyp5r34LtbOuL4EHi0H/SLodEqgBUyVYekcFZ1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KoL1O0LZJCjOgVcWsEmwmB18rbr1kUa4gUKODSHZRKSfgEGcmJPCO9KlohKjmGoBa
	 Z8TxaFCWjkGBVomGa/w9qUoK+Z7fMDbXHNKleR8QCQ7cE+ZAX3Y4U1zDA0K85uZJGM
	 c92Mj6jSQepQ1PK+6OBvlPiRWcjOil+I4R4WlLcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 191/230] flow_dissector: use RCU protection to fetch dev_net()
Date: Wed, 19 Feb 2025 09:28:28 +0100
Message-ID: <20250219082609.171507790@linuxfoundation.org>
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
index 0e638a37aa096..5db41bf2ed93e 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1108,10 +1108,12 @@ bool __skb_flow_dissect(const struct net *net,
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
@@ -1122,7 +1124,6 @@ bool __skb_flow_dissect(const struct net *net,
 		enum netns_bpf_attach_type type = NETNS_BPF_FLOW_DISSECTOR;
 		struct bpf_prog_array *run_array;
 
-		rcu_read_lock();
 		run_array = rcu_dereference(init_net.bpf.run_array[type]);
 		if (!run_array)
 			run_array = rcu_dereference(net->bpf.run_array[type]);
@@ -1150,17 +1151,17 @@ bool __skb_flow_dissect(const struct net *net,
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



