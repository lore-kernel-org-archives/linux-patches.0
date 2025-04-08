Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D13226659C;
	Tue,  8 Apr 2025 11:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110461; cv=none; b=NLY8l3q6IRZu5jr9Mu1tw9jMjRxJbnaj7aFcts8QrcjkKzBY3hS/vmbAjR9OcEEfdqoCZV5G5bHVRfL+U8hOdwzbQPY9lk/8VIzbdXutX2/9AhDKGbiqENudAYFP90kscZ7h+gQP9QgEpf0A5S8RbOwJ6Oj9a2YdEpYxYy/0cC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110461; c=relaxed/simple;
	bh=rOdsnMbySLwmb3hFJYryc2A8/fndQWzQi3g8R8AeJfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTKOh/d7ltUsyftDoXDleW/iIUHfYmRozjd1MKTr7HYDo+S1M0KySjL1nN7/wyRdKYB6R47nVqpcRrTMmBDJm50iWVIVO6e1LhhUIVb4aOB9WQarTRjdQlfYgh2BzcA84/TLXl9skzS/bvf8+h1Axdn0ZTAUs6nWWVS+PV85e14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDd74jei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDd74jei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE30C4CEE5;
	Tue,  8 Apr 2025 11:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110461;
	bh=rOdsnMbySLwmb3hFJYryc2A8/fndQWzQi3g8R8AeJfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDd74jeicRSrJT7Kb4lAMCHED/hD+HCEBaP6w4zZ1EbLngGABr0tWGnaEQ4MNQYk2
	 jnA7MJeFLgu5U7GV+bPUASyY5NHcPlY8sIZMeyfReRBMAaBrXhGy6i3Gk+NInUgtM7
	 6BouOvPMf01ZnC66YpLE/Vb8e6ACcRrMc+sbUwIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ritu Chaudhary <rituc@nvidia.com>,
	Sheetal <sheetal@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 071/731] ASoC: tegra: Use non-atomic timeout for ADX status register
Date: Tue,  8 Apr 2025 12:39:28 +0200
Message-ID: <20250408104915.923505061@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritu Chaudhary <rituc@nvidia.com>

[ Upstream commit f1d742c35b659fb0122da0a8ff09ad9309cb29d8 ]

ADX startup() callback uses atomic poll timeout on ADX status register.

This is unnecessary because:

- The startup() callback itself is non-atomic.
- The subsequent timeout call in the same function already uses a
  non-atomic version.

Using atomic version can hog CPU when it is not really needed,
so replace it with non-atomic version.

Fixes: a99ab6f395a9e ("ASoC: tegra: Add Tegra210 based ADX driver")
Signed-off-by: Ritu Chaudhary <rituc@nvidia.com>
Signed-off-by: Sheetal <sheetal@nvidia.com>
Link: https://patch.msgid.link/20250311062010.33412-1-sheetal@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra210_adx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/tegra/tegra210_adx.c b/sound/soc/tegra/tegra210_adx.c
index 0aa93b948378f..3c10e09976ad0 100644
--- a/sound/soc/tegra/tegra210_adx.c
+++ b/sound/soc/tegra/tegra210_adx.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-// SPDX-FileCopyrightText: Copyright (c) 2021-2024 NVIDIA CORPORATION & AFFILIATES.
+// SPDX-FileCopyrightText: Copyright (c) 2021-2025 NVIDIA CORPORATION & AFFILIATES.
 // All rights reserved.
 //
 // tegra210_adx.c - Tegra210 ADX driver
@@ -57,8 +57,8 @@ static int tegra210_adx_startup(struct snd_pcm_substream *substream,
 	int err;
 
 	/* Ensure if ADX status is disabled */
-	err = regmap_read_poll_timeout_atomic(adx->regmap, TEGRA210_ADX_STATUS,
-					      val, !(val & 0x1), 10, 10000);
+	err = regmap_read_poll_timeout(adx->regmap, TEGRA210_ADX_STATUS,
+				       val, !(val & 0x1), 10, 10000);
 	if (err < 0) {
 		dev_err(dai->dev, "failed to stop ADX, err = %d\n", err);
 		return err;
-- 
2.39.5



