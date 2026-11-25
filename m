Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624884;
	b=Irf7bL9GECoWqcpaBbKkO6y3XOFGADkHfJUBL3a+liQ+RVoj7p14fscmgjnM4+1clMuN
	 L1RvYgLEU0pRnRmTa5aSPFbuB2Pj6ZAfGoMqyfNgc1qwtW5MydZZjQ1tf8Wu57Y3uiHzC
	 mKAcxa5CaYQEP8cI9E5XrlHay75V10CHidstAahFbdhXuOoLYT4Ml9qRWawGueCFdVmxM
	 GTf4m77xHVYu9Tc/Tl1+brwCnJD0ucPHJLacWo197OO9iWimGGQDz6JUhqV5Zie39Lz+W
	 BzrsVJtx/wRRStp2kxKkkVHpkglctVKVt0JGpt9EpSmc38/n7dGGfayQs378b8LfLBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ek6Ps5aIHr0dLT+U35A+0ZgV66mYoZ1oJUrhzxkJc78=;
	b=ZvNnmlppzF7IRVtPwYKU7jYr3XxVkCT5WGxe1V/uX8+0qG8LyiLadRZaTqjliGMlDUF9
	 rPDpao042bqQ2Msgc+X++0tfXkekzlfxcVYVibTZMGP33wqGXJStOIJ2Lsq+ozhVx7A9q
	 DnEJfI0SVOLfJsGZ29W1JZnzPpFNDcIQpEgx4FwDWm88fOcykQ0JsPfIFW0p/6a7ZJaje
	 kEVEwH+NRg8SiuJLwoqHhmFi4Zm7EPZpQ6TRsyJ1ssFlqQK4SPtVB1haVTC/7zxGorl6L
	 t8GhbJNb+P+nSJJAn3qWeOciCVTp3tmRL0BTDHbip4X/+npZ+mOV8DUECttiYZqqhMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lZzetHVv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBC1606A31E;
	Wed, 25 Nov 2026 16:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lZzetHVv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732DD1F000C0;
	Wed, 25 Nov 2026 16:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624884;
	bh=Ek6Ps5aIHr0dLT+U35A+0ZgV66mYoZ1oJUrhzxkJc78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZzetHVvz2LMcLveAlDdx6LM+Dom8OxkaQ0T8Xd1ShXGcMyKF85nBV/umPH0eE0P8
	 /8tMPx4hPKOMd95XwIQJToJUIJHDFw+NTWAsFIiFA/9iWYTdX1NPnURB+exo8ZAAHI
	 VjygnzV+m99kuKmT+3FJs0wrHk8goHR5jN4j5otM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 338/816] net: gro: compare skb->protocol in gro_list_prepare()
Date: Wed, 25 Nov 2026 15:31:26 +0100
Message-ID: <20261125143857.021792185@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 511582022bfd07475d0daa209e6e6aa5a940740d ]

gro_list_prepare() checks whether a held packet may belong to the same
flow as the incoming one by comparing the device, VLAN tag, metadata
and the link-layer header, using dev->hard_header_len as its length.

On devices without a link-layer header (hard_header_len == 0), such as
L3 GRE tunnels, no compared byte carries the outer protocol:
skb->protocol comes from the tunnel header. Packets of different
protocols can then stay eligible, and the GRO handler selected from the
incoming skb->protocol parses the held packet with the wrong layout.

For example, take an IPv4/UDP packet held by UDP GRO and a
VLAN/IPv4/TCP packet received on the same ipgre device.
vlan_gro_receive() reads the first four bytes of the held IPv4 header
as a VLAN header. With crafted values, the held packet survives up to
tcp_gro_receive(), which uses its UDP header as a TCP header. With a
short linear part, the FIN/PSH update of the held packet's TCP flags
can then write into skb_shared_info.

The VLAN, GRE, IPv4 and IPv6 GRO handlers compare the next-protocol
field of their own header, so once the outer protocol matches, the
inner layers are checked too. Only the outermost protocol was not
compared.

Compare skb->protocol too. On Ethernet devices this is redundant with
compare_ether_header(), but it is cheap.

GUE direct IP encapsulation has a similar issue, but there both packets
have the same outer protocol, so it is fixed separately in
gue_gro_receive().

Fixes: 60769a5dcd87 ("ipv4: gre: add GRO capability")
Reported-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261109164540.3104392-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/gro.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/gro.c b/net/core/gro.c
index 6a730b4593e1c..f0817aa5294c3 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -379,6 +379,7 @@ static void gro_list_prepare(const struct list_head *head,
 		}
 
 		diffs = (unsigned long)p->dev ^ (unsigned long)skb->dev;
+		diffs |= p->protocol != skb->protocol;
 		diffs |= p->vlan_all ^ skb->vlan_all;
 		diffs |= skb_metadata_differs(p, skb);
 		if (maclen == ETH_HLEN)
-- 
2.53.0



