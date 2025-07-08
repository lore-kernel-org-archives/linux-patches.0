Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143A32E6126;
	Tue,  8 Jul 2025 17:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994008; cv=none; b=PHzSTSLod6A9CXYunyaRGTtBoAGA1nzhiz5En0OkEUTWEjf1N1DR9UW/Fj1LfIDuVPi/WkipwIe7BRDqCv2ldCOGa00AXaeo7De7aXhu11wlMvKu84Tp0PLPqArKBbvKFXYwRYvQ7ajxTAr4mkqLRcjYOuxqlKDD2IjHG1REpfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994008; c=relaxed/simple;
	bh=ajK7nli8DVbI9bA4/pu+jokdoHPz/tkNH4HzLKD7oN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rr0hgtzx3tQhADHbtDgLYrvGg1TQ87VqRo/ys1YHKMY5jTKGW4HNZrJ8bsLv81eP3lIpVUMC7XMVioiHOH/WuOIk/N/Qj3lwz/w2ZpJPDqENPVRsZMpKZewp15r/1a3fO6/KV4HNmDksxwGPTfB2XKYCOBeqX3ATGKcTDyMr/RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pp+GFEun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pp+GFEun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4425EC4CEED;
	Tue,  8 Jul 2025 17:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994007;
	bh=ajK7nli8DVbI9bA4/pu+jokdoHPz/tkNH4HzLKD7oN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pp+GFEunCBXIQ07N4Bb7FUUSIoSZl4ZG8EWJ3TmJPUJN9CuuqU99dIpC3IpyxuBaz
	 L5l+ffZzwaf0lV6xKQLckB06ybqK2okDLJeVxYNpcv6IbtBvoH5fWgmTgrzMtxQPLI
	 l6StiPXgQQOnmazHSYUXmV9PqmSGOTYl/+xGuMCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"regressions@lists.linux.dev, stable@vger.kernel.org, willemb@google.com, Brett A C Sheffield" <bacs@librecast.net>,
	Brett A C Sheffield <bacs@librecast.net>
Subject: [PATCH 5.15 093/160] Revert "ipv6: save dontfrag in cork"
Date: Tue,  8 Jul 2025 18:22:10 +0200
Message-ID: <20250708162234.082387238@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Brett A C Sheffield (Librecast) <bacs@librecast.net>

This reverts commit 2b572c40981138349c04b3f69220ac878a36c561 which is
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
@@ -195,7 +195,6 @@ struct inet6_cork {
 	struct ipv6_txoptions *opt;
 	u8 hop_limit;
 	u8 tclass;
-	u8 dontfrag:1;
 };
 
 /**
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1428,7 +1428,6 @@ static int ip6_setup_cork(struct sock *s
 	cork->fl.u.ip6 = *fl6;
 	v6_cork->hop_limit = ipc6->hlimit;
 	v6_cork->tclass = ipc6->tclass;
-	v6_cork->dontfrag = ipc6->dontfrag;
 	if (rt->dst.flags & DST_XFRM_TUNNEL)
 		mtu = np->pmtudisc >= IPV6_PMTUDISC_PROBE ?
 		      READ_ONCE(rt->dst.dev->mtu) : dst_mtu(&rt->dst);
@@ -1463,7 +1462,7 @@ static int __ip6_append_data(struct sock
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
 			     void *from, size_t length, int transhdrlen,
-			     unsigned int flags)
+			     unsigned int flags, struct ipcm6_cookie *ipc6)
 {
 	struct sk_buff *skb, *skb_prev = NULL;
 	unsigned int maxfraglen, fragheaderlen, mtu, orig_mtu, pmtu;
@@ -1520,7 +1519,7 @@ static int __ip6_append_data(struct sock
 	if (headersize + transhdrlen > mtu)
 		goto emsgsize;
 
-	if (cork->length + length > mtu - headersize && v6_cork->dontfrag &&
+	if (cork->length + length > mtu - headersize && ipc6->dontfrag &&
 	    (sk->sk_protocol == IPPROTO_UDP ||
 	     sk->sk_protocol == IPPROTO_RAW)) {
 		ipv6_local_rxpmtu(sk, fl6, mtu - headersize +
@@ -1837,7 +1836,7 @@ int ip6_append_data(struct sock *sk,
 
 	return __ip6_append_data(sk, fl6, &sk->sk_write_queue, &inet->cork.base,
 				 &np->cork, sk_page_frag(sk), getfrag,
-				 from, length, transhdrlen, flags);
+				 from, length, transhdrlen, flags, ipc6);
 }
 EXPORT_SYMBOL_GPL(ip6_append_data);
 
@@ -2032,7 +2031,7 @@ struct sk_buff *ip6_make_skb(struct sock
 	err = __ip6_append_data(sk, fl6, &queue, &cork->base, &v6_cork,
 				&current->task_frag, getfrag, from,
 				length + exthdrlen, transhdrlen + exthdrlen,
-				flags);
+				flags, ipc6);
 	if (err) {
 		__ip6_flush_pending_frames(sk, &queue, cork, &v6_cork);
 		return ERR_PTR(err);


