Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D2637BE77;
	Thu, 19 Mar 2026 11:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773920261; cv=none; b=s09njQr/HKHCJU/c7c3417soVT6ULeJJLDgFPykdevSHvn/HSGyKGlJ/3g/ihdLzU9kDFItCY7JwSbolCslx2GC0qP7u1dHHBXVBrP2vmarW1/ufATuaqUroCVsOWMbyTELXQC8j+n9LY+GPCN8EKKbW2dpjHfVAZssJnXuImls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773920261; c=relaxed/simple;
	bh=MIzWb14uWVOfRWgpIeFl+RNd8KZIR7SHWTeh3IGagsQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=sM6R1jtThaeH+faKkuIIJ1cbXebtJv4OVP+9/dX5pX1fgmy4zKh7FT+YNstwFesN+pztvq14eqlhuno7C/SD1IP51A5LD/lnlIQfr1pxeh/y09fJWUYgeIQqSi+/WaFGFEL5inDsAqNCtwucwatcKIizwA6+RcHQrWlYgPmq3w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6M0tH+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6M0tH+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C84DC2BCB0;
	Thu, 19 Mar 2026 11:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773920260;
	bh=MIzWb14uWVOfRWgpIeFl+RNd8KZIR7SHWTeh3IGagsQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=f6M0tH+13gjROVN0algEs0UAtPylRxcskt4+z7oJDiU3nJhwJGAidWq9MkVnkLlvT
	 ohRviyYe6tqUqH8OMUjod6d9DnK8a70ESAtKetQOLR0sNknlqAIW44j8NLRDhHHiwy
	 Ir06iBY+53c4LOGLUWeEXZaPsDRl4a+qvhL6vitM=
Subject: Patch "net: gso: fix tcp fraglist segmentation after pull from frag_list" has been added to the 6.6-stable tree
To: 1468888505@139.com,angelogioacchino.delregno@collabora.com,davem@davemloft.net,dsahern@kernel.org,edumazet@google.com,gregkh@linuxfoundation.org,kuba@kernel.org,linux-arm-kernel@lists.infradead.org,linux-mediatek@lists.infradead.org,matthias.bgg@gmail.com,nbd@nbd.name,pabeni@redhat.com,patches@lists.linux.dev,willemb@google.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 19 Mar 2026 12:37:12 +0100
In-Reply-To: <20260302065522.2695626-1-1468888505@139.com>
Message-ID: <2026031912-cacti-mumbo-b576@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    net: gso: fix tcp fraglist segmentation after pull from frag_list

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     net-gso-fix-tcp-fraglist-segmentation-after-pull-from-frag_list.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-222524-greg=kroah.com@vger.kernel.org Mon Mar  2 07:56:08 2026
From: Li hongliang <1468888505@139.com>
Date: Mon,  2 Mar 2026 14:55:22 +0800
Subject: net: gso: fix tcp fraglist segmentation after pull from frag_list
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, nbd@nbd.name
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, edumazet@google.com, davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com, willemb@google.com, netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, bpf@vger.kernel.org
Message-ID: <20260302065522.2695626-1-1468888505@139.com>

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


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.6/pnfs-fix-a-deadlock-when-returning-a-delegation-during-open.patch
queue-6.6/net-add-support-for-segmenting-tcp-fraglist-gso-packets.patch
queue-6.6/net-fix-segmentation-of-forwarding-fraglist-gro.patch
queue-6.6/nfs-pass-explicit-offset-count-to-trace-events.patch
queue-6.6/net-gso-fix-tcp-fraglist-segmentation-after-pull-from-frag_list.patch
queue-6.6/nfs-fix-a-deadlock-involving-nfs_release_folio.patch
