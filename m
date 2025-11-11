Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F484C97;
	Tue, 11 Nov 2025 00:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822195; cv=none; b=VdPAl5VeH/n0kzVseewdAosaHghDSSLWt31Ykr0+Q3yUaYZ4UvcPb287NyQMNsH7vloZL5+aOqlaU1hwylBHklNyCSUoQhx5ZU2Jy0uZtE9QxFy8hoaZ57YaQ9ytbOA3ReXQSuyBxxnrpQUDTDw7iZ8U+Uv8zqjkl3wJ0VaumEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822195; c=relaxed/simple;
	bh=uRXVkMb4hSPe5OTq5vL4HKZOTwlmzelOsHeqwfREnUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qahu1i6Gepo6VPonGlJikkc73BacYtqidyvMXZkH5DxA78gcLofQd9yYlbQlXN21dTCEcSvX7Vwm8Ic0zijl+uBsbz5V8ViWuBAcPMXnwrR/WZAy7Teknz8A90Dtx6gk5ua89E41DKwmQq0aZmUzUAsoc7xOLIL51ClZyDmWbJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQISJRaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQISJRaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14588C4CEF5;
	Tue, 11 Nov 2025 00:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822195;
	bh=uRXVkMb4hSPe5OTq5vL4HKZOTwlmzelOsHeqwfREnUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQISJRaOpA2vO8OiQsp71C38tfKIUennZ8MoZUchafXTJO9qvy4cVmlFHch+evIxT
	 M6ljUMtjUeK477l15+uZHR5V1ICVzDAVTxgV06Fjj2iaTBoFgW4SUow6idM14JBFc/
	 nn0WYjiGCnkGHfYpzyOZ4v194iSjeJ839yzf8N6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 055/849] ASoC: mediatek: Fix double pm_runtime_disable in remove functions
Date: Tue, 11 Nov 2025 09:33:45 +0900
Message-ID: <20251111004537.767528816@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 79a6f2da168543c0431ade57428f673c19c5b72f ]

Both mt8195-afe-pcm and mt8365-afe-pcm drivers use devm_pm_runtime_enable()
in probe function, which automatically calls pm_runtime_disable() on device
removal via devres mechanism. However, the remove callbacks explicitly call
pm_runtime_disable() again, resulting in double pm_runtime_disable() calls.

Fix by removing the redundant pm_runtime_disable() calls from remove
functions, letting the devres framework handle it automatically.

Fixes: 2ca0ec01d49c ("ASoC: mediatek: mt8195-afe-pcm: Simplify runtime PM during probe")
Fixes: e1991d102bc2 ("ASoC: mediatek: mt8365: Add the AFE driver support")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251020170440.585-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c | 1 -
 sound/soc/mediatek/mt8365/mt8365-afe-pcm.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
index 5d025ad72263f..c63b3444bc176 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -3176,7 +3176,6 @@ static int mt8195_afe_pcm_dev_probe(struct platform_device *pdev)
 
 static void mt8195_afe_pcm_dev_remove(struct platform_device *pdev)
 {
-	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		mt8195_afe_runtime_suspend(&pdev->dev);
 }
diff --git a/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c b/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c
index 10793bbe9275d..d48252cd96ac4 100644
--- a/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c
+++ b/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c
@@ -2238,7 +2238,6 @@ static void mt8365_afe_pcm_dev_remove(struct platform_device *pdev)
 
 	mt8365_afe_disable_top_cg(afe, MT8365_TOP_CG_AFE);
 
-	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		mt8365_afe_runtime_suspend(&pdev->dev);
 }
-- 
2.51.0



