Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1882E405;
	Mon,  8 Apr 2024 13:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582825; cv=none; b=Q8D7EL0X/kLXohNpFNAlI19iXjJdV0hw/e1NHjdo5U6e7dOZ2lMth4U/lUMPfko8aY9gjlURK06EmbJZWtHjKZ3uXFHKUuZ105m44Ol57Rgv4e5exZyvG8+jQdiksLEQqtF/cmoOWs4cR12MXq8wanaQKncrEr72aEtkzSpgeQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582825; c=relaxed/simple;
	bh=VuBCR92U/0DvCH5xQYa+uKVxVnhcj0uRCpgzUAkv7jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qU6Em0XRX0bnCMwdWAvo/H7V3427nPWyv8MtvF/+e0RzP1PiKMmlrX5wtOCElFHsGUFLYDVo31vMguBGD5Gfk8/BqqWNgl8W8yGNf3OxXQqYSK76NC2UvMyakmZ0+7U2LOppiuGVBpIMhVissO+TxA5jCQoy0KnAt1tAAhQhSHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNqHFeOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNqHFeOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95C3C433C7;
	Mon,  8 Apr 2024 13:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582825;
	bh=VuBCR92U/0DvCH5xQYa+uKVxVnhcj0uRCpgzUAkv7jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNqHFeOd/UmqSuyI+GetVifQKSXt0I2SmySee1rSp7sIV8dVONgjXGnbaXe8066RB
	 BKU1tQ2z0D2Z4OJazTL+/6I39+WP3HhORnpIGO6A9ZMFMOAkQad+Ake8oz4LcIg/m5
	 jayKf64QtBMsYKL3vYmo+A4gS/uMwGeK20yeS1wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.8 108/273] gro: fix ownership transfer
Date: Mon,  8 Apr 2024 14:56:23 +0200
Message-ID: <20240408125312.658101895@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 


