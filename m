Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA2A15442C;
	Thu,  3 Jul 2025 15:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555872; cv=none; b=mLCyZJva4EYD5D4raHeDgETaUFgLVr4pZFE8Aja52h0kasSMP9Dnj3gjNZPbdSuhj4Yw4DLaCOoMCseBOHLmAyIiVDpTO3LUj5wDbgcKOIAjZSKJsqVQ5iotArPtitoRo9k1nRmaCpaXGLBEFznJBtO6AMWVS52E/16O2xk6hWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555872; c=relaxed/simple;
	bh=4UNbGxzFItyML5RTstbPU/3qCOnZBmovDZk7QbsTG+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0NGCsxzAZPawrs2zx1mvsEBymI66hM1v6IKb3OICUyfavwezPXgBliowcBlANqVQsJELGYAil7252hj7wAvQ/mjwSBc+DJnOc6vFWxtSN2n81M9uQuTwFgB9/JRxqbWpPj4r0EA9C2QPWbOwhJsuvgbZIDUP0nMPxPoiupezhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvCEzKCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvCEzKCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D99CC4CEED;
	Thu,  3 Jul 2025 15:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555872;
	bh=4UNbGxzFItyML5RTstbPU/3qCOnZBmovDZk7QbsTG+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvCEzKCkDhV0hquTWXUdCM9R/cHU2E7jfIoKWJ5HbLbnsW9cxhedg5ap4rf6ldPOU
	 HjjQTxEsWkw4rUF3q17fwe81RiG3Kvx7Op1o+w34BiJqxMpH4EVAivaLDY7XblQUyo
	 ++kWOW0ePSigN97NaE4XMiszSgZGSlXxmn30xlIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"regressions@lists.linux.dev, stable@vger.kernel.org, willemb@google.com, Brett A C Sheffield" <bacs@librecast.net>,
	Brett A C Sheffield <bacs@librecast.net>
Subject: [PATCH 6.6 135/139] Revert "ipv6: save dontfrag in cork"
Date: Thu,  3 Jul 2025 16:43:18 +0200
Message-ID: <20250703143946.457484387@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
User-Agent: quilt/0.68
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


From: Brett A C Sheffield (Librecast) <bacs@librecast.net>

This reverts commit 8ebf2709fe4dcd0a1b7b95bf61e529ddcd3cdf51 which is
commit a18dfa9925b9ef6107ea3aa5814ca3c704d34a8a upstream.

A regression was introduced when backporting this to the stable kernels
without applying previous commits in this series.

When sending IPv6 UDP packets larger than MTU, EMSGSIZE was returned
instead of fragmenting the packets as expected.

As there is no compelling reason for this commit to be present in the
stable kernels it should be reverted.

Signed-off-by: Brett A C Sheffield <bacs@librecast.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ipv6.h  |    1 -
 net/ipv6/ip6_output.c |    9 ++++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -199,7 +199,6 @@ struct inet6_cork {
 	struct ipv6_txoptions *opt;
 	u8 hop_limit;
 	u8 tclass;
-	u8 dontfrag:1;
 };
 
 /* struct ipv6_pinfo - ipv6 private area */
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1452,7 +1452,6 @@ static int ip6_setup_cork(struct sock *s
 	}
 	v6_cork->hop_limit = ipc6->hlimit;
 	v6_cork->tclass = ipc6->tclass;
-	v6_cork->dontfrag = ipc6->dontfrag;
 	if (rt->dst.flags & DST_XFRM_TUNNEL)
 		mtu = np->pmtudisc >= IPV6_PMTUDISC_PROBE ?
 		      READ_ONCE(rt->dst.dev->mtu) : dst_mtu(&rt->dst);
@@ -1486,7 +1485,7 @@ static int __ip6_append_data(struct sock
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
 			     void *from, size_t length, int transhdrlen,
-			     unsigned int flags)
+			     unsigned int flags, struct ipcm6_cookie *ipc6)
 {
 	struct sk_buff *skb, *skb_prev = NULL;
 	struct inet_cork *cork = &cork_full->base;
@@ -1542,7 +1541,7 @@ static int __ip6_append_data(struct sock
 	if (headersize + transhdrlen > mtu)
 		goto emsgsize;
 
-	if (cork->length + length > mtu - headersize && v6_cork->dontfrag &&
+	if (cork->length + length > mtu - headersize && ipc6->dontfrag &&
 	    (sk->sk_protocol == IPPROTO_UDP ||
 	     sk->sk_protocol == IPPROTO_ICMPV6 ||
 	     sk->sk_protocol == IPPROTO_RAW)) {
@@ -1914,7 +1913,7 @@ int ip6_append_data(struct sock *sk,
 
 	return __ip6_append_data(sk, &sk->sk_write_queue, &inet->cork,
 				 &np->cork, sk_page_frag(sk), getfrag,
-				 from, length, transhdrlen, flags);
+				 from, length, transhdrlen, flags, ipc6);
 }
 EXPORT_SYMBOL_GPL(ip6_append_data);
 
@@ -2119,7 +2118,7 @@ struct sk_buff *ip6_make_skb(struct sock
 	err = __ip6_append_data(sk, &queue, cork, &v6_cork,
 				&current->task_frag, getfrag, from,
 				length + exthdrlen, transhdrlen + exthdrlen,
-				flags);
+				flags, ipc6);
 	if (err) {
 		__ip6_flush_pending_frames(sk, &queue, cork, &v6_cork);
 		return ERR_PTR(err);


