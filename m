Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC4C74438;
	Mon,  8 Apr 2024 14:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585174; cv=none; b=ehwa5gWNDeTeDF3w1xGhbKrVV9YLFjBr/FmJAFEuIHcq5npeQwrOxDNTDOBdYjava3ZeiuSI4mzlcAGlK1KreZBSfKJUDCmgixXLl42Knlxedfsm610cK6rdYIRzbPvtpxOO3cAIGhLlndOaqCf7/c4MWYtWGSZgC81IZjKP2oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585174; c=relaxed/simple;
	bh=UlMG9cH/me4JT4avTbNkakl5wGbrYxU70TcynvQQznw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6OfljCuQzNNKVP2Gae00WPE4d+dmCEkDdn1WssPYZQbJX3FFqDD1OO7kkEEOa1w8uwGM1lQlci4WQX075aQVvDflXY81DDAJI5cu4R50pb17LQbLee+XxYQfueB2Hm3ePVevhtERNm8FJ1IMWvSDdmojolI3Tuw4ODNkmIxlC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8SQznWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8SQznWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D9AC433C7;
	Mon,  8 Apr 2024 14:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585174;
	bh=UlMG9cH/me4JT4avTbNkakl5wGbrYxU70TcynvQQznw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8SQznWpKLOEb96JV1BW3nFHltRhVQw+Q0z33ZoGRyk4Px39pbKEwxpSY8PfppNv8
	 dGHhuUSYid3Mw2g24M0ugnFtN6d1U74+ch0gc+NHV+D9dBcvE1xnxQgjitpZAWTO1G
	 K3mwhxAV//nMuFWbR0hNKpovMxfbU/vLkiQGxiP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 689/690] gro: fix ownership transfer
Date: Mon,  8 Apr 2024 14:59:15 +0200
Message-ID: <20240408125424.683864290@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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

---
 net/core/skbuff.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3976,8 +3976,9 @@ int skb_gro_receive_list(struct sk_buff
 	NAPI_GRO_CB(p)->count++;
 	p->data_len += skb->len;
 
-	/* sk owenrship - if any - completely transferred to the aggregated packet */
+	/* sk ownership - if any - completely transferred to the aggregated packet */
 	skb->destructor = NULL;
+	skb->sk = NULL;
 	p->truesize += skb->truesize;
 	p->len += skb->len;
 
@@ -4425,8 +4426,9 @@ int skb_gro_receive(struct sk_buff *p, s
 	}
 
 merge:
-	/* sk owenrship - if any - completely transferred to the aggregated packet */
+	/* sk ownership - if any - completely transferred to the aggregated packet */
 	skb->destructor = NULL;
+	skb->sk = NULL;
 	delta_truesize = skb->truesize;
 	if (offset > headlen) {
 		unsigned int eat = offset - headlen;


