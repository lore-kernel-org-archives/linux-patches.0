Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23D33375DC;
	Tue, 26 Aug 2025 11:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208663; cv=none; b=RVgAseXgPDEoL0v2COLf5BAFnGu89YH+GM0R1UhLkNz3Hh2DPJsOkJcz6XGc5KVAMMW5kAV3VCxmhKpKB9Tdbxd0u61qXPOBJQwnAaHSL8MBHWe4N2loXTKfi1hj+7Jx6s0q8zdq9t49EEQDtsf8gtGuWmZUZQwT7ukdnI2Z3MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208663; c=relaxed/simple;
	bh=na68LtGyms7k2daci8BylHlg0hS7d0HkQMiPHoLMVbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8YhaxSC3PxVSRJNrgCsMHOhHCjAD3HuutP0NWa9k/GLCUrUzRKOlejagfaMF8dnlb4GxUHE/L6pziEQcnoUlaEXbIlJP7ARoYluqP5DtaTQ/D1mqfT+vUxyPAJ1cKepI/j6e2TMrtcPuL625OI8zo947Uor4HkQpgObpvRIwsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocqfNqgO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocqfNqgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171D7C4CEF1;
	Tue, 26 Aug 2025 11:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208663;
	bh=na68LtGyms7k2daci8BylHlg0hS7d0HkQMiPHoLMVbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocqfNqgOqW55+gIMT34cDTdnEoEE5Jp8JuQ6wLUohHxVVQVTyQJah2omoZr3qPZLY
	 M0FPa1UWUNdZly7a3cXCK2O4dtm8km2oSe/PCrxQaPRbMBSUaL7WimusahJjCaY1mu
	 dk9LyiIHeoIfgjZV/7sQrVi43LazqiEB+Hoi2lIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/322] iio: adc: ad7173: fix setting ODR in probe
Date: Tue, 26 Aug 2025 13:10:12 +0200
Message-ID: <20250826110920.732181215@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 6fa908abd19cc35c205f343b79c67ff38dbc9b76 ]

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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7173.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7173.c
+++ b/drivers/iio/adc/ad7173.c
@@ -1243,6 +1243,7 @@ static int ad7173_fw_parse_channel_confi
 		chan_st_priv->cfg.bipolar = false;
 		chan_st_priv->cfg.input_buf = st->info->has_input_buf;
 		chan_st_priv->cfg.ref_sel = AD7173_SETUP_REF_SEL_INT_REF;
+		chan_st_priv->cfg.odr = st->info->odr_start_value;
 		st->adc_mode |= AD7173_ADC_MODE_REF_EN;
 
 		chan_index++;
@@ -1307,7 +1308,7 @@ static int ad7173_fw_parse_channel_confi
 		chan->channel = ain[0];
 		chan_st_priv->chan_reg = chan_index;
 		chan_st_priv->cfg.input_buf = st->info->has_input_buf;
-		chan_st_priv->cfg.odr = 0;
+		chan_st_priv->cfg.odr = st->info->odr_start_value;
 
 		chan_st_priv->cfg.bipolar = fwnode_property_read_bool(child, "bipolar");
 		if (chan_st_priv->cfg.bipolar)


