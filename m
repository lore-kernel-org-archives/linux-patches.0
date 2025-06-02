Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847F9225785;
	Mon,  2 Jun 2025 15:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876827; cv=none; b=QCuiwWW1/N03lPdg66wVywJ6u755TAX52MoqawjWFr2v8XGAsK2jtZg2f7U5i+XWa47oz30BI0bptacMSJexcO+JUvatpSGrzwu7vcJUi6bLtPRfyek47YsnmGmMf4qyWRAoeAeEDMKQ/QtRe9QqLc/YwleqtR2olk+MHmiLFxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876827; c=relaxed/simple;
	bh=vBynjrK7gHOJZMNajzBQ4G2URj/JkMPbhKGIyKOZr0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=do28zxhVCRiuz3rIODO+dMYmXN7FYvsMLYGgR43SifU3eVQ+JUsRsSH4U0UzYyhD7DFfXE8kawQuGxQ+cIAMX68dk6sKPSQZjPby6qry05/TRBsSsnG+R3EA8uKTQA9tkV8Hsp81Kj3Tc5euNH7n3jGVT9R4DWzYcS2jc5aWLtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXNbNOss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXNbNOss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886D9C4CEEE;
	Mon,  2 Jun 2025 15:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876827;
	bh=vBynjrK7gHOJZMNajzBQ4G2URj/JkMPbhKGIyKOZr0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXNbNOss+uikWMSw9c+qjTm4s4CvIFPrNoint4wxIV252THgCTaJlvLLRkcQMQdNk
	 AtkAPgeHN0DFS/pToq0ISchoNfuHfEmOOXAAb3TOGjdDSPGWrGQVwBkE7BCfVusIdA
	 huQ08MPAxT9I0M9d9NDayUOO2JbXrlCMh1SbIEvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/325] ipv6: save dontfrag in cork
Date: Mon,  2 Jun 2025 15:46:03 +0200
Message-ID: <20250602134323.315624215@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit a18dfa9925b9ef6107ea3aa5814ca3c704d34a8a ]

When spanning datagram construction over multiple send calls using
MSG_MORE, per datagram settings are configured on the first send.

That is when ip(6)_setup_cork stores these settings for subsequent use
in __ip(6)_append_data and others.

The only flag that escaped this was dontfrag. As a result, a datagram
could be constructed with df=0 on the first sendmsg, but df=1 on a
next. Which is what cmsg_ip.sh does in an upcoming MSG_MORE test in
the "diff" scenario.

Changing datagram conditions in the middle of constructing an skb
makes this already complex code path even more convoluted. It is here
unintentional. Bring this flag in line with expected sockopt/cmsg
behavior.

And stop passing ipc6 to __ip6_append_data, to avoid such issues
in the future. This is already the case for __ip_append_data.

inet6_cork had a 6 byte hole, so the 1B flag has no impact.

Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250307033620.411611-3-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ipv6.h  | 1 +
 net/ipv6/ip6_output.c | 9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 9a44de45cc1f2..9f27e004127bb 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -199,6 +199,7 @@ struct inet6_cork {
 	struct ipv6_txoptions *opt;
 	u8 hop_limit;
 	u8 tclass;
+	u8 dontfrag:1;
 };
 
 /**
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index f7a225da8525b..cfc276e5a249f 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1450,6 +1450,7 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 	}
 	v6_cork->hop_limit = ipc6->hlimit;
 	v6_cork->tclass = ipc6->tclass;
+	v6_cork->dontfrag = ipc6->dontfrag;
 	if (rt->dst.flags & DST_XFRM_TUNNEL)
 		mtu = np->pmtudisc >= IPV6_PMTUDISC_PROBE ?
 		      READ_ONCE(rt->dst.dev->mtu) : dst_mtu(&rt->dst);
@@ -1483,7 +1484,7 @@ static int __ip6_append_data(struct sock *sk,
 			     int getfrag(void *from, char *to, int offset,
 					 int len, int odd, struct sk_buff *skb),
 			     void *from, size_t length, int transhdrlen,
-			     unsigned int flags, struct ipcm6_cookie *ipc6)
+			     unsigned int flags)
 {
 	struct sk_buff *skb, *skb_prev = NULL;
 	struct inet_cork *cork = &cork_full->base;
@@ -1539,7 +1540,7 @@ static int __ip6_append_data(struct sock *sk,
 	if (headersize + transhdrlen > mtu)
 		goto emsgsize;
 
-	if (cork->length + length > mtu - headersize && ipc6->dontfrag &&
+	if (cork->length + length > mtu - headersize && v6_cork->dontfrag &&
 	    (sk->sk_protocol == IPPROTO_UDP ||
 	     sk->sk_protocol == IPPROTO_ICMPV6 ||
 	     sk->sk_protocol == IPPROTO_RAW)) {
@@ -1884,7 +1885,7 @@ int ip6_append_data(struct sock *sk,
 
 	return __ip6_append_data(sk, &sk->sk_write_queue, &inet->cork,
 				 &np->cork, sk_page_frag(sk), getfrag,
-				 from, length, transhdrlen, flags, ipc6);
+				 from, length, transhdrlen, flags);
 }
 EXPORT_SYMBOL_GPL(ip6_append_data);
 
@@ -2089,7 +2090,7 @@ struct sk_buff *ip6_make_skb(struct sock *sk,
 	err = __ip6_append_data(sk, &queue, cork, &v6_cork,
 				&current->task_frag, getfrag, from,
 				length + exthdrlen, transhdrlen + exthdrlen,
-				flags, ipc6);
+				flags);
 	if (err) {
 		__ip6_flush_pending_frames(sk, &queue, cork, &v6_cork);
 		return ERR_PTR(err);
-- 
2.39.5



