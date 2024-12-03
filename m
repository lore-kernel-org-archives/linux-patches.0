Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E538D1F130F;
	Tue,  3 Dec 2024 15:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239522; cv=none; b=B8485CGs5BocRohGgeOsQHha2EDLZW0w4xZfgTLjWSJIYNaaLsE/TMlxcqtdcShknWGoQMxjLuHhZCXSDb08xtL8hD/2UWokSF6xpQ0CJvxZnsKt97hRgFF4SINiRvI1yaEQ5/SrL2xElx5882N89Of6LQt4M7U7b1+lVJJMbgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239522; c=relaxed/simple;
	bh=DqB0I+mD0HD01jyxxS8+1P0tQIHPEst5eUJ6TO9xrbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UyiYapvD4BfhEROWFcE3wr+xrI5J2M6e0dM3M0BDmgDMsDo17ZeBamb7PXaXskw5X7icGEUOlnYerpFDpyqH6aaO0FNa9EXgxye88wIDjzSqH3Lp6MRRcaYb/8B1dZtSJ/Iasr4kDo9lv2xlSVBd9jZkHISni7rG3QwczamER2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4KOapik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4KOapik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1A6C4CECF;
	Tue,  3 Dec 2024 15:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239521;
	bh=DqB0I+mD0HD01jyxxS8+1P0tQIHPEst5eUJ6TO9xrbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4KOapikuWVhdQokvA0GCF5zQKbYqjlNnp32cPn9V7rjYfC28fJ5D3fcJrGADB/+t
	 jICcRN0uM6OUu+5uV4FMl1gKfLFUWn5M4Y1nEwyazeEyYkkGzMHsgHnLMKaY4xoa2c
	 bXhkbN94Gc1nj22LtgCc5bHY2QyHqxWFntlua0fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 641/817] ASoC: codecs: Fix atomicity violation in snd_soc_component_get_drvdata()
Date: Tue,  3 Dec 2024 15:43:33 +0100
Message-ID: <20241203144020.970866560@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiu-ji Chen <chenqiuji666@gmail.com>

commit 1157733344651ca505e259d6554591ff156922fa upstream.

An atomicity violation occurs when the validity of the variables
da7219->clk_src and da7219->mclk_rate is being assessed. Since the entire
assessment is not protected by a lock, the da7219 variable might still be
in flux during the assessment, rendering this check invalid.

To fix this issue, we recommend adding a lock before the block
if ((da7219->clk_src == clk_id) && (da7219->mclk_rate == freq)) so that
the legitimacy check for da7219->clk_src and da7219->mclk_rate is
protected by the lock, ensuring the validity of the check.

This possible bug is found by an experimental static analysis tool
developed by our team. This tool analyzes the locking APIs
to extract function pairs that can be concurrently executed, and then
analyzes the instructions in the paired functions to identify possible
concurrency bugs including data races and atomicity violations.

Fixes: 6d817c0e9fd7 ("ASoC: codecs: Add da7219 codec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Link: https://patch.msgid.link/20240930101216.23723-1-chenqiuji666@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/da7219.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/da7219.c
+++ b/sound/soc/codecs/da7219.c
@@ -1167,17 +1167,20 @@ static int da7219_set_dai_sysclk(struct
 	struct da7219_priv *da7219 = snd_soc_component_get_drvdata(component);
 	int ret = 0;
 
-	if ((da7219->clk_src == clk_id) && (da7219->mclk_rate == freq))
+	mutex_lock(&da7219->pll_lock);
+
+	if ((da7219->clk_src == clk_id) && (da7219->mclk_rate == freq)) {
+		mutex_unlock(&da7219->pll_lock);
 		return 0;
+	}
 
 	if ((freq < 2000000) || (freq > 54000000)) {
+		mutex_unlock(&da7219->pll_lock);
 		dev_err(codec_dai->dev, "Unsupported MCLK value %d\n",
 			freq);
 		return -EINVAL;
 	}
 
-	mutex_lock(&da7219->pll_lock);
-
 	switch (clk_id) {
 	case DA7219_CLKSRC_MCLK_SQR:
 		snd_soc_component_update_bits(component, DA7219_PLL_CTRL,


