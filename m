Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666BE35AC03;
	Fri,  4 Sep 2026 05:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501134; cv=none; b=KT3LujbgACVvWbXMONfc0tu8nULgz6zv0DhHwMaEQO6A7PXdHE+tp6JxJq7uiOCeD0Xwo46XPf2Wx/Kk7ImeWdh76x8Ch4yDjEXoO53bO8ELnWXSHc5jPaeWJuIwE/WbNAIsThGjvbNe9X0UlsWM72bZpgpW5n+B/Uv6Gk3jW8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501134; c=relaxed/simple;
	bh=YsEFgVG//MpG5cbB6mbjJjGU54JfRKCaFITQ7IeEHzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNCuNB9FYq+iIG1o4uu3eTHcDW2EECDU190qwrecGIDHeFnXWHkGmOHOvwIxoUh2StLzZ2Cikqkcg2mWn2SjdRJYAFUMwbRaPDZUBeQQTE6sdcNNIynPRj32kH4xhYTJ9cZPTMrESJ2oZkvOSovRXrcUd2b9MXMVj/S05WXG1VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfCZP2pK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfCZP2pK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA41D1F00A3D;
	Fri,  4 Sep 2026 05:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501133;
	bh=KuMzYnFefLw9UkjgU874RVJT7K21UU+7VvQhULU7WAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfCZP2pK0Z5dMQGpz5Zxu1yg9CylK9afx5MVmAekC5kQNO+PLtQcvb3kc4VH7qRcy
	 L1xwgsl327JXeCuRZxMkfNtn7qKTDJIB5eu4iLiWKyFW3CAy4m9CPvntNSVBzPPz8j
	 Z4doFhwN3tUhUxeftBHv02lDZMkCcddJ2d2Aku6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 259/552] ip: orphan prefetched skbs before multicast forwarding
Date: Fri,  4 Sep 2026 06:56:56 +0200
Message-ID: <20260904045755.677719015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

commit e36ce6e78fe3fc3c071a26750783b7ba081ce10d upstream.

IPv4 and IPv6 input preserve an skb->sk association installed by
bpf_sk_assign() so that local delivery can use the selected socket under
RCU. Both address families can also prefetch a socket in UDP early demux.
In both paths (BPF and UDP early demux) a reference is not guaranteed to
be held on the socket.

When a multicast packet is not locally deliverable, IPv6 hands the
original skb to ip6_mr_input(). IPv4's ip_mr_input() similarly keeps the
original skb when local delivery is not needed. Either path can put the
skb on an unresolved multicast route queue or forward it after the
receive-side RCU section ends.

After the prefetched socket is destroyed, a later skb free invokes
sock_pfree() and dereferences the stale skb->sk. Orphan the skb before
each non-local multicast forwarding path. Local delivery retains the
original skb; the existing skb_clone() calls provide multicast forwarding
with a socket-free clone.

Fixes: cf7fbe660f2d ("bpf: Add socket assign support")
Fixes: 08842c43d016 ("udp: no longer touch sk->sk_refcnt in early demux")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/0c52eb3d7532aaf8bccf37e0f7c922143c639735.1786552223.git.zhilinz@nebusec.ai
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ipmr.c      |    3 +++
 net/ipv6/ip6_input.c |    1 +
 2 files changed, 4 insertions(+)

--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2168,6 +2168,9 @@ int ip_mr_input(struct sk_buff *skb)
 	if (IPCB(skb)->flags & IPSKB_FORWARDED)
 		goto dont_forward;
 
+	if (!local)
+		skb_orphan(skb);
+
 	mrt = ipmr_rt_fib_lookup(net, skb);
 	if (IS_ERR(mrt)) {
 		kfree_skb(skb);
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -577,6 +577,7 @@ int ip6_mc_input(struct sk_buff *skb)
 		if (deliver) {
 			skb2 = skb_clone(skb, GFP_ATOMIC);
 		} else {
+			skb_orphan(skb);
 			skb2 = skb;
 			skb = NULL;
 		}


