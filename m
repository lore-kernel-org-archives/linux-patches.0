Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCE1402BB7;
	Tue, 21 Jul 2026 17:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654191; cv=none; b=FL+6CmtkvvOr4H/nQgclja1KQkV4uzHxFOMx0ZquHf2rarEQV5tLKtmmM2cyDOrpwuvkZ0sKBCAo7aeQmOFZVMeYZdWOJkmtfmtN0GWdyPSQPncETAF3ZhCqt7PpXD05NtDbzGJUqXx34Ursp3JpJ7Y2TP0zfsmofnlBnULyURY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654191; c=relaxed/simple;
	bh=yRBWEwWnvsI40BJU27ZN8Gl7Pnn8lKWYEJB1iFqOkgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5n3bzjgAeL/1UkKLTH1CAtxykfDK1G1UMkTWMZe0L2FRj05+fS+KVdZwalPCXw2umOuLKtOChllmcM20c/sSdwF0taDlxoFYjyk5bThqzo98e8En0vLtQRGKb8pv77NH/Sds/LKynZLUHhwiMijhho8Ob2D1fdFfat+2jzY8Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEgRSmaA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEgRSmaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8161F000E9;
	Tue, 21 Jul 2026 17:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654190;
	bh=NZauNdVVMy0+kjtNU1tN93Bfk+mjyH11GGMcyc7uTsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NEgRSmaAzoOq4bhc/KHRfe4Q3BfjbYaeAqXQB3E786ousKOnPAHdiRWdqJUi9XoWa
	 P2m1JPtzth4YSJa2g1EADYUl9B7CvDc/Npv3OIpvP/FxNQoeoAfrMypvBmJ8X2jJDj
	 jDw6Rkv8K3BaMfFtohWNkv4wT0gAGq9Xlfv8cDcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 7.1 1609/2077] netfilter: nf_conntrack_reasm: guard mac_header adjustment after IPv6 defrag
Date: Tue, 21 Jul 2026 17:21:22 +0200
Message-ID: <20260721152630.717128748@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -348,7 +348,8 @@ static int nf_ct_frag6_reasm(struct frag
 	skb_network_header(skb)[fq->nhoffset] = skb_transport_header(skb)[0];
 	memmove(skb->head + sizeof(struct frag_hdr), skb->head,
 		(skb->data - skb->head) - sizeof(struct frag_hdr));
-	skb->mac_header += sizeof(struct frag_hdr);
+	if (skb_mac_header_was_set(skb))
+		skb->mac_header += sizeof(struct frag_hdr);
 	skb->network_header += sizeof(struct frag_hdr);
 
 	skb_reset_transport_header(skb);


