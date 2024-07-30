Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7281FBA;
	Tue, 30 Jul 2024 17:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358807; cv=none; b=vCWlf0DE00o15b866hnS4uBR1JDpxjiDYCPMk9ZOKjJp0xttrtGGgUL62m7hhUpNjVS4h14c7nAg3tNngPxA4ISw2yTGYgsO1RCg01/qXAci5wLM1W/KOwFmWs3x6T3+qxbBfwj4UsPxfKIzaAYiTd/BdOYJDrF8RertIXEHjGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358807; c=relaxed/simple;
	bh=hRT1X53jY8hWGkrgXaaV+omSre4UvWUTDO2WPD33xjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hb4ggAuzuwevO+/DMNaMVagDwCIvIZHvWwQ/EenYW7QRoScCSfcey6tUhsvCRz4M1HOknMv2brxb0+QpFOGBX5b2deVcH0ttpVXPzi0uHD/+KACarxD7lurKHamDPVOmF3DAH0CH+NyiWTSDKyHKOCW6TM8c+w3gOZtypkXVyhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnkpiMRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnkpiMRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590A6C32782;
	Tue, 30 Jul 2024 17:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358806;
	bh=hRT1X53jY8hWGkrgXaaV+omSre4UvWUTDO2WPD33xjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnkpiMRSRJyJXv+ooELavbkeVJMUhMpFXDzM8lECRlNR4hsYfA7VW18tX6hzobupr
	 MRSaARpFyooX8ebXPhny2ufxBBkVNUgaZcYpt5Xii2EcaDbtuBKMwvzQ1pdO9H4K0g
	 VsVxyCN2PIA46zzzY9wBxwifR7O8hqHYIOVQiLVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 398/809] iio: adc: adi-axi-adc: dont allow concurrent enable/disable calls
Date: Tue, 30 Jul 2024 17:44:34 +0200
Message-ID: <20240730151740.402273997@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit 202b89f4b778d86a940f693785600acaccca6a2b ]

Add proper mutex guards as we should not be able to disable
the core in the middle of enabling it.

Note there's no need to rush in backporting this as the only user of the
backend does not do anything crazy..

Fixes: 794ef0e57854 ("iio: adc: adi-axi-adc: move to backend framework")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240531-dev-axi-adc-drp-v3-1-e3fa79447c67@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/adi-axi-adc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/adc/adi-axi-adc.c b/drivers/iio/adc/adi-axi-adc.c
index 0cf0d81358fd5..bf51d619ebbc9 100644
--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -85,6 +85,7 @@ static int axi_adc_enable(struct iio_backend *back)
 	struct adi_axi_adc_state *st = iio_backend_get_priv(back);
 	int ret;
 
+	guard(mutex)(&st->lock);
 	ret = regmap_set_bits(st->regmap, ADI_AXI_REG_RSTN,
 			      ADI_AXI_REG_RSTN_MMCM_RSTN);
 	if (ret)
@@ -99,6 +100,7 @@ static void axi_adc_disable(struct iio_backend *back)
 {
 	struct adi_axi_adc_state *st = iio_backend_get_priv(back);
 
+	guard(mutex)(&st->lock);
 	regmap_write(st->regmap, ADI_AXI_REG_RSTN, 0);
 }
 
-- 
2.43.0



