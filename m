Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8DB275AFF;
	Fri, 21 Nov 2025 13:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733321; cv=none; b=Grv7YJey6nM3fE3XYjw7L3YYM09FmXuiUeJyWBvEISKzSOwFg3wryFQ9NbrkdtmPAVTKWzlhYQboU2fQ6Yk8SmuouGNO806WILZE6nx6Qr5PR5Z1MiHQgHyZw82bYHgvWtkn6AzNQPO6gORiwM2JNF9CK3CLkPbqIV4sWNxGkJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733321; c=relaxed/simple;
	bh=UgQOf+hUgf/2ct6qqcNkg+tVPSkcxjYtHRpPm9tBzR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebygw+fh8lwf06Z7jH7+SOUva6GYrkfAV6UbDHhuwWy1XSpnXRM14MH4nQNzQYoqlecnBlhQLRKqZ6MFPrGFUB1J8Jd5SQGwE229nuudTj+D6/JztDN366oYidIHY0pMk+2dGwROFZdb05x/HTxbpBp1em/iNWYl+vLauLqx2NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07FcnZxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07FcnZxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7DFC4CEF1;
	Fri, 21 Nov 2025 13:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733321;
	bh=UgQOf+hUgf/2ct6qqcNkg+tVPSkcxjYtHRpPm9tBzR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07FcnZxB+pQcOoI2Y6Vig0aapOudUmWVoXWJb06bwbAakazbhAn23fAdvpDnE0Trb
	 l81Ju0axiY+1Wd2guxD6eYgLlOTrDYjeacL7CMu8wjndQ+xsBFzA6nPAkO+1MfqOlQ
	 hGMvEG9Boj7ludkT+8vtQzgDhkOX8vs4Ma0G7YUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 429/529] ASoC: tas2781: fix getting the wrong device number
Date: Fri, 21 Nov 2025 14:12:08 +0100
Message-ID: <20251121130246.280449135@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 43775c1944452..836cf06a45266 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -616,7 +616,8 @@ static void tasdevice_parse_dt(struct tasdevice_priv *tas_priv)
 {
 	struct i2c_client *client = (struct i2c_client *)tas_priv->client;
 	unsigned int dev_addrs[TASDEVICE_MAX_CHANNELS];
-	int i, ndev = 0;
+	int ndev = 0;
+	int i, rc;
 
 	if (tas_priv->isacpi) {
 		ndev = device_property_read_u32_array(&client->dev,
@@ -627,8 +628,12 @@ static void tasdevice_parse_dt(struct tasdevice_priv *tas_priv)
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



