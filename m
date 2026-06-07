Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE7E31F983;
	Sun,  7 Jun 2026 10:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827770; cv=none; b=SQZtzo3uemxZ779d4BxHOBoJdWDQoBhZei2Ze11O9W3jszJnzIBEpIqUpDTQYq4GxkwCVTkfiplypOuFUwkhya8OLNBuwKuuSylGd7Knr5gSSU/postGQRGXUg23EpGYkl6xaqucgXRsrGaDH6ti7UTn1Q4jd37wjfmBDWT/bHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827770; c=relaxed/simple;
	bh=Nl+uz67fJVInqqpv9Q2+1NWiWVsxMTr1CnNYwP/Lh3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPHA0WjgpKdMT6AIl3vDLEaqbX3pTS1y9UBVjltcrJ1wQZEM37KaZz2jifrXAZV35cYeVYV5/t1bT8lubUCYmZPeikK0m59etURbgQdKZarKaaTiKHwRz6RIInELeT2GAUJPZq5aYQ6RK3fdu0LR+/0pwjM900GhnL7z1qbBO68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x0tf43ht; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x0tf43ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE8E1F00893;
	Sun,  7 Jun 2026 10:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827769;
	bh=LuJtZrrL6YTGsmaY7u8tJsuJDZOgcOVUuV3Mhfifx+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x0tf43htFbAHwZDXZqlvfxbS8peLv2q5712pfw6s98LK0jXkbLL1H+Z8p3bpg2Lvv
	 ejLJTxGEK1Lp+PubCGskr1JdXTAB7a9kFWATxrAPsWcbCbbJHJ6mWoZvnmdxkBUYQc
	 Hs5iQtztc1zOJs7iECeYeeb1JadhxSd+6Ocr2qIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/307] ethtool: linkstate: fix unbalanced ethnl_ops_complete() on PHY lookup error
Date: Sun,  7 Jun 2026 11:57:44 +0200
Message-ID: <20260607095730.217923685@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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



