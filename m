Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20724132129;
	Wed, 19 Jun 2024 13:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802332; cv=none; b=rHeocf2QVdItOY7EDkXC21e3JFwiNv85E5TkyzRYHD5E5xXkhg6tKHSVGeOXUqzo6qxsixAFhKVGmhWWMF2qUdqzr3l6YsJSQ/wWNr1eoCA7zSCit8Cz5tkfToy+l5QmBSzX1PPN7DdlniaNey3SM1Ftm8xZrYOQ2KrWe9BtT48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802332; c=relaxed/simple;
	bh=qtiLadvDKis44toYnNsyHvH1AmfvFJecpZJEtTqqVaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0Al/ploD8ujw+u1htZJZKHQVUsfrjoscv6N9Vk0dUmpo/PJPhxEBUBNFcEash0crGr1HEoXS/qFQl9CPzPeCe5cDqm9b+8h4plrQEoP0UMnir1xt6cPbUF93jAo5+B/u5h0Qbh48RPFZ6ZqOy2QTJWsdAVMJS30PAVmX4RXRTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCRQKKYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCRQKKYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB49C2BBFC;
	Wed, 19 Jun 2024 13:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802332;
	bh=qtiLadvDKis44toYnNsyHvH1AmfvFJecpZJEtTqqVaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCRQKKYIGyEKu/J9ltfPBgx5+Aos+KPW4uIFFeT93UN4ijIFuulsEFOEJs11zRIE2
	 VAY89sr6QNfngNmOYguEvJ3Q0da2VvYvTEGogQhrRRM1XSa7xnEHP+6/93JgggvB+f
	 3rfs0720tIshAsN9/0Q4eRh0+nQCe5UbHLo2n1UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrei Vagin <avagin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/267] gve: ignore nonrelevant GSO type bits when processing TSO headers
Date: Wed, 19 Jun 2024 14:55:12 +0200
Message-ID: <20240619125612.523048664@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Joshua Washington <joshwash@google.com>

[ Upstream commit 1b9f756344416e02b41439bf2324b26aa25e141c ]

TSO currently fails when the skb's gso_type field has more than one bit
set.

TSO packets can be passed from userspace using PF_PACKET, TUNTAP and a
few others, using virtio_net_hdr (e.g., PACKET_VNET_HDR). This includes
virtualization, such as QEMU, a real use-case.

The gso_type and gso_size fields as passed from userspace in
virtio_net_hdr are not trusted blindly by the kernel. It adds gso_type
|= SKB_GSO_DODGY to force the packet to enter the software GSO stack
for verification.

This issue might similarly come up when the CWR bit is set in the TCP
header for congestion control, causing the SKB_GSO_TCP_ECN gso_type bit
to be set.

Fixes: a57e5de476be ("gve: DQO: Add TX path")
Signed-off-by: Joshua Washington <joshwash@google.com>
Reviewed-by: Praveen Kaligineedi <pkaligineedi@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Acked-by: Andrei Vagin <avagin@gmail.com>

v2 - Remove unnecessary comments, remove line break between fixes tag
and signoffs.

v3 - Add back unrelated empty line removal.

Link: https://lore.kernel.org/r/20240610225729.2985343-1-joshwash@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index 1e19b834a6130..5a44354bbdfdf 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -501,28 +501,18 @@ static int gve_prep_tso(struct sk_buff *skb)
 	if (unlikely(skb_shinfo(skb)->gso_size < GVE_TX_MIN_TSO_MSS_DQO))
 		return -1;
 
+	if (!(skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)))
+		return -EINVAL;
+
 	/* Needed because we will modify header. */
 	err = skb_cow_head(skb, 0);
 	if (err < 0)
 		return err;
 
 	tcp = tcp_hdr(skb);
-
-	/* Remove payload length from checksum. */
 	paylen = skb->len - skb_transport_offset(skb);
-
-	switch (skb_shinfo(skb)->gso_type) {
-	case SKB_GSO_TCPV4:
-	case SKB_GSO_TCPV6:
-		csum_replace_by_diff(&tcp->check,
-				     (__force __wsum)htonl(paylen));
-
-		/* Compute length of segmentation header. */
-		header_len = skb_tcp_all_headers(skb);
-		break;
-	default:
-		return -EINVAL;
-	}
+	csum_replace_by_diff(&tcp->check, (__force __wsum)htonl(paylen));
+	header_len = skb_tcp_all_headers(skb);
 
 	if (unlikely(header_len > GVE_TX_MAX_HDR_SIZE_DQO))
 		return -EINVAL;
-- 
2.43.0



