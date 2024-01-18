Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27C42375B;
	Thu, 18 Jan 2024 10:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575343; cv=none; b=jrhCgs3u/nXWSoUbpKBieLTH+DbrB0LXDkehpAF8Yxj2qDrKws+Ufx8vKYTvrtjJzxCd3c6O/ckaj9JHDauxs5A/N6Op/JHAalXjQRbbQDuYpA+ykiQxss1O5quv7XnBdcIDOgfD+zEdH5emt4tHrmEER5kh9bvDk5BSQ5t5DLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575343; c=relaxed/simple;
	bh=YVvW+pOsdM89NzE9f8SGSUBitCwcwunRQwHwwwszK/I=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=F0/qlmHhAzW89JXh0lZC/xl1OUomRqvq4YN8/iESQHUHPMPSAJUeaepndFBgfd5H+2ytc1C5o7iV2AZ96ke5TTwIHvTbWfYyM0ifN0t2wIbobtb5FsYLNb+oCot+iG1RE53AqdMBOarBI0rNjAfC6Op/zF9aBmUa0ED8ogc1ZXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0XniUUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0XniUUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35CEC433C7;
	Thu, 18 Jan 2024 10:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575343;
	bh=YVvW+pOsdM89NzE9f8SGSUBitCwcwunRQwHwwwszK/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0XniUUMQ/yuF/LMltM+N1yDaqgx/46l+ySaryTqW7yuhNE8tET/5X/SuvgPf62/D
	 xn5uYC09qoJUxCyfbeXSrNfRXnS5qV3dDPxpsceKFeD9rM1rtehahy9pL5XdNn8CKL
	 Pixq9YZOR8lC2S5mu3qdY3hceq10NQLmzEZvABdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/150] ASoC: cs35l45: Prevent IRQ handling when suspending/resuming
Date: Thu, 18 Jan 2024 11:48:33 +0100
Message-ID: <20240118104324.163825480@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>

[ Upstream commit c3c8b088949b9ccb88da2f84d3c3cc06580a6a43 ]

Use the SYSTEM_SLEEP_PM_OPS handlers to prevent handling an IRQ
when the system is in the middle of suspending or resuming.

Signed-off-by: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20231206160318.1255034-3-rriveram@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l45.c | 43 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/sound/soc/codecs/cs35l45.c b/sound/soc/codecs/cs35l45.c
index b1d0f2c8f2ca..310747b7689d 100644
--- a/sound/soc/codecs/cs35l45.c
+++ b/sound/soc/codecs/cs35l45.c
@@ -854,6 +854,46 @@ static int cs35l45_runtime_resume(struct device *dev)
 	return ret;
 }
 
+static int cs35l45_sys_suspend(struct device *dev)
+{
+	struct cs35l45_private *cs35l45 = dev_get_drvdata(dev);
+
+	dev_dbg(cs35l45->dev, "System suspend, disabling IRQ\n");
+	disable_irq(cs35l45->irq);
+
+	return 0;
+}
+
+static int cs35l45_sys_suspend_noirq(struct device *dev)
+{
+	struct cs35l45_private *cs35l45 = dev_get_drvdata(dev);
+
+	dev_dbg(cs35l45->dev, "Late system suspend, reenabling IRQ\n");
+	enable_irq(cs35l45->irq);
+
+	return 0;
+}
+
+static int cs35l45_sys_resume_noirq(struct device *dev)
+{
+	struct cs35l45_private *cs35l45 = dev_get_drvdata(dev);
+
+	dev_dbg(cs35l45->dev, "Early system resume, disabling IRQ\n");
+	disable_irq(cs35l45->irq);
+
+	return 0;
+}
+
+static int cs35l45_sys_resume(struct device *dev)
+{
+	struct cs35l45_private *cs35l45 = dev_get_drvdata(dev);
+
+	dev_dbg(cs35l45->dev, "System resume, reenabling IRQ\n");
+	enable_irq(cs35l45->irq);
+
+	return 0;
+}
+
 static int cs35l45_apply_property_config(struct cs35l45_private *cs35l45)
 {
 	struct device_node *node = cs35l45->dev->of_node;
@@ -1291,6 +1331,9 @@ EXPORT_SYMBOL_NS_GPL(cs35l45_remove, SND_SOC_CS35L45);
 
 EXPORT_GPL_DEV_PM_OPS(cs35l45_pm_ops) = {
 	RUNTIME_PM_OPS(cs35l45_runtime_suspend, cs35l45_runtime_resume, NULL)
+
+	SYSTEM_SLEEP_PM_OPS(cs35l45_sys_suspend, cs35l45_sys_resume)
+	NOIRQ_SYSTEM_SLEEP_PM_OPS(cs35l45_sys_suspend_noirq, cs35l45_sys_resume_noirq)
 };
 
 MODULE_DESCRIPTION("ASoC CS35L45 driver");
-- 
2.43.0



