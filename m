Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF4919CC3D;
	Thu,  3 Jul 2025 15:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556293; cv=none; b=rJayb/qDQmRUU9ss/OTwEHMsO1hDaZJA7vVfMunmj1lzS0Noy747kwbITcJihrTq3Hi8GZtmR2IWebDvcqB4a+hbWARmrR3HVj8gyv08LT+DXyrT/svVmWoju5jz3gMgDsWKBRC5D2hAuXAb2L+My9yOSyvXCHYPjyMFCndnX6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556293; c=relaxed/simple;
	bh=jAAf6VbBmOQZLq8aJBdgFJ3TxCX9uXLPh1yvCv8Khq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QB1wbzu7mjp75SAU05VWVBQtCV8tpZouXEtb4GK/x9dpwGcnZSBEWMdU1Hq4y13GZBfm25aiR5K51yeWi5b5r8EAGazDHOO2vWfumlqKkTSgEfXm68utK2os0SeQ+GNoIiFaa44xW+5hZXH4bypGqtLe9dyqwWaD/wtbkFO3w5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dm8ssWR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dm8ssWR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6CFC4CEE3;
	Thu,  3 Jul 2025 15:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556292;
	bh=jAAf6VbBmOQZLq8aJBdgFJ3TxCX9uXLPh1yvCv8Khq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dm8ssWR/YHX0lxbd/PU0azC/ZhETyUOHhcnQKKV3P00XeZ5wk9oyt1oQDKGKll9jX
	 AJP6n5lddYJtcUBKBL138WMxW1NJymG7KE96H0+PguMiJFHjzW5kEX+cIE17N/OD+a
	 SemgDu0nkc9IcvKcw7b7KSnad7O/WAbbG2wT67rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"regressions@lists.linux.dev, stable@vger.kernel.org, willemb@google.com, Brett A C Sheffield" <bacs@librecast.net>,
	Brett A C Sheffield <bacs@librecast.net>
Subject: [PATCH 6.1 127/132] Revert "ipv6: save dontfrag in cork"
Date: Thu,  3 Jul 2025 16:43:36 +0200
Message-ID: <20250703143944.377359902@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Brett A C Sheffield (Librecast) <bacs@librecast.net>

This reverts commit 4f809be95d9f3db13d31c574b8764c8d429f0c3b which is
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
 
 /**
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1450,7 +1450,6 @@ static int ip6_setup_cork(struct sock *s
 	}
 	v6_cork->hop_limit = ipc6->hlimit;
 	v6_cork->tclass = ipc6->tclass;
-	v6_cork->dontfrag = ipc6->dontfrag;
 	if (rt->dst.flags & DST_XFRM_TUNNEL)
 		mtu = np->pmtudisc >= IPV6_PMTUDISC_PROBE ?
 		      READ_ONCE(rt->dst.dev->mtu) : dst_mtu(&rt->dst);
@@ -1484,7 +1483,7 @@ static int __ip6_append_data(struct sock
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
 			     void *from, size_t length, int transhdrlen,
-			     unsigned int flags)
+			     unsigned int flags, struct ipcm6_cookie *ipc6)
 {
 	struct sk_buff *skb, *skb_prev = NULL;
 	struct inet_cork *cork = &cork_full->base;
@@ -1540,7 +1539,7 @@ static int __ip6_append_data(struct sock
 	if (headersize + transhdrlen > mtu)
 		goto emsgsize;
 
-	if (cork->length + length > mtu - headersize && v6_cork->dontfrag &&
+	if (cork->length + length > mtu - headersize && ipc6->dontfrag &&
 	    (sk->sk_protocol == IPPROTO_UDP ||
 	     sk->sk_protocol == IPPROTO_ICMPV6 ||
 	     sk->sk_protocol == IPPROTO_RAW)) {
@@ -1885,7 +1884,7 @@ int ip6_append_data(struct sock *sk,
 
 	return __ip6_append_data(sk, &sk->sk_write_queue, &inet->cork,
 				 &np->cork, sk_page_frag(sk), getfrag,
-				 from, length, transhdrlen, flags);
+				 from, length, transhdrlen, flags, ipc6);
 }
 EXPORT_SYMBOL_GPL(ip6_append_data);
 
@@ -2090,7 +2089,7 @@ struct sk_buff *ip6_make_skb(struct sock
 	err = __ip6_append_data(sk, &queue, cork, &v6_cork,
 				&current->task_frag, getfrag, from,
 				length + exthdrlen, transhdrlen + exthdrlen,
-				flags);
+				flags, ipc6);
 	if (err) {
 		__ip6_flush_pending_frames(sk, &queue, cork, &v6_cork);
 		return ERR_PTR(err);


