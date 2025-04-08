Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CCC26A0E9;
	Tue,  8 Apr 2025 12:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114285; cv=none; b=cZy/EYDzntg/hageS2OVOZ1Lc3CCcRa4i7vma5kGDD6+pm4oywpU3gSrpnPkIwWGdRojrflU0t1/xJboHvrDZbanbtNYdcimdlMVOaUqn675i2IJycJgW4gfRcHXLkyAA4XuAe0GZaGMZpq4Mmx3u+EOize91vJErC9NQyTBS1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114285; c=relaxed/simple;
	bh=CEkuO+W4IApaRFIvIJwT8kFc4CE0Fyw5VIVw6ahum+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrK0/gKcJ4G9TE+FNHL54HGxUJKdxfEcazV73IpNJt3eHoAl/WQi/35jJUQWn3HnUR2Gl5z6RiknGG2bShVPm7Xr7J3Kg590UWavXoRo3tF2kZTsWlK2psB7VYXfMpalScZu3NuIWeb/v4wKkeYuUPuERNbaiohp63xiOJ3FUa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+DkzMQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+DkzMQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABA9C4CEF0;
	Tue,  8 Apr 2025 12:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114285;
	bh=CEkuO+W4IApaRFIvIJwT8kFc4CE0Fyw5VIVw6ahum+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+DkzMQoYnx82Hovsm4i7Whmenglf03LCkhkj9B6NkU7sBzwEpqGQNm+WiS1U4QBO
	 q+kCAG65pEui7Qw/EEXGO7OEz4dQVER1tNAgOsEFhPapTJr5aiz0lFeX8SoirJjajs
	 536VfEB4YNa2kqEfPnJ8lc7Qy0XWYW+97delzMA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 051/499] ASoC: cs35l41: check the return value from spi_setup()
Date: Tue,  8 Apr 2025 12:44:23 +0200
Message-ID: <20250408104852.511530646@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>

[ Upstream commit ad5a0970f86d82e39ebd06d45a1f7aa48a1316f8 ]

Currently the return value from spi_setup() is not checked for a failure.
It is unlikely it will ever fail in this particular case but it is still
better to add this check for the sake of completeness and correctness. This
is cheap since it is performed once when the device is being probed.

Handle spi_setup() return value.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 872fc0b6bde8 ("ASoC: cs35l41: Set the max SPI speed for the whole device")
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
Link: https://patch.msgid.link/20250304115643.2748-1-v.shevtsov@mt-integration.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l41-spi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l41-spi.c b/sound/soc/codecs/cs35l41-spi.c
index a6db44520c060..f9b6bf7bea9c9 100644
--- a/sound/soc/codecs/cs35l41-spi.c
+++ b/sound/soc/codecs/cs35l41-spi.c
@@ -32,13 +32,16 @@ static int cs35l41_spi_probe(struct spi_device *spi)
 	const struct regmap_config *regmap_config = &cs35l41_regmap_spi;
 	struct cs35l41_hw_cfg *hw_cfg = dev_get_platdata(&spi->dev);
 	struct cs35l41_private *cs35l41;
+	int ret;
 
 	cs35l41 = devm_kzalloc(&spi->dev, sizeof(struct cs35l41_private), GFP_KERNEL);
 	if (!cs35l41)
 		return -ENOMEM;
 
 	spi->max_speed_hz = CS35L41_SPI_MAX_FREQ;
-	spi_setup(spi);
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
 
 	spi_set_drvdata(spi, cs35l41);
 	cs35l41->regmap = devm_regmap_init_spi(spi, regmap_config);
-- 
2.39.5



