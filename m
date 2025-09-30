Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EF42F5301;
	Tue, 30 Sep 2025 15:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245192; cv=none; b=qz2NctdmQCPfi2UIlAIkDQ1/Yb/5JmAxYQ9asPwDgJ9eTRsUdZ4ttPNyB0XSeUZndsWRBrwKjTxyZUxzAJYm9V8zu+V76DbziJAv1dTXw27ZoaStAU6a2TjlccQkQphnA+zlvSQLpkvhTREiKvJ0NqvQQO6Gs9eINukwV1abLQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245192; c=relaxed/simple;
	bh=ZHPfMm8kebs98q4CWxLnwqFJahlIh512EINm/UKNA3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+g90McXihJX8jP3D+WYIAst8fLgcr1AqN+Pefvny5pX7QQEK8C5n1j3Q4USdGQkrxuf1iPRUJiN3VL7Yx0Arb3cYjCfz1xoQt3CggqpZZxNg6D1X+DCXJiKGXpeP3jG85k3DC3Sk7pWsNGYxVrwBg2KJq7Ljb+kd2xSzbsW4eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QYtovwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QYtovwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6464C4CEF0;
	Tue, 30 Sep 2025 15:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245192;
	bh=ZHPfMm8kebs98q4CWxLnwqFJahlIh512EINm/UKNA3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0QYtovwJAgt8OPPgL0/u1/HWv7YJnrz0fWMLIkYRDwKpSDbUinMCe4olyzHJo5iYB
	 +m8kBlML5kF6mAlhIsDZwtCxD6hQvs4EC5KeVpIShL0oc3vl2vhLKME4y/Cl6sPWUK
	 JjgNdm+Hj+0Qz8f8ucoqdXPTbONKcKln7mKti7GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/151] ASoC: wm8974: Correct PLL rate rounding
Date: Tue, 30 Sep 2025 16:46:56 +0200
Message-ID: <20250930143831.023724204@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9eeac34435664..914b7d04b09ca 100644
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



