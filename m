Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD58E33D6F2;
	Fri, 21 Nov 2025 13:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731136; cv=none; b=jxDOvTumiylsA9Zg48mkW6tqoxfn23YIjkQMh8g77LpDRSzmr2w7ctUiorL5fSbBNLtJWKwvtLCcVMiLlxgCK3XbUQSl1oJqfhS1Hndt3djWoCzCodE/h5NwBHOOnPDv6l/ulVE/y423mndMSC32BE9J62H+T3pUi4MITtnNe8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731136; c=relaxed/simple;
	bh=/fZxQ+v9UMsLsKLRf68JsrsvcEDEXgIhzslCvpGi/VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufl/LWDIzruvceLBbqHmF6F/cXdN1TwVlRQQh0G3t5mNzxcpHacUkV5/P+aDJL2dvc9urij+eBYNa6tOJ1WmItzYtGCw9/KOZk7WA/Q3XBQmyz5qiwntnBg4WMRH4n6Si666hIcUe582CvKbXKY5v6GG5QbuZmPu8TRV5kAP+eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwh8dd+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwh8dd+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A081C4CEFB;
	Fri, 21 Nov 2025 13:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731135;
	bh=/fZxQ+v9UMsLsKLRf68JsrsvcEDEXgIhzslCvpGi/VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwh8dd+IDfMTske95Ho1nO4hWxTgvHMZHS48136eCOo/knyKAh6L9sqWUrTCJkNC7
	 p5J3Ksy77If4KPcN0FP9sFjfVhmX8uxD6JaX1qLxU3YsrMjzAyq9KwGgTxhhecDX+L
	 zRZ0A0MyJLYEZG3ZCDmYP0PqxwJljalKcd+wNBOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 102/247] ASoC: tas2781: fix getting the wrong device number
Date: Fri, 21 Nov 2025 14:10:49 +0100
Message-ID: <20251121130158.249456352@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index ea3cdb8553de1..9890b1a6d2924 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -1864,7 +1864,8 @@ static void tasdevice_parse_dt(struct tasdevice_priv *tas_priv)
 {
 	struct i2c_client *client = (struct i2c_client *)tas_priv->client;
 	unsigned int dev_addrs[TASDEVICE_MAX_CHANNELS];
-	int i, ndev = 0;
+	int ndev = 0;
+	int i, rc;
 
 	if (tas_priv->isacpi) {
 		ndev = device_property_read_u32_array(&client->dev,
@@ -1875,8 +1876,12 @@ static void tasdevice_parse_dt(struct tasdevice_priv *tas_priv)
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



