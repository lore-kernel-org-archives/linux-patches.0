Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C26421A16
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301150; cv=none; b=RPxyhIPOjDf8FZv1qsKvCJmUHs/atfkDFpG1dSlLHMNtpVFaf2ZxlF/r9CAcAQaAd0uGeX8/7r0R/ZF7lh0b556uxsm9XHw4MLTOFTO69JR/5OfmLJ2D/oP8o/5ZnBU1oQy+Nut0kR0prhpsgNyVw5WSJ5NBGNRwJaXXTZ4aoqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301150; c=relaxed/simple;
	bh=zewmezckcapVIGLR/SEXo0DCkA/JWHsz4NUGR/Ja8jA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeGs6LrgWlmAhwU5zQ6CO8yxN3kIzAv61/x+7XVQtSOZt+MYttTSzKzdtt45/m3eXpOY8Qptpszuvg6gknp8ZW88PKJmST58IHCLGNf2i2SMjZpCSSG4BzUU7TLhaBhvKlRRiBgwtIC5Lwy8vLoUXhIH2Qv5uYIxHCtZ/R5R4NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zf90UZ7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zf90UZ7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AD5C2BC87;
	Sat, 28 Feb 2026 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301149;
	bh=zewmezckcapVIGLR/SEXo0DCkA/JWHsz4NUGR/Ja8jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zf90UZ7Qsw2aW3EKxswYcWpQm92dv5EtTXVO0s5I6ZI7XjyFmio0k2Gx7G1Ecm+sU
	 7ia9w+WqBMp9Q+uq2DhGi34VLa0T2xa0vNXe+8MZAx/DIMUik2k5y1s5pY3m9+WI+8
	 HHwac77MZmV/DiELAWvmD0g5OTwqqik00W5psmTGlrQWcg19DGmqONUntcDmG6Gkkt
	 2K7JCrBJzW6NmghJ9LUXtw6o9SutqbUGgxSost/amiLggbAZvX21B/iEHAKKG1Iig9
	 JNzCl+Nh/uE1QKGB3PAuE5Oh92QG5BEpaEseOtU7UuDVLG/igkdkU/CFh0OZajf6u3
	 VS/4SQe49Bp1Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jacky Bai <ping.bai@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 312/752] mailbox: imx: Skip the suspend flag for i.MX7ULP
Date: Sat, 28 Feb 2026 12:40:23 -0500
Message-ID: <20260228174750.1542406-312-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jacky Bai <ping.bai@nxp.com>

[ Upstream commit 673b570825ace0dcb2ac0c676080559d505c6f40 ]

In current imx-mailbox driver, the MU IRQ is configured with
'IRQF_NO_SUSPEND' flag set. So during linux suspend/resume flow,
the MU IRQ is always enabled. With commit 892cb524ae8a ("mailbox: imx:
fix wakeup failure from freeze mode"), if the MU IRQ is triggered after
the priv->suspended flag has been set, the system suspend will be
aborted.

On i.MX7ULP platform, certain drivers that depend on rpmsg may need
to send rpmsg request and receive an acknowledgment from the remote
core during the late_suspend stage. Early suspend abort is not
expected, and the i.MX7ULP already has additional hardware and
software to make sure the system can be wakeup from freeze mode
correctly when MU IRQ is trigger.

Skip the 'suspend' flag handling logic on i.MX7ULP to avoid the
early abort when doing suspend.

Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/imx-mailbox.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index 6778afc64a048..003f9236c35e0 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -122,6 +122,7 @@ struct imx_mu_dcfg {
 	u32	xRR;		/* Receive Register0 */
 	u32	xSR[IMX_MU_xSR_MAX];	/* Status Registers */
 	u32	xCR[IMX_MU_xCR_MAX];	/* Control Registers */
+	bool	skip_suspend_flag;
 };
 
 #define IMX_MU_xSR_GIPn(type, x) (type & IMX_MU_V2 ? BIT(x) : BIT(28 + (3 - (x))))
@@ -988,6 +989,7 @@ static const struct imx_mu_dcfg imx_mu_cfg_imx7ulp = {
 	.xRR	= 0x40,
 	.xSR	= {0x60, 0x60, 0x60, 0x60},
 	.xCR	= {0x64, 0x64, 0x64, 0x64, 0x64},
+	.skip_suspend_flag = true,
 };
 
 static const struct imx_mu_dcfg imx_mu_cfg_imx8ulp = {
@@ -1071,7 +1073,8 @@ static int __maybe_unused imx_mu_suspend_noirq(struct device *dev)
 			priv->xcr[i] = imx_mu_read(priv, priv->dcfg->xCR[i]);
 	}
 
-	priv->suspend = true;
+	if (!priv->dcfg->skip_suspend_flag)
+		priv->suspend = true;
 
 	return 0;
 }
@@ -1094,7 +1097,8 @@ static int __maybe_unused imx_mu_resume_noirq(struct device *dev)
 			imx_mu_write(priv, priv->xcr[i], priv->dcfg->xCR[i]);
 	}
 
-	priv->suspend = false;
+	if (!priv->dcfg->skip_suspend_flag)
+		priv->suspend = false;
 
 	return 0;
 }
-- 
2.51.0

