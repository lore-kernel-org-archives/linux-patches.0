Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB119D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7167EC433EF;
	Mon, 12 Jun 2023 10:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566932;
	bh=6Y6/0m5cmc2yHceB393htXJuSpcOf+tERViRuoHXJdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiLIKd3RIMlqjV2mUz2zIplDgYXiD7laXozM7lLMZlzMAah5AIhqzrI6NQ0gcBT2K
	 /9SdKwySVPICP/2NBN1EXNIR1o0iJZ8llWPJ6ajyzX2x6Ic+IC/X8nIoWWHZ1n/VD9
	 9/LOByUOyvYQterGYW3b5juNdXd6RTodcmCtRudQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 048/160] tcp: gso: really support BIG TCP
Date: Mon, 12 Jun 2023 12:26:20 +0200
Message-ID: <20230612101717.232126985@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 82a01ab35bd02ba4b0b4e12bc95c5b69240eb7b0 ]

We missed that tcp_gso_segment() was assuming skb->len was smaller than 65535 :

oldlen = (u16)~skb->len;

This part came with commit 0718bcc09b35 ("[NET]: Fix CHECKSUM_HW GSO problems.")

This leads to wrong TCP checksum.

Adapt the code to accept arbitrary packet length.

v2:
  - use two csum_add() instead of csum_fold() (Alexander Duyck)
  - Change delta type to __wsum to reduce casts (Alexander Duyck)

Fixes: 09f3d1a3a52c ("ipv6/gso: remove temporary HBH/jumbo header")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230605161647.3624428-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_offload.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 45dda78893870..4851211aa60d6 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -60,12 +60,12 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	struct tcphdr *th;
 	unsigned int thlen;
 	unsigned int seq;
-	__be32 delta;
 	unsigned int oldlen;
 	unsigned int mss;
 	struct sk_buff *gso_skb = skb;
 	__sum16 newcheck;
 	bool ooo_okay, copy_destructor;
+	__wsum delta;
 
 	th = tcp_hdr(skb);
 	thlen = th->doff * 4;
@@ -75,7 +75,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, thlen))
 		goto out;
 
-	oldlen = (u16)~skb->len;
+	oldlen = ~skb->len;
 	__skb_pull(skb, thlen);
 
 	mss = skb_shinfo(skb)->gso_size;
@@ -110,7 +110,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	if (skb_is_gso(segs))
 		mss *= skb_shinfo(segs)->gso_segs;
 
-	delta = htonl(oldlen + (thlen + mss));
+	delta = (__force __wsum)htonl(oldlen + thlen + mss);
 
 	skb = segs;
 	th = tcp_hdr(skb);
@@ -119,8 +119,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	if (unlikely(skb_shinfo(gso_skb)->tx_flags & SKBTX_SW_TSTAMP))
 		tcp_gso_tstamp(segs, skb_shinfo(gso_skb)->tskey, seq, mss);
 
-	newcheck = ~csum_fold((__force __wsum)((__force u32)th->check +
-					       (__force u32)delta));
+	newcheck = ~csum_fold(csum_add(csum_unfold(th->check), delta));
 
 	while (skb->next) {
 		th->fin = th->psh = 0;
@@ -165,11 +164,11 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 			WARN_ON_ONCE(refcount_sub_and_test(-delta, &skb->sk->sk_wmem_alloc));
 	}
 
-	delta = htonl(oldlen + (skb_tail_pointer(skb) -
-				skb_transport_header(skb)) +
-		      skb->data_len);
-	th->check = ~csum_fold((__force __wsum)((__force u32)th->check +
-				(__force u32)delta));
+	delta = (__force __wsum)htonl(oldlen +
+				      (skb_tail_pointer(skb) -
+				       skb_transport_header(skb)) +
+				      skb->data_len);
+	th->check = ~csum_fold(csum_add(csum_unfold(th->check), delta));
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		gso_reset_checksum(skb, ~th->check);
 	else
-- 
2.39.2



