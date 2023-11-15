Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FB73BB23
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OixbDWyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8205C433C9;
	Wed, 15 Nov 2023 19:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077481;
	bh=dg25mljLHa411KD+Xhxnq3pT5WaiPBSm3kUNRPY+Xac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OixbDWyHWwyaQNDh7VCDKz5qxS2psTZxS+5UjDG6Wz6hcNhFd9jLiDkxqa/ZcyQdC
	 qvadk7C0+qTcITxtPm+0rsc3XB8ANG88nY2myJR8bYAAI2CkfpZboO3G6KSMM0TfvA
	 XkwJei7a6RODXGmA6uY3y5l39lajhz5YKEVURZD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 330/603] ASoC: cs35l41: Handle mdsync_up reg write errors
Date: Wed, 15 Nov 2023 14:14:35 -0500
Message-ID: <20231115191636.349745885@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 4bb5870ab60abca6ad18196090831b5e4cf82d93 ]

The return code of regmap_multi_reg_write() call related to "MDSYNC up"
sequence is shadowed by the subsequent regmap_read_poll_timeout()
invocation, which will hit a timeout in case the write operation above
fails.

Make sure cs35l41_global_enable() returns the correct error code instead
of -ETIMEDOUT.

Additionally, to be able to distinguish between the timeouts of
wait_for_completion_timeout() and regmap_read_poll_timeout(), print an
error message for the former and return immediately.  This also avoids
having to wait unnecessarily for the second time.

Fixes: f8264c759208 ("ALSA: cs35l41: Poll for Power Up/Down rather than waiting a fixed delay")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20230907171010.1447274-3-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l41-lib.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/cs35l41-lib.c b/sound/soc/codecs/cs35l41-lib.c
index a018f1d984286..a6c6bb23b9574 100644
--- a/sound/soc/codecs/cs35l41-lib.c
+++ b/sound/soc/codecs/cs35l41-lib.c
@@ -1251,15 +1251,18 @@ int cs35l41_global_enable(struct device *dev, struct regmap *regmap, enum cs35l4
 
 		ret = wait_for_completion_timeout(pll_lock, msecs_to_jiffies(1000));
 		if (ret == 0) {
-			ret = -ETIMEDOUT;
-		} else {
-			regmap_read(regmap, CS35L41_PWR_CTRL3, &pwr_ctrl3);
-			pwr_ctrl3 |= CS35L41_SYNC_EN_MASK;
-			cs35l41_mdsync_up_seq[0].def = pwr_ctrl3;
-			ret = regmap_multi_reg_write(regmap, cs35l41_mdsync_up_seq,
-						     ARRAY_SIZE(cs35l41_mdsync_up_seq));
+			dev_err(dev, "Timed out waiting for pll_lock\n");
+			return -ETIMEDOUT;
 		}
 
+		regmap_read(regmap, CS35L41_PWR_CTRL3, &pwr_ctrl3);
+		pwr_ctrl3 |= CS35L41_SYNC_EN_MASK;
+		cs35l41_mdsync_up_seq[0].def = pwr_ctrl3;
+		ret = regmap_multi_reg_write(regmap, cs35l41_mdsync_up_seq,
+					     ARRAY_SIZE(cs35l41_mdsync_up_seq));
+		if (ret)
+			return ret;
+
 		ret = regmap_read_poll_timeout(regmap, CS35L41_IRQ1_STATUS1,
 					int_status, int_status & pup_pdn_mask,
 					1000, 100000);
-- 
2.42.0



