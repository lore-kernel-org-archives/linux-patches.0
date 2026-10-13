Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CB338F62F;
	Tue, 13 Oct 2026 12:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894488; cv=none; b=JtlvcCP8pFt8Kp+kSBeH6t8G18nbeItj0+3T/5d2X4b8J97hNytAfVCD82h5DupDxu7hEaH+VQ58aGL7fV9MdYsll8/SkQmEaKw9T8R8ypXHSVXTuSZpHQxYTItL8/7rVH4swYx4mUWPbPdqcHp/xva0/N3tMzIzb2toLRvVwQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894488; c=relaxed/simple;
	bh=knhwBweOub+dQHtBrHCJnOlW/OQJnKwl3ZhKmb3LjUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VRsXx+CFxhOI/TC75+A29918Sous+xMo+kFv5uH921MqFlu++u+Z5+gIMLP2LDuNuUVZqJPPbU7Ihe+QfF0NlIYQnysQp7aK0U5Z/n2cCY1NSmhwmlE2aNyhcpkNqQW4wEdCDuX2K5GP7/mbgbmaTrxkeh/yb0c3S1zIrm5ym+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/jRU16R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/jRU16R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7C41F000FF;
	Tue, 13 Oct 2026 12:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894487;
	bh=lUFAS5jvNyBpLUzxCoBNG/zWKEtULNn7xObv2wiaCHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/jRU16RbXFC2TXNC1bUGWShlbqbHd8Qf/C6uICipVLVWCOzkmG/0Q1OBD1dpMHcG
	 XCb/Wiuse1bjvsJczzVJ+9b5QKJQH/uLQShurinCWnmHjVf1lwH7pdOXrbMd4PZq0j
	 s7TZgCZMawx3eZROLCTYUSgzBLoWErivqfqlNq+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 575/621] ASoC: adau1372: fix invalid default state of output ASRC and DAC muxes
Date: Tue, 13 Oct 2026 13:39:30 +0200
Message-ID: <20261013112934.453105785@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alvin Šipraga <alvin.sipraga@analog.com>

[ Upstream commit 36d0e05815ce84266c8b138cd4f84c3feeaf15f4 ]

The chip has strange power-on reset values for the registers that
control the output ASRC and DAC source muxes - the values are actually
marked "Reserved" in the datasheet [1]. This means that until the
underlying kcontrols are modified, the codec will not function as
expected.

The registers in question are:

  register / field       reset value       valid values

  ASRCO_SOURCE_0_1       0x10
   ASRC_OUT_SOURCE0      0                 4 .. 16
   ASRC_OUT_SOURCE1      1                 4 .. 16
  ASRCO_SOURCE_2_3       0x10
   ASRC_OUT_SOURCE2      2                 4 .. 16
   ASRC_OUT_SOURCE3      3                 4 .. 16
  DAC_SOURCE_0_1         0x10
   DAC_SOURCE_0          0                 12 .. 13
   DAC_SOURCE_1          1                 12 .. 13

Set some sane defaults during the driver probe:

  ADC Decimator0 -> Output ASRC0
  ADC Decimator1 -> Output ASRC1
  ADC Decimator2 -> Output ASRC2
  ADC Decimator3 -> Output ASRC3
  Input ASRC0 -> DAC0
  Input ASRC1 -> DAC1

With this, the chip will behave as advertised by the default kcontrol
state exposed by the driver.

[1] https://www.analog.com/media/en/technical-documentation/data-sheets/ADAU1372.pdf

Fixes: 6cd4c6459e47 ("ASoC: Add ADAU1372 audio CODEC support")
Signed-off-by: Alvin Šipraga <alvin.sipraga@analog.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20261006-asoc-adau1372-fixes-v1-2-599cc17fb5f6@analog.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/adau1372.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/codecs/adau1372.c b/sound/soc/codecs/adau1372.c
index a1fcce04c4dfc..f5b135799b146 100644
--- a/sound/soc/codecs/adau1372.c
+++ b/sound/soc/codecs/adau1372.c
@@ -1003,6 +1003,17 @@ int adau1372_probe(struct device *dev, struct regmap *regmap,
 
 	regmap_write(regmap, ADAU1372_REG_OP_STAGE_MUTE, 0x0);
 
+	/*
+	 * Set sane default values for the Output ASRC and DAC input muxes,
+	 * since the power-on reset defaults are invalid "Reserved" states.
+	 */
+	regmap_write(regmap, ADAU1372_REG_ASRCO_SOURCE_0_1,
+		     0x54); /* Decimator0, Decimator1 */
+	regmap_write(regmap, ADAU1372_REG_ASRCO_SOURCE_2_3,
+		     0x76); /* Decimator2, Decimator3 */
+	regmap_write(regmap, ADAU1372_REG_DAC_SOURCE,
+		     0xdc); /* Input ASRC0, Input ASRC1 */
+
 	regmap_write(regmap, 0x7, 0x01); /* CLOCK OUT */
 
 	return  devm_snd_soc_register_component(dev, &adau1372_driver, &adau1372_dai_driver, 1);
-- 
2.53.0



