Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE04F2820D1;
	Mon, 22 Sep 2025 19:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569968; cv=none; b=q4xp3kUGwDUQZcDo/juDYSICNxoGdAW4p1sTKBSRxt1cx2mFEmO2zA9GMBgKxwEdwqoJGlkKhp4yyxAyRUK6gN8AT5lajfqw4FXgTN+fvXmD5mzh8abt7gTWkeW36GTsPxg4XaGoPHj+MbLVH/NiMevWMvNftBt8iIgC0u1a7QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569968; c=relaxed/simple;
	bh=H7sguuAodPDZJuMqswIbGNCkzzzY2vA/JRG0e2wXibk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWg+Ogeyls7mA5DmKK58zQr8TbgTLWQ46KWi9ls+N0/XC9L+sOCVOJolHdvdtmxJ3i5vZs7TRVpGh1W4xWaQqzFIg+KYAzhgwX6bhh7NuqNVBmAvvmb/fJ5uyCKWEt7IXfhYVXPtB4ZFb3w88MqD/omBXBsCuMZnWGXOwZwH29g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vu8PiziJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vu8PiziJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C48C4CEF5;
	Mon, 22 Sep 2025 19:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569968;
	bh=H7sguuAodPDZJuMqswIbGNCkzzzY2vA/JRG0e2wXibk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vu8PiziJ0ZIAGHU3oE4OTWaeC3/yQDbJJsrOTP6J4AI+kr0qtI2naUgKSVRz7sdFP
	 Meoqj44xGkZWeZHRMZGiylN07uO5GU/y4SlnA99r80r7NsnoAtW+pkx7K1GstoACWj
	 naF9KIZOuSLxzJMp8XmW/J0Zq8UtYGp0/jUW0RfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankur Tyagi <ankur.tyagi85@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/105] ASoC: wm8940: Correct PLL rate rounding
Date: Mon, 22 Sep 2025 21:29:54 +0200
Message-ID: <20250922192410.762143720@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit d05afb53c683ef7ed1228b593c3360f4d3126c58 ]

Using a single value of 22500000 for both 48000Hz and 44100Hz audio
will sometimes result in returning wrong dividers due to rounding.
Update the code to use the actual value for both.

Fixes: 294833fc9eb4 ("ASoC: wm8940: Rewrite code to set proper clocks")
Reported-by: Ankur Tyagi <ankur.tyagi85@gmail.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Tested-by: Ankur Tyagi <ankur.tyagi85@gmail.com>
Link: https://patch.msgid.link/20250821082639.1301453-2-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8940.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index 8a532f7d750c8..5e8ed8a2c270a 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -693,7 +693,12 @@ static int wm8940_update_clocks(struct snd_soc_dai *dai)
 	f = wm8940_get_mclkdiv(priv->mclk, fs256, &mclkdiv);
 	if (f != priv->mclk) {
 		/* The PLL performs best around 90MHz */
-		fpll = wm8940_get_mclkdiv(22500000, fs256, &mclkdiv);
+		if (fs256 % 8000)
+			f = 22579200;
+		else
+			f = 24576000;
+
+		fpll = wm8940_get_mclkdiv(f, fs256, &mclkdiv);
 	}
 
 	wm8940_set_dai_pll(dai, 0, 0, priv->mclk, fpll);
-- 
2.51.0



