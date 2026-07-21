Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043F33B1ECC;
	Tue, 21 Jul 2026 20:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666603; cv=none; b=dv91Xf2uq2jcZTX2m2bYSp1iqf5sBdVSc07KjVR/JcWU0JkBYJ6R/TUw6xyt5jneJNy+blfbyUAdaeObkkOzjG2tc7BSjX7eGwRY4eMJPkkunQVE6dr//76tsodmvtbsP8IRutbv/du4epaLH5PP+2IGCqwvRoO0A4M+cuIBpzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666603; c=relaxed/simple;
	bh=mZp55kczxWBwG9NJ9F/Ahhiq3Ixy06B4YpOd/BoD/n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7/97DDR32HGadhxD1GTuPoGDHeGcDgBp3fZxChKvDQLhi8rftPM9FR4vrh/23ifHNpiV9kyINuxlUa2jaXtUJz2pTZ3Yz+WgVFpcCSKEvZNlHExxnF4cYsoXBYiXn3LZCzOm7Uy0lKofW229Tijoq2Uer+DH2Qa1AbQwLdGbgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4sWr+mT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4sWr+mT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0821F000E9;
	Tue, 21 Jul 2026 20:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666601;
	bh=yWcLSw4DcKtdlKOdaZtfsfF6ypDNc32bg5S7eg4Ct90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y4sWr+mTJxJ8ACaoY0dmDrPCHZQhHHLL3cTlEPP6leS9A2huJOgXofnGcV0OmDeU+
	 Q3I5grjnTM9noqLgmRaQ3I0zM/OUfGAbJk78aw6ez3DGgDc/1VwqL9EyovHcDTfB/I
	 BnFvsTiZW8J+u7+RHKhlXvvPCmFbaRyxdpNfjSIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0746/1266] netfilter: nft_meta_bridge: fix NFT_META_BRI_IIFPVID stack leak
Date: Tue, 21 Jul 2026 17:19:43 +0200
Message-ID: <20260721152458.563704012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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



