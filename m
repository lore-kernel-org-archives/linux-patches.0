Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4272E4E50A6;
	Fri,  9 Oct 2026 14:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555717; cv=none; b=Bp83PzCZlNGKG1/338VZB/N5Vt8IdLOMlVlr4XEBLIVksHVM/4TyHVVBZZbAlkEcASd+SQY8ebic9NCWRAxbz6pD4jpDzItPHmI/zLyVEY9rotpTAtrHUz3TRSE1VHEdFnez6gZOYYNGjc6LvraRv+nTpSaboUtNIi+RhxThy7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555717; c=relaxed/simple;
	bh=fmug0JCrVloHCn3/q8SN0nmv0WzP7fN3hR9J19+1yfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGwAmIeS83dlCrq/BoumCgVeoj54yOovgSAevIgaEAOqYq8LEv5DjODhwXLeRIwN04BNNgLcnNgUWEfwp4sLZalwIQP+FQPqgUlnYfIt2YUEFFVxgLpvIZ/oZRCzbCUtYYaTtMrMxFIBlpZP6eOrr0Rfh6GfI8h6eSos2F2bWvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tL6SEoK8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tL6SEoK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87EC1F000FF;
	Fri,  9 Oct 2026 14:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555716;
	bh=g9vTCMQMRhcCaiy6ZlSfWPgSkRgv0tDCNMJOvG9FXkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tL6SEoK8Rbmgv8R0nHS8zNPA5EmkTnz/AGmOypMO8tRsgBAjQvsIDoHRKcr8UtWRZ
	 K7zJLK1SLGdiZdlBxHARJ7rN3JQRKL1qylKJzd3vOsn/Mc5m+1qmqT2ZqRkFBXGyKy
	 WksKehCRa8IuT5j/t3GXv5xf30XjIFMFqvKAnNYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannu Varjoranta <hannu@varjosoft.com>,
	Eric Dumazet <edumazet@google.com>,
	Ankit Garg <nktgrg@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/403] gve: DQO: accept TSO packets with non-protocol gso_type bits
Date: Fri,  9 Oct 2026 16:07:45 +0200
Message-ID: <20261009140954.517183562@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannu Varjoranta <hannu@varjosoft.com>

[ Upstream commit f8932b2c0c9ae6fb577bcc05a2080c8498f91c0d ]

Since commit 014c607f86ab ("gve: add support for UDP GSO for DQO
format"), gve_prep_tso() matches shinfo->gso_type exactly. gso_type is
a bitmask, though: SKB_GSO_DODGY is set on every GSO packet that comes
from tun/tap, packet sockets or other untrusted sources, and
SKB_GSO_TCP_ECN and SKB_GSO_TCP_FIXEDID can be set as well. Such packets
hit the default case, gve_tx_add_skb_dqo() fails and gve_try_tx_skb()
drops them, counting them in tx_dropped.

These packets do reach the driver: tcp_gso_segment() passes DODGY skbs
through unsegmented to devices that support TSO, after recomputing
gso_segs, so drivers must tolerate the bit.

This breaks virtual machines behind a tap on GCE instances using the DQO
queue formats. Every TSO packet forwarded from a guest (gso_type
SKB_GSO_TCPV4 | SKB_GSO_DODGY) is dropped, and guest uploads slow to a
crawl of retransmissions or stall entirely, while the host's own TSO
traffic (gso_type SKB_GSO_TCPV4) is unaffected. On an n4 instance
(DQO-QPL) with a Cloud Hypervisor guest, a 64 MB upload from the guest
went from a 60 s timeout at ~0.9 MB/s to 0.19 s with this change, with
tx_dropped no longer increasing.

Host TCP with ECN is hit as well: gve advertises NETIF_F_TSO_ECN, so a
TSO packet carrying CWR has SKB_GSO_TCP_ECN set and is dropped too.

Restore the bitmask test that commit 1b9f75634441 ("gve: ignore
nonrelevant GSO type bits when processing TSO headers") introduced for
the same problem, keeping the UDP GSO support.

While here, reload shinfo after skb_cow_head(). If the head was cloned,
pskb_expand_head() moves skb_shared_info to the new head, and the
pointer cached at function entry can then refer to memory that another
clone frees.

Fixes: 014c607f86ab ("gve: add support for UDP GSO for DQO format")
Signed-off-by: Hannu Varjoranta <hannu@varjosoft.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ankit Garg <nktgrg@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Link: https://patch.msgid.link/20260925115237.56465-1-hannu@varjosoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index b5565d0b197f0..dad793c0a7c4b 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -600,25 +600,25 @@ static int gve_prep_tso(struct sk_buff *skb)
 	err = skb_cow_head(skb, 0);
 	if (err < 0)
 		return err;
+	shinfo = skb_shinfo(skb);
 
 	l4_start = skb_transport_offset(skb);
 	paylen = skb->len - l4_start;
 
-	switch (shinfo->gso_type) {
-	case SKB_GSO_TCPV4:
-	case SKB_GSO_TCPV6:
+	/* gso_type is a bitmask: SKB_GSO_DODGY, SKB_GSO_TCP_ECN and
+	 * SKB_GSO_TCP_FIXEDID may be set alongside the protocol bit.
+	 */
+	if (shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)) {
 		tcp = tcp_hdr(skb);
 		csum_replace_by_diff(&tcp->check,
 				     (__force __wsum)htonl(paylen));
 		header_len = skb_tcp_all_headers(skb);
-		break;
-	case SKB_GSO_UDP_L4:
+	} else if (shinfo->gso_type & SKB_GSO_UDP_L4) {
 		udp = udp_hdr(skb);
 		csum_replace_by_diff(&udp->check,
 				     (__force __wsum)htonl(paylen));
 		header_len = sizeof(struct udphdr) + l4_start;
-		break;
-	default:
+	} else {
 		return -EINVAL;
 	}
 
-- 
2.53.0



