Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF37A18DB35;
	Sat, 12 Sep 2026 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230019; cv=none; b=dR1ypSa0RdfgSw0q8M6rDUFwfOnVwmf17Ne3OLBW3r37RdbFRPhKY7I67gBNsHzlVZzB8Nu+iw9PJ3zlgUSk72lhjfGDjoPkgoARGB0H6Aw90Fth7O95sOYRFoUnOLSwRfJDPC7rAWSI5tDtzJO5MJjjFaY3qRjB5lMB+NGoN/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230019; c=relaxed/simple;
	bh=w+2zUicP8LSZygCU0emky+LczgHeN0aNUXwR1cpqyyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOgqIXBQQL6zovLaL+8n6dG5Bdk8M36HUfZ10yecw7OQCkKVsWEDNUGiVf8rSxcf4UqRt7jr+yRLk4H2Qjb0TxFGQyRqEjYd6LipVAHjNzdr678mseW+OH+uWGsnOI3sNNkunlo9hWRMPlFQfpKVmTvez8xvtGJms+JXv8YkDek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LqIyY/PD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LqIyY/PD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA2A1F000FF;
	Sat, 12 Sep 2026 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230017;
	bh=7TlbRf4BhejP13Gv96yzoaBcGhBTBaLr0Jn4vRD4f6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LqIyY/PDuaPPs+iQkEfZvgGx5vOsfv9HSGHQIVP6M6sEKgMkCWFuZNJUyLeHWM83h
	 mBSQjQmeTHkgVI3L/nBDWnDHbJ8NqZttFZ5lOVAxO48/U8sgIcnHb5fL8L85mSsKOA
	 icGcdDQNV4SChuxwkrkI1BUope25CC6osY6/QuX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0709/1191] netfilter: nf_nat_sip: rewind offset when NAT shrinks the packet
Date: Sat, 12 Sep 2026 08:57:17 +0200
Message-ID: <20260912065604.196184311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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



