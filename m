Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F0447F78D;
	Thu, 20 Aug 2026 17:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247746; cv=none; b=q1rOfSmj0tAWRC58Y6gDmwJZrR2KxPBrJNAqdPk+lpydMl7dPuJjHBwFE5wYLAuEgbMOKB20oXLcjvrqh9gbDfUtOt6Ao9nB6QSHu+IufmJcgvf3+4aarmjQGvO271RqR5SlV8qOENyfY3FEXdfwQ38Ji18kaG69YmdRgJ9pdps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247746; c=relaxed/simple;
	bh=qm6u2iH0QO3Rn+eDeT2W59Bn6Mhgml0sNg/pMWi87ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/MGIlhcomCN7uIHr+iP4azPcFN7gS7isijvZAyXIGoJ7TwDM/VbcnKf4+u14mEfK4QJM65x9D5QrqBtM1HoqycMaWn0l00HFvESadr3qctRn4cOOEQxtszmBntdu5MJyWly3UbI+LdxmIj4/Wp2hMcaljSARsYHM0OF2DxeXek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2n0p/BU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2n0p/BU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDC01F000E9;
	Thu, 20 Aug 2026 17:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247745;
	bh=s3+Oc+EgP3wZbb+CZOVriHS+CS8GIzsqMQunMSzR+hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2n0p/BU8I79RAi4RmnftUNdFqvq2+32a0n0ULueVxYqX+gBgbWnNWvbRTUJ4jMuz
	 DIw2+uMmZPIWRrlRc80gmH03cfpIah36ilYpKO3ut0n4QJEwvUGoFGihASr7bl7cGu
	 +/EusEPzYSn2pAFFsqYK5YqBPZ8vtOSCQmJu1Ytk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Yan Zhai <yan@cloudflare.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/166] packet: add a generic drop reason for receive
Date: Thu, 20 Aug 2026 16:56:52 +0200
Message-ID: <20260820145215.769498021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Yan Zhai <yan@cloudflare.com>

[ Upstream commit 2f57dd94bdef083855366138646b26b05f410d99 ]

Commit da37845fdce2 ("packet: uses kfree_skb() for errors.") switches
from consume_skb to kfree_skb to improve error handling. However, this
could bring a lot of noises when we monitor real packet drops in
kfree_skb[1], because in tpacket_rcv or packet_rcv only packet clones
can be freed, not actual packets.

Adding a generic drop reason to allow distinguish these "clone drops".

[1]: https://lore.kernel.org/netdev/CABWYdi00L+O30Q=Zah28QwZ_5RU-xcxLFUK2Zj08A8MrLk9jzg@mail.gmail.com/
Fixes: da37845fdce2 ("packet: uses kfree_skb() for errors.")
Suggested-by: Eric Dumazet <edumazet@google.com>
Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Yan Zhai <yan@cloudflare.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/ZW4piNbx3IenYnuw@debian.debian
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f60b396ee174 ("net/sched: act_api: fix TOCTOU NULL deref on a->goto_chain")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dropreason-core.h |  6 ++++++
 net/packet/af_packet.c        | 20 +++++++-------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index 845dce805de7f..6ff543fe8a8b5 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -81,6 +81,7 @@
 	FN(IPV6_NDISC_NS_OTHERHOST)	\
 	FN(QUEUE_PURGE)			\
 	FN(TC_ERROR)			\
+	FN(PACKET_SOCK_ERROR)		\
 	FNe(MAX)
 
 /**
@@ -348,6 +349,11 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_QUEUE_PURGE,
 	/** @SKB_DROP_REASON_TC_ERROR: generic internal tc error. */
 	SKB_DROP_REASON_TC_ERROR,
+	/**
+	 * @SKB_DROP_REASON_PACKET_SOCK_ERROR: generic packet socket errors
+	 * after its filter matches an incoming packet.
+	 */
+	SKB_DROP_REASON_PACKET_SOCK_ERROR,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of core drop reasons, which
 	 * shouldn't be used as a real 'reason' - only for tracing code gen
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 455a70aa9a9e9..116578fbd9a1c 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2186,13 +2186,13 @@ static int packet_rcv_vnet(struct msghdr *msg, const struct sk_buff *skb,
 static int packet_rcv(struct sk_buff *skb, struct net_device *dev,
 		      struct packet_type *pt, struct net_device *orig_dev)
 {
+	enum skb_drop_reason drop_reason = SKB_CONSUMED;
 	struct sock *sk;
 	struct sockaddr_ll *sll;
 	struct packet_sock *po;
 	u8 *skb_head = skb->data;
 	int skb_len = skb->len;
 	unsigned int snaplen, res;
-	bool is_drop_n_account = false;
 
 	if (skb->pkt_type == PACKET_LOOPBACK)
 		goto drop;
@@ -2282,9 +2282,9 @@ static int packet_rcv(struct sk_buff *skb, struct net_device *dev,
 	return 0;
 
 drop_n_acct:
-	is_drop_n_account = true;
 	atomic_inc(&po->tp_drops);
 	atomic_inc(&sk->sk_drops);
+	drop_reason = SKB_DROP_REASON_PACKET_SOCK_ERROR;
 
 drop_n_restore:
 	if (skb_head != skb->data && skb_shared(skb)) {
@@ -2292,16 +2292,14 @@ static int packet_rcv(struct sk_buff *skb, struct net_device *dev,
 		skb->len = skb_len;
 	}
 drop:
-	if (!is_drop_n_account)
-		consume_skb(skb);
-	else
-		kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return 0;
 }
 
 static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 		       struct packet_type *pt, struct net_device *orig_dev)
 {
+	enum skb_drop_reason drop_reason = SKB_CONSUMED;
 	struct sock *sk;
 	struct packet_sock *po;
 	struct sockaddr_ll *sll;
@@ -2315,7 +2313,6 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	struct sk_buff *copy_skb = NULL;
 	struct timespec64 ts;
 	__u32 ts_status;
-	bool is_drop_n_account = false;
 	unsigned int slot_id = 0;
 	int vnet_hdr_sz = 0;
 
@@ -2568,19 +2565,16 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 		skb->len = skb_len;
 	}
 drop:
-	if (!is_drop_n_account)
-		consume_skb(skb);
-	else
-		kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return 0;
 
 drop_n_account:
 	spin_unlock(&sk->sk_receive_queue.lock);
 	atomic_inc(&po->tp_drops);
-	is_drop_n_account = true;
+	drop_reason = SKB_DROP_REASON_PACKET_SOCK_ERROR;
 
 	sk->sk_data_ready(sk);
-	kfree_skb(copy_skb);
+	kfree_skb_reason(copy_skb, drop_reason);
 	goto drop_n_restore;
 }
 
-- 
2.53.0



