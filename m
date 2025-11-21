Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3EC31B124;
	Fri, 21 Nov 2025 13:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731763; cv=none; b=syAN3dhxKQiN4++18OzGy+ZYPJGvQsY+0SouPaTdYXz4jSb7amoGmiauCCzfQNIMiVuatUkbxsHVLFvGrLB61XakZsAZk6HsOUxUhCLZFSnpVQ/PnR8zu9aL85Rem6Xit735QAvVOwq40lEtvqsfyKL9BgdJjscVwLnoNAZtBLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731763; c=relaxed/simple;
	bh=ZFJIdO9F1X9B/dTItCbEja77G9VOyRb9GM1mH8fdzD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSd4jKRUc5VpvOx6eQK6nX7ObGnN8RgkWYDaaTnCG3f0rrqQwCsKKEqkTSxBswOzOsv+W+r/5U0ji8ytXaSvlPaHeijWRquVP1RNDt3+Aa5L6lX3gVcTKP34sKAlrOCX/M6c3OT8HzvjhCwHGS80L3sCgag/WluBTh8A+E/JZak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7Nu/Ycx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7Nu/Ycx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25801C4CEF1;
	Fri, 21 Nov 2025 13:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731763;
	bh=ZFJIdO9F1X9B/dTItCbEja77G9VOyRb9GM1mH8fdzD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7Nu/YcxORQlmK+V2r7lsJ5Pn0OMRkIGIEW10h0aaEdOcFdg1/k6hKjAWgPOGx+8U
	 3fBRK2HHWFFRt6y+6wgqYinBnWOgWxvV7yV+yg7v6b0aBCHBMunNEb1szZ7DRT3SMZ
	 zrPMCpJcMRPmZQ09pFM/QlH5EvNkpuzdZDsIi6bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/185] ASoC: tas2781: fix getting the wrong device number
Date: Fri, 21 Nov 2025 14:11:39 +0100
Message-ID: <20251121130146.471316756@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit 29528c8e643bb0c54da01237a35010c6438423d2 ]

The return value of device_property_read_u32_array used for getting the
property is the status instead of the number of the property.

Fixes: ef3bcde75d06 ("ASoC: tas2781: Add tas2781 driver")
Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20251107054959.950-1-shenghao-ding@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-i2c.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index 1b2f55030c396..2f100cbfdc41f 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -1635,7 +1635,8 @@ static void tasdevice_parse_dt(struct tasdevice_priv *tas_priv)
 {
 	struct i2c_client *client = (struct i2c_client *)tas_priv->client;
 	unsigned int dev_addrs[TASDEVICE_MAX_CHANNELS];
-	int i, ndev = 0;
+	int ndev = 0;
+	int i, rc;
 
 	if (tas_priv->isacpi) {
 		ndev = device_property_read_u32_array(&client->dev,
@@ -1646,8 +1647,12 @@ static void tasdevice_parse_dt(struct tasdevice_priv *tas_priv)
 		} else {
 			ndev = (ndev < ARRAY_SIZE(dev_addrs))
 				? ndev : ARRAY_SIZE(dev_addrs);
-			ndev = device_property_read_u32_array(&client->dev,
+			rc = device_property_read_u32_array(&client->dev,
 				"ti,audio-slots", dev_addrs, ndev);
+			if (rc != 0) {
+				ndev = 1;
+				dev_addrs[0] = client->addr;
+			}
 		}
 
 		tas_priv->irq =
-- 
2.51.0



