Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522D0313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301060; cv=none; b=DHUZMdvQIvLH2HNlQmPW/64HYKZVCNLvYmeFiwWBf3jFgJNZobygqrdMa/fa0lavPtnI58TjFZoTgkw+G/BR0TluP9BHDzAaHF/4+8PxxWP6V9lKzjIbW36wcZ6gzkRWULtROaxyBnbKZArptDuXLJLmhduvA02vvyQhlsXsW+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301060; c=relaxed/simple;
	bh=qqlcOoyg563JE1Wpv7r2VRKEEVmqBZ8zj2d/aHPFEQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E93IVCwoMPFl/JZzLaNXrEz3x+E9Fkg3ClWl37Qm8JdZPqBddY8O1fH1iHJQkFh1YyP6os2BxX+ouEHZhYOwWC3+dm5l/myd2eSg8UlZR01Zr/jkSNhWxOtwKQzM3JRbhF9CpIJrEnio4OPKR6k9eNELdAcWEWY4UIuXqLCx1I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ab7FBkzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ab7FBkzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB296C116D0;
	Sat, 28 Feb 2026 17:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301060;
	bh=qqlcOoyg563JE1Wpv7r2VRKEEVmqBZ8zj2d/aHPFEQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ab7FBkzUbMGwhd4U4PXywVuFrGyw6B6Uo1dU+e5lDzBUv776cegBevjO5AxxBiCfM
	 vUcwOW/1xrsVd+BSW+XFrMCQRvywf0PX1zgjs5jgK7ndGw4we0gZl/Cc6ub42OV5rb
	 elEbOwf4ixu6jXUXPysIu6JnIfuuGtj/k7qYCeNF5meJR1vOQydmJ8Ano7Y4JJiJTz
	 EZEOpvJCcP/55u7JQB/UrCjexJi0I1jTUUhQHZIuCrqFIo7R/W2umxena20Zx5xKwk
	 d5T06uEv3H3meT4qqdUxbAkGePGZsaxHE9t7DRYlBm0QjnH7bnOBo88amaPkMoHRdA
	 LrmVSH0eFA6kA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hsieh Hung-En <hungen3108@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 202/752] ASoC: es8328: Add error unwind in resume
Date: Sat, 28 Feb 2026 12:38:33 -0500
Message-ID: <20260228174750.1542406-202-sashal@kernel.org>
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

From: Hsieh Hung-En <hungen3108@gmail.com>

[ Upstream commit 8232e6079ae6f8d3a61d87973cb427385aa469b9 ]

Handle failures in the resume path by unwinding previously enabled
resources.

If enabling regulators or syncing the regcache fails, disable regulators
and unprepare the clock to avoid leaking resources and leaving the device
in a partially resumed state.

Signed-off-by: Hsieh Hung-En <hungen3108@gmail.com>
Link: https://patch.msgid.link/20260130160017.2630-6-hungen3108@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8328.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/es8328.c b/sound/soc/codecs/es8328.c
index 76159c45e6b52..c0d7ce64b2d96 100644
--- a/sound/soc/codecs/es8328.c
+++ b/sound/soc/codecs/es8328.c
@@ -756,17 +756,23 @@ static int es8328_resume(struct snd_soc_component *component)
 					es8328->supplies);
 	if (ret) {
 		dev_err(component->dev, "unable to enable regulators\n");
-		return ret;
+		goto err_clk;
 	}
 
 	regcache_mark_dirty(regmap);
 	ret = regcache_sync(regmap);
 	if (ret) {
 		dev_err(component->dev, "unable to sync regcache\n");
-		return ret;
+		goto err_regulators;
 	}
 
 	return 0;
+
+err_regulators:
+	regulator_bulk_disable(ARRAY_SIZE(es8328->supplies), es8328->supplies);
+err_clk:
+	clk_disable_unprepare(es8328->clk);
+	return ret;
 }
 
 static int es8328_component_probe(struct snd_soc_component *component)
-- 
2.51.0

