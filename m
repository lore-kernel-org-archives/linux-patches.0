Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971042144C4;
	Thu, 12 Dec 2024 16:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020051; cv=none; b=LHVcQ/24Bae32fMyerjCxj+E9KmrTJwVwue8I8E0Rm9NxeoTcy+fFOJrsMXx0Tjf4TGZso8n4xuyHBtGDBSeZXjAWYqBHzRnMD8j/C8hA4eM/ha+1ngITkbP27uofv3PJTuCGBSoZ8k8isBoP/bX//YinCfstlAfJtByP98FmkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020051; c=relaxed/simple;
	bh=vRE5uxM5+gHDK7dMS45teS1LoliVxDCzLacJhv+pldA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzS9zjVibToJnYoFBVk4UyFktkc8/dtBT5ucVnVPrt0x5S5TgoKivx73c/KxijYPTusf3h/bsiYfMSUSBOCDA09hyrXrFXBd0yKRRzHxhTWN01NQ6QOB2A5QLXiQZr44c4ypuAPao6mRiHFRULDEz5PCZHu2QLyCvuT63kCJjy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwFnZgJN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwFnZgJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FBCC4CECE;
	Thu, 12 Dec 2024 16:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020051;
	bh=vRE5uxM5+gHDK7dMS45teS1LoliVxDCzLacJhv+pldA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwFnZgJNOsD41AD7Sik/i5SsVCMyFi7v7PxbvIyjc7NqZRvpk0KILaFGPIfaCNrjz
	 tjiB5LDZ6jdpSAfDEhLw8vjdDwQQAQzaLiXiIeh91gTJhBJJ0jMAXAHDNt2RnJm1hI
	 ZS7L1tNHqS2jPcTaXGN839kFrOANGpL18cttQ5Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 366/772] ASoC: codecs: Fix atomicity violation in snd_soc_component_get_drvdata()
Date: Thu, 12 Dec 2024 15:55:11 +0100
Message-ID: <20241212144405.033804005@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


