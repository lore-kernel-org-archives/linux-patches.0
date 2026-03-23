Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090E3263F4A;
	Mon, 23 Mar 2026 15:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278803; cv=none; b=BhxSPdKb1yA+9xhV3BpPdL0W77hzY74qDhOB0qWgLUqXcndLisIMvUIq5j8VFhLQ80YetnjECWWl6AFjZx97RcUyivYqVKNFANoh9hDHZtG1+seku/FYxMFnk9lYh+y4nGV+1tRoamw02SinZKzCKVte0qIBimMFtFJLyeWZ3aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278803; c=relaxed/simple;
	bh=4FjBjFDNFWwJzCAEwlO9n/TP/gfSV/1PKZV7ESQ6JXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4kpsPVAJn6LYTNxsKqaHD5TG/rh/nKPcvKQa9wYRanKH/ebekskQHi9yy6VLd+zr4U5fWcw4P0cJlMhM9K/NSuzc+0irufvRXtVMb4ZEfL0DGZR/UgBNIz7fRdKhSDIX/eGqN43mCL10if3SD9J+pZdaYN4Sa8K7pL9Id/3fwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXEWKJkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXEWKJkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81436C4CEF7;
	Mon, 23 Mar 2026 15:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278802;
	bh=4FjBjFDNFWwJzCAEwlO9n/TP/gfSV/1PKZV7ESQ6JXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXEWKJkEK8BNHcfxist5zyQqNHNu6aYYtWe0AZC/ZQWs091jBagqXiw2gceDE+3fO
	 YdwNKXsWuMi43ENQCAN9fyj/O2nJ1z3GOQDfyZ+5Wqk3ILzA8y8gHH7T+R2DOnqXFf
	 BQVkxNvhRpejcJZ/r4sc8vlMhs2cqpfVI3Yb1c5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Li hongliang <1468888505@139.com>
Subject: [PATCH 6.6 425/567] net: gso: fix tcp fraglist segmentation after pull from frag_list
Date: Mon, 23 Mar 2026 14:45:45 +0100
Message-ID: <20260323134544.406996061@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_offload.c   |   10 ++++++++--
 net/ipv6/tcpv6_offload.c |   10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -104,8 +104,14 @@ static struct sk_buff *tcp4_gso_segment(
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
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -106,8 +106,14 @@ static struct sk_buff *tcp6_gso_segment(
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


