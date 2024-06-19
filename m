Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B24F14373E;
	Wed, 19 Jun 2024 13:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803924; cv=none; b=KhkNi3wHlOPkuJirTpoWiQ4SbhGIskqj/uzWOBb2qGm3M3PeoQc3fiuWLC3Uh9/9wd+Vf6GP1cN5SZHabHyOpwL6pI7VX9gMd+hfiaGf8XXK0x4fL0ZPBBh6rhUtxGR2fS/WhQrRjc87o5UMGuzQjEoNJ0lygq/Kr2pnI2AtDIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803924; c=relaxed/simple;
	bh=QGVTDG/b5yF2L+/HnUI0RqkOAiZqMucnK8vJM1DYDw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkOzgCyCpAduvjQiEVpOyfiu1aAVhPGyMmlKALVjJv2AZr0h2V7IYjMIcVaGgN7SlY7LJlb1RVzlrDL6OO85OSfzbQu7taocmxuSOJoztsMwlInpd5+/JzRCIJ4FGOnXGW+No0pWaZq78VuuqUu69IRDBvQ/y5aX6b/Ipct4Bk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rd9OTCme; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rd9OTCme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF46C4AF1A;
	Wed, 19 Jun 2024 13:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803923;
	bh=QGVTDG/b5yF2L+/HnUI0RqkOAiZqMucnK8vJM1DYDw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rd9OTCmePiczyoFv7JfNsBvntTK8ZzT9uge8wLS9QUTERPf9eG/qW7NaYHXn8mr/c
	 JFTADfPoIZOoDa+GI92IlbX5LtXfUiTkrmseJTCwIg6n6go3H5YBscysmt+/lntHGv
	 9RicfltTJJFN8xrbu354cyKM0Bx0E/RJ17JRzTfg=
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
Subject: [PATCH 6.1 150/217] gve: ignore nonrelevant GSO type bits when processing TSO headers
Date: Wed, 19 Jun 2024 14:56:33 +0200
Message-ID: <20240619125602.476854684@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e84e944d751d2..5147fb37929e0 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -370,28 +370,18 @@ static int gve_prep_tso(struct sk_buff *skb)
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



