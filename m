Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D91D47DFB9;
	Thu, 20 Aug 2026 17:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248418; cv=none; b=YYNpr/z4k8QIQ6S83wfXYBQ1HP38uzGVnltr4Gd0q6aq+Lm+Rfy6Gt745x8sivLvcNyB9RJZ+iXhLls0y2LCMaR6GwsVmCIlN7v/3LrRHNxVyuwCu7iOkDDchamjT84DvgZnWEvVza+opQPgTcvN4AZJ38zQf3/Yun1sGXirQNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248418; c=relaxed/simple;
	bh=kCYrjDDrOrfMWFvOZ+/K74exkBlJjsmEj35k74msZj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJ7IiYzw1mjdTQg1RGgyFsAcGb+Psh2nV2nZFHdc1c94h4N7yGiPnfhqON2g3BoIrQKd/WS+z+z+nMoBl9/CWuIj3xbgDhxXsbPptoLBWtju4ESfXEVJEjnTxBjrWs+simpuQYYfWdEd31KF2NSdvlYd8UyO0hGlCL/Tzs8HbT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnsqK+iX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnsqK+iX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAF01F000E9;
	Thu, 20 Aug 2026 17:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248417;
	bh=/9N3iY+zbGDk+fKZ0C7RYMnF/HesBz/8O326IjufZhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EnsqK+iXuqRxT5xSJzvVPLitTGHSD+aX7xXPlmiGEtwUmnKp+0FMKNqClqjr4RJ6u
	 tQc1PcDWwEIeArDXmc4/oGTSk0BchWcWh0TmJq9qcmm950OLHRM+CwHeq1EK0Wi/Ty
	 ocpIMTj44LMN27c7SjXEXH2UtcX20zbofo1IxtwQ=
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
Subject: [PATCH 6.1 219/303] net: move skb_gro_receive_list from udp to core
Date: Thu, 20 Aug 2026 16:55:55 +0200
Message-ID: <20260820145259.980850001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -424,6 +424,7 @@ static inline __wsum ip6_gro_compute_pse
 }
 
 int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb);
+int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb);
 
 /* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
 static inline void gro_normal_list(struct napi_struct *napi)
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -295,6 +295,35 @@ done:
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
@@ -526,35 +526,6 @@ out:
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


