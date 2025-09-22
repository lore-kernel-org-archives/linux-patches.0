Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBAD1F91E3;
	Mon, 22 Sep 2025 19:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570334; cv=none; b=XyA0DhRhlvrmc+u1v5JijMQ+hq2TyRX5lxTudEUnFa2odyVcZ5dpjKy8ewhR+dlHrcv2maj8yYEk8//Azrkm1vW6jbwIv5wCP0tflz1gCvzTO2N8UMRuTrAjsndhsVAe6fi9UG9/A6gZ91tKWmhMqcXOe8LEb6YIJv2NT8CfQiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570334; c=relaxed/simple;
	bh=9hk5Dw82ZPvwzusfg5GgeSVEU+XzegNK8SVe1dsQMsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXfzq5dstZO7Ptaw+X6ngxZ7UskeLmzLNRz6o2KYrE2lWp0sw+CJzducf3L2La65jekGnhEXKAwElfUUXv3SFdq9Dpb0QkMozPzym/5uMxFcJlNu4Gl16F6byf72nbD6pPicOBtBL1fy6v6CEIDeqcCjjuNodU42r+/58kFHYc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnuusKW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnuusKW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49444C4CEF0;
	Mon, 22 Sep 2025 19:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570334;
	bh=9hk5Dw82ZPvwzusfg5GgeSVEU+XzegNK8SVe1dsQMsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnuusKW3sV6bf0sY5neHCmrqttNTG5IOgCgoHXHYCbCsO7giWNxZoriuQr+ODrdiX
	 W7NS4oBsAewoVaVY/XHPHZGIXw4RSGTrwlvXVXXspUuo/8YLJU20ubYa5kmwwy24Z4
	 61tSq8hrQmdU5dskKRhvRBnnzFqzYwoNCVbUl820=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankur Tyagi <ankur.tyagi85@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 108/149] ASoC: wm8940: Correct PLL rate rounding
Date: Mon, 22 Sep 2025 21:30:08 +0200
Message-ID: <20250922192415.604083698@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 401ee20897b1b..46c16c9bc17a8 100644
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



