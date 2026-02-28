Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D18B36C9CE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302262; cv=none; b=qH6Qik4vIcp/s9tqLeGqIzvy2/8yEVKNDiJCNiDU1lXT1TPmWtanOJqqd72Vg2qIRdbBCjPaAMXZ+hbeuPWsGWBDZQ2CD0gi+f/H+HgmpkwNm5eAv7jkKvIPX/47YXHhtpjW5qdxUhV+/bDuMZSIAMGLt9lTLLlYVdRMX5UW6SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302262; c=relaxed/simple;
	bh=Q6GBT8Cn62mjIQ9xE9BwRUGdHw3n/wRUyD/DW5egki0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dm2wgkRvntO28IvsQYjf6HBC2FU78W280DY6/veB2rv2Lu7XVqHWM+Hq5M11sty2XFRqfLb48Gkz7iRCVa1ZXKxhf2Mnm8rb3+Xebeo5ZocOtxgoQgEJkADK+lDhhYoVMpKHwojjAzcXXb+QqKPRr8WoWabe93HEpi6suAdi4wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BYIUFHp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BYIUFHp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C876C116D0;
	Sat, 28 Feb 2026 18:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302262;
	bh=Q6GBT8Cn62mjIQ9xE9BwRUGdHw3n/wRUyD/DW5egki0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYIUFHp+Dl9WKv4+Oxep2ikErYPdGKhWERJZGVZOd0oljqdXnZDtfi4tQvlT0E6A4
	 +mCmmLSIIwxiFdjiX8mRe/m8k1v6ucTN282Jl34uAMjBHX9F2QyVx2aSz11i74bogb
	 TcH4uCqFkSuh7j+Lxx68ZO2qVjNqhF8tiCPuYVohrDCH3XMz7TB1EHuGxh7b6QY9/u
	 nx99E1rnQpbxyodEOdE1Gnox4avvBEf1rvAlj3J3KIEMwqNf6tbWrguoXxbUzV9uwS
	 khRCnwFdDjOhiIPRYU3MpPZGs/sduj+SCR/248cjSowoPYIngH9NaVo9MtYle38912
	 aPSB808g5QKYA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 277/283] netfilter: nf_conntrack_h323: don't pass uninitialised l3num value
Date: Sat, 28 Feb 2026 13:06:59 -0500
Message-ID: <20260228180709.1583486-277-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 5a9bce24f3c3d..ed983421e2eb2 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1186,13 +1186,13 @@ static struct nf_conntrack_expect *find_expect(struct nf_conn *ct,
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

