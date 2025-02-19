Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451581DF738;
	Wed, 19 Feb 2025 08:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954500; cv=none; b=CVVoGdiHmncWJPe56wICYLKP3T+nI+QTixIH/VuE5Tvy4cckMb74RPOGR8VrBIes8xLX99v0iI+CElCc+L3XUqSn9XNP+OkUlQZXfQv226lOq0n33XEGdUnX/Lt1TBnWgnxc4YqH/IahMFG2XkJiSvjAvU4IZI2tCNs2YGvJYCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954500; c=relaxed/simple;
	bh=OTf3XuLswm4F62TDNrzIRjXFhaf9GmpTknW1zwR9eVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBVEgd70gISD2WayATvLT3Z12InTe8puiwfRrX4D/9Qruda4ZmqGdilL+zZnPuN/tf06fHHwSeAUAddgPxS7ag+Evc6Da7yDgpJtTDlse03Waq2UDEYT8NOXu//ghlU9D5VMpOUoS1jVWEf0co9i5vMq5gwSW7eYxgFIUmC7K7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZD+nCerC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZD+nCerC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6EAC4CEE7;
	Wed, 19 Feb 2025 08:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954499;
	bh=OTf3XuLswm4F62TDNrzIRjXFhaf9GmpTknW1zwR9eVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZD+nCerCvL97pu/fAnabTfBTDX9Pnr8YgR84uZw047bSEzsvjkAe66h+NyNRTiWcl
	 B8yp36w7q2LmCG8QxLMttNii5EMst9v0gTex3RU1A1/2yXMdIgIdO3WsDBlQWbpIVA
	 uDOgYM6dvs6Ub11BAKeByqfHqkqbvfy7lHgy8ylk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 222/274] flow_dissector: use RCU protection to fetch dev_net()
Date: Wed, 19 Feb 2025 09:27:56 +0100
Message-ID: <20250219082618.264856080@linuxfoundation.org>
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



