Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250C639B976
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302639; cv=none; b=YSlawaL4X+Qs5XXpn9f+cCP8pjaB+8Gs+DVnaaIqeYz8rpIecdlda5UupeiXBhRT+0KsRUT396qw6byw+2F6QgqgRD9EIaR3aEGpz4qq7k01FtvtaLVgfZSCZPV8fxLuGmXA27E3gALetI1yuUkp7A7paIvjJ5v3gNDSxRrXKeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302639; c=relaxed/simple;
	bh=lYu80QE+IQs47tnOyUZvuauwzVKC77R2uNtiObzrkSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZ9KPVVepCVPBf9fW3ZkdCLvVUvmLE2KvdW6kj6ePF5mnG91mkemPBw0+2uwVoDhUADOezi9iB8eRyPAlcJnKSQ+J8J9aunL/tlIkiUAFxsP2/q3FRNQqG//qeEkO0mGdA3j4D+FaLhSfsYHDDCpZ7cdFo0/5wGgsgyl+hLViLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OT3FtdGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OT3FtdGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924A9C116D0;
	Sat, 28 Feb 2026 18:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302639;
	bh=lYu80QE+IQs47tnOyUZvuauwzVKC77R2uNtiObzrkSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OT3FtdGMY2I4kgelBnaadVsEGr6CvL0DwrvkWTacp5dODE77g7CZnyUowOQ0IqMp0
	 7+S/jvqcvMwRIiquaDrxY5O4QUjdy50l9OzZX1MRxuCSLHsnKWjJNpDdYK2OAVROhU
	 eYlRL3nvvdK0UMMyqJjkYevzGmKe/lrWMi0SJhe8tOS5rQzzfVV7GHpGVv9lNzOwji
	 XO3BmJKr3urExzfclZ0QWwfKeUHVmPO0KXya/x5Jp5mC8g471B+AuO2qVUN91Y+6Go
	 joZDYNqSLTOZCl9wR3CJjBuseLkwe++2P9nJnmF7GZ/MGx8hrTdziFvtU9lBJrU9wz
	 CQidQTUirrpiA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/164] netfilter: nf_conntrack_h323: don't pass uninitialised l3num value
Date: Sat, 28 Feb 2026 13:14:59 -0500
Message-ID: <20260228181505.1600663-160-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 2eb31ffb3d141..b479dc148d7bf 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1229,13 +1229,13 @@ static struct nf_conntrack_expect *find_expect(struct nf_conn *ct,
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

