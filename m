Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A5D49D59C;
	Thu, 17 Sep 2026 18:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670591; cv=none; b=n7IfC13+tYGdPzBdRSHmN3A5YT0MfI+/37nVF7LiIne8gl8DPFZL1d9NEwYyMvszeFqprbYRwexXzcoDn6lX0rBGtIJ1ss2yVTA5ln2zKBAt4RvH3sOWSAunkVudou3Ma2+Tb8S6x6Ij3qmO48UL7D7f/uQ8HwN/tAZHI2s6TpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670591; c=relaxed/simple;
	bh=SChZR3CgIclqd4MaArXzFvacQq+PZfXzuUAOlSL6xWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwtpn2yeEdwwrjHdbFW182neZvUSgPYU7E4GvlodwnnUr0ohKzEo/+Hd6ADV1bXj1oMCus/CEEvWqYWVpVv+DGzpqdKuMqD/wEnze6EUhlcb5qRC9xufCNX49/J4q2TYwUzgJW588CAu317kM79V5KButn7Y44kp97H5ERKhNB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCEU0A6K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCEU0A6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1551F000FF;
	Thu, 17 Sep 2026 18:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670589;
	bh=CwieGPX5OyNYAkLArYvfLWT+3ktN72BbEQXfdg7ZpfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KCEU0A6KiMbJYtVtx7N22nPmxZianSotKmJ8FDhlqxLsHUbXaBbsyHiXBKA5mbToR
	 ZcG7X8mfbwHDHhZ3e1U7MyWqQqpTI2X2ah4xoJ70E0mqBTer4v2oh+/VUzmFgXJPfl
	 wChSC3fvMuLLOK9vw2peQc6x2b7+CsIlCmVZa4yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0709/1102] netfilter: ip6_tables: set F_PROTO when proto value is nonzero
Date: Thu, 17 Sep 2026 16:10:52 +0100
Message-ID: <20260917151558.124737864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6c5022242cf0b..f4e01f451d576 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -647,6 +647,11 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
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



