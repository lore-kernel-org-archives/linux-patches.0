Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0450E4E50B1;
	Fri,  9 Oct 2026 14:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556182; cv=none; b=jCTgfYd3gh0LmLI+7URQcBAP6BJCZTEx2OqwbZXhCAsBqkctxmyPvouEq0JyOmnKPt+R5RJuCM6OTLxQGHZpuqCC6KQOTPkf4xfNzKmcNk8ipHB+CT8bVB+T+2vUjNC/2ehL59V/Lzng7sVUMxy9D40WNK0Rgk4AJ9iWJEZYrpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556182; c=relaxed/simple;
	bh=untVpZJ7B40jPGi39Dl5fk7td/fdW1kEqQZ02oGypCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syc2QFmks+HpywJA019LNOxZF/TgIPVT8YBTnOnvNWCvVBtpSEJUYeekjs2bVlwTj0wXhIlCfB5WUcE3a3gVqhZo955TBukcZ7bMaAg0nCiRG2L9su8o3UURpkWtVKNHejTVQtDXuwQQzF03YakM5MPdcYpr2VNdOl/uDPj/gxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fP5+blsr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fP5+blsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6C41F000FF;
	Fri,  9 Oct 2026 14:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556178;
	bh=3pa4ClcCop/uO5Vk1J/I/YWTNYSxrwFCbigcBnEFgWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fP5+blsrDmkksA8Qzxb/9Mi8REd633yDYgpiS94Hcb3NNCfmuMF7xjqhsQWRm0Zbp
	 BjelLdeCS7HeSTSE1F0aHDpM47goP0v7TeOcaYrs7XBPXR9Rt7q5laQF3UA+BAL1gS
	 gsMLNERmAVbKdPX26/R/ANpEGM69N5mNRkMMi2zI=
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
Subject: [PATCH 7.2 133/428] gve: DQO: accept TSO packets with non-protocol gso_type bits
Date: Fri,  9 Oct 2026 16:07:50 +0200
Message-ID: <20261009140949.105254989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 616c1921aebea..ad99cbb77e291 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -595,25 +595,25 @@ static int gve_prep_tso(struct sk_buff *skb)
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



