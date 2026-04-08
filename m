Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5242336166F;
	Wed,  8 Apr 2026 18:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673034; cv=none; b=N4lWeXOEIYTUyH6kxX+RyttiA7N5dMORdz8+EcvQRLxDt97i8VlSGW+K6cnFxujelXqWjFUFWXvQGj+UL6BfWtZIr+onoLE2QxPJj7ih1uuaj074OgUT8nEMCl5QgMdeyFb6V+EDWBjFy/R3aE/SGv1nyY0vM2X/hOBfwrcF+L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673034; c=relaxed/simple;
	bh=LMX8jLGHpOT+27LmV0TLJv0gkePblx3oP+io9x9Qydk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+xMdl/WwUs7M1NM1dDMbuSBuUxe4medbp4m+l6Sa/BuiW8poD2E1UVlqjahALaiGdRBmQj6ybXaCnVw9y9YgILxUah/BjSgDSXgFrPrmzmV5D/uJ8A333yYsIvE3otNAOcqwHK2WXvvgVXunJW+IsK8tuvasVF+EWMIFHgoWA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6+3SleO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6+3SleO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4393C2BC87;
	Wed,  8 Apr 2026 18:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673034;
	bh=LMX8jLGHpOT+27LmV0TLJv0gkePblx3oP+io9x9Qydk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6+3SleOwVYFEPqjOAxJuuAQYN15eTIPtYUkzCsW43K91Nu308MLHSCggM3WJQzJ/
	 AjTtsrPXS8pTC+smvLJeX64823s1vgiTLDb02f5gWzBMRrYw/T71VAbbtDmo2QOHCn
	 UlceT+92GaOuZAn9giKSu/+9HoBRd5EDQ7gdl13I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/277] net: enetc: check whether the RSS algorithm is Toeplitz
Date: Wed,  8 Apr 2026 20:00:28 +0200
Message-ID: <20260408175935.465681495@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit d389954a6cae7bf76b7b082ac3511d177b77ef2d ]

Both ENETC v1 and v4 only provide Toeplitz RSS support. This patch adds
a validation check to reject attempts to configure other RSS algorithms,
avoiding misleading configuration options for users.

Fixes: d382563f541b ("enetc: Add RFS and RSS support")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Clark Wang <xiaoning.wang@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://patch.msgid.link/20260326075233.3628047-2-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 0250ed95e48ca..8349d38dbd896 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -770,6 +770,10 @@ static int enetc_set_rxfh(struct net_device *ndev,
 	struct enetc_si *si = priv->si;
 	int err = 0;
 
+	if (rxfh->hfunc != ETH_RSS_HASH_NO_CHANGE &&
+	    rxfh->hfunc != ETH_RSS_HASH_TOP)
+		return -EOPNOTSUPP;
+
 	/* set hash key, if PF */
 	if (rxfh->key && enetc_si_is_pf(si))
 		enetc_set_rss_key(si, rxfh->key);
-- 
2.53.0



