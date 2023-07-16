Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2608F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CABC433C8;
	Sun, 16 Jul 2023 20:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539761;
	bh=BkUaZCdr7Lv2FazZRT+Eo/VPuGZvhaKgOKFVNgzH7bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsOA00lSp9HoffYENPA6FmfjJWKl9KLXutjJ9LmsSLz5Bq+llpSDPuHjr7R3MpLWE
	 aq4iYMLPY/8+2bnzurXgZzz5WUemzWj0bGIOZhxmGhKsLKnZCvTrYwB+Ece7hZqcZi
	 HA7wR7h/iV70uZmeLKHBsFwQv1A/chfV14pUewF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gilad Sever <gilad9366@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shmulik Ladkani <shmulik.ladkani@gmail.com>,
	Eyal Birger <eyal.birger@gmail.com>,
	Stanislav Fomichev <sdf@google.com>,
	David Ahern <dsahern@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/591] bpf: Fix bpf socket lookup from tc/xdp to respect socket VRF bindings
Date: Sun, 16 Jul 2023 21:44:21 +0200
Message-ID: <20230716194927.031354543@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gilad Sever <gilad9366@gmail.com>

[ Upstream commit 9a5cb79762e0eda17ca15c2a6eaca4622383c21c ]

When calling bpf_sk_lookup_tcp(), bpf_sk_lookup_udp() or
bpf_skc_lookup_tcp() from tc/xdp ingress, VRF socket bindings aren't
respoected, i.e. unbound sockets are returned, and bound sockets aren't
found.

VRF binding is determined by the sdif argument to sk_lookup(), however
when called from tc the IP SKB control block isn't initialized and thus
inet{,6}_sdif() always returns 0.

Fix by calculating sdif for the tc/xdp flows by observing the device's
l3 enslaved state.

The cg/sk_skb hooking points which are expected to support
inet{,6}_sdif() pass sdif=-1 which makes __bpf_skc_lookup() use the
existing logic.

Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
Signed-off-by: Gilad Sever <gilad9366@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
Acked-by: Stanislav Fomichev <sdf@google.com>
Cc: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/bpf/20230621104211.301902-4-gilad9366@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |  9 +++++
 net/core/filter.c         | 69 ++++++++++++++++++++++-----------------
 2 files changed, 48 insertions(+), 30 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d5eb3ab8e38f2..5a04fbf724768 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -5028,6 +5028,15 @@ static inline bool netif_is_l3_slave(const struct net_device *dev)
 	return dev->priv_flags & IFF_L3MDEV_SLAVE;
 }
 
+static inline int dev_sdif(const struct net_device *dev)
+{
+#ifdef CONFIG_NET_L3_MASTER_DEV
+	if (netif_is_l3_slave(dev))
+		return dev->ifindex;
+#endif
+	return 0;
+}
+
 static inline bool netif_is_bridge_master(const struct net_device *dev)
 {
 	return dev->priv_flags & IFF_EBRIDGE;
diff --git a/net/core/filter.c b/net/core/filter.c
index 1b60a6cc975a7..da71e6812ab51 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6474,12 +6474,11 @@ static struct sock *sk_lookup(struct net *net, struct bpf_sock_tuple *tuple,
 static struct sock *
 __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 		 struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
-		 u64 flags)
+		 u64 flags, int sdif)
 {
 	struct sock *sk = NULL;
 	struct net *net;
 	u8 family;
-	int sdif;
 
 	if (len == sizeof(tuple->ipv4))
 		family = AF_INET;
@@ -6491,10 +6490,12 @@ __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 	if (unlikely(flags || !((s32)netns_id < 0 || netns_id <= S32_MAX)))
 		goto out;
 
-	if (family == AF_INET)
-		sdif = inet_sdif(skb);
-	else
-		sdif = inet6_sdif(skb);
+	if (sdif < 0) {
+		if (family == AF_INET)
+			sdif = inet_sdif(skb);
+		else
+			sdif = inet6_sdif(skb);
+	}
 
 	if ((s32)netns_id < 0) {
 		net = caller_net;
@@ -6514,10 +6515,11 @@ __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 static struct sock *
 __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 		struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
-		u64 flags)
+		u64 flags, int sdif)
 {
 	struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
-					   ifindex, proto, netns_id, flags);
+					   ifindex, proto, netns_id, flags,
+					   sdif);
 
 	if (sk) {
 		struct sock *sk2 = sk_to_full_sk(sk);
@@ -6557,7 +6559,7 @@ bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 	}
 
 	return __bpf_skc_lookup(skb, tuple, len, caller_net, ifindex, proto,
-				netns_id, flags);
+				netns_id, flags, -1);
 }
 
 static struct sock *
