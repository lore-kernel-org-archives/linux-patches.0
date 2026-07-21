Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB22B47140C;
	Tue, 21 Jul 2026 19:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662862; cv=none; b=GRWvoePIVExgieforn7KGaSAE17FLcOr9fqzYcZqmNhkBw4UezF+x5zbO2BBFXWbaQIwBRfdF33oZ3s/aq8i4wEwdmZhIJFoFhxL2o2lJllqceYWv5KGjVPJ58Xf+U8BrAV6ZxnCynCBYioajno1JDJjUtkoE37vq+9jIsEZNj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662862; c=relaxed/simple;
	bh=5BoEBCNb8ZTg0rfxtJNKkTcXfxyJLLmQKVALTCu+aOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HoeqHAqdWZaVKDPFvrmnAN+i/1RiIba7u9wkZfMuQgt05mr8KKnsw+SECgtg/BuGkyfgxPYG7EMK+Cl4TR51l4xn8GxZ8OfIwU6ClCsn/NUIerWy8NlVbz3UMHlIiuFiARy1ZeZk30g9bywonN4TA1z469pRRobybZjcc4siJTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXhG4Teg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXhG4Teg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4711F000E9;
	Tue, 21 Jul 2026 19:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662861;
	bh=yHWVfDmeV6yFZkd3nDAjYQjZeHBr/1BWm4QpTtDZiXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zXhG4TegrekEbD2tRXNo6fO6zFT5Hvbkj52zaLPeCDUoSPOGHEB0ifBvvdBDAHzIV
	 ZAH6SaerO49X1yxlIG2AqkT1VENQ6tCfJ5sTrGrbAavPlWMSsGRy2uBPIJoEukog/o
	 ZJZ8NX8b1aXpX8qNgQdHKbyHNWAn9dEc5occpp+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0598/1276] netfilter: nft_meta_bridge: fix NFT_META_BRI_IIFPVID stack leak
Date: Tue, 21 Jul 2026 17:17:21 +0200
Message-ID: <20260721152459.495869897@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

[ Upstream commit 27dd2997746d54ebc079bb13161cc1bdd401d4a6 ]

This needs to test for nonzero retval.

Fixes: c54c7c685494 ("netfilter: nft_meta_bridge: add NFT_META_BRI_IIFPVID support")
Closes: https://sashiko.dev/#/patchset/20260618061631.21919-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/nft_meta_bridge.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index d12a221366d60c..475d7d1709b9fb 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -44,7 +44,9 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
 		if (!br_dev || !br_vlan_enabled(br_dev))
 			goto err;
 
-		br_vlan_get_pvid_rcu(in, &p_pvid);
+		if (br_vlan_get_pvid_rcu(in, &p_pvid))
+			goto err;
+
 		nft_reg_store16(dest, p_pvid);
 		return;
 	}
-- 
2.53.0



