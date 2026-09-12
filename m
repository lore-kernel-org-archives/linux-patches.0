Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0091DE4EF;
	Sat, 12 Sep 2026 14:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223836; cv=none; b=eIzv70qKCN+3kQ4IF5ctSCVgKcHP4aQlFc9dazAfMMfIzAly7abz1ZP69ARDkapfIF4SzCx4A0t5R0HiuV72v9mB2v+UFsKQc37qASCeoWfheGLfvzA/b0Qwk+YqIt3ZOUrMWQAgO+3N/1LLJ7BJLXl8Mr2gA+/bnVyxdjlkgOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223836; c=relaxed/simple;
	bh=SOMr6FxeaN9KggRFnmyGAhCCfNHku/7WZNPo4EtCDTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZ27XOEe1o2dnbbF7GBQitLcS+J2q8X/87V7qc2HVv5PtX4FiidIY5YFYgi2/yCN3CVB5gcSP3GBymjqf9qBpzXvg+H2TZ2Qvf+WxHPRx3AH8nOi+aQganpmFYSE1MoygK50ptHewW/MFmEzEhvyKJyM7wTZ8Bm3AC/gWPAl1RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqhxbHH9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqhxbHH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217C31F000FF;
	Sat, 12 Sep 2026 14:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223835;
	bh=n2FhazXNU7tl8kmjh1uVEDYy2A+eCOwH7UaqyBdQEeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fqhxbHH98LNuZgi0RM9ADPc2GS2FawKIa0C/Lv9ASrXejXxq1wus7bwJWXPzWr5hm
	 yluSdUOLXkv/FscmWFYuxchj5ZqE+XNKHV5UPxYJBi1RXYdPR+kBBRamEezGaC0HbL
	 SR5Bua9X1l2e1M4/NM/r5t+JZ84Y7qYUIv6OYVCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0871/1424] netfilter: nf_nat_sip: rewind offset when NAT shrinks the packet
Date: Sat, 12 Sep 2026 08:55:03 +0200
Message-ID: <20260912065626.826894619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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



