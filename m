Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA1C421A07;
	Tue, 21 Jul 2026 21:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669563; cv=none; b=eSui3mAYhXCZv410o1J7t26xwYt2ojYE+HtndD0VX/wE+OhzS/YTCZN6EgklXVloJf28eEfhvFv1Tg6MLoGrl5rv1cHBjtgxzq+48hLAlE/oXTfvWWfi5Q1SnuazSDeaR/ENKUzPFw3olnRHk6/rOV2Pm6ZLQkxMHOmG5l1pUGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669563; c=relaxed/simple;
	bh=YVQUrKWGn8gDXqyGZdSte1J8/6oe5gUMY8IIrCQasbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvnRgSHNsDoMgUxXFla9cyJB8xMKQg4nKYPt8tpydSiJU8ipbnj2sYUdCRtOAnUt7kqxceQPljxGSzFTvh18ouwMcXWSms3Shar2dvWCT3WA0VtX1RGnP6Z+Gyqvphgbs3WEUivvqTJkGmeYDLlw7CVhrq/J0L0xfl58clNYqUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZnZrVjjM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZnZrVjjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5651A1F000E9;
	Tue, 21 Jul 2026 21:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669560;
	bh=gLjRQhhYyPAFTkPfa2yJ71KEQUFzhu2JnOV/QwGYa8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZnZrVjjMfaedoRcUfUNL/8J5minEqn1JkYiXJJnHsJyz8qEYFcORIq9txs6+hrIO6
	 sGodCdMlbbxNsyDnE9TxFJ4xrXGSk0XS1bZSOmVasSPxojLnuZ4C1Nxlx1/AnmRSfQ
	 YQG+qMFTEqD0Hn18Xj2K4Y29Erc0gX6t60Uqrka8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0600/1067] netfilter: nft_meta_bridge: fix NFT_META_BRI_IIFPVID stack leak
Date: Tue, 21 Jul 2026 17:20:01 +0200
Message-ID: <20260721152438.025444016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c3ecd77e25cb8c..6fc558ff580917 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -41,7 +41,9 @@ static void nft_meta_bridge_get_eval(const struct nft_expr *expr,
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



