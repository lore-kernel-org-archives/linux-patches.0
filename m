Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7BC17744
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24F5C433C8;
	Wed,  9 Aug 2023 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580611;
	bh=voBmh+95tdlWKsFS1FzRUatVA9Z2Z4WuUb6iCbNcAzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ndDvnma2mowIewjW9ZndsBkhBRa7r/bUkslfxNl+qo3NmMrEidfEXPg1MjVFFQ9B
	 WuavAC98zfGEulMoEohP9rRVgjxdWqe4GMnld4kyIDVEVx9B5zPB/5FpathxJnw85G
	 W0vNjGcoK1v3BjhHrEc8vrE68RJQLlbL45hvP6sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 079/154] ASoC: wm8904: Fill the cache for WM8904_ADC_TEST_0 register
Date: Wed,  9 Aug 2023 12:41:50 +0200
Message-ID: <20230809103639.606304894@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

commit f061e2be8689057cb4ec0dbffa9f03e1a23cdcb2 upstream.

The WM8904_ADC_TEST_0 register is modified as part of updating the OSR
controls but does not have a cache default, leading to errors when we try
to modify these controls in cache only mode with no prior read:

wm8904 3-001a: ASoC: error at snd_soc_component_update_bits on wm8904.3-001a for register: [0x000000c6] -16

Add a read of the register to probe() to fill the cache and avoid both the
error messages and the misconfiguration of the chip which will result.

Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230723-asoc-fix-wm8904-adc-test-read-v1-1-2cdf2edd83fd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wm8904.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -2276,6 +2276,9 @@ static int wm8904_i2c_probe(struct i2c_c
 	regmap_update_bits(wm8904->regmap, WM8904_BIAS_CONTROL_0,
 			    WM8904_POBCTRL, 0);
 
+	/* Fill the cache for the ADC test register */
+	regmap_read(wm8904->regmap, WM8904_ADC_TEST_0, &val);
+
 	/* Can leave the device powered off until we need it */
 	regcache_cache_only(wm8904->regmap, true);
 	regulator_bulk_disable(ARRAY_SIZE(wm8904->supplies), wm8904->supplies);


