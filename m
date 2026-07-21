Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6300544AB91;
	Tue, 21 Jul 2026 22:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674198; cv=none; b=eTzQ/haa+fsyAIA4S4GUkt5XLcKxvvoD5HtCE8D4nMq5R82/OQayWk6Ur+RfZ55TSW4PkqpHpZ0UZzGNtbD51GJKg8IsoTKEjPjFEH7878ijUoNxSVt9NDtKZolUe+pDpvInz1lLarv80v5GfyG5hhROgXiPIjLNBaRNG3CakUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674198; c=relaxed/simple;
	bh=kwUwU3O+H2RjUnmVzBOtz2p/ZMYQ+z+T8O2IqJRTC/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcGmK2Rus3PJ3Y6jI9IlLHfBZ9FLl1gLbAzloawip0Ec+/YeSo7jORajjaDCqSfOFitYfUXt5llqFbOJDUmCeFFf7x4W1gtwc3G4odgahGrhEXhVNEmytJblsACmvMBEnYFNiGOgpPEeQ22tJ/HN0qzWLcbYAVBNbQXQ52Z9g+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACBYCJkt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACBYCJkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85DE1F00A3A;
	Tue, 21 Jul 2026 22:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674197;
	bh=BxPxfnDelFNLzwipJlUU+fQOZWJeRn3/oZWV5io2tZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ACBYCJktW1lmz6jiQg22XrxhCL0A4QWhkUxK5Bo4M00IfuIYOUoKlcNt5w0fInN2Z
	 6pHJ0g/XKexqTUlHCC+raSMUwaht0shGgH8cITFRX6ENKEY8rzQ9HThD3gd534tYQu
	 vRc3KpC+4R2AUPZgyax508RW23A//lprlXFTO/u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.10 448/699] netfilter: nf_conntrack_reasm: guard mac_header adjustment after IPv6 defrag
Date: Tue, 21 Jul 2026 17:23:27 +0200
Message-ID: <20260721152405.805754925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -344,7 +344,8 @@ static int nf_ct_frag6_reasm(struct frag
 	skb_network_header(skb)[fq->nhoffset] = skb_transport_header(skb)[0];
 	memmove(skb->head + sizeof(struct frag_hdr), skb->head,
 		(skb->data - skb->head) - sizeof(struct frag_hdr));
-	skb->mac_header += sizeof(struct frag_hdr);
+	if (skb_mac_header_was_set(skb))
+		skb->mac_header += sizeof(struct frag_hdr);
 	skb->network_header += sizeof(struct frag_hdr);
 
 	skb_reset_transport_header(skb);


