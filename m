Received: from n169-110.mail.139.com (n169-110.mail.139.com [120.232.169.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE87B327BF8
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 06:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772434533; cv=none; b=XZ/JD4M/1b6+OChXeJws1K914RQcPbaF2tg+h/B6MIv3C4YGKL8re6B0ZRXQIn1f7Tnr/INlEItk4Fh6n/dI7bgNdX8Q9gDx7YGqPQP+pOicP0CvBj3iaj5jhfvb6SbIlwtopeX2D9S41C4MHWi9UFxcHfen9in7O5SdYA2oLv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772434533; c=relaxed/simple;
	bh=f3tHTh5SiTtM5YKpNRSVNFvu/XrUQtLNrfCWsfyfJGA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Y9m/K4Br4aoFZ1uHZUM1pZxyrayZRSzo5k/9GTzWf2Kmjo6+CCZGiyNAoUeczRt0v432DOo8hK+coQdMpRxmmvhSoUAXS6CYy5drMW224B9E1H8g0iqacA838xkzpqZ2Htpqg8BmoLWyRv1P2m/wKVReXPkTJiibgWwtCE3wwho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=jQYcORwv; arc=none smtp.client-ip=120.232.169.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="jQYcORwv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=jQYcORwvVGgafP32QYYiyirgUNSO0hmpd1mwGrFOa+QJsyHMnau8KoI8BwGSO9x717iUJVM4krK4Z
	 CZ9p+Cs3zSsNOBWyFeyspR2TF+daA+eQHlSvtR/0qGZvsTeFAJfOOIecANcGR51ZA66C4X/Col8wqk
	 dn1+34GaDj5BYJfE=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-03-12081 (RichMail) with SMTP id 2f3169a5345964b-01670;
	Mon, 02 Mar 2026 14:55:24 +0800 (CST)
X-RM-TRANSID:2f3169a5345964b-01670
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	nbd@nbd.name
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	dsahern@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	willemb@google.com,
	netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	bpf@vger.kernel.org
Subject: [PATCH 6.6.y 2/3] net: gso: fix tcp fraglist segmentation after pull from frag_list
Date: Mon,  2 Mar 2026 14:55:22 +0800
Message-Id: <20260302065522.2695626-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 17bd3bd82f9f79f3feba15476c2b2c95a9b11ff8 ]

Detect tcp gso fraglist skbs with corrupted geometry (see below) and
pass these to skb_segment instead of skb_segment_list, as the first
can segment them correctly.

Valid SKB_GSO_FRAGLIST skbs
- consist of two or more segments
- the head_skb holds the protocol headers plus first gso_size
- one or more frag_list skbs hold exactly one segment
- all but the last must be gso_size

Optional datapath hooks such as NAT and BPF (bpf_skb_pull_data) can
modify these skbs, breaking these invariants.

In extreme cases they pull all data into skb linear. For TCP, this
causes a NULL ptr deref in __tcpv4_gso_segment_list_csum at
tcp_hdr(seg->next).

Detect invalid geometry due to pull, by checking head_skb size.
Don't just drop, as this may blackhole a destination. Convert to be
able to pass to regular skb_segment.

Approach and description based on a patch by Willem de Bruijn.

Link: https://lore.kernel.org/netdev/20240428142913.18666-1-shiming.cheng@mediatek.com/
Link: https://lore.kernel.org/netdev/20240922150450.3873767-1-willemdebruijn.kernel@gmail.com/
Fixes: bee88cd5bd83 ("net: add support for segmenting TCP fraglist GSO packets")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20240926085315.51524-1-nbd@nbd.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Li hongliang <1468888505@139.com>
---
 net/ipv4/tcp_offload.c   | 10 ++++++++--
 net/ipv6/tcpv6_offload.c | 10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 03b2bf580997..36595709279c 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -104,8 +104,14 @@ static struct sk_buff *tcp4_gso_segment(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, sizeof(struct tcphdr)))
 		return ERR_PTR(-EINVAL);
 
-	if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST)
-		return __tcp4_gso_segment_list(skb, features);
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST) {
+		struct tcphdr *th = tcp_hdr(skb);
+
+		if (skb_pagelen(skb) - th->doff * 4 == skb_shinfo(skb)->gso_size)
+			return __tcp4_gso_segment_list(skb, features);
+
+		skb->ip_summed = CHECKSUM_NONE;
+	}
 
 	if (unlikely(skb->ip_summed != CHECKSUM_PARTIAL)) {
 		const struct iphdr *iph = ip_hdr(skb);
diff --git a/net/ipv6/tcpv6_offload.c b/net/ipv6/tcpv6_offload.c
index 503a4338e37a..7567c32670c6 100644
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -106,8 +106,14 @@ static struct sk_buff *tcp6_gso_segment(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, sizeof(*th)))
 		return ERR_PTR(-EINVAL);
 
-	if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST)
-		return __tcp6_gso_segment_list(skb, features);
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST) {
+		struct tcphdr *th = tcp_hdr(skb);
+
+		if (skb_pagelen(skb) - th->doff * 4 == skb_shinfo(skb)->gso_size)
+			return __tcp6_gso_segment_list(skb, features);
+
+		skb->ip_summed = CHECKSUM_NONE;
+	}
 
 	if (unlikely(skb->ip_summed != CHECKSUM_PARTIAL)) {
 		const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-- 
2.34.1


