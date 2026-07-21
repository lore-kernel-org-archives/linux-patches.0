Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD213B52FF;
	Tue, 21 Jul 2026 20:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666066; cv=none; b=S9gB9jubntRqyIzynRmuV9CTcEakjfqbx6XuDdWxkLV7yNtIOzh/JThDryBKDrbdx1XZ/FokX8H+djHYkEWDztHqlkv7a2GHfP7lqtvmhMvvob0L22183o/9okwE5wb9cs1I+EsyeV5vMCdVFWhaN9ZKAK478lG5E1DOWYpjrBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666066; c=relaxed/simple;
	bh=fAyE4x1kU4HZAtoSd+nMWeaJddS2YS+t3RvNQ0STvK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDqs/Sm0EKjy7EHYaHDmGwhavNak52fSwb5nEzPwL+gcCCLcF2yaOSl1hY6iu9wENoTGXG1/P8GYFOUC0bRgLM/Kuev+yRjOPdH58esIg3t/EX7wui9hilUl1ldb5hk/96joZLuGJLSYlaboLF5Xky3a8klKeSR30GKTDuyAsM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUUPkH2Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUUPkH2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2301F00A3A;
	Tue, 21 Jul 2026 20:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666063;
	bh=c2Wj6yQlamm9D/Fm9PDxOpZxrUo18qc565fjsoBIw80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUUPkH2YXooovdj8VQLGrPLL7OnZRxEl9P97xGPmDGvkvT1yy0pdhOoKqDLFDYmIk
	 KA5TsLi64Zq94Eb2+Yb6QjQru8x9s7cR8IyTJMK9waGysg1a4kpBPIspY5ojrxohQt
	 2/XwoZg7LDBRipDNPxzL0YXsEC8JQ/0kpnyMjK+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0540/1266] ASoC: cs35l56: Dont leave parent IRQ disabled if system_suspend fails
Date: Tue, 21 Jul 2026 17:16:17 +0200
Message-ID: <20260721152453.951081867@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 15637b60ac2ea1..832ff2cd3d24e9 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1055,6 +1055,7 @@ static int __maybe_unused cs35l56_runtime_resume_i2c_spi(struct device *dev)
 int cs35l56_system_suspend(struct device *dev)
 {
 	struct cs35l56_private *cs35l56 = dev_get_drvdata(dev);
+	int ret;
 
 	dev_dbg(dev, "system_suspend\n");
 
@@ -1070,7 +1071,11 @@ int cs35l56_system_suspend(struct device *dev)
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



