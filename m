Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B9038E8B9;
	Sat, 12 Sep 2026 19:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242746; cv=none; b=VEZyNvxv+aQLRNse4MPDPqABFzFMJ41XXVZqDK04GArVtlJac6dpdz+KIRr5XY/r1tsi0WZgB4edo/Jg8qYMr4PvxiTUn0dG6ZGHUxgVKnIM4A7rvFK+fH5tG73zEJTHb69I54HYfvwI0LrXmplD3LhKjf2+jtIPecYzYcKnh9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242746; c=relaxed/simple;
	bh=Hv42/WVKlbiBFwgJ6jpyxj0sL4K+bM7q+Zx/khupOGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAdY2a3jTEVc4m8EC12sVBt5SPQQVs/PXFPP3JU4+0jkBpXgAgh/BWJxU3MqjampwOLmYYh9uYO4qXUjD6uc7llrTXkzpyWloUxWGpZyv4e4/hK6DzNl9eVlufn7Kt4fazYh1bcjOBxz4+s9E0ToqZ1NERqd1UJ7QBdw4cLj4Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJv25FMu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJv25FMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3341F000FF;
	Sat, 12 Sep 2026 19:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242745;
	bh=er/KHh2E4+7YJnTI8MIzkLv2lIjwWMSL8/g9XSFIlBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJv25FMukxxfsYpOTyPTKxNZcYNzTASLu+GaewOAA6ZWIZWGFDIQ5364oA+V1Uxyi
	 JkOLErSeWkTSLdq7lGNftm22bPwy3UXF+i0WNn/TPLMy7FRt4/rLeVKLZ8h1cVGagY
	 gqUVGQS3iM3mqF6n63Uqj6aG0mjgDn5lI5yePXxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 510/798] netfilter: nf_nat_sip: rewind offset when NAT shrinks the packet
Date: Sat, 12 Sep 2026 09:02:18 +0200
Message-ID: <20260912065528.823560378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index 7687d3d15df22..a77881c218ebf 100644
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



