Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28469503BD3;
	Wed, 30 Sep 2026 18:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791634; cv=none; b=ZjpH6XWvJ59+VAWLYQWIqpgTpsWlyFlwiAM1+2/2UsTtroEI+Omq6rfhO9JIKVzTeSirG8IGbmnO0ay1DpTFUyfNgAKePMjBA7Wk9Wt4/lnrK80cm9BnXF3Rn0NxjpLrk4yauPi2uD74N6Fnm2SIVyx0+hD4wED8d/DAz9Q1mLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791634; c=relaxed/simple;
	bh=ZFH6a2E1zcFyrvS4rZo/39/7Z4NobtEfYX0tUv+d1VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNa7Hk7Yayw9kM/bQFhhkMaYhjo+RiCneZqZx9MuKVN+WHr8NGe/GJtD5e7Dzbxd1sZPclZr0aIa3DhuhJ25NxMLhZiCU1BRI4Tre8lpl7yaB68QfilhEbQ4QliqeXpGkght4e86Mag6JBYexdeT2CRLv5M8jFigs6uYtVOGz1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jqeyswc7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jqeyswc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828EE1F000FF;
	Wed, 30 Sep 2026 18:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791633;
	bh=57+hnwKZxO/t4urVyDIc6BZP6UEiRCa/BdyM99VZ4tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jqeyswc7Ez30jPLLk99IVHIImterFu8lOb9CnijW2A4nwMYcEv7OvropNOHLHrpV1
	 qginDOf4hyff/dOYmP8oHMRhaXalWplqLNsBQRvpiqvdSH5Iq4paVKOiiqSCbDUyJM
	 UmzDbQGNkfi/0i6/3LTHKADTsWrxfqpTDMvvU6kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 326/752] netfilter: ip6_tables: set F_PROTO when proto value is nonzero
Date: Wed, 30 Sep 2026 17:23:16 +0200
Message-ID: <20260930152405.349532294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit da4afc5a956d407443988e97a4d4ca14c2e999c7 ]

The ip6tables traverser doesn't search the extension header chain unless
userspace did set the IP6T_F_PROTO flag.

This also means that userspace that sets the e->ipv6.proto flag can bypass
the protocol check for the rule by not setting this flag.

That in turn means that all ip6_tables modules and targets that want to
reject rules without '-p' flag MUST also check for that flag.

Not all do, likely because they got copied from iptables which lacks
this flag (no extension headers).

Instead of fixing up all the relevant targets, emulate ip6tables behaviour
in the kernel (like nft_compat.c) and set the flag if the protocol is set.

Reported-by: Zhiling Zou <zhilinz@nebusec.ai>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/ip6_tables.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index f2de34f0de239..6fdd00ac2f84e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -649,6 +649,11 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
 	/* Clear counters and comefrom */
 	e->counters = ((struct xt_counters) { 0, 0 });
 	e->comefrom = 0;
+
+	/* set F_PROTO, else ip6_packet_match won't do the right thing. */
+	if (e->ipv6.proto)
+		e->ipv6.flags |= IP6T_F_PROTO;
+
 	return 0;
 }
 
-- 
2.53.0



