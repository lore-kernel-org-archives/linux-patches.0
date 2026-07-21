Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D55C44AB9E;
	Tue, 21 Jul 2026 21:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669994; cv=none; b=jEecsu5eWwc/JxS55m/znGBfR346XLvlP90vC3LplMWbtIwtcWX4tCXsyP5BLRp9V1pNN494je87ypjQEsrVEeW9bdSsCmRjtgJpP2hgW/HHfpHsQTLYYMzvkkJ2w7+RSL3xQr+GYawHP1tT89GFtJimN3scTWaVZAXeYeh+N/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669994; c=relaxed/simple;
	bh=DPmZSiO7KX6iyC/h24iIX1suNwpKA97lS9ZBrqWn1ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0uFJKiIqPtTJgo9DeqQWyIMp7Ty4anMsTeV86ih/lNzNlWbw81C88yFxyqVdJ9np6hX3luEcXFD8iUk3CgkNCqB+0iPs1z3IFrTJTj1Yb47uA2RoK2F8R9qiNNhrH+gLNv54f/f8TdzDzIP3pzon9iybxz1biv9m15O5on/5zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXi6x0a9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXi6x0a9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37371F000E9;
	Tue, 21 Jul 2026 21:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669992;
	bh=lRUVSaZrtlDfsGZ8PVPvFMfROkyHGq/2ZWlD16zaptU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jXi6x0a90ZRkzlV1h5n8VadKNKzHo3fww8I8j+QNfjuH1eBT06v1PYLRjWdiwbFmf
	 7bByW3NPHH3mqfK4J1yUPapnIUN54nmsI4eC3sPVL/7Avinl31Sxq9gKC8pDpJk6q9
	 iEjeSL7htOykuLj4ydZniStVFGDTMdJa71MRiRyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.1 0747/1067] netfilter: nf_conntrack_reasm: guard mac_header adjustment after IPv6 defrag
Date: Tue, 21 Jul 2026 17:22:28 +0200
Message-ID: <20260721152441.287108971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

commit 3b08fed5b7e0d5e3a25d73ef3ba09cd33ade16c9 upstream.

nf_ct_frag6_reasm() slides the packet head forward to drop the IPv6
fragment header and then unconditionally advances skb->mac_header:

	skb->mac_header += sizeof(struct frag_hdr);

On the NF_INET_LOCAL_OUT defrag path the skb has no link-layer header
yet, so skb->mac_header is still the "not set" sentinel (u16)~0U. Adding
sizeof(struct frag_hdr) wraps it to a small value (0xffff + 8 == 7),
after which skb_mac_header_was_set() wrongly reports a MAC header is
present and skb_mac_header() points into the headroom.

The reassembler has done this unconditional add since it was introduced;
it was harmless while mac_header was a bare pointer, but wrong once
mac_header became a u16 offset whose unset state is the ~0U sentinel
tested by skb_mac_header_was_set(). The sibling net/ipv6/reassembly.c
does the same relocation and does guard the adjustment; mirror the
guard here.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Cc: stable@vger.kernel.org
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -345,7 +345,8 @@ static int nf_ct_frag6_reasm(struct frag
 	skb_network_header(skb)[fq->nhoffset] = skb_transport_header(skb)[0];
 	memmove(skb->head + sizeof(struct frag_hdr), skb->head,
 		(skb->data - skb->head) - sizeof(struct frag_hdr));
-	skb->mac_header += sizeof(struct frag_hdr);
+	if (skb_mac_header_was_set(skb))
+		skb->mac_header += sizeof(struct frag_hdr);
 	skb->network_header += sizeof(struct frag_hdr);
 
 	skb_reset_transport_header(skb);


