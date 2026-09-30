Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5883CC300;
	Wed, 30 Sep 2026 19:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796413; cv=none; b=HD7JOvwH1LxwN5exVD8YcJ4LhnGMY+NUoN8nWkxh+VsQ3XNcbCJmTphQzQADWAmXLMm1kjmw8KEUOIH1j/FNQVwgN7enmBtumkxLdQoZI2RzMsjohWVuk/9xrGGVdPMK6rYcc8uttEOoLBS4WM8gpwMU/H2mkYO1RRTWb6OnuOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796413; c=relaxed/simple;
	bh=tyjmtBZUx9u7m2a6eIIlPjEWcy5d58lpvvLqyuQp8RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noxoMM0eYOsriw+aplNSD0uKRqmHzen78V6WCf4/T6iozzn5GN4tMfO7aScSzRUr4AqH2R6MSuJy43EC1KkIuasUD8Xi8knpVo9wuxWUT22Q+VrAxYGkvyJG2yH4mN/yKO3J6wSsWh0ZWO5Npga8r2f4AUDVBQsYqPDFi/m2BkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqZUcFBB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqZUcFBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AC11F000FF;
	Wed, 30 Sep 2026 19:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796411;
	bh=ibahUgzgtb0G4gvSc4HOwU6Zh1z++rszDbexBO0SPRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqZUcFBBtVS04byk09HDhsay9N/VoCMV0ChzqSdGiHAUQ+QTBxJr/N1DQQmBWXBN0
	 fOhN/wc4kxsP8Rc0NX7J45S9cpDG4ZaScXF4XZOlwav8r3vF3p5+aeEKrp/i4PFHhC
	 +L0T/mSd0xgRsJtTEK4rHNhmyYyY0zhsgEzouo3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.6 0859/1193] ipv6: xfrm: use full sockets in local error paths
Date: Wed, 30 Sep 2026 17:25:43 +0200
Message-ID: <20260930152453.319015691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit 6973a21ee73c5567f883813c8ef414774b45892f upstream.

xfrm6_local_rxpmtu() and xfrm6_local_error() dereference skb->sk as if it
always pointed at a full IPv6 socket.

That is not guaranteed. TCP SYN-ACK skbs can be owned by a
TCP_NEW_SYN_RECV request_sock while the output path itself is driven by the
full listener. If rerouting selects an IPv6 XFRM tunnel route with a lower
MTU, the local PMTU/error handling path can reach these callbacks with that
mini-socket still attached to the skb.

The callbacks then miscast the request socket as a full inet/IPv6 socket and
can read beyond the request_sock allocation when they access inet_sock or
ipv6_pinfo state.

Resolve the owner with skb_to_full_sk() in both callbacks and bail out when
no full socket is attached. This matches the surrounding XFRM IPv6 PMTU/error
logic, which already reasons about full sockets with skb_to_full_sk().

Fixes: dd767856a36e ("xfrm6: Don't call icmpv6_send on local error")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/xfrm6_output.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -19,7 +19,10 @@
 void xfrm6_local_rxpmtu(struct sk_buff *skb, u32 mtu)
 {
 	struct flowi6 fl6;
-	struct sock *sk = skb->sk;
+	struct sock *sk = skb_to_full_sk(skb);
+
+	if (!sk)
+		return;
 
 	fl6.flowi6_oif = sk->sk_bound_dev_if;
 	fl6.daddr = ipv6_hdr(skb)->daddr;
@@ -31,7 +34,10 @@ void xfrm6_local_error(struct sk_buff *s
 {
 	struct flowi6 fl6;
 	const struct ipv6hdr *hdr;
-	struct sock *sk = skb->sk;
+	struct sock *sk = skb_to_full_sk(skb);
+
+	if (!sk)
+		return;
 
 	hdr = skb->encapsulation ? inner_ipv6_hdr(skb) : ipv6_hdr(skb);
 	fl6.fl6_dport = inet_sk(sk)->inet_dport;


