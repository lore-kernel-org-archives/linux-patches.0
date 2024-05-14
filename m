Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC0E58AC4;
	Tue, 14 May 2024 11:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684762; cv=none; b=ZuSiDgK3TrJj7Jxi/0TJApGGoYLb96XznjWB8yVbO7Q38Lfru2AvxaCZGBmjj1JkjAyx37J3Wr77YlhkjT9C9KUbrAnN2mxbqW10rTn813ZxJtSOwB7fZ9zk9rMQPpXTtGuRTS4sI8zLlobUW36IOI68K14YJzHNt9SI5cVa0b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684762; c=relaxed/simple;
	bh=wnxkFZ8cdMzo2TgGZFwgnsgCuH5UZt+0IbB6Tf7EtIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBZNCLJTG+F5QDNrb8EJHyFkoHOuFzbIFBOLKjfdruihkGkCtcy8/xwnyAn6oE3ptRpT34RPjtP6vx/yk9U8vkYm2bXQR78VLsp3cOOlzeSoZiQr2yzQDSrrLQGtqNyO0POtp9uDaXjPxhU1q3Lr8FpL2qm5RjzPilaEorXoWqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlwlc5jU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlwlc5jU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051C9C2BD10;
	Tue, 14 May 2024 11:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684762;
	bh=wnxkFZ8cdMzo2TgGZFwgnsgCuH5UZt+0IbB6Tf7EtIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlwlc5jUJnHjXH1j5aCAYJQG4DKhPqTc/g5TX2YpCbtWElnJHRu7v/O3ZLoDLBVWF
	 996KfXsbSRsyGTsvXeuxiWizXBEPcme5QVGJJ6YaUJrFk1ZUIPYg1hIsNje7YqOM9J
	 8Z/Jms15M2aKIFplSqwoPK4oqFibIzKAtOwOFoqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Gobert <richardbgobert@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 086/301] net: gro: parse ipv6 ext headers without frag0 invalidation
Date: Tue, 14 May 2024 12:15:57 +0200
Message-ID: <20240514101035.493829758@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Richard Gobert <richardbgobert@gmail.com>

[ Upstream commit dff0b0161ad571f888d37f5e7163a07dcafdef60 ]

The existing code always pulls the IPv6 header and sets the transport
offset initially. Then optionally again pulls any extension headers in
ipv6_gso_pull_exthdrs and sets the transport offset again on return from
that call. skb->data is set at the start of the first extension header
before calling ipv6_gso_pull_exthdrs, and must disable the frag0
optimization because that function uses pskb_may_pull/pskb_pull instead of
skb_gro_ helpers. It sets the GRO offset to the TCP header with
skb_gro_pull and sets the transport header. Then returns skb->data to its
position before this block.

This commit introduces a new helper function - ipv6_gro_pull_exthdrs -
which is used in ipv6_gro_receive to pull ipv6 ext headers instead of
ipv6_gso_pull_exthdrs. Thus, there is no modification of skb->data, all
operations use skb_gro_* helpers, and the frag0 fast path can be taken for
IPv6 packets with ext headers.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/504130f6-b56c-4dcc-882c-97942c59f5b7@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5ef31ea5d053 ("net: gro: fix udp bad offset in socket lookup by adding {inner_}network_offset to napi_gro_cb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_offload.c | 51 +++++++++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index d6314287338da..f6e5fcdf041d1 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -37,6 +37,40 @@
 		INDIRECT_CALL_L4(cb, f2, f1, head, skb);	\
 })
 
+static int ipv6_gro_pull_exthdrs(struct sk_buff *skb, int off, int proto)
+{
+	const struct net_offload *ops = NULL;
+	struct ipv6_opt_hdr *opth;
+
+	for (;;) {
+		int len;
+
+		ops = rcu_dereference(inet6_offloads[proto]);
+
+		if (unlikely(!ops))
+			break;
+
+		if (!(ops->flags & INET6_PROTO_GSO_EXTHDR))
+			break;
+
+		opth = skb_gro_header(skb, off + sizeof(*opth), off);
+		if (unlikely(!opth))
+			break;
+
+		len = ipv6_optlen(opth);
+
+		opth = skb_gro_header(skb, off + len, off);
+		if (unlikely(!opth))
+			break;
+		proto = opth->nexthdr;
+
+		off += len;
+	}
+
+	skb_gro_pull(skb, off - skb_network_offset(skb));
+	return proto;
+}
+
 static int ipv6_gso_pull_exthdrs(struct sk_buff *skb, int proto)
 {
 	const struct net_offload *ops = NULL;
@@ -206,28 +240,25 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 		goto out;
 
 	skb_set_network_header(skb, off);
-	skb_gro_pull(skb, sizeof(*iph));
-	skb_set_transport_header(skb, skb_gro_offset(skb));
 
-	flush += ntohs(iph->payload_len) != skb_gro_len(skb);
+	flush += ntohs(iph->payload_len) != skb->len - hlen;
 
 	proto = iph->nexthdr;
 	ops = rcu_dereference(inet6_offloads[proto]);
 	if (!ops || !ops->callbacks.gro_receive) {
-		pskb_pull(skb, skb_gro_offset(skb));
-		skb_gro_frag0_invalidate(skb);
-		proto = ipv6_gso_pull_exthdrs(skb, proto);
-		skb_gro_pull(skb, -skb_transport_offset(skb));
-		skb_reset_transport_header(skb);
-		__skb_push(skb, skb_gro_offset(skb));
+		proto = ipv6_gro_pull_exthdrs(skb, hlen, proto);
 
 		ops = rcu_dereference(inet6_offloads[proto]);
 		if (!ops || !ops->callbacks.gro_receive)
 			goto out;
 
-		iph = ipv6_hdr(skb);
+		iph = skb_gro_network_header(skb);
+	} else {
+		skb_gro_pull(skb, sizeof(*iph));
 	}
 
+	skb_set_transport_header(skb, skb_gro_offset(skb));
+
 	NAPI_GRO_CB(skb)->proto = proto;
 
 	flush--;
-- 
2.43.0



