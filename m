Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06758331220;
	Wed, 20 May 2026 17:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296987; cv=none; b=huB5X85ZnTHNpRY4/l4wdkauBwUJkewc07+jMYWXowy7njBk2gVgGfj6vYeNEK5K86pMYgF6EQ4bGfZlu12AWrfssc8BN7vJY7DcgQ/GYGjzRqExAylFQQ1vQItK3aKcOyfU1vrqvUAag4Iz31Wc+ZqEBrXiC0kRfHxZTVPaHBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296987; c=relaxed/simple;
	bh=cJGKH663Aijsm2u+H+TgdKl8kCBnov/+Ew4vG7/0mHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3RInWkZ5S3+gs7NprBubh3DBmitgkHM+3QDglRdUOGw3h9YuTUDKX2/L0ipbcCLxs0JK51vztSoSG8LUAehBUfgg5CW16/4ph4NMJc0gwQNo5Gz0tHDrzWrkIBTGlaMQkDvSU6kHezYzeyN/ZJxZLP5B+5BGC/fsFRi3R4eDk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFsbkgPc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFsbkgPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A3E1F000E9;
	Wed, 20 May 2026 17:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296985;
	bh=Jp+TVt7Rvi+zuzvb5xtSgENMHTCEedYDboKfUcE6lR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yFsbkgPcsGVsaOi4hVE1Mk0GoyrpQfQKvFq4cJTCqG+KS9Jw+ekR66qEYTks9tLWB
	 +mVjTnPnX7BQa3PlfGLIu0n4vWGqynovvySRBttR32BqiAZj/xXJADQrD65vw6GaTW
	 i0EaPwyuxuRDQM9xeCOkG6k7LAD8HvVO9OyzfodQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1000/1146] ALSA: hda/tas2781: Fix incorrect bit update for non-book-zero or book 0 pages >1
Date: Wed, 20 May 2026 18:20:50 +0200
Message-ID: <20260520162210.865610811@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Ding <shenghao-ding@ti.com>

[ Upstream commit e052a1f7199260eda4d6ca08a59c3b98738f8491 ]

In TAS2781 SPI mode, when accessing non-book-zero or page numbers greater
than 1 in book 0, an additional byte must be read. The first byte in such
cases is a dummy byte and should be ignored.

Fixes: 9fa6a693ad8d ("ALSA: hda/tas2781: Remove tas2781_spi_fwlib.c and leverage SND_SOC_TAS2781_FMWLIB")
Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Link: https://patch.msgid.link/20260429054206.429-1-shenghao-ding@ti.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/tas2781_hda_spi.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/sound/hda/codecs/side-codecs/tas2781_hda_spi.c b/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
index f860e0eb7602a..6c736b17c9831 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
@@ -132,10 +132,18 @@ static int tasdevice_spi_dev_update_bits(struct tasdevice_priv *tas_priv,
 	int ret, val;
 
 	/*
-	 * In our TAS2781 SPI mode, read/write was masked in last bit of
-	 * address, it cause regmap_update_bits() not work as expected.
+	 * In TAS2781 SPI mode, when accessing non-book-zero or page numbers
+	 * greater than 1 in book 0, an additional byte must be read. The
+	 * first byte in such cases is a dummy byte and should be ignored.
 	 */
-	ret = tasdevice_dev_read(tas_priv, chn, reg, &val);
+	if ((TASDEVICE_BOOK_ID(reg) > 0) || (TASDEVICE_PAGE_ID(reg) > 1)) {
+		unsigned char buf[2];
+
+		ret = tasdevice_dev_bulk_read(tas_priv, chn, reg, buf, 2);
+		val = buf[1];
+	} else {
+		ret = tasdevice_dev_read(tas_priv, chn, reg, &val);
+	}
 	if (ret < 0) {
 		dev_err(tas_priv->dev, "%s, E=%d\n", __func__, ret);
 		return ret;
-- 
2.53.0



