Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C623E2DC76A;
	Tue, 21 Jul 2026 16:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649655; cv=none; b=HxstvtomBmJzR0yOJoZG2zlw0LtpifszUc4nHNWe18ltpmy002xP1N5l/d0tVeSbfbu8JL4snJ4rNvgpG/rTe4Bfcte0k30qWrVri7AdAGXerbrAtoujDSDeVkWgYUxsZuNtL1p5cUTfJvRR8IFh1P6nVUwAQ/nV3LXLwf9Brq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649655; c=relaxed/simple;
	bh=TDPfZzvmIjN9np3MRdhw7nm2uXs7TpUEHNruDaGBlrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVJcFiMBoqb7/w8AKK9PGqUp6pNVJWv1c5JUVbHf3liOUSAcVzRvhQ7V9u4cNshQMbR3YY4pOBvhbiAsf0a8xo2DkWtyTShhdTYYGPSSWBZp/t2Svu7JQ5F4clcJQMfp4QFErcJEDvM59ycHiB3UmSBOgOSM0f3ikCzU7SjhGnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYaZZzYd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYaZZzYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3882E1F000E9;
	Tue, 21 Jul 2026 16:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649654;
	bh=7tYwivEVG/yYITUu7QqzRzjGZtQSwXZYDINSN/WTRdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yYaZZzYdACof6n+8zF5wQQvQbYlMNVUUBQz5SPHQtukMLy3lTP49nz4doScPfCfDV
	 moMNOgGoc22yvHCIsNflsYzREN8qpN/co5Wtol6IGElvsuUU52oFLYpWyZkxk9nAiF
	 UUaZiAeCR71U+4JYKGrB76dO5XSYJb+av8T+pJKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0642/2077] ASoC: cs35l56: Dont leave parent IRQ disabled if system_suspend fails
Date: Tue, 21 Jul 2026 17:05:15 +0200
Message-ID: <20260721152607.949332064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 53cebeb017164254cde5e31c94d8deef9e4fff97 ]

In cs35l56_system_suspend() re-enable the parent IRQ if the call to
pm_runtime_force_suspend() returns an error.

Fixes: f9dc6b875ec0 ("ASoC: cs35l56: Add basic system suspend handling")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260610105556.612830-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index 3641ac1378c7c2..033028a4734b50 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1491,6 +1491,7 @@ static int __maybe_unused cs35l56_runtime_resume_i2c_spi(struct device *dev)
 int cs35l56_system_suspend(struct device *dev)
 {
 	struct cs35l56_private *cs35l56 = dev_get_drvdata(dev);
+	int ret;
 
 	dev_dbg(dev, "system_suspend\n");
 
@@ -1506,7 +1507,11 @@ int cs35l56_system_suspend(struct device *dev)
 	if (cs35l56->base.irq)
 		disable_irq(cs35l56->base.irq);
 
-	return pm_runtime_force_suspend(dev);
+	ret = pm_runtime_force_suspend(dev);
+	if ((ret < 0) && cs35l56->base.irq)
+		enable_irq(cs35l56->base.irq);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(cs35l56_system_suspend);
 
-- 
2.53.0



