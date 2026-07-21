Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB86449B2A;
	Tue, 21 Jul 2026 17:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656588; cv=none; b=bps17hjxeqREp8+Wfv373eu61EQ4ST6Rzy39qVJqtGdvs7y+g4PxNO+5RDi+WOwCYhA7k/5cpVxTW+lS3aJY+Y1NlMvIfXCsM6YrylyNw/antAUtQEbHVkxSbjvsFTHLl+DW9VYc5j/OAChFCewc531sfy2kqx/yGk+q5C7wZBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656588; c=relaxed/simple;
	bh=uI0izHzNe398gEAuRQH4Ix6Q/tw375Hp4SfZUqKs2Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m42KGr7gjmVbzWT75cSlx8K0C69rv1ERRmQAXpGPy3ezs7ntVwdQ71O3ICoWJVBVdMTZW7l1b70GlUmjMTT/SKZC+60UUATZ2W8CSrsEkcjrdleV/sdkqphiZRxakEqLfPl19Lpm1yD0emiB0YPsSRDTQO/d14B+RvDA6OmW7L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFpcVD2l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFpcVD2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4015D1F000E9;
	Tue, 21 Jul 2026 17:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656587;
	bh=X6VCfjhVY2OM3kx816hrPnyqbBBjWzmVlkcr0GU7X+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFpcVD2llVsDroQoIOT/yrRx5XK03qpy0ldbjNkv2MBOEtKdFbW9CDFqA9aPWUuj8
	 KJHtoxkIR3ai18+atAfuCn1v7JX9BgnJnqdqA44G0hT7tOtXpFtUMORbmwEvckgIk4
	 jGC/rUCVRFPJnuw+FZ4VK3NlgHZxtSwyh9GlPxZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0444/1611] ASoC: cs35l56: Dont leave parent IRQ disabled if system_suspend fails
Date: Tue, 21 Jul 2026 17:09:20 +0200
Message-ID: <20260721152525.280195498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index f6d61bdfd24efc..7b57ef2336ea8d 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1057,6 +1057,7 @@ static int __maybe_unused cs35l56_runtime_resume_i2c_spi(struct device *dev)
 int cs35l56_system_suspend(struct device *dev)
 {
 	struct cs35l56_private *cs35l56 = dev_get_drvdata(dev);
+	int ret;
 
 	dev_dbg(dev, "system_suspend\n");
 
@@ -1072,7 +1073,11 @@ int cs35l56_system_suspend(struct device *dev)
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