@@ -6649,12 +6651,13 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
 BPF_CALL_5(bpf_tc_skc_lookup_tcp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
-	struct net *caller_net = dev_net(skb->dev);
-	int ifindex = skb->dev->ifindex;
+	struct net_device *dev = skb->dev;
+	int ifindex = dev->ifindex, sdif = dev_sdif(dev);
+	struct net *caller_net = dev_net(dev);
 
 	return (unsigned long)__bpf_skc_lookup(skb, tuple, len, caller_net,
 					       ifindex, IPPROTO_TCP, netns_id,
-					       flags);
+					       flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
@@ -6672,12 +6675,13 @@ static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
 BPF_CALL_5(bpf_tc_sk_lookup_tcp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
-	struct net *caller_net = dev_net(skb->dev);
-	int ifindex = skb->dev->ifindex;
+	struct net_device *dev = skb->dev;
+	int ifindex = dev->ifindex, sdif = dev_sdif(dev);
+	struct net *caller_net = dev_net(dev);
 
 	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
 					      ifindex, IPPROTO_TCP, netns_id,
-					      flags);
+					      flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
@@ -6695,12 +6699,13 @@ static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
 BPF_CALL_5(bpf_tc_sk_lookup_udp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
-	struct net *caller_net = dev_net(skb->dev);
-	int ifindex = skb->dev->ifindex;
+	struct net_device *dev = skb->dev;
+	int ifindex = dev->ifindex, sdif = dev_sdif(dev);
+	struct net *caller_net = dev_net(dev);
 
 	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
 					      ifindex, IPPROTO_UDP, netns_id,
-					      flags);
+					      flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_tc_sk_lookup_udp_proto = {
@@ -6732,12 +6737,13 @@ static const struct bpf_func_proto bpf_sk_release_proto = {
 BPF_CALL_5(bpf_xdp_sk_lookup_udp, struct xdp_buff *, ctx,
 	   struct bpf_sock_tuple *, tuple, u32, len, u32, netns_id, u64, flags)
 {
-	struct net *caller_net = dev_net(ctx->rxq->dev);
-	int ifindex = ctx->rxq->dev->ifindex;
+	struct net_device *dev = ctx->rxq->dev;
+	int ifindex = dev->ifindex, sdif = dev_sdif(dev);
+	struct net *caller_net = dev_net(dev);
 
 	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len, caller_net,
 					      ifindex, IPPROTO_UDP, netns_id,
-					      flags);
+					      flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_xdp_sk_lookup_udp_proto = {
@@ -6755,12 +6761,13 @@ static const struct bpf_func_proto bpf_xdp_sk_lookup_udp_proto = {
 BPF_CALL_5(bpf_xdp_skc_lookup_tcp, struct xdp_buff *, ctx,
 	   struct bpf_sock_tuple *, tuple, u32, len, u32, netns_id, u64, flags)
 {
-	struct net *caller_net = dev_net(ctx->rxq->dev);
-	int ifindex = ctx->rxq->dev->ifindex;
+	struct net_device *dev = ctx->rxq->dev;
+	int ifindex = dev->ifindex, sdif = dev_sdif(dev);
+	struct net *caller_net = dev_net(dev);
 
 	return (unsigned long)__bpf_skc_lookup(NULL, tuple, len, caller_net,
 					       ifindex, IPPROTO_TCP, netns_id,
-					       flags);
+					       flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_xdp_skc_lookup_tcp_proto = {
@@ -6778,12 +6785,13 @@ static const struct bpf_func_proto bpf_xdp_skc_lookup_tcp_proto = {
 BPF_CALL_5(bpf_xdp_sk_lookup_tcp, struct xdp_buff *, ctx,
 	   struct bpf_sock_tuple *, tuple, u32, len, u32, netns_id, u64, flags)
 {
-	struct net *caller_net = dev_net(ctx->rxq->dev);
-	int ifindex = ctx->rxq->dev->ifindex;
+	struct net_device *dev = ctx->rxq->dev;
+	int ifindex = dev->ifindex, sdif = dev_sdif(dev);
+	struct net *caller_net = dev_net(dev);
 
 	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len, caller_net,
 					      ifindex, IPPROTO_TCP, netns_id,
-					      flags);
+					      flags, sdif);
 }
 
 static const struct bpf_func_proto bpf_xdp_sk_lookup_tcp_proto = {
@@ -6803,7 +6811,8 @@ BPF_CALL_5(bpf_sock_addr_skc_lookup_tcp, struct bpf_sock_addr_kern *, ctx,
 {
 	return (unsigned long)__bpf_skc_lookup(NULL, tuple, len,
 					       sock_net(ctx->sk), 0,
-					       IPPROTO_TCP, netns_id, flags);
+					       IPPROTO_TCP, netns_id, flags,
+					       -1);
 }
 
 static const struct bpf_func_proto bpf_sock_addr_skc_lookup_tcp_proto = {
@@ -6822,7 +6831,7 @@ BPF_CALL_5(bpf_sock_addr_sk_lookup_tcp, struct bpf_sock_addr_kern *, ctx,
 {
 	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len,
 					      sock_net(ctx->sk), 0, IPPROTO_TCP,
-					      netns_id, flags);
+					      netns_id, flags, -1);
 }
 
 static const struct bpf_func_proto bpf_sock_addr_sk_lookup_tcp_proto = {
@@ -6841,7 +6850,7 @@ BPF_CALL_5(bpf_sock_addr_sk_lookup_udp, struct bpf_sock_addr_kern *, ctx,
 {
 	return (unsigned long)__bpf_sk_lookup(NULL, tuple, len,
 					      sock_net(ctx->sk), 0, IPPROTO_UDP,
-					      netns_id, flags);
+					      netns_id, flags, -1);
 }
 
 static const struct bpf_func_proto bpf_sock_addr_sk_lookup_udp_proto = {
-- 
2.39.2



