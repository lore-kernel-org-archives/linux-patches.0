Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7C21C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3254C433EF;
	Mon, 20 Mar 2023 15:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324511;
	bh=6g8e/x/AIk+47u2wNkdqmTl3FIE//2nlw/lM0FE6ybE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VV+iosmDd1NZ8bqck1eabv/ZJdaHenyH2gvE+jzVlPD4Xfpxs5A/7DWyH0TnydGFA
	 jtbxW/eGPauK8ZyR3aoDNl5q8whLTgpaFlTT5qHEo5nymNpBqm18AZPNBzus49QnnL
	 lKG81dhu1mvo0FUNdHj+5npnVmg18fnUSK/R9R2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Sowden <jeremy@azazel.net>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/99] netfilter: nft_nat: correct length for loading protocol registers
Date: Mon, 20 Mar 2023 15:53:47 +0100
Message-Id: <20230320145443.752456317@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Sowden <jeremy@azazel.net>

[ Upstream commit 068d82e75d537b444303b8c449a11e51ea659565 ]

The values in the protocol registers are two bytes wide.  However, when
parsing the register loads, the code currently uses the larger 16-byte
size of a `union nf_inet_addr`.  Change it to use the (correct) size of
a `union nf_conntrack_man_proto` instead.

Fixes: d07db9884a5f ("netfilter: nf_tables: introduce nft_validate_register_load()")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_nat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index db8f9116eeb43..cd4eb4996aff3 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -226,7 +226,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		priv->flags |= NF_NAT_RANGE_MAP_IPS;
 	}
 
-	plen = sizeof_field(struct nf_nat_range, min_addr.all);
+	plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
 		err = nft_parse_register_load(tb[NFTA_NAT_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
-- 
2.39.2



