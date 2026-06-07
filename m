Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DCB320A37;
	Sun,  7 Jun 2026 10:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827860; cv=none; b=T43+ZpNYznBmAk095s9YN1Tv0hHGWr9W2IkLZgjO70TI3OUi9ZX7GKGlosy9jrU+O0NhKU+bIonIHgGwuW2ONKgmw+sA0a34C3SOHuAg0gfnDXKystAEzj+bnKTuYrtWNsgQKyXsT2RgWa356Xee8krkX9MwrLOa+NOE6v5ySoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827860; c=relaxed/simple;
	bh=mMN4UeIrKwGZUiszDDN1TQoVRawo7zb86Xwj9bkdlbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8MsvwWpbANS5EOXjEEJtLLOohcpq5BUsp/Bz+793H0bMVj+RD+XBnDbQPga7iCnAGT/L6hYxIrJnthIcePIp8aTqJ/jGbl07LXHuh/QcmeErEmHL/XvhTsBzVHnmFrQpBg8aeX3jV3na+v2a7+Z9GG8/pIk4gM2G+TqROo/aMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEnr6Tc+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEnr6Tc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA921F00893;
	Sun,  7 Jun 2026 10:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827859;
	bh=l2QEb1GPtgs4AYs+KbjyziJtUt6ECD2aK7fV7Aas9CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEnr6Tc+v71ekK5O9LAqrCWzGkzw/AGiY+MUhkk0YQd+dezFMCt50Sm3BR4hOTfyM
	 Ll6r+e1QBZTdVtzzE/43Naitqz2sHThteQhYybGEkzVRK9c7GANOkIka0go1NVyH/U
	 XD5SpoWEMhst49ZhS+fEcLu2jqMaMnOTSJBS3jNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/307] ethtool: pse-pd: fix missing ethnl_ops_complete()
Date: Sun,  7 Jun 2026 11:57:45 +0200
Message-ID: <20260607095730.254935443@linuxfoundation.org>
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
index 71843de832cca7..01517c53113def 100644
--- a/net/ethtool/pse-pd.c
+++ b/net/ethtool/pse-pd.c
@@ -60,14 +60,14 @@ static int pse_prepare_data(const struct ethnl_req_info *req_base,
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



