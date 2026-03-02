Received: from n169-112.mail.139.com (n169-112.mail.139.com [120.232.169.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FE537BE64
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 06:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772434518; cv=none; b=uqRLrwSK9Rm8znSwzegEnXP6z1pRs1Gwv452wN5agSNflKERMQ8PMYAxC7GY2vvE4DPPLK8dt3Ne1HNC5yvDquHwfuN+7DigW0i5d9fd5VEhSw1i80gdcLP5HnWL4PVNadHh67xD+z3G2FKdo5PHQuhhhmoFPxNOMa+3pd6uVww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772434518; c=relaxed/simple;
	bh=O9M0P6Ov/Z7R3mnrIbLwyfT36K3jKJ1hKCl4tm8lrwc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nIcmm0OHs4OP8kkPJMsiFSfhpZ+5E+VsF/ppjVjS5SKEs81W7SwsnjD9vAw4ZB3bwPjrkvYVp5LFEiUic5PM/L9RhvJJ6NPnZBW5Q150VYhtujNRNCwyLjjyaxU9mF/1QQlavBV5p9yptkOgxtdGnFuRQLN82K9t7wNH8DoZfKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=J+ehW0lG; arc=none smtp.client-ip=120.232.169.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="J+ehW0lG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=J+ehW0lGx3CJdr19CjMk8scGAw92kbO3OGRA1Y539YrirbltjOuCyLPbVnCbu9gMcDbamYgymZQhJ
	 iFpqNtxucYOiety3TWtrmnzcmzucUNURXdKPJuQun1CgJYY/1ZjVmFc2aR1c2z6GWdqBDxCAjI2m1i
	 J6uOW9rz52kU7cC0=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-21-12024 (RichMail) with SMTP id 2ef869a5345018a-011dc;
	Mon, 02 Mar 2026 14:55:14 +0800 (CST)
X-RM-TRANSID:2ef869a5345018a-011dc
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	nbd@nbd.name
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	yoshfuji@linux-ipv6.org,
	dsahern@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	willemb@google.com
Subject: [PATCH 6.6.y 1/3] net: add support for segmenting TCP fraglist GSO packets
Date: Mon,  2 Mar 2026 14:55:13 +0800
Message-Id: <20260302065513.2695586-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit bee88cd5bd83d40b8aec4d6cb729378f707f6197 ]

Preparation for adding TCP fraglist GRO support. It expects packets to be
combined in a similar way as UDP fraglist GSO packets.
For IPv4 packets, NAT is handled in the same way as UDP fraglist GSO.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Li hongliang <1468888505@139.com>
---
 net/ipv4/tcp_offload.c   | 67 ++++++++++++++++++++++++++++++++++++++++
 net/ipv6/tcpv6_offload.c | 58 ++++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index f1f723579a49..03b2bf580997 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -31,6 +31,70 @@ static void tcp_gso_tstamp(struct sk_buff *skb, struct sk_buff *gso_skb,
 	}
 }
 
