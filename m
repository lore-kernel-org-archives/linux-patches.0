Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BED82C17A0;
	Tue, 26 Aug 2025 11:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207193; cv=none; b=lipO/4lWb1ZdC49Uwsd66f4Qo1QiPQbG4djiGUBwIHxLeLwrZMCwKElgfCHOHRZqpv92+R06p2JvFwDnv3zTkizZipexQ75lxuO9jegGHbGjgGcQS9eNfyfSTjVTeLCBlkKZPrcfRwD/RCAeJy/QBzpqaK91K51Zoa5XmY4nMWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207193; c=relaxed/simple;
	bh=k4pBN6lOdxlQDAi1UrKTQUGN4gXXdwBYdPI2n4SiHD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDWMPpPpy3+fsH209DdhzYoytdoxDn8CXPD4tZ6XE+o/eCu+HmZv86ZoL6srKKydMCmHExZbk98t63u2aC0qhI5INUr9TBafd/5XwmrU18v+mJw7Sbkz571scunWVzU9ZSx361UE+uUOBBJCVScMFFYkSElM4yexHituBGi02CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q4XMIJnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q4XMIJnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B68C4CEF1;
	Tue, 26 Aug 2025 11:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207193;
	bh=k4pBN6lOdxlQDAi1UrKTQUGN4gXXdwBYdPI2n4SiHD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4XMIJnIzkgtD2eLiOPnK70gaNYoJUoghAl8HFzjMM7TO+hGQ439WDxcd/tuVEt3i
	 egYhxPaJizTLm/4GirmOsRMAbmnlATTN0+xf1V1muvgABPqbEMsMaJZF5L0KwWIx4d
	 ZmDzxY9+MxbfwtZ4eDyVhjMnx3Vo/DHUayuRsJZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.16 079/457] iio: adc: ad7173: fix setting ODR in probe
Date: Tue, 26 Aug 2025 13:06:03 +0200
Message-ID: <20250826110939.327599898@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: David Lechner <dlechner@baylibre.com>

commit 6fa908abd19cc35c205f343b79c67ff38dbc9b76 upstream.

Fix the setting of the ODR register value in the probe function for
AD7177. The AD7177 chip has a different ODR value after reset than the
other chips (0x7 vs. 0x0) and 0 is a reserved value on that chip.

The driver already has this information available in odr_start_value
and uses it when checking valid values when writing to the
sampling_frequency attribute, but failed to set the correct initial
value in the probe function.

Fixes: 37ae8381ccda ("iio: adc: ad7173: add support for additional models")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250710-iio-adc-ad7173-fix-setting-odr-in-probe-v1-1-78a100fec998@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7173.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7173.c
+++ b/drivers/iio/adc/ad7173.c
@@ -1595,6 +1595,7 @@ static int ad7173_fw_parse_channel_confi
 		chan_st_priv->cfg.bipolar = false;
 		chan_st_priv->cfg.input_buf = st->info->has_input_buf;
 		chan_st_priv->cfg.ref_sel = AD7173_SETUP_REF_SEL_INT_REF;
+		chan_st_priv->cfg.odr = st->info->odr_start_value;
 		chan_st_priv->cfg.openwire_comp_chan = -1;
 		st->adc_mode |= AD7173_ADC_MODE_REF_EN;
 		if (st->info->data_reg_only_16bit)
@@ -1661,7 +1662,7 @@ static int ad7173_fw_parse_channel_confi
 		chan->scan_index = chan_index;
 		chan->channel = ain[0];
 		chan_st_priv->cfg.input_buf = st->info->has_input_buf;
-		chan_st_priv->cfg.odr = 0;
+		chan_st_priv->cfg.odr = st->info->odr_start_value;
 		chan_st_priv->cfg.openwire_comp_chan = -1;
 
 		chan_st_priv->cfg.bipolar = fwnode_property_read_bool(child, "bipolar");


