Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A89194A45;
	Tue, 27 May 2025 17:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368366; cv=none; b=G9f0jWvdBNio6aidq8aV66uygcRZVbdcAvhL56FcDRz7LVtrBzLntRg1jbrxagiBb/kFgSRBK12GEqCigtHKdoIOZs7qmK8TMHUtBcECS6Fn9MnlT3Xfz5DqFCGkVPwRz6nvZgYrCNT4/7A9S5pxYql7CRt9dqZ2stRdsMCa8ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368366; c=relaxed/simple;
	bh=7PNloi1VkdJcJg3Ddzw3LZKz1Nc008L9aLZswh9Jvx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3GZSv2ce8pKnNiCWV/FwMtIhMzWUpcy2c7w7G6OKYd2QePZW2nCfykw6amh1YhfbBm0kUCayFKHfPq1qL3DqF9G99Kn+nZSO1hecel4M/0fM+dfk2uKf2IjWQW6asekWx+gGleRfNIYc3WgSyHI5szg5htiqeTv/cwCUMdYqq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTSET7xT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTSET7xT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F08C4CEE9;
	Tue, 27 May 2025 17:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368366;
	bh=7PNloi1VkdJcJg3Ddzw3LZKz1Nc008L9aLZswh9Jvx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTSET7xTfo7vKny29F2n/IkRWgN60zlg2nTubeJUBUl4b3BgMyfWROvE6yjy0JX1j
	 C6VEzSgQt8hiPzu3iZ4DwW25Sgx14DWTvvB6uDOYNH1m+xSLgeof0ENY/YQs8oxP+M
	 xNgry8V704x4Diz6HjMF7X+k2SILmVslFYsixi2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Brunner <tobias@strongswan.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 684/783] xfrm: Fix UDP GRO handling for some corner cases
Date: Tue, 27 May 2025 18:28:01 +0200
Message-ID: <20250527162540.984349814@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Brunner <tobias@strongswan.org>

[ Upstream commit e3fd0577768584ece824c8b661c40fb3d912812a ]

This fixes an issue that's caused if there is a mismatch between the data
offset in the GRO header and the length fields in the regular sk_buff due
to the pskb_pull()/skb_push() calls.  That's because the UDP GRO layer
stripped off the UDP header via skb_gro_pull() already while the UDP
header was explicitly not pulled/pushed in this function.

For example, an IKE packet that triggered this had len=data_len=1268 and
the data_offset in the GRO header was 28 (IPv4 + UDP).  So pskb_pull()
was called with an offset of 28-8=20, which reduced len to 1248 and via
pskb_may_pull() and __pskb_pull_tail() it also set data_len to 1248.
As the ESP offload module was not loaded, the function bailed out and
called skb_push(), which restored len to 1268, however, data_len remained
at 1248.

So while skb_headlen() was 0 before, it was now 20.  The latter caused a
difference of 8 instead of 28 (or 0 if pskb_pull()/skb_push() was called
with the complete GRO data_offset) in gro_try_pull_from_frag0() that
triggered a call to gro_pull_from_frag0() that corrupted the packet.

This change uses a more GRO-like approach seen in other GRO receivers
via skb_gro_header() to just read the actual data we are interested in
and does not try to "restore" the UDP header at this point to call the
existing function.  If the offload module is not loaded, it immediately
bails out, otherwise, it only does a quick check to see if the packet
is an IKE or keepalive packet instead of calling the existing function.

Fixes: 172bf009c18d ("xfrm: Support GRO for IPv4 ESP in UDP encapsulation")
Fixes: 221ddb723d90 ("xfrm: Support GRO for IPv6 ESP in UDP encapsulation")
Signed-off-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/xfrm4_input.c | 18 ++++++++++--------
 net/ipv6/xfrm6_input.c | 18 ++++++++++--------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/xfrm4_input.c b/net/ipv4/xfrm4_input.c
index b5b06323cfd94..0d31a8c108d4f 100644
--- a/net/ipv4/xfrm4_input.c
+++ b/net/ipv4/xfrm4_input.c
@@ -182,11 +182,15 @@ struct sk_buff *xfrm4_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
 	int offset = skb_gro_offset(skb);
 	const struct net_offload *ops;
 	struct sk_buff *pp = NULL;
-	int ret;
-
-	offset = offset - sizeof(struct udphdr);
+	int len, dlen;
+	__u8 *udpdata;
+	__be32 *udpdata32;
 
-	if (!pskb_pull(skb, offset))
+	len = skb->len - offset;
+	dlen = offset + min(len, 8);
+	udpdata = skb_gro_header(skb, dlen, offset);
+	udpdata32 = (__be32 *)udpdata;
+	if (unlikely(!udpdata))
 		return NULL;
 
 	rcu_read_lock();
@@ -194,11 +198,10 @@ struct sk_buff *xfrm4_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
 	if (!ops || !ops->callbacks.gro_receive)
 		goto out;
 
-	ret = __xfrm4_udp_encap_rcv(sk, skb, false);
-	if (ret)
+	/* check if it is a keepalive or IKE packet */
+	if (len <= sizeof(struct ip_esp_hdr) || udpdata32[0] == 0)
 		goto out;
 
-	skb_push(skb, offset);
 	NAPI_GRO_CB(skb)->proto = IPPROTO_UDP;
 
 	pp = call_gro_receive(ops->callbacks.gro_receive, head, skb);
@@ -208,7 +211,6 @@ struct sk_buff *xfrm4_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
 
 out:
 	rcu_read_unlock();
-	skb_push(skb, offset);
 	NAPI_GRO_CB(skb)->same_flow = 0;
 	NAPI_GRO_CB(skb)->flush = 1;
 
diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
index 4abc5e9d63227..841c81abaaf4f 100644
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -179,14 +179,18 @@ struct sk_buff *xfrm6_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
 	int offset = skb_gro_offset(skb);
 	const struct net_offload *ops;
 	struct sk_buff *pp = NULL;
-	int ret;
+	int len, dlen;
+	__u8 *udpdata;
+	__be32 *udpdata32;
 
 	if (skb->protocol == htons(ETH_P_IP))
 		return xfrm4_gro_udp_encap_rcv(sk, head, skb);
 
-	offset = offset - sizeof(struct udphdr);
-
-	if (!pskb_pull(skb, offset))
+	len = skb->len - offset;
+	dlen = offset + min(len, 8);
+	udpdata = skb_gro_header(skb, dlen, offset);
+	udpdata32 = (__be32 *)udpdata;
+	if (unlikely(!udpdata))
 		return NULL;
 
 	rcu_read_lock();
@@ -194,11 +198,10 @@ struct sk_buff *xfrm6_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
 	if (!ops || !ops->callbacks.gro_receive)
 		goto out;
 
-	ret = __xfrm6_udp_encap_rcv(sk, skb, false);
-	if (ret)
+	/* check if it is a keepalive or IKE packet */
+	if (len <= sizeof(struct ip_esp_hdr) || udpdata32[0] == 0)
 		goto out;
 
-	skb_push(skb, offset);
 	NAPI_GRO_CB(skb)->proto = IPPROTO_UDP;
 
 	pp = call_gro_receive(ops->callbacks.gro_receive, head, skb);
@@ -208,7 +211,6 @@ struct sk_buff *xfrm6_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
 
 out:
 	rcu_read_unlock();
-	skb_push(skb, offset);
 	NAPI_GRO_CB(skb)->same_flow = 0;
 	NAPI_GRO_CB(skb)->flush = 1;
 
-- 
2.39.5



