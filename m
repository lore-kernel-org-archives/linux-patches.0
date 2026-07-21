Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22244471246;
	Tue, 21 Jul 2026 19:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660996; cv=none; b=PFxIKhjXvp9+FaIZEBdMgtc/uUsi/MjEXdMAa71OJcdQscZLBpcRwPSpggicWqcacVcMAjNq2IzhIgiTckBIdoWKWlH/5rM2o0gRNZdC4DCF0AbekO9UmID1foKxDKaBjc8GMrc1I7hbGYwolPNWxVXT2TptP7yiMQUoUYSfmFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660996; c=relaxed/simple;
	bh=Et7lTbflh4FdAyVM0uhq59+pi+Xc5SOFWLQmWUtzu8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBYZ0TEs6YI7jT7KaBTl1XfsUjxBiS3Pn8Jd3QddyD1wskWqJWLk8Tcs+v4KzchpIugmiPK6Cm63Q1qjBSWr66bmiqyfPMdvc9kHVyBelgSeNz3fKcVwB2+5bzwb9x7G3g0SdkcGYZaDoMZButQvEn4WcH4msXElk9zRCsEXdPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFJBd1EY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFJBd1EY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5971F000E9;
	Tue, 21 Jul 2026 19:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660994;
	bh=2ZR/ir/MW8Lj124ypkgVeZBraLftUm6//dalXaY8myY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFJBd1EYZ+dk2Qj8XXDItkL2PI3aBBsVvBzgJh5AUbiVNe81Waepff6bPLFARAiSE
	 n9HVL/gbaAX0Ye0jpZYZ73SOVF4SyvhSeIxspQauYaoLhMxcWJZjhSstZ8fsPgdeKO
	 1lw6DdKoPGr9vcToS/ccjTO3iX5+KidHTkttX7fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1154/2077] netfilter: nft_meta_bridge: fix NFT_META_BRI_IIFPVID stack leak
Date: Tue, 21 Jul 2026 17:13:47 +0200
Message-ID: <20260721152620.041935470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3d95f68e0906ab..e4c9aa1f64e25f 100644
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



