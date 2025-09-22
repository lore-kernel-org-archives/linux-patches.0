Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E575F1C1ADB;
	Mon, 22 Sep 2025 19:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570395; cv=none; b=CDRFWuy6a8WLzS//uz8GKCnKifLA6DUpTXDjLF2xop/d+pdqyayRWEdM+qFlpwwnXPgFQqMEsoJ1Gc6EVhpBQBEYQ6m9JqJt5LUZVYjadnnau4IFJmXpFimA+3ZAfeMhOKfcL+s/22XRsCZYOh+3zgiv5ZGrnoPW9wtUUARowOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570395; c=relaxed/simple;
	bh=qkM8shYCYEVUq/7R/NJx/rDLGQVOA7Q0JeVRWXanv3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsmlgeZ9xk/0fjDeFOEvSToWIdR9ZIIQVpyhLG95+SruuEYZV6z12OYo3FGWQRPkAbgoa/ewFQdE3jnmY0kV+DpN9jcY2ZdfTCaQ56dblVnBdSmoY4tGZJS2FXNMePZNiRNJFMP8bC5oKefiT+HNG0qXzVfgeSWLUEChZoMnEC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEhamLEY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEhamLEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC9BC4CEF5;
	Mon, 22 Sep 2025 19:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570394;
	bh=qkM8shYCYEVUq/7R/NJx/rDLGQVOA7Q0JeVRWXanv3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEhamLEYxZUwSJV1LXCHyXynNy9GN0qbIIi5e3H+cWtczO89YRPuNmQpaMuCwotN/
	 3FBpzRmi+Vqgo4j2Fz3Y9QUCGNc0NZBbjZXWlYFQfhqGZ0eUE5jQTI881Y/kPBu6yZ
	 7ZWqVDUUHg/Liiwa570SCWLlkWOtkxXjzXn7kkEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 110/149] ASoC: wm8974: Correct PLL rate rounding
Date: Mon, 22 Sep 2025 21:30:10 +0200
Message-ID: <20250922192415.649930237@linuxfoundation.org>
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
index bdf437a5403fe..db16d893a2351 100644
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



