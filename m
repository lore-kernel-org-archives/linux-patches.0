Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2FA1C0DE7;
	Tue, 27 Aug 2024 15:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772732; cv=none; b=EoIVaRuNYbVYS5uf6hIFAdjEDvGlZZ6YKX738IGqLskYd0w/hq+DpzZZYaFiwddoGLNkS0L6MZLJ0ZWqd6fcH+bQpym39XgsF69nEXqjrDlLgoobtegDD0JPvE5WNyO9lIeB6n/DpTgZrz4ODibx8JjL6kdBnLoBDzKFETLpNJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772732; c=relaxed/simple;
	bh=9Hr4b0puNcBjkGOuJqnCo0uXIRVTZNVcChpQHbhOGxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5FutpRDdqKATkRDqyUfehmRGK+WGzwtR0ixql1Np56QX7ZYKSg+Lg03hPaP/+Xdjipxd8oeUr6D2nn3hj8HZEolkRCPU9jPmsvqnGf0/jXee+ZO+f9/OL65rBpKBhdUgiYEPallxZHVI80NC8bln8n6kMsFPUsb9r4eyvpRdGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imnD/Je5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imnD/Je5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24941C4DE04;
	Tue, 27 Aug 2024 15:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772731;
	bh=9Hr4b0puNcBjkGOuJqnCo0uXIRVTZNVcChpQHbhOGxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imnD/Je5x6LOK96dqEQCcX6Vem0rcaDGIQznS8ATrIiKOLZa/ikBwxrL6tbPOJz32
	 xIk96Iak1AYUF+ZFkLBmzN0MhTP5OaoJxn46nKWHyug+X/a0DcLp1BTJEYifnYkjd+
	 aZBxYX4FQOj3LI7ov/yVp7J0Ldt9oGY7BNhILMIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Yan Zhai <yan@cloudflare.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 301/321] gso: fix dodgy bit handling for GSO_UDP_L4
Date: Tue, 27 Aug 2024 16:40:09 +0200
Message-ID: <20240827143849.714078602@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Yan Zhai <yan@cloudflare.com>

commit 9840036786d90cea11a90d1f30b6dc003b34ee67 upstream.

Commit 1fd54773c267 ("udp: allow header check for dodgy GSO_UDP_L4
packets.") checks DODGY bit for UDP, but for packets that can be fed
directly to the device after gso_segs reset, it actually falls through
to fragmentation:

https://lore.kernel.org/all/CAJPywTKDdjtwkLVUW6LRA2FU912qcDmQOQGt2WaDo28KzYDg+A@mail.gmail.com/

This change restores the expected behavior of GSO_UDP_L4 packets.

Fixes: 1fd54773c267 ("udp: allow header check for dodgy GSO_UDP_L4 packets.")
Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Yan Zhai <yan@cloudflare.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp_offload.c |   16 +++++++++++-----
 net/ipv6/udp_offload.c |    3 +--
 2 files changed, 12 insertions(+), 7 deletions(-)

--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -273,13 +273,20 @@ struct sk_buff *__udp_gso_segment(struct
 	__sum16 check;
 	__be16 newlen;
 
-	if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)
-		return __udp_gso_segment_list(gso_skb, features, is_ipv6);
-
 	mss = skb_shinfo(gso_skb)->gso_size;
 	if (gso_skb->len <= sizeof(*uh) + mss)
 		return ERR_PTR(-EINVAL);
 
+	if (skb_gso_ok(gso_skb, features | NETIF_F_GSO_ROBUST)) {
+		/* Packet is from an untrusted source, reset gso_segs. */
+		skb_shinfo(gso_skb)->gso_segs = DIV_ROUND_UP(gso_skb->len - sizeof(*uh),
+							     mss);
+		return NULL;
+	}
+
+	if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)
+		return __udp_gso_segment_list(gso_skb, features, is_ipv6);
+
 	skb_pull(gso_skb, sizeof(*uh));
 
 	/* clear destructor to avoid skb_segment assigning it to tail */
@@ -387,8 +394,7 @@ static struct sk_buff *udp4_ufo_fragment
 	if (!pskb_may_pull(skb, sizeof(struct udphdr)))
 		goto out;
 
-	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 &&
-	    !skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST))
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
 		return __udp_gso_segment(skb, features, false);
 
 	mss = skb_shinfo(skb)->gso_size;
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -42,8 +42,7 @@ static struct sk_buff *udp6_ufo_fragment
 		if (!pskb_may_pull(skb, sizeof(struct udphdr)))
 			goto out;
 
-		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 &&
-		    !skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST))
+		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
 			return __udp_gso_segment(skb, features, true);
 
 		mss = skb_shinfo(skb)->gso_size;