+static void __tcpv4_gso_segment_csum(struct sk_buff *seg,
+				     __be32 *oldip, __be32 newip,
+				     __be16 *oldport, __be16 newport)
+{
+	struct tcphdr *th;
+	struct iphdr *iph;
+
+	if (*oldip == newip && *oldport == newport)
+		return;
+
+	th = tcp_hdr(seg);
+	iph = ip_hdr(seg);
+
+	inet_proto_csum_replace4(&th->check, seg, *oldip, newip, true);
+	inet_proto_csum_replace2(&th->check, seg, *oldport, newport, false);
+	*oldport = newport;
+
+	csum_replace4(&iph->check, *oldip, newip);
+	*oldip = newip;
+}
+
+static struct sk_buff *__tcpv4_gso_segment_list_csum(struct sk_buff *segs)
+{
+	const struct tcphdr *th;
+	const struct iphdr *iph;
+	struct sk_buff *seg;
+	struct tcphdr *th2;
+	struct iphdr *iph2;
+
+	seg = segs;
+	th = tcp_hdr(seg);
+	iph = ip_hdr(seg);
+	th2 = tcp_hdr(seg->next);
+	iph2 = ip_hdr(seg->next);
+
+	if (!(*(const u32 *)&th->source ^ *(const u32 *)&th2->source) &&
+	    iph->daddr == iph2->daddr && iph->saddr == iph2->saddr)
+		return segs;
+
+	while ((seg = seg->next)) {
+		th2 = tcp_hdr(seg);
+		iph2 = ip_hdr(seg);
+
+		__tcpv4_gso_segment_csum(seg,
+					 &iph2->saddr, iph->saddr,
+					 &th2->source, th->source);
+		__tcpv4_gso_segment_csum(seg,
+					 &iph2->daddr, iph->daddr,
+					 &th2->dest, th->dest);
+	}
+
+	return segs;
+}
+
+static struct sk_buff *__tcp4_gso_segment_list(struct sk_buff *skb,
+					      netdev_features_t features)
+{
+	skb = skb_segment_list(skb, features, skb_mac_header_len(skb));
+	if (IS_ERR(skb))
+		return skb;
+
+	return __tcpv4_gso_segment_list_csum(skb);
+}
+
 static struct sk_buff *tcp4_gso_segment(struct sk_buff *skb,
 					netdev_features_t features)
 {
@@ -40,6 +104,9 @@ static struct sk_buff *tcp4_gso_segment(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, sizeof(struct tcphdr)))
 		return ERR_PTR(-EINVAL);
 
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST)
+		return __tcp4_gso_segment_list(skb, features);
+
 	if (unlikely(skb->ip_summed != CHECKSUM_PARTIAL)) {
 		const struct iphdr *iph = ip_hdr(skb);
 		struct tcphdr *th = tcp_hdr(skb);
diff --git a/net/ipv6/tcpv6_offload.c b/net/ipv6/tcpv6_offload.c
index bf0c957e4b5e..503a4338e37a 100644
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -40,6 +40,61 @@ INDIRECT_CALLABLE_SCOPE int tcp6_gro_complete(struct sk_buff *skb, int thoff)
 	return 0;
 }
 
+static void __tcpv6_gso_segment_csum(struct sk_buff *seg,
+				     __be16 *oldport, __be16 newport)
+{
+	struct tcphdr *th;
+
+	if (*oldport == newport)
+		return;
+
+	th = tcp_hdr(seg);
+	inet_proto_csum_replace2(&th->check, seg, *oldport, newport, false);
+	*oldport = newport;
+}
+
+static struct sk_buff *__tcpv6_gso_segment_list_csum(struct sk_buff *segs)
+{
+	const struct tcphdr *th;
+	const struct ipv6hdr *iph;
+	struct sk_buff *seg;
+	struct tcphdr *th2;
+	struct ipv6hdr *iph2;
+
+	seg = segs;
+	th = tcp_hdr(seg);
+	iph = ipv6_hdr(seg);
+	th2 = tcp_hdr(seg->next);
+	iph2 = ipv6_hdr(seg->next);
+
+	if (!(*(const u32 *)&th->source ^ *(const u32 *)&th2->source) &&
+	    ipv6_addr_equal(&iph->saddr, &iph2->saddr) &&
+	    ipv6_addr_equal(&iph->daddr, &iph2->daddr))
+		return segs;
+
+	while ((seg = seg->next)) {
+		th2 = tcp_hdr(seg);
+		iph2 = ipv6_hdr(seg);
+
+		iph2->saddr = iph->saddr;
+		iph2->daddr = iph->daddr;
+		__tcpv6_gso_segment_csum(seg, &th2->source, th->source);
+		__tcpv6_gso_segment_csum(seg, &th2->dest, th->dest);
+	}
+
+	return segs;
+}
+
+static struct sk_buff *__tcp6_gso_segment_list(struct sk_buff *skb,
+					      netdev_features_t features)
+{
+	skb = skb_segment_list(skb, features, skb_mac_header_len(skb));
+	if (IS_ERR(skb))
+		return skb;
+
+	return __tcpv6_gso_segment_list_csum(skb);
+}
+
 static struct sk_buff *tcp6_gso_segment(struct sk_buff *skb,
 					netdev_features_t features)
 {
@@ -51,6 +106,9 @@ static struct sk_buff *tcp6_gso_segment(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, sizeof(*th)))
 		return ERR_PTR(-EINVAL);
 
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST)
+		return __tcp6_gso_segment_list(skb, features);
+
 	if (unlikely(skb->ip_summed != CHECKSUM_PARTIAL)) {
 		const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 		struct tcphdr *th = tcp_hdr(skb);
-- 
2.34.1


