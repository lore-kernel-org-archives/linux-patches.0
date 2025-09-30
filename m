Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94D8305048;
	Tue, 30 Sep 2025 14:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244223; cv=none; b=nH4w+wYyAQpWgPIaXW/tIFlHGZL3NCIIUMghWS5QzaXrwUWZBmV5Z+44ORNZo1AVhxzX+FfRAc+n+T2TN/TgGXVv8Va4BDoftH2H6Vj0zQZCffPKeL1jq4vhHVGtbxFnWJHEUO4hV90PvCr1OVz/2zPYIg64yWY59eHBO+QrhWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244223; c=relaxed/simple;
	bh=zL4jZM81Z9l/u2AtLOBejaXkSPqe3LWRSCmZuXpoyos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAKApgOdWFpLc5zGNp57bGMm3i2e06a7Oa8lcJdv/97uZz2dUbdereVuzKoE9Yj7i6+LSBtRJtSeGfMfWV9uSiPJ5Z59TBRgJLbXFNNqo64ACx8xqMpZPJD3PY2V5oum4JDfSm2lCMMfVOePVtEGqUd3FlFhR1CJi7zZK/fcrcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eI2rEzsv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eI2rEzsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58486C4CEF0;
	Tue, 30 Sep 2025 14:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244222;
	bh=zL4jZM81Z9l/u2AtLOBejaXkSPqe3LWRSCmZuXpoyos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eI2rEzsvcQrp+fftHdbDzS9woh1GJLAeweG+tOIere6wK5Jc8bvgHuYyaau4fh03u
	 vIAbQmu6hdNSqH4PCyomEle1L7NTZ52w95tHAxvU8arjuGUf3XqHV+gVtg7F3L43Kr
	 tLJqB6V4TBcxRAJzt+HA02WpamFPmkfx0WVJYCMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/122] ASoC: wm8974: Correct PLL rate rounding
Date: Tue, 30 Sep 2025 16:46:36 +0200
Message-ID: <20250930143825.665673925@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 9b17d3724df55ecc2bc67978822585f2b023be48 ]

Using a single value of 22500000 for both 48000Hz and 44100Hz audio
will sometimes result in returning wrong dividers due to rounding.
Update the code to use the actual value for both.

Fixes: 51b2bb3f2568 ("ASoC: wm8974: configure pll and mclk divider automatically")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250821082639.1301453-4-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8974.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8974.c b/sound/soc/codecs/wm8974.c
index 600e93d61a90f..bfc72c2bf90b8 100644
--- a/sound/soc/codecs/wm8974.c
+++ b/sound/soc/codecs/wm8974.c
@@ -419,10 +419,14 @@ static int wm8974_update_clocks(struct snd_soc_dai *dai)
 	fs256 = 256 * priv->fs;
 
 	f = wm8974_get_mclkdiv(priv->mclk, fs256, &mclkdiv);
-
 	if (f != priv->mclk) {
 		/* The PLL performs best around 90MHz */
-		fpll = wm8974_get_mclkdiv(22500000, fs256, &mclkdiv);
+		if (fs256 % 8000)
+			f = 22579200;
+		else
+			f = 24576000;
+
+		fpll = wm8974_get_mclkdiv(f, fs256, &mclkdiv);
 	}
 
 	wm8974_set_dai_pll(dai, 0, 0, priv->mclk, fpll);
-- 
2.51.0



