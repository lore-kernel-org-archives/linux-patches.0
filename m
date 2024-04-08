Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDE22E62C;
	Mon,  8 Apr 2024 13:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581791; cv=none; b=QfeNiWpXYuewORJ+i5rZbroe78TC8sCUDaDAHuBIprlQoQvvVwvV5n6Yf8B2pzox1X3fvOz6q//mMGVVJZqtmYvkj/Oepwe4gh4osXUc2xvGhCkcCIzmnRZPubCZfz5Q92DeowYhqY0Xyfo0uyuyJEH8IM+f/YZgmzSb2V4qEBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581791; c=relaxed/simple;
	bh=0IVUcbZqHFz+sTizvVUTGs1bqPaU1XsMxE/bp/CRcyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZvFvqqAYBsKbtVbCJjqDRuLp2SvPahwWvUi6pAk7P9hPtWisMBlrncASbync8guQOMpdnvNP00hwQOu2qdRzT4SDBvG2/NEsW78yYnjKZ8nJb1rBErgh2whXJuJ/X8koc4tGm8fka4qD8U6z8QkU25LYonLeL/ozMyaL/PPd7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrL/kBFL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrL/kBFL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B2CC433F1;
	Mon,  8 Apr 2024 13:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581791;
	bh=0IVUcbZqHFz+sTizvVUTGs1bqPaU1XsMxE/bp/CRcyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrL/kBFL+iMmU0iXYDy0X0+dFSsYLMwU+fIeWTl1TRd+NvOTsUnYmyi4yrKq6K36+
	 C3sZkvTmPg4avU3V0u2LpYFzdNa78nTgrkY3WTz5qop0hKgtdo7C9zh+2BAPssm4Vu
	 oV4ytLiQx4bvLvBmqySugjbs1VvIehUr/0OlsWXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 052/138] gro: fix ownership transfer
Date: Mon,  8 Apr 2024 14:57:46 +0200
Message-ID: <20240408125257.844996664@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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
@@ -252,8 +252,9 @@ int skb_gro_receive(struct sk_buff *p, s
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
@@ -441,8 +441,9 @@ static int skb_gro_receive_list(struct s
 	NAPI_GRO_CB(p)->count++;
 	p->data_len += skb->len;
 
-	/* sk owenrship - if any - completely transferred to the aggregated packet */
+	/* sk ownership - if any - completely transferred to the aggregated packet */
 	skb->destructor = NULL;
+	skb->sk = NULL;
 	p->truesize += skb->truesize;
 	p->len += skb->len;
 


