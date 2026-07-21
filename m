Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E76E44AB60;
	Tue, 21 Jul 2026 22:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673931; cv=none; b=KrhRV5S0nhe9AM56myk6KeT1A1kIcOQRjxd3TFv2FA+SbyEpZqLzoakb6pfD1cCbPssWd14IQrIOsqukE+IlLxDM2sOBNcapEq8gFlTvNQ6j+t7RUreOyDfyqPeKiMNXcJ8Q+YW6pkkqwurAj86RXZO8Oe2k33ZVvZFIvYKfYA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673931; c=relaxed/simple;
	bh=n7Qo5DimPybSp4h+sVqj7OsZ6Wg0EizQdBd8SKHJ8fY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJoyrNx08HTcE3w7MLLZC8C+s84tW5YSeu21oL8w342ww6pD4IF26QHRueSHiBujCHvfGJtSCrjWT85+ktGjlzhbB+gJhpRAC7o3lTV86RI4zrfcxlHeGcmnOvXZIc82mVkGmlB7jYxVdZMowd1Gp5Ppi3J7coLwF1oBqUhaKyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pi2W+55+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pi2W+55+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022B51F000E9;
	Tue, 21 Jul 2026 22:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673930;
	bh=STVijmyOaTDt6v0SXZt5JyPq7N16t7aWYKEppO5KOMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pi2W+55+WUIV9eKjWj2GmxaMGTdAbaYxBzQKDK1sdwI7ou18U8QsjlHK4yf5QTWcx
	 Mrmciu+jamxmBbTmTsGmSXWN9DmQgmvQjEDzrqKNLxN7jXNFuQO4/JEe9zRRLP4UOS
	 9DY2g7FBAplFx2JVHICeC49uJBLq0YlbXYaQSPi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 348/699] netfilter: nft_meta_bridge: fix NFT_META_BRI_IIFPVID stack leak
Date: Tue, 21 Jul 2026 17:21:47 +0200
Message-ID: <20260721152403.542160111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 97805ec424c199..5ebcf5001dfd28 100644
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



