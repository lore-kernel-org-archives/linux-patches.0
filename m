Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531D4299920;
	Sat, 12 Sep 2026 10:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208172; cv=none; b=NztfCTCYw/d4rpgjJQCH6YKM1skWFr5vcT8sQFoMNfVcMxu+1Gi7KVnQfqDKiQdMs3wo6P9hD7zGRre5nlpQF/a3ES2GMUc2wqDQ2mn4huTUODzyHXLzpKhPS82xUTLIKK9lrMHqwMyHCe+VRyhber+k4WkN/SR+xSwKP9EteNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208172; c=relaxed/simple;
	bh=j0J2+bEWzBU8Pf4PTsvYzky1irnH0/hLCvQD3JwINY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kj0UwMN6Say1rDWWBRW2tQ6DSzI6ImjB7DAvWMda3oPNQjODGbvPtKr1fAEc8B+o5UWfmiuI7vyXKUy/eob2ddseS6ecdm0Rp7kGaquaBG0U+r5Spzg8Luyd0Ty6qHMf6JTCf9crzVRNIyPqhIQFWpxYXCzhAk/he0B59xws8NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hifG67Rv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hifG67Rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE541F000FF;
	Sat, 12 Sep 2026 10:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208168;
	bh=gV3Rs8Y1F6346RqdNrRcsKBlIg3yxdivwZg18D/gLZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hifG67RvMXn5RlrKnVS4ETRz6hmBH8Upkj+RMzjjnL8/vDsEwfKdDosCy/nfWrj68
	 4DzAHAVZmQq3/Dss7z0oBYYb4Ynef8iN61EVyKROelbnoL99GZKlqpsoB6Rec+YKoW
	 WWecbzuPsJ7yC3k0z3Orsu/2dTG26l51CGidQj3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0564/1518] netfilter: nf_nat_sip: rewind offset when NAT shrinks the packet
Date: Sat, 12 Sep 2026 08:45:33 +0200
Message-ID: <20260912065636.191249685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 16aecbe3036f6097c26b51b12e4c1cf207769690 ]

sashiko says:
 If map_addr() changes the packet length, such as when the public NAT IP
 string is shorter or longer than the internal IP, coff will still point to
 the offset relative to the pre-mangled packet.
 If the packet shrinks, coff could overshoot the correct position,
 potentially causing the next ct_sip_parse_header_uri() call to silently
 skip bytes and miss subsequent Contact headers. Could this lead to a
 failure to NAT those subsequent headers and leak internal network details?

Fixes: c978cd3a9371 ("[NETFILTER]: nf_nat_sip: translate all Contact headers")
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_sip.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index a1c41defaf22d..6b00c81084fe2 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -267,12 +267,17 @@ static unsigned int nf_nat_sip(struct sk_buff *skb, unsigned int protoff,
 				       SIP_HDR_CONTACT, &in_header,
 				       &matchoff, &matchlen,
 				       &addr, &port) > 0) {
+		int old_len = skb->len, delta;
+
 		if (!map_addr(skb, protoff, dataoff, dptr, datalen,
 			      matchoff, matchlen,
 			      &addr, port)) {
 			nf_ct_helper_log(skb, ct, "cannot mangle contact");
 			return NF_DROP;
 		}
+
+		delta = (int)skb->len - old_len;
+		coff += delta;
 	}
 
 	if (!map_sip_addr(skb, protoff, dataoff, dptr, datalen, SIP_HDR_FROM) ||
-- 
2.53.0



