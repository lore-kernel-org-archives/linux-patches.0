Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760DD3B95F9;
	Tue, 21 Jul 2026 20:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667200; cv=none; b=ggiqe2eYJbuWxp4A8qA0TsobPcU53ACiODG5qgDPO+28YUlGdW17E7vcfC6MiyGulovcW7Du1jEgbHRxwAoZuL3FFnF8JGJNBD8Rqsbk/rkWvjX2AJGOuzt6cjhpKDeuQF9cYqv4OUh8qS82Xicv2T2pK34Z8mObOiw+Sfubz5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667200; c=relaxed/simple;
	bh=7FXlXn/lRAYdWGTmegx+71ht5skkKdA+QfviSg1yi2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcD5bcj567ke94kHPKgRb8eIWRW6WuVaRF4uffhnh28gV/PISJPa8xF47hRcJpHsBVeBAeoKzqHPkb5DCgHCEtee2yh2OKp5a0N4pzPNnqd02UQ8Lpbg4WLsta1tS9ANX9SfnvQfcCiL6HNv+jtdtnLvOGqE3Cx+I0q+AM62LAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJ8QZHZX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJ8QZHZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0511F00A3A;
	Tue, 21 Jul 2026 20:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667199;
	bh=kOL1vi4StuKiRwmFe0QhAWPMVPLkqv++9e4OrdVvhT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJ8QZHZXrEL3mDEOsKl3J+VHrzulhJzIbmiJJeEomUPFV6n9UWCNOej1VDam+Z8J4
	 3UaEUek6CnZbNEJjzl/jfglmwI2evxV7n2S9JZAmH3mcC6WlAk8M1WP9CxvylVipIo
	 G47j650VkzlZFDqksme2U7Zcq7HdKjXfSkjYtTyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.6 0928/1266] netfilter: nf_conntrack_reasm: guard mac_header adjustment after IPv6 defrag
Date: Tue, 21 Jul 2026 17:22:45 +0200
Message-ID: <20260721152502.602831901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -346,7 +346,8 @@ static int nf_ct_frag6_reasm(struct frag
 	skb_network_header(skb)[fq->nhoffset] = skb_transport_header(skb)[0];
 	memmove(skb->head + sizeof(struct frag_hdr), skb->head,
 		(skb->data - skb->head) - sizeof(struct frag_hdr));
-	skb->mac_header += sizeof(struct frag_hdr);
+	if (skb_mac_header_was_set(skb))
+		skb->mac_header += sizeof(struct frag_hdr);
 	skb->network_header += sizeof(struct frag_hdr);
 
 	skb_reset_transport_header(skb);


