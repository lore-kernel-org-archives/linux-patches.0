Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624862;
	b=AVFJ7JmTsWurMDv+GTfljqbcmBTIHa9RKrIDJ3B1fsBvb+9p3hNxASnJHXaF0Ekcvp+g
	 /DD1DhTQiwigcdJNxQGWfsF5DxiZi5feDQch8aqMAZ9Sae/s3Gc2sWWVm86PKxvzQ1ryj
	 eP9IfpMf9ofR9IhsthGMtS2kLRbch8JrKf+yOYEosUgcgPFAN+xy54fprAACbh2hllS4N
	 poaiU2KgUSsCQMLGbPQLRR/LJnwzbdCowVJ/uf077w8GGJN9iqpCQFR8keoEx1e20pbsP
	 zqsfmaiWyAbYuC+MRaWyWwSZsYGzu0l5XDkqF2ZVKq3+EIXN+huIc9Y2ZitPjcMWalw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Ie1z1EEzJeNaGTDdz8K0f7ENArQ/FSebnVXlFJK8So=;
	b=0QAcqwgQD7Atc4ykEMXpf/lSKBgH9M5QtLo0ORbVSzniOCCwk1uNztHrF66YKcpCPUs1
	 WMJfGu6n8E1aMg/3T0epYsWBTbptDDWnzxyyRm1Vy9/qWsbGI52+1f23Dht/vpJEBLQaH
	 yWTD7C4B2P0C0ixBrpyJPYG5LsjBWL7LMKxPKceQ8N1xXLUIw5kKDQ2J2T9alLwb7dVLn
	 13biV2x7hB8h2SpfCNJ00VFODiDV/AULAb7kQMnHN5RV6yhok4ZXdVlJp/RueIn7bo6ac
	 izcLih8P3LfDhYL53+V5jKe5+0tx/EhH6bYB8iImJlJsVU81VWRH5K0OVJhpNP9rEJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n+pQHVQI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77986606A31E;
	Wed, 25 Nov 2026 16:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n+pQHVQI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A44C1F000C0;
	Wed, 25 Nov 2026 16:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624861;
	bh=/Ie1z1EEzJeNaGTDdz8K0f7ENArQ/FSebnVXlFJK8So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+pQHVQIr5b/I5+7tn+4mh8lftQt2r33RX3rRz/aA6G6o0EgYPA8/Tk2GKdsZZ621
	 5p7nhI9d7B6lPUTvuQ76ccZFkUgUzFLqew2PcY4wE0ESktg1LaSjULshy04tG70qwi
	 o1D/Df3M9CaqQ40Ib3dSTJTqLHfHwyB3+v7yumIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Chris Mason <mason@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 331/816] net: skbuff: uncharge trimmed zerocopy frags on error
Date: Wed, 25 Nov 2026 15:31:19 +0100
Message-ID: <20261125143856.861391598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 8b67debdfbf6b370312ebec5c9e0a1c39b5c7733 ]

__zerocopy_sg_from_iter() accounts for the frags that it adds even when
it returns an error: it adds the growth of skb->truesize to
sk_wmem_queued and, unless the skb is pure zerocopy, charges it to the
socket.

On error, skb_zerocopy_iter_stream() cannot free the skb, as it may hold
data from an earlier send. It trims the new frags, but leaves
skb->truesize and their accounting in place.

Repeated failed sends to the same skb accumulate this stale accounting.
This can inflate TCP memory accounting past tcp_mem, and can wrap
skb->truesize, leading to a use-after-free of the socket.

Undo the accounting after the trim. If the trim fails, the frags and
their accounting remain. The trim only fails if the skb is cloned,
which is not expected for the unsent skb at the TCP write queue tail.

The issue was found by an LLM.

Fixes: 52267790ef52 ("sock: add MSG_ZEROCOPY")
Reported-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Chris Mason <mason@kernel.org>
[willemb: revised commit message]
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261105223512.3647504-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5c7af2ce14a80..341cc822933f1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1886,6 +1886,7 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 			     struct msghdr *msg, int len,
 			     struct ubuf_info *uarg)
 {
+	unsigned int orig_truesize = skb->truesize;
 	int err, orig_len = skb->len;
 
 	if (uarg->ops->link_skb) {
@@ -1905,12 +1906,18 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 
 	err = __zerocopy_sg_from_iter(msg, sk, skb, &msg->msg_iter, len);
 	if (err == -EFAULT || (err == -EMSGSIZE && skb->len == orig_len)) {
+		u32 delta_truesize = skb->truesize - orig_truesize;
 		struct sock *save_sk = skb->sk;
 
 		/* Streams do not free skb on error. Reset to prev state. */
 		iov_iter_revert(&msg->msg_iter, skb->len - orig_len);
 		skb->sk = sk;
-		___pskb_trim(skb, orig_len);
+		if (!___pskb_trim(skb, orig_len)) {
+			skb->truesize -= delta_truesize;
+			sk_wmem_queued_add(sk, -delta_truesize);
+			if (!skb_zcopy_pure(skb))
+				sk_mem_uncharge(sk, delta_truesize);
+		}
 		skb->sk = save_sk;
 		return err;
 	}
-- 
2.53.0



