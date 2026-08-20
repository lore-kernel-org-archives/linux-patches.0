Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18081469843;
	Thu, 20 Aug 2026 17:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247543; cv=none; b=dZZnOUEvHQSvZSupS3gv1INhRRP9AHH6i5E8WlZIlZy+2Bf6Qm6ZTnqcZCV06IIvahq9vk+zJ3x5yblX2fTZ9Va6s6bbxCil6eXo7U/kgu1qv0c1gU2L3aDpACyyqonJhgU+MGmdNDaUq7kw2pIJpV00VTxg/kGH9ec1uH1uoXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247543; c=relaxed/simple;
	bh=c9oDIzFQi5qOrUZKOR0iXTdLT2Ds0eL+n7K4Lv7JzU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dA9zvCH7+AIE3dVSbqRcHWsapLer++EGy8fRkATQcqqF/teE/dAd+B1Pet3zPJqLznduTAw1rqU8NF1wt7wL1zFB7/UeDJw9g2toARM350FEbeXvQwzp9p7KoFngyhWYcanDFrZKRS86UrAat91w0VonmSEiBPNfDzF9+HrvUtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEQafnli; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEQafnli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4931F00A3A;
	Thu, 20 Aug 2026 17:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247541;
	bh=6XYz4t/xI+XefasOYxEKOdwZkngxL1sE6424EkGxJVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEQafnliEgUQoAbg818U1bpCQDSmOxWo+2DT+9oVK8QwehecdUqFneSdwYovzSm+a
	 EgG7XnQpHoJ548SHuPR6N6C9dde1YEkU1EdU9ED7fTlRODGCd91Khpqu9S+dwDaZJ4
	 1tefF5Zhj1c93CqJOhwEY8fR6ZBVCgWkkJbZ567o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Felix Fietkau <nbd@nbd.name>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/166] net: move skb_gro_receive_list from udp to core
Date: Thu, 20 Aug 2026 16:55:42 +0200
Message-ID: <20260820145213.649435901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 8928756d53d5b99dcd18073dc7738b8ebdbe7d96 ]

This helper function will be used for TCP fraglist GRO support

Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: e751256486d0 ("net: gro: fix double aggregation of flush-marked skbs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/gro.h      |    1 +
 net/core/gro.c         |   29 +++++++++++++++++++++++++++++
 net/ipv4/udp_offload.c |   29 -----------------------------
 3 files changed, 30 insertions(+), 29 deletions(-)

--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -442,6 +442,7 @@ static inline __wsum ip6_gro_compute_pse
 }
 
 int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb);
+int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb);
 
 /* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
 static inline void gro_normal_list(struct napi_struct *napi)
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -230,6 +230,35 @@ done:
 	return 0;
 }
 
+int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb)
+{
+	if (unlikely(p->len + skb->len >= 65536))
+		return -E2BIG;
+
+	if (NAPI_GRO_CB(p)->last == p)
+		skb_shinfo(p)->frag_list = skb;
+	else
+		NAPI_GRO_CB(p)->last->next = skb;
+
+	skb_pull(skb, skb_gro_offset(skb));
+
+	NAPI_GRO_CB(p)->last = skb;
+	NAPI_GRO_CB(p)->count++;
+	p->data_len += skb->len;
+
+	/* sk ownership - if any - completely transferred to the aggregated packet */
+	skb->destructor = NULL;
+	skb->sk = NULL;
+	p->truesize += skb->truesize;
+	p->len += skb->len;
+
+	skb_shinfo(p)->flags |= skb_shinfo(skb)->flags & SKBFL_SHARED_FRAG;
+
+	NAPI_GRO_CB(skb)->same_flow = 1;
+
+	return 0;
+}
+
 
 static void napi_gro_complete(struct napi_struct *napi, struct sk_buff *skb)
 {
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -527,35 +527,6 @@ out:
 	return segs;
 }
 
-static int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb)
-{
-	if (unlikely(p->len + skb->len >= 65536))
-		return -E2BIG;
-
-	if (NAPI_GRO_CB(p)->last == p)
-		skb_shinfo(p)->frag_list = skb;
-	else
-		NAPI_GRO_CB(p)->last->next = skb;
-
-	skb_pull(skb, skb_gro_offset(skb));
-
-	NAPI_GRO_CB(p)->last = skb;
-	NAPI_GRO_CB(p)->count++;
-	p->data_len += skb->len;
-
-	/* sk ownership - if any - completely transferred to the aggregated packet */
-	skb->destructor = NULL;
-	skb->sk = NULL;
-	p->truesize += skb->truesize;
-	p->len += skb->len;
-
-	skb_shinfo(p)->flags |= skb_shinfo(skb)->flags & SKBFL_SHARED_FRAG;
-
-	NAPI_GRO_CB(skb)->same_flow = 1;
-
-	return 0;
-}
-
 
 #define UDP_GRO_CNT_MAX 64
 static struct sk_buff *udp_gro_receive_segment(struct list_head *head,


