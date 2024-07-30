Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53831A6195;
	Tue, 30 Jul 2024 16:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357399; cv=none; b=PaSqR/Ci404UsGAuGL+MF/u68iGq7S58MEBCTOebG7NWP/HHSZ9PG9ZyFsPXh7FlAWJhIeDmoRtuREZm0G8Poi6Lh8tlULe6q8QA6M8HDJKxlLYNwwQqR+qT3jZZlekPox1mYVNxvKeT/bkPgGmRvuz27t1DEcEl/9bBtdOY+7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357399; c=relaxed/simple;
	bh=KMf/OIHu6sLaTSazuTtYRYW0RtI8REHdRuH8etKAhvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8c2dCU2JDJNur4cACLgjGMMB6F4zBxbYSmfHJuWdKLBnDu524TtWGU5yjHlFlrvwjbYYW30RBW9BgST4qp/FiIFgtQFplbv/3OYDwVsh0t7FntYeI1Wx0tcE4ZeXDtnXOope064sdWGonwyjxgCTVwUa1hmsf466NV7+kWzUZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQZ6X/m/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQZ6X/m/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5481DC4AF0F;
	Tue, 30 Jul 2024 16:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357398;
	bh=KMf/OIHu6sLaTSazuTtYRYW0RtI8REHdRuH8etKAhvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQZ6X/m/uAnWfcUGfONagei2knrTY+LRY/cYPGLk5mzoXzx+E3UgTfjE6fqOw24RI
	 1WZmkAc+6QxMt3nA+FicZFfrfaYEWARxNaEHgfGkv/9ftRR4k3rwPjamJLsxZPrs9E
	 nVqCCOhFEtRwsOYnEUNuPMdOt5Rjb9HVqql1Cp58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 250/809] net: pse-pd: Do not return EOPNOSUPP if config is null
Date: Tue, 30 Jul 2024 17:42:06 +0200
Message-ID: <20240730151734.471265351@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit 93c3a96c301f0b1ac0bafb5e74bef58e79937648 ]

For a PSE supporting both c33 and PoDL, setting config for one type of PoE
leaves the other type's config null. Currently, this case returns
EOPNOTSUPP, which is incorrect. Instead, we should do nothing if the
configuration is empty.

Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Fixes: d83e13761d5b ("net: pse-pd: Use regulator framework within PSE framework")
Link: https://patch.msgid.link/20240711-fix_pse_pd_deref-v3-1-edd78fc4fe42@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pse-pd/pse_core.c | 4 ++--
 net/ethtool/pse-pd.c          | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/pse-pd/pse_core.c b/drivers/net/pse-pd/pse_core.c
index 795ab264eaf27..513cd7f859337 100644
--- a/drivers/net/pse-pd/pse_core.c
+++ b/drivers/net/pse-pd/pse_core.c
@@ -719,13 +719,13 @@ int pse_ethtool_set_config(struct pse_control *psec,
 {
 	int err = 0;
 
-	if (pse_has_c33(psec)) {
+	if (pse_has_c33(psec) && config->c33_admin_control) {
 		err = pse_ethtool_c33_set_config(psec, config);
 		if (err)
 			return err;
 	}
 
-	if (pse_has_podl(psec))
+	if (pse_has_podl(psec) && config->podl_admin_control)
 		err = pse_ethtool_podl_set_config(psec, config);
 
 	return err;
diff --git a/net/ethtool/pse-pd.c b/net/ethtool/pse-pd.c
index 2c981d443f27e..982995ff16280 100644
--- a/net/ethtool/pse-pd.c
+++ b/net/ethtool/pse-pd.c
@@ -183,7 +183,9 @@ ethnl_set_pse(struct ethnl_req_info *req_info, struct genl_info *info)
 	if (pse_has_c33(phydev->psec))
 		config.c33_admin_control = nla_get_u32(tb[ETHTOOL_A_C33_PSE_ADMIN_CONTROL]);
 
-	/* Return errno directly - PSE has no notification */
+	/* Return errno directly - PSE has no notification
+	 * pse_ethtool_set_config() will do nothing if the config is null
+	 */
 	return pse_ethtool_set_config(phydev->psec, info->extack, &config);
 }
 
-- 
2.43.0



