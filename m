Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318F135C1A6;
	Tue, 21 Jul 2026 19:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662077; cv=none; b=h6j4JKI5U2PFftanLB1SwAqk1Iq8kFVHH+DZq/XAFIqSjketYDS6I+AeovQrrXOtHspWe6B2mp4TaZBD2Y7WA08AVzMOhPemXnQYVvNRypt57+9hTvcDieW81m8DoAXUVdzENrJEz0KiBJeeGfWKvjYIpPJQA47IVafxyaoV6tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662077; c=relaxed/simple;
	bh=DGpMxzdwoFE2tczlnQmObjTqyEv2xD4OBRMmopVHjM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPXjGigjORt/7fLo0M5hkHBGVNoNGVIaItVG9qCwcgafNbcC0hllZU5l6OzLpb8nxUsT0ZKBq6tXh7l4KuITuliEUtZsFnbRTaMgzlMqVhXNAyT+OWJ0c6UUnwGxBA69oOfh/PcEOMvfjP2D2c83rqlvFyhwopRc6b/pXPkuaX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qz3sg3AQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qz3sg3AQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C651F00A3A;
	Tue, 21 Jul 2026 19:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662074;
	bh=0uWdZWyT+337NfIQEzRSr8R/lLj3/CXQsEe0flN0Gy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qz3sg3AQSIy9AKInuGj1SykCeW4JMpy8FF1QiYoCUQQqOd6ItF1bg6sdvSHPMZIUB
	 EMnpNPW/s/ySu3Xp0JTYaKgB1nLI3rCfcMTic4u0HJyfVt6UIH88I2B7n15S2Ayefh
	 FaKD4tCjjCiQbVIYROsEfTSi2hyA0kya7rFB0ZI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0306/1276] ASoC: cs35l56: Dont leave parent IRQ disabled if system_suspend fails
Date: Tue, 21 Jul 2026 17:12:29 +0200
Message-ID: <20260721152452.941103395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d5d6d5b03d033f..c78f7f95f127d0 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -950,6 +950,7 @@ static int __maybe_unused cs35l56_runtime_resume_i2c_spi(struct device *dev)
 int cs35l56_system_suspend(struct device *dev)
 {
 	struct cs35l56_private *cs35l56 = dev_get_drvdata(dev);
+	int ret;
 
 	dev_dbg(dev, "system_suspend\n");
 
@@ -965,7 +966,11 @@ int cs35l56_system_suspend(struct device *dev)
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



