Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700983BF699;
	Sat, 17 Oct 2026 17:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259394; cv=none; b=YK7Peiaa1ShwvaspBLkQO17pVDdFxjUaUCmpnYwKSoEQBR4xJhk1wCqAUYiXzh4kNArnR0fKYGzC59IrEiBtRSiYSODHW8zctSGjppmHT14FZB2uQTP+/9OOFw1pKVgNw6pLr+6Y/Kgh8KMXiB9hB7uiqWvc0zoS4fLtwjgtYoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259394; c=relaxed/simple;
	bh=93cbIqXRG/jaOobSFdX31DsVkJF/BkMFywBHCgaoNns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+/U2Bf71SFbmJYwvz6ZOYcoDrA5AM9MOLzEBZbaFPpTnOU81k9Cq6hmsPONkO0X6GZfkTP6Rugn67tNd/U2c2oq493ByZA8HgIjzIs1h3vpoEgEEi8b/2qZLTqB4OdRdMpC5ICiuOiz1/gBWjjMuXj8N7idOJ1X7Vk/mRZzvZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=piy9r9At; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="piy9r9At"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0691F000C4;
	Sat, 17 Oct 2026 17:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259393;
	bh=YH2oNqTYMqRSXRMdIXO6FDp/SfrhSlo9s2cwv+nooyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=piy9r9AtwVvPXZuwWZzmcDYbny04OW2QLzAwarFr8z/SuF/MpaCWjsnVS1DFr/pw0
	 Vi4GI9GPROEsjzoYbq8hCoihCAxYSCg9BsJUrvO2uRMQlxrwztECHAvpfid4a6JLR0
	 yknsPl1n7BGyxRZV+agb96u0rB1en3SCUqRGcKPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+76d4e3a055aec3b007ec@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1200/1674] netfilter: nf_flow_table: drop existing skb dst before skb_dst_set_noref()
Date: Sat, 17 Oct 2026 17:57:52 +0200
Message-ID: <20261017160501.939494988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8aecf0bbcc72605592134c917c222207d8f63ab0 ]

Incoming skbs passing through netfilter flowtable offload hooks (or XFRM
offload path) might already carry a ref-counted dst_entry assigned during
earlier RX or routing steps.

Calling skb_dst_set_noref() when skb already holds a ref-counted dst
overwrites skb->_skb_refdst, leaking the previous dst_entry reference
count and triggering a DEBUG_NET_WARN_ON_ONCE assertion in
skb_dst_check_unset():

  WARNING: at skb_dst_check_unset include/linux/skbuff.h:1170
  WARNING: at skb_dst_set_noref include/linux/skbuff.h:1234
  WARNING: at nf_flow_offload_ip_hook+0xf6c/0x2b60 net/netfilter/nf_flow_table_ip.c:864

Drop any existing dst_entry reference with skb_dst_drop(skb) before
setting the non-referenced flowtable destination.

Fixes: 2a79fd3908ac ("netfilter: nf_flow_table: attach dst to skbs")
Reported-by: syzbot+76d4e3a055aec3b007ec@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a71b141.9511d2ce.1fc5b9.033b.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Link: https://patch.msgid.link/20260804093328.1831847-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 20dd4eeac78b1..6e6d036fe1391 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -268,6 +268,7 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 				      struct dst_entry *dst)
 {
 	skb_orphan(skb);
+	skb_dst_drop(skb);
 	skb_dst_set_noref(skb, dst);
 	dst_output(state->net, state->sk, skb);
 	return NF_STOLEN;
@@ -453,6 +454,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		outdev = rt->dst.dev;
 		skb->dev = outdev;
 		nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 		neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
 		ret = NF_STOLEN;
@@ -748,6 +750,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		outdev = rt->dst.dev;
 		skb->dev = outdev;
 		nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 		neigh_xmit(NEIGH_ND_TABLE, outdev, nexthop, skb);
 		ret = NF_STOLEN;
-- 
2.53.0



