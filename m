Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9AD2EBDDB;
	Tue, 15 Jul 2025 13:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587599; cv=none; b=sJIOIOModQnHGE0es3i7VDDgrWb8HyLodCxL1IKILS9lftZ0bPh3aO+c7spBxnYfJ7n8S/tyE1vBX+edP8bBnqEAWUcFpGIdQyfHdTPB62JCc7wxfXmxjbmS2EL7sA7gqU71K1mlQ5Im9wL8sBi6vnuvlpbAdhdFG/ql2eL2Jjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587599; c=relaxed/simple;
	bh=54KF7qPk5noOB1Igmtue+H1sIX9DQ13aQp6xepRkuwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIjhPvu91kzIvaXyszgJdNlobOjswUCYKOJ0mqIgjDs9cAbznltM2jvnoOvxj8MIes/4S5qRFwWEHsgWUct6UfHmj31MGxy1a1JE0tgHTBZ7cGbSlqa/ZK4e2IOcKvGYZ9uRlnFhgeqKpO6rcnS6JIgVOpsGgDcKUvkSBNf59S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAn/9drm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAn/9drm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1203FC4CEE3;
	Tue, 15 Jul 2025 13:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587599;
	bh=54KF7qPk5noOB1Igmtue+H1sIX9DQ13aQp6xepRkuwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAn/9drmtewtjePciBLIlApjOL5JolFoSpi3ewA4nCL5dM0PB3b9qrFfw/FwSFT0s
	 7rlBhCB9q+uanQ4MiJikZR8vqm0WL+R2vN1G51aM/iZIUfmu2RDB/+fjvI5qJ9zMOf
	 Ezxa1EcUTkr5RvszPw8fJVtPky5eDD3vgfj7Asnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"regressions@lists.linux.dev, stable@vger.kernel.org, willemb@google.com, Brett A C Sheffield" <bacs@librecast.net>,
	Brett A C Sheffield <bacs@librecast.net>
Subject: [PATCH 5.10 073/208] Revert "ipv6: save dontfrag in cork"
Date: Tue, 15 Jul 2025 15:13:02 +0200
Message-ID: <20250715130813.873544891@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Brett A C Sheffield (Librecast) <bacs@librecast.net>

This reverts commit 29533d1a54b8de5aaf8c4aa6790dc67d5c14fba5 which is
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
@@ -189,7 +189,6 @@ struct inet6_cork {
 	struct ipv6_txoptions *opt;
 	u8 hop_limit;
 	u8 tclass;
-	u8 dontfrag:1;
 };
 
 /**
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1416,7 +1416,6 @@ static int ip6_setup_cork(struct sock *s
 	cork->fl.u.ip6 = *fl6;
 	v6_cork->hop_limit = ipc6->hlimit;
 	v6_cork->tclass = ipc6->tclass;
-	v6_cork->dontfrag = ipc6->dontfrag;
 	if (rt->dst.flags & DST_XFRM_TUNNEL)
 		mtu = np->pmtudisc >= IPV6_PMTUDISC_PROBE ?
 		      READ_ONCE(rt->dst.dev->mtu) : dst_mtu(&rt->dst);
@@ -1451,7 +1450,7 @@ static int __ip6_append_data(struct sock
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
 			     void *from, size_t length, int transhdrlen,
-			     unsigned int flags)
+			     unsigned int flags, struct ipcm6_cookie *ipc6)
 {
 	struct sk_buff *skb, *skb_prev = NULL;
 	unsigned int maxfraglen, fragheaderlen, mtu, orig_mtu, pmtu;
@@ -1508,7 +1507,7 @@ static int __ip6_append_data(struct sock
 	if (headersize + transhdrlen > mtu)
 		goto emsgsize;
 
-	if (cork->length + length > mtu - headersize && v6_cork->dontfrag &&
+	if (cork->length + length > mtu - headersize && ipc6->dontfrag &&
 	    (sk->sk_protocol == IPPROTO_UDP ||
 	     sk->sk_protocol == IPPROTO_RAW)) {
 		ipv6_local_rxpmtu(sk, fl6, mtu - headersize +
@@ -1826,7 +1825,7 @@ int ip6_append_data(struct sock *sk,
 
 	return __ip6_append_data(sk, fl6, &sk->sk_write_queue, &inet->cork.base,
 				 &np->cork, sk_page_frag(sk), getfrag,
-				 from, length, transhdrlen, flags);
+				 from, length, transhdrlen, flags, ipc6);
 }
 EXPORT_SYMBOL_GPL(ip6_append_data);
 
@@ -2021,7 +2020,7 @@ struct sk_buff *ip6_make_skb(struct sock
 	err = __ip6_append_data(sk, fl6, &queue, &cork->base, &v6_cork,
 				&current->task_frag, getfrag, from,
 				length + exthdrlen, transhdrlen + exthdrlen,
-				flags);
+				flags, ipc6);
 	if (err) {
 		__ip6_flush_pending_frames(sk, &queue, cork, &v6_cork);
 		return ERR_PTR(err);


