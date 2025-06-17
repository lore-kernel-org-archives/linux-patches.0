Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CC92EE272;
	Tue, 17 Jun 2025 16:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177559; cv=none; b=pSAtBmrclsDkDMR2gESVVKtv8oFtb5RWlkJ4SBZEVKQSyds9Q3Tt2sFlQBrLYp5eZKspT+G+MipQhfWXwH/63KbPG1MdBLry5mhCBKdrLoZCMkx0ncQb6Sfz12e0Ff/EXl3KCXPsk4lhJEbpLLQZCF6bC0PZG5XwYRgR1N5nsO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177559; c=relaxed/simple;
	bh=Jp/e+2YAKCXzOmcUfoE4inZvHGUS7RONRzl833Q+VC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LPlr8RNbdAI15oAN3GdHF2SGgZ6mGI9o0ZluybmJZIlDfvrg75gH7i63I+c38cGWACI26c7ncFcJkv3zyVT8emTbxQvLgD3o6cQmc0jTNrZi6MAmTLuffFKFVUiYIVzGm8jAvhNq2vzPqR/jx8peDlbb4iuXI58QBzCbrvvsCoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mF6NDkw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mF6NDkw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E7BC4CEE7;
	Tue, 17 Jun 2025 16:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177559;
	bh=Jp/e+2YAKCXzOmcUfoE4inZvHGUS7RONRzl833Q+VC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mF6NDkw07E7ensCYhe3uNsw0s9hHuLqq77LLNwCIEICIXAWxXAdxNJR/Qu+6nKjJ+
	 d7YWabQ+r9ITEffBZ1rwUWDJ2UtQXKDsC0u3ex7sM9N8uy6n2mrX7JeHvN2Z26jVlo
	 h8SOLBzE+rfax2HdTdp+XrouTHlMsCkjYH+7wahs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 363/512] net: stmmac: make sure that ptp_rate is not 0 before configuring EST
Date: Tue, 17 Jun 2025 17:25:29 +0200
Message-ID: <20250617152434.285750962@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



