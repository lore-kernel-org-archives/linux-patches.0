Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18021A6192;
	Tue, 30 Jul 2024 16:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357411; cv=none; b=BmKFxxT8J7klIgvKA06T0s3zd7ua3SMCjpNx7GEtC69B0SbERr9CZ4Or80wuu2UqQ3nEPFOiWPqfdPgTemRewnuZZXr4JlBMBBWsoJWkUhcMhw3CBag+G9ce9zNVu5NQsinP3bP+ui+H3G61pk5QjdipGfojvFEt4S4RvveXkx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357411; c=relaxed/simple;
	bh=J78UyL3nQUOVxG9YnLglybDfF2wJBiN//9cqudzmFcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfxb9LzNCnrlGOQIuPK7whRAVt8St5wiHXB8j1SAHUb0to61QoSBDvAtueANBc1/KKlpKxDOml4DEE95iCwn12ejFGd2VAIUSSCDLYhS7oTA02e0VBNhMTmogNTEzD7IkEnVoroTVFjD1s22NuD66RQShtJu4znULhhCHct7KW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xkp/fYSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xkp/fYSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30591C32782;
	Tue, 30 Jul 2024 16:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357411;
	bh=J78UyL3nQUOVxG9YnLglybDfF2wJBiN//9cqudzmFcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xkp/fYSfAAsvEQ9gQqdhfqIJpms+38pwAaelUSVk/aWK1tIUzxDs3HnM25BhrkWM2
	 Snd9ARrjl90wWbXJCxRA3L3s3y5m0MXlYazTRReIUkmr6hg4k0mj0UpgAQb5RnZ6V6
	 CIibCoZ6mZnS3UC+UQbE3KBV2BTnc1rQyc6ldvvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 251/809] net: ethtool: pse-pd: Fix possible null-deref
Date: Tue, 30 Jul 2024 17:42:07 +0200
Message-ID: <20240730151734.510121999@linuxfoundation.org>
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

[ Upstream commit 4cddb0f15ea9c62f81b4889ea69a99368cc63a86 ]

Fix a possible null dereference when a PSE supports both c33 and PoDL, but
only one of the netlink attributes is specified. The c33 or PoDL PSE
capabilities are already validated in the ethnl_set_pse_validate() call.

Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20240705184116.13d8235a@kernel.org/
Fixes: 4d18e3ddf427 ("net: ethtool: pse-pd: Expand pse commands with the PSE PoE interface")
Link: https://patch.msgid.link/20240711-fix_pse_pd_deref-v3-2-edd78fc4fe42@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/pse-pd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/pse-pd.c b/net/ethtool/pse-pd.c
index 982995ff16280..776ac96cdadc9 100644
--- a/net/ethtool/pse-pd.c
+++ b/net/ethtool/pse-pd.c
@@ -178,9 +178,9 @@ ethnl_set_pse(struct ethnl_req_info *req_info, struct genl_info *info)
 
 	phydev = dev->phydev;
 	/* These values are already validated by the ethnl_pse_set_policy */
-	if (pse_has_podl(phydev->psec))
+	if (tb[ETHTOOL_A_PODL_PSE_ADMIN_CONTROL])
 		config.podl_admin_control = nla_get_u32(tb[ETHTOOL_A_PODL_PSE_ADMIN_CONTROL]);
-	if (pse_has_c33(phydev->psec))
+	if (tb[ETHTOOL_A_C33_PSE_ADMIN_CONTROL])
 		config.c33_admin_control = nla_get_u32(tb[ETHTOOL_A_C33_PSE_ADMIN_CONTROL]);
 
 	/* Return errno directly - PSE has no notification
-- 
2.43.0



