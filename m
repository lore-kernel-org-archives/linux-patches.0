Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D157673161;
	Wed, 21 Feb 2024 13:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521606; cv=none; b=i5Hlrj1tZ343Dfa+D5kuCdte8h13scvq95SfrmxaOfr99HOb9o90Rh0YPr1ELxo5cE4rjJdr055hZPAEjXE21uYrXr8KDHw4XhXq66f+ZnmKyzHy/nRUi9pVzWBi8NB371nxmLYwfLlaHdmH+5h2rqprQUtw2ft6B1VZdjyXAtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521606; c=relaxed/simple;
	bh=tkqSTUuAYjY0amJ/kQd2m+AXj3CaU2njiQa32y5BH7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ysb7180+l8BWaq3+1IshbRkIDEnxM7CO/+CDzzHDhRLI8xxd8oCoQJB5sqcr12R13ucL7+Cm6qNhpLB9X+66ljm3bZMGrsO4oqaeTs3NBglt6N9FHJ8WzmcLiFWyktZAI7UoBC9uCjhCVnGW9lhbFG07WfGSVoa0vrwWijsxaAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KVDQYao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KVDQYao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AEAC433C7;
	Wed, 21 Feb 2024 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521606;
	bh=tkqSTUuAYjY0amJ/kQd2m+AXj3CaU2njiQa32y5BH7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2KVDQYao5yHBGYlLkDeFsYiPu8wq3TRgmv+rflYWCx7q2CXRXuHLE1B+rtN6rC42r
	 v/DIGHJBz16nCtKRzaHBPJzXrYQoWXMgoXOYBnh96Uo847I+VGw4B083a0jUwCTcMk
	 E8KPWIWFV0OYTZgWiNc3ElQ8gKrXHEZL4MIak5EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 157/202] netfilter: nft_compat: restrict match/target protocol to u16
Date: Wed, 21 Feb 2024 14:07:38 +0100
Message-ID: <20240221125936.765234050@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d694b754894c93fb4d71a7f3699439dec111decc ]

xt_check_{match,target} expects u16, but NFTA_RULE_COMPAT_PROTO is u32.

NLA_POLICY_MAX(NLA_BE32, 65535) cannot be used because .max in
nla_policy is s16, see 3e48be05f3c7 ("netlink: add attribute range
validation to policy").

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 95af1dbc28c1..763ba07a58ab 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -195,6 +195,7 @@ static const struct nla_policy nft_rule_compat_policy[NFTA_RULE_COMPAT_MAX + 1]
 static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
 {
 	struct nlattr *tb[NFTA_RULE_COMPAT_MAX+1];
+	u32 l4proto;
 	u32 flags;
 	int err;
 
@@ -213,7 +214,12 @@ static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
 	if (flags & NFT_RULE_COMPAT_F_INV)
 		*inv = true;
 
-	*proto = ntohl(nla_get_be32(tb[NFTA_RULE_COMPAT_PROTO]));
+	l4proto = ntohl(nla_get_be32(tb[NFTA_RULE_COMPAT_PROTO]));
+	if (l4proto > U16_MAX)
+		return -EINVAL;
+
+	*proto = l4proto;
+
 	return 0;
 }
 
-- 
2.43.0



