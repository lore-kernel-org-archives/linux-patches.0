Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C561633AD85
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302770; cv=none; b=qzSHwvLl5+RxppEfPbsXzmNtSD7+v+eUUweLs32A/lehDACrqD+YHDOX9OR7HVCI1ulpau9TkhLqj0/TtcDm/jc3ibC/ZSl5+i1GapKSgEgrDg0xahkDSh3ua4DVIVxUH/dGhyJQmDNbNrRtq69S4nDnLSoIWDzP8lzuoqq3SaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302770; c=relaxed/simple;
	bh=BXjNMcUEvfK4NN6aJ2heKSmeSETSyiRp70VZ8acEueo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+758axxTvxCHABE6lE6vrIs6j0y+Am+WRuoTP6KNHoOKxG689MJ8ZYDRGlRH3kbomcEselNZ48JBevy9n9mkcNuNHXK+OFiOJqHdxMoPtWjFs14TYr6EdWQJ86rCdiI5ewyCpwro6tGzAi85xkBEl/ctwg8CUb/Az/DhQJK10Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fiDQKsdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fiDQKsdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD5AC2BCC6;
	Sat, 28 Feb 2026 18:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302770;
	bh=BXjNMcUEvfK4NN6aJ2heKSmeSETSyiRp70VZ8acEueo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fiDQKsdYIIzOjZMVVNJ7Y3rlPhNf4s/By70H2OomQCCh76dc4j8DLlJaMBu0xsFBz
	 6tRNRbCy1LOB+6ajSyB6UFN0vf3knUrvWH6Aw0F3BqZgqcvoUVE2bz64McKCR5N+58
	 1ZL/Qx0cfGqi+hw5J2TqdUuD+EP64MMEdygir8xKTUVdso/mSS1lEGkyVueCwCVqDr
	 kvVZIMPu5C7Cjg7qxaUXtig8Q/Ttrg52DDuKp2+jWVm6qE4JBryQfqq3iwGhMX8/7l
	 PdQhOvLMzxGIPDh1YBisfjg9USIJqgSkb+tQXg+qmm9cvPz/zaesjXTfEkv2F4yB3U
	 AcU71N+x6qkXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/147] netfilter: nf_conntrack_h323: don't pass uninitialised l3num value
Date: Sat, 28 Feb 2026 13:17:31 -0500
Message-ID: <20260228181736.1605592-143-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit a6d28eb8efe96b3e35c92efdf1bfacb0cccf541f ]

Mihail Milev reports: Error: UNINIT (CWE-457):
 net/netfilter/nf_conntrack_h323_main.c:1189:2: var_decl:
	Declaring variable "tuple" without initializer.
 net/netfilter/nf_conntrack_h323_main.c:1197:2:
	uninit_use_in_call: Using uninitialized value "tuple.src.l3num" when calling "__nf_ct_expect_find".
 net/netfilter/nf_conntrack_expect.c:142:2:
	read_value: Reading value "tuple->src.l3num" when calling "nf_ct_expect_dst_hash".

  1195|   	tuple.dst.protonum = IPPROTO_TCP;
  1196|
  1197|-> 	exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &tuple);
  1198|   	if (exp && exp->master == ct)
  1199|   		return exp;

Switch this to a C99 initialiser and set the l3num value.

Fixes: f587de0e2feb ("[NETFILTER]: nf_conntrack/nf_nat: add H.323 helper port")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_h323_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 8ba037b76ad3a..106dea9b53a96 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1228,13 +1228,13 @@ static struct nf_conntrack_expect *find_expect(struct nf_conn *ct,
 {
 	struct net *net = nf_ct_net(ct);
 	struct nf_conntrack_expect *exp;
-	struct nf_conntrack_tuple tuple;
+	struct nf_conntrack_tuple tuple = {
+		.src.l3num = nf_ct_l3num(ct),
+		.dst.protonum = IPPROTO_TCP,
+		.dst.u.tcp.port = port,
+	};
 
-	memset(&tuple.src.u3, 0, sizeof(tuple.src.u3));
-	tuple.src.u.tcp.port = 0;
 	memcpy(&tuple.dst.u3, addr, sizeof(tuple.dst.u3));
-	tuple.dst.u.tcp.port = port;
-	tuple.dst.protonum = IPPROTO_TCP;
 
 	exp = __nf_ct_expect_find(net, nf_ct_zone(ct), &tuple);
 	if (exp && exp->master == ct)
-- 
2.51.0

