Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8D520CCFB;
	Tue, 17 Jun 2025 16:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178968; cv=none; b=D+JF56xSBJUFDyxUoDO8h67jfxQB0bDXcJQJMpJd/RbWiZa6qAl834OAZOQif3Ky9IWMYzm74NHoUQkn4wPaI/fuNyoaw+JdFRVolgspXpHZuWaH8qVNlFHlEsoG96FYp3MG7oSgtJOy38kZAIMEiKBMAKad5ipX3Q6M9KuMeL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178968; c=relaxed/simple;
	bh=2nr0en8xmKREnHgHwUpByKufI1mqs5WjJLdBYrgBCqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nq9D5wkaxJg34J69oNaDWDTzp7M/YK7aksTXa5HfPYe9UfNZdttETl8jYndcJ/VPDGvNB3jbaQoL7SGa/W0y/xG0/mAEtSBET67UuEjhOvmPjtDRD3FtWNukAaRqNdzDtuwJmL74Hh+FFy9ITATK76vcDjzjv5IXrANAOfNYOhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylr/7t5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylr/7t5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC1CC4CEE3;
	Tue, 17 Jun 2025 16:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178968;
	bh=2nr0en8xmKREnHgHwUpByKufI1mqs5WjJLdBYrgBCqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylr/7t5eBJDOUCl2BT0G/mV5Lcp1dVNb/mIR/yNVrgedCt8fZj+NsJjjpC7vhwgUk
	 obewScU0fVIkxXbOLTDWmrKgPWQUHJ94WXZ5lAmxgMHvyKDQKF14BLaddbixLm6W6j
	 wD63B9DQLceHGqGkgF7gjMY5bPOXQBGxEGlPbxP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 578/780] net: stmmac: make sure that ptp_rate is not 0 before configuring EST
Date: Tue, 17 Jun 2025 17:24:46 +0200
Message-ID: <20250617152515.022753190@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré <alexis.lothore@bootlin.com>

[ Upstream commit cbefe2ffa7784525ec5d008ba87c7add19ec631a ]

If the ptp_rate recorded earlier in the driver happens to be 0, this
bogus value will propagate up to EST configuration, where it will
trigger a division by 0.

Prevent this division by 0 by adding the corresponding check and error
code.

Suggested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Fixes: 8572aec3d0dc ("net: stmmac: Add basic EST support for XGMAC")
Link: https://patch.msgid.link/20250529-stmmac_tstamp_div-v4-2-d73340a794d5@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_est.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c
index c9693f77e1f61..ac6f2e3a3fcd2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c
@@ -32,6 +32,11 @@ static int est_configure(struct stmmac_priv *priv, struct stmmac_est *cfg,
 	int i, ret = 0;
 	u32 ctrl;
 
+	if (!ptp_rate) {
+		netdev_warn(priv->dev, "Invalid PTP rate");
+		return -EINVAL;
+	}
+
 	ret |= est_write(est_addr, EST_BTR_LOW, cfg->btr[0], false);
 	ret |= est_write(est_addr, EST_BTR_HIGH, cfg->btr[1], false);
 	ret |= est_write(est_addr, EST_TER, cfg->ter, false);
-- 
2.39.5



