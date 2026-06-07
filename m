Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B97D1E98EF;
	Sun,  7 Jun 2026 10:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827197; cv=none; b=JrYI+o7PNoz4bTYBQe08PidvNc3qNZY9EvGOF5Yi7PP4jjYMOSeU6/QOjszp7w/cFQosfplXRsUzKeIvjRXG4f/bZGNQagdLxG8qb3vCTH2exxaeoLVkIgUJ5g6PRQIjfo4jKGjrHjzsjqrH5V34JhOPx4vgCezrZUcI0/eRGrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827197; c=relaxed/simple;
	bh=pDQQ/ArHUqpTM7hLQjb5Y3sJahngUJTBT0hxFfChHXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYH55BUKwCE65tF42lete/qc+3bfmORKwblXMS7/NiDuTIFY3FJHSZrp+zBPsSOAUadRgNFW/6sIqZdSYdxKTC187fGkXpuq2k36LOorY7i9qqRQcP+pqNnUyU5C3WjKHFFrMVJE0jSEX6mPcbJB1d0wZmBeHC9gj/BplPK7FHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wg8Z7QXV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wg8Z7QXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F101F00893;
	Sun,  7 Jun 2026 10:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827196;
	bh=jwssuk5lH49FRQtxUGXNkmzRMSOd1M3qlKfvJNLgjlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wg8Z7QXVMisqj0XMHDws+L5owk+0+glCZV1R4semFKVxyWAa0UWk6CWNaH6hLouxk
	 4BcyxDkn6h+pxB9CTUy7Qeus4IwGQNZkCX3ZIT/URiDhFe945i40u7/nAp81jophwx
	 Lzl2P7AEvemXbTa/d8CBKiC7fiKzqq4Lf+XirG1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 071/332] ethtool: pse-pd: fix missing ethnl_ops_complete()
Date: Sun,  7 Jun 2026 11:57:20 +0200
Message-ID: <20260607095730.745374171@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ab5bf428fb6bd361163c7247b92750d1d24ca2ed ]

pse_prepare_data() is missing ethnl_ops_complete() if
ethnl_req_get_phydev() returned an error. Move getting
phydev up so that we don't have to worry about this
(similar order to linkstate_prepare_data()).

Note that phydev may still be NULL (this is checked in
pse_get_pse_attributes()), the goal isn't really to avoid
the _begin() / _complete() calls, only to simplify the error
handling.

While at it propagate the original error. Why this code
overrides the error with -ENODEV but !phydev generates
-EOPNOTSUPP is unclear to me...

Fixes: 31748765bed3 ("net: ethtool: pse-pd: Target the command to the requested PHY")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260526153533.2779187-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/pse-pd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ethtool/pse-pd.c b/net/ethtool/pse-pd.c
index 24def9c9dd54bf..aa4514333d13bd 100644
--- a/net/ethtool/pse-pd.c
+++ b/net/ethtool/pse-pd.c
@@ -61,14 +61,14 @@ static int pse_prepare_data(const struct ethnl_req_info *req_base,
 	struct phy_device *phydev;
 	int ret;
 
-	ret = ethnl_ops_begin(dev);
-	if (ret < 0)
-		return ret;
-
 	phydev = ethnl_req_get_phydev(req_base, tb, ETHTOOL_A_PSE_HEADER,
 				      info->extack);
 	if (IS_ERR(phydev))
-		return -ENODEV;
+		return PTR_ERR(phydev);
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
 
 	ret = pse_get_pse_attributes(phydev, info->extack, data);
 
-- 
2.53.0



