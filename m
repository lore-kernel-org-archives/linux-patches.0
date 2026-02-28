Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BF0421A16
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301167; cv=none; b=UbtS0nhmGg7n2DTpMvLV2z7nuA1G0qnAK3DJIZBZmfDGmhQfE2Tnv5oa3sZ7CmBamqKxF3+Jf2+xMpvUFDT9SyN/IKgTH9FmzlylOv/KvQkKJ9La1Oakoiwk4VZ/9LgHESI90lGAcLFJKz1h9JuvQvhFHbvVrwvrVWI2uRNqKz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301167; c=relaxed/simple;
	bh=kk2/UZdY4A+i9yZHtFFnvjm4Eqf8Gk9+iUrxy+RCzw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGMT+o88wa1P983oJUz3ehDe/DLc7pYOaYARoeFkqgVandpyi39FrMJtMsO4FyeOJmZPvsGJETaWjrwWcvF9jmHVH9mx3tEN+DYLat3Rk0fGgNGwK0kNWtHmTRyIMSeA7vXHM6hRfA1w0SCcFMPHHcDA3Ku7r+Qoij7+c/jaeZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvgUPbrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvgUPbrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED239C19424;
	Sat, 28 Feb 2026 17:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301167;
	bh=kk2/UZdY4A+i9yZHtFFnvjm4Eqf8Gk9+iUrxy+RCzw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvgUPbrEsTRRLBr0W1U4jSpLMpwFmoneB2202YCQ/Nop2QQ3mHAiEm29T143Qhxdp
	 AjEChHxeHMYA0W0HsRiaVoXJnn6Heluz2PsnM+LvarugnYzP4cG9u0ER+AJ3BRCpAH
	 dTqnjKoL/rdWpEvBpdVtOf/h8x9O3issIxpzH72R150ZFS+4yxUYh1qmAUODKDcUn1
	 3wjgfaGd/qm6tM4Q0tsif4ZLz+TPaQ692b+gnquQt6NHuzJRl/wl1bMevMETRcGuGk
	 3yPuWu2b176V3ndOebtQPWizQS8OOfJcDBf22oQHZOVW4Pbo2mhUf+Na5U+xUFXGKk
	 DCfwWy/x65q7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Thomas Richard (TI.com)" <thomas.richard@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 333/752] phy: ti: phy-j721e-wiz: restore mux selection during resume
Date: Sat, 28 Feb 2026 12:40:44 -0500
Message-ID: <20260228174750.1542406-333-sashal@kernel.org>
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

From: "Thomas Richard (TI.com)" <thomas.richard@bootlin.com>

[ Upstream commit 53f6240e88c9e8715e09fc19942f13450db4cb33 ]

While suspend and resume mux selection was getting lost. So save and
restore these values in suspend and resume operations.

Signed-off-by: Thomas Richard (TI.com) <thomas.richard@bootlin.com>
Link: https://patch.msgid.link/20251216-phy-ti-phy-j721e-wiz-resume-restore-mux-sel-v1-1-771d564db966@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-j721e-wiz.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/ti/phy-j721e-wiz.c b/drivers/phy/ti/phy-j721e-wiz.c
index a8b440c6c46bb..ba31b0a1f7f79 100644
--- a/drivers/phy/ti/phy-j721e-wiz.c
+++ b/drivers/phy/ti/phy-j721e-wiz.c
@@ -393,6 +393,7 @@ struct wiz {
 	struct clk		*output_clks[WIZ_MAX_OUTPUT_CLOCKS];
 	struct clk_onecell_data	clk_data;
 	const struct wiz_data	*data;
+	int			mux_sel_status[WIZ_MUX_NUM_CLOCKS];
 };
 
 static int wiz_reset(struct wiz *wiz)
@@ -1654,11 +1655,25 @@ static void wiz_remove(struct platform_device *pdev)
 	pm_runtime_disable(dev);
 }
 
+static int wiz_suspend_noirq(struct device *dev)
+{
+	struct wiz *wiz = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < WIZ_MUX_NUM_CLOCKS; i++)
+		regmap_field_read(wiz->mux_sel_field[i], &wiz->mux_sel_status[i]);
+
+	return 0;
+}
+
 static int wiz_resume_noirq(struct device *dev)
 {
 	struct device_node *node = dev->of_node;
 	struct wiz *wiz = dev_get_drvdata(dev);
-	int ret;
+	int ret, i;
+
+	for (i = 0; i < WIZ_MUX_NUM_CLOCKS; i++)
+		regmap_field_write(wiz->mux_sel_field[i], wiz->mux_sel_status[i]);
 
 	/* Enable supplemental Control override if available */
 	if (wiz->sup_legacy_clk_override)
@@ -1680,7 +1695,7 @@ static int wiz_resume_noirq(struct device *dev)
 	return ret;
 }
 
-static DEFINE_NOIRQ_DEV_PM_OPS(wiz_pm_ops, NULL, wiz_resume_noirq);
+static DEFINE_NOIRQ_DEV_PM_OPS(wiz_pm_ops, wiz_suspend_noirq, wiz_resume_noirq);
 
 static struct platform_driver wiz_driver = {
 	.probe		= wiz_probe,
-- 
2.51.0

