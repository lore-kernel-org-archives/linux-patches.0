Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8483F58D6;
	Wed, 20 May 2026 17:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299583; cv=none; b=MH7/HMEtpzU4L6hThhqgSXYJJVzAfFcATPxxchwqXgWbnywsZgJs8pU92NRgYpjIPxahF+p6YlQGgeF6Tn+mnMsglCMcwUugzTzpPLvD2bFYBdum1iX/kdFhkgtv+mzNx3+c3lXAei3tjSrsY4OAigNLREqcZGs0xNzkquF3gPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299583; c=relaxed/simple;
	bh=t76zTtSlyT5AuTZi+KZl4p0DlQVfti1xQRoJC6OYAkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvZAllFZ47BVQLp1Zdw8Sa3EYeFTD7AhE8uXq5WKyM9BhcDLbwDfZZQ/3vnU4iMxHhh+XaVmIDEc33kw2FFnhpLh6eAf081H1C5E2+kxm9lV9JGrCd12R1sWlizvnlgF82tW9Ud1gzQVmol4r86DGeODxvZ/ibe9dD1NerO8Ogc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LsamIue1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LsamIue1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A433A1F00893;
	Wed, 20 May 2026 17:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299582;
	bh=VdtuFvi+Z+5yYKN9HDbMwvHofcEteo0H8wZllkMNjMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LsamIue1XCXctEBUKLLDjEdwAuCmCA0jdSSO13IKJcNFSCZdPGi/o8XUTxjE0+iEb
	 SRZnO542+m7AmEXvjgy42ekrdwIVOUWWMwdclqNnATAR0qst1REhwPULn8Z4OrxKYL
	 rJIHS5eWgOfbBqHkC6XwQ+7ejcBSiJffswCuKNkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 826/957] ALSA: hda/tas2781: Fix incorrect bit update for non-book-zero or book 0 pages >1
Date: Wed, 20 May 2026 18:21:49 +0200
Message-ID: <20260520162152.481303952@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 488e35dac9524..a64f2c899d50c 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda_spi.c
@@ -135,10 +135,18 @@ static int tasdevice_spi_dev_update_bits(struct tasdevice_priv *tas_priv,
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



