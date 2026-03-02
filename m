Received: from n169-113.mail.139.com (n169-113.mail.139.com [120.232.169.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C171E8320
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 06:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772434259; cv=none; b=AxKtPu2D6HfxWqIm7vgA88mboKWUao5Xt18WwE9Ac39J+eSt7o9Y+FJSRhJlPFl78M2eUUm6vY2sA/8+IhmSs2eEw6VdzKKXvYQi8MIF+wvjaYct2cBGqieI9PaDA2Tu3yUAHcED2ViDHmePucFAJPpif5R6RjsVA58BnXH17+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772434259; c=relaxed/simple;
	bh=Lt3x1fleXW/KHaN7MKGMz7aLgjrFHRgBcU/d773384c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LojEjgILormRvpfQcPyViIS5Jbn5c68mtwai/66K/bccyshq5qhCGI+SCGUf1fIdELQAKVlAR0l1YfdA6iZ/OeNVdZa4JFqViz3Atw24dX6s/DfCCKJIYxaGb0Es6ozojiX/DRiUjMudLRovXE8tWNIbURwMra9gk5wPJa7iHyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=PmaBmBEz; arc=none smtp.client-ip=120.232.169.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="PmaBmBEz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=PmaBmBEzQINbK4j9lS6pgYigm3f3wjLaTHSYGU4gfc21wpyaHFW2BEXGfOM6Y0PacZwiJqAca4yAa
	 v4x67j2ug8H+1wVwsWaRvz31xMSIZPZqarWihWDlFDmvJXacTaM346SJbqAXvEL3rSwEqY6q8GWA3y
	 B4sgAPNHQ3Kuqbic=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-36-12050 (RichMail) with SMTP id 2f1269a53344a6a-02acb;
	Mon, 02 Mar 2026 14:50:47 +0800 (CST)
X-RM-TRANSID:2f1269a53344a6a-02acb
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
Subject: [PATCH 6.1.y 1/3] net: add support for segmenting TCP fraglist GSO packets
Date: Mon,  2 Mar 2026 14:50:44 +0800
Message-Id: <20260302065044.2694740-1-1468888505@139.com>
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
index ce84073e0b7b..3d244a787011 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -30,6 +30,70 @@ static void tcp_gso_tstamp(struct sk_buff *skb, struct sk_buff *gso_skb,
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
@@ -39,6 +103,9 @@ static struct sk_buff *tcp4_gso_segment(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, sizeof(struct tcphdr)))
 		return ERR_PTR(-EINVAL);
 
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST)
+		return __tcp4_gso_segment_list(skb, features);
+
 	if (unlikely(skb->ip_summed != CHECKSUM_PARTIAL)) {
 		const struct iphdr *iph = ip_hdr(skb);
 		struct tcphdr *th = tcp_hdr(skb);
diff --git a/net/ipv6/tcpv6_offload.c b/net/ipv6/tcpv6_offload.c
index 39db5a226855..fab13afaa7c1 100644
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -39,6 +39,61 @@ INDIRECT_CALLABLE_SCOPE int tcp6_gro_complete(struct sk_buff *skb, int thoff)
 	return tcp_gro_complete(skb);
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
@@ -50,6 +105,9 @@ static struct sk_buff *tcp6_gso_segment(struct sk_buff *skb,
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


