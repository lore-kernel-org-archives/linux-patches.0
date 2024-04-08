Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC66C79F0;
	Mon,  8 Apr 2024 13:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582933; cv=none; b=rfjs84r4RmSiDUAEIjjSSsBHtW/mLxOthw8psZQdoUcASZ430no3cfk6akdHduTQ7UasnQ84c0AokTwCm2hpN8s5ot+rn88AAfYh2IetOrtOb5CGDBR2YLaR7FB09mK0hCn9p7z++L69s6WHHLDWFOaTDspdvK+0aHFLQEGHwQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582933; c=relaxed/simple;
	bh=904XqTgLBm95N27F7oZmjRTe/yRrKHOjAO0aods+2Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kd6MC++C/mer2sh1FgNbsxSZO+9vJ+n7MPo8mW2kHNQCEoJvyk+ENMLHbEkzJYys6aCapigvYeCB6n3HcSRFbOyxs83uWkRyJs84NkVvzku4Itu7A3vEWJC5+k1Xpvh2+g+wPTjyR+9WHxEAjxNbfBJrxSomsQHRy+1K0mOUcQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wu7oEGq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wu7oEGq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715D7C433C7;
	Mon,  8 Apr 2024 13:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582932;
	bh=904XqTgLBm95N27F7oZmjRTe/yRrKHOjAO0aods+2Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wu7oEGq8VFiOMLNFIelibPnPxZ+CHPvk+LZqLY/DB7FwEaQrXxZ3CmjL5q0+rBAG8
	 AfeYFJK+gOvOlKjvWzvHLzxCDiEOYb7BLwg7fO1FuSG2luxy7DpPcCdyL4GKPFl7gY
	 8gkUNN/i5szSOxFK4oIKN6hBPMRrS8LIFK12wlGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 113/252] gro: fix ownership transfer
Date: Mon,  8 Apr 2024 14:56:52 +0200
Message-ID: <20240408125310.143550801@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Antoine Tenart <atenart@kernel.org>

commit ed4cccef64c1d0d5b91e69f7a8a6697c3a865486 upstream.

If packets are GROed with fraglist they might be segmented later on and
continue their journey in the stack. In skb_segment_list those skbs can
be reused as-is. This is an issue as their destructor was removed in
skb_gro_receive_list but not the reference to their socket, and then
they can't be orphaned. Fix this by also removing the reference to the
socket.

For example this could be observed,

  kernel BUG at include/linux/skbuff.h:3131!  (skb_orphan)
  RIP: 0010:ip6_rcv_core+0x11bc/0x19a0
  Call Trace:
   ipv6_list_rcv+0x250/0x3f0
   __netif_receive_skb_list_core+0x49d/0x8f0
   netif_receive_skb_list_internal+0x634/0xd40
   napi_complete_done+0x1d2/0x7d0
   gro_cell_poll+0x118/0x1f0

A similar construction is found in skb_gro_receive, apply the same
change there.

Fixes: 5e10da5385d2 ("skbuff: allow 'slow_gro' for skb carring sock reference")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/gro.c         |    3 ++-
 net/ipv4/udp_offload.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -195,8 +195,9 @@ int skb_gro_receive(struct sk_buff *p, s
 	}
 
 merge:
-	/* sk owenrship - if any - completely transferred to the aggregated packet */
+	/* sk ownership - if any - completely transferred to the aggregated packet */
 	skb->destructor = NULL;
+	skb->sk = NULL;
 	delta_truesize = skb->truesize;
 	if (offset > headlen) {
 		unsigned int eat = offset - headlen;
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -449,8 +449,9 @@ static int skb_gro_receive_list(struct s
 	NAPI_GRO_CB(p)->count++;
 	p->data_len += skb->len;
 
-	/* sk owenrship - if any - completely transferred to the aggregated packet */
+	/* sk ownership - if any - completely transferred to the aggregated packet */
 	skb->destructor = NULL;
+	skb->sk = NULL;
 	p->truesize += skb->truesize;
 	p->len += skb->len;
 


