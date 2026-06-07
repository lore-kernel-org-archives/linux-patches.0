Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910DF4071DA;
	Sun,  7 Jun 2026 10:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827351; cv=none; b=TmCsO1W4mJvZLhQfZSVwuHKUgrQ0j6mX7i5JAuEo4O3jY/jAtAmZDQJan+hNNO1sd8Od6rdWWxq/YMtDz2q39z8R6ofV1hCURvzVXyheoEtTNXttNJxC56srQc6Iq5evR7TtABrfOmUVd3rZmoyr+tLmkBqVASo5jCWLk07oTyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827351; c=relaxed/simple;
	bh=DSNo6gXepNVA6FgvvDk/52frQnmdlxxZ3C8cPI6Vflc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnJ+hns//ecsJE3k9+rpH8OOH22/zfgAdCbkC8tsThzjRxslAiamnK3Aj5h3t8BpsUqZcc9GFnf2tl0xzrhvT2NdhXBr2efCrygaWU5l5clKJ9HK1WpNYp0tWW2DgxC0xIeKgCR2QkGtaWbc7p9KURBF867WJIPdXurBBnI2gvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpdi9fTe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpdi9fTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71211F00893;
	Sun,  7 Jun 2026 10:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827350;
	bh=YhgMs2mzf1ed7LPTRhluwe3IDG5Om4ZxSF6gPzZHwpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpdi9fTehBBv3Ruibi3e59iVBEQpSaABKrwxCzmCXADYpbe/9DQBSsAICklwU4qbC
	 IO3xS9RMdaYnUup1TLDjNdFNsyrtWG/HXeriYkq22GJzvAELj7PoKpi68BDLMyGNuz
	 0mWl5TkVWKz3hHhH/X9JpQYG8q9GuGD6YIIQutbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/315] ethtool: linkstate: fix unbalanced ethnl_ops_complete() on PHY lookup error
Date: Sun,  7 Jun 2026 11:57:33 +0200
Message-ID: <20260607095730.035308367@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 596c51ed9e125b12c4d85b4530dfd4c7847634b7 ]

linkstate_prepare_data() calls ethnl_req_get_phydev() before
ethnl_ops_begin(), but routes its error path through "goto out"
which calls ethnl_ops_complete().

Fixes: fe55b1d401c6 ("ethtool: linkstate: migrate linkstate functions to support multi-PHY setups")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260526153533.2779187-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/linkstate.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/linkstate.c b/net/ethtool/linkstate.c
index 05a5f72c99fab1..3dc52a39d34525 100644
--- a/net/ethtool/linkstate.c
+++ b/net/ethtool/linkstate.c
@@ -105,10 +105,8 @@ static int linkstate_prepare_data(const struct ethnl_req_info *req_base,
 
 	phydev = ethnl_req_get_phydev(req_base, tb, ETHTOOL_A_LINKSTATE_HEADER,
 				      info->extack);
-	if (IS_ERR(phydev)) {
-		ret = PTR_ERR(phydev);
-		goto out;
-	}
+	if (IS_ERR(phydev))
+		return PTR_ERR(phydev);
 
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
-- 
2.53.0



