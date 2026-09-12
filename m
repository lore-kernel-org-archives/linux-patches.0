Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFC8429CC7;
	Sat, 12 Sep 2026 10:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209626; cv=none; b=Ty1hJkcwDlSgTwy7u5zrUJbaMtNhvmm6RXDLxVMyntPdj3WKr+1WeG64DhPGLhxFtEVFPC25XLt8J8kEPsAKS0mdLXxPepl+x9qztzKsY/vbZTn/7HGjbnqQxLN5o//0O3/4rUfxZAbBjtK3q5FgIhVhzfsu+FLP4gKT2bbjBT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209626; c=relaxed/simple;
	bh=NhAysi8Li8I6VU9JlshdgUmBwTJBdrmoMBfQGm6fPtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cg+qlVj0IyVxlG+mKuB26mNEtqFz1/UO8c/X8GJdBE2UDfI/y527H7W5D65iKyu2j1iKkMkesRBI3/OMMmthDJMldpMoPiDKd5mk2GMVpJhqWDp+5LEOJivJw5ebfqWhgue1KO4bwXqvvhrUXEBpnklLghC/45sZZLMvxvN67s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBAcE82C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBAcE82C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40A21F00899;
	Sat, 12 Sep 2026 10:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209624;
	bh=MR5Mx/uZIwT52UbNViq9MjWQoYj9a3Ghz9Gb1FbFE9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oBAcE82CetMGCkTg5P2ufUZcNsiluHHEGSXCfuQ61juY/zHaKTKHHfXyrYTb0MFf0
	 bMZnRDsYg3B38hon1SB8utB/KrWj6I6p4qakv0R9DbZ6GrvfxJhfJ/KZIRdrsTxeu4
	 BRDo35h4EkAANuTTSyLX+b+jXqxeJqemfyqOUuVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zxyan Zhu <zxyan0222@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0858/1518] net: stmmac: Skip PHY attach if custom PCS is in use
Date: Sat, 12 Sep 2026 08:50:27 +0200
Message-ID: <20260912065642.859024962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Zxyan Zhu <zxyan0222@gmail.com>

[ Upstream commit af4d934164457f0578bf90e92ae0fcc5348260cb ]

When a platform provides a custom PCS via the pcs_init callback,
the MAC's phylink_pcs is already configured. In this case, no
traditional PHY device is needed.

Without this, stmmac_init_phy() falls through to the no-phy-node
path and errors out with "no phy found" when the DT has no
phy-handle for such interfaces.

Skip the PHY attach when priv->hw->phylink_pcs is set and
phy_addr is invalid.

Fixes: f0ef433fc264 ("net: stmmac: introduce pcs_init/pcs_exit stmmac operations")
Signed-off-by: Zxyan Zhu <zxyan0222@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260729074237.2624940-2-zxyan0222@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index bf2fa56b861be..4b458a39ab9f5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1126,6 +1126,10 @@ static int stmmac_init_phy(struct net_device *dev)
 		struct phy_device *phydev;
 
 		if (addr < 0) {
+			/* If a custom PCS is in use, no PHY is needed */
+			if (priv->hw->phylink_pcs)
+				return 0;
+
 			netdev_err(priv->dev, "no phy found\n");
 			return -ENODEV;
 		}
-- 
2.53.0



