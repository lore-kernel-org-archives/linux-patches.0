Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F039B23D6A
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E11C433EF;
	Wed,  7 Jun 2023 20:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171227;
	bh=uBKma2Aqhkrx3VqK+20ig6xk1tNDVIK+ji+ozjbFkRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeupwqODbMbd7DIgfyp5cUS73CAQdiqZuAIPoLiP2NCvLf1bdeObAdn4yNrcilpPW
	 tGAHDg1lso5uAtuz+pdkTxPjCGl4auMjbd5uUlip7MGxdY3Gq52UVWgaevX/XBh6w2
	 Uu0wphera52bHDT1+Cv93sU7mMxWmxVCfIglk0mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/99] ASoC: ssm2602: Add workaround for playback distortions
Date: Wed,  7 Jun 2023 22:16:29 +0200
Message-ID: <20230607200901.415265504@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.195572674@linuxfoundation.org>
References: <20230607200900.195572674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paweł Anikiel <pan@semihalf.com>

[ Upstream commit f63550e2b165208a2f382afcaf5551df9569e1d4 ]

Apply a workaround for what appears to be a hardware quirk.

The problem seems to happen when enabling "whole chip power" (bit D7
register R6) for the very first time after the chip receives power. If
either "output" (D4) or "DAC" (D3) aren't powered on at that time,
playback becomes very distorted later on.

This happens on the Google Chameleon v3, as well as on a ZYBO Z7-10:
https://ez.analog.com/audio/f/q-a/543726/solved-ssm2603-right-output-offset-issue/480229
I suspect this happens only when using an external MCLK signal (which
is the case for both of these boards).

Here are some experiments run on a Google Chameleon v3. These were run
in userspace using a wrapper around the i2cset utility:
ssmset() {
        i2cset -y 0 0x1a $(($1*2)) $2
}

For each of the following sequences, we apply power to the ssm2603
chip, set the configuration registers R0-R5 and R7-R8, run the selected
sequence, and check for distortions on playback.

  ssmset 0x09 0x01 # core
  ssmset 0x06 0x07 # chip, out, dac
  OK

  ssmset 0x09 0x01 # core
  ssmset 0x06 0x87 # out, dac
  ssmset 0x06 0x07 # chip
  OK

  (disable MCLK)
  ssmset 0x09 0x01 # core
  ssmset 0x06 0x1f # chip
  ssmset 0x06 0x07 # out, dac
  (enable MCLK)
  OK

  ssmset 0x09 0x01 # core
  ssmset 0x06 0x1f # chip
  ssmset 0x06 0x07 # out, dac
  NOT OK

  ssmset 0x06 0x1f # chip
  ssmset 0x09 0x01 # core
  ssmset 0x06 0x07 # out, dac
  NOT OK

  ssmset 0x09 0x01 # core
  ssmset 0x06 0x0f # chip, out
  ssmset 0x06 0x07 # dac
  NOT OK

  ssmset 0x09 0x01 # core
  ssmset 0x06 0x17 # chip, dac
  ssmset 0x06 0x07 # out
  NOT OK

For each of the following sequences, we apply power to the ssm2603
chip, run the selected sequence, issue a reset with R15, configure
R0-R5 and R7-R8, run one of the NOT OK sequences from above, and check
for distortions.

  ssmset 0x09 0x01 # core
  ssmset 0x06 0x07 # chip, out, dac
  OK

  (disable MCLK)
  ssmset 0x09 0x01 # core
  ssmset 0x06 0x07 # chip, out, dac
  (enable MCLK after reset)
  NOT OK

  ssmset 0x09 0x01 # core
  ssmset 0x06 0x17 # chip, dac
  NOT OK

  ssmset 0x09 0x01 # core
  ssmset 0x06 0x0f # chip, out
  NOT OK

  ssmset 0x06 0x07 # chip, out, dac
  NOT OK

Signed-off-by: Paweł Anikiel <pan@semihalf.com
Link: https://lore.kernel.org/r/20230508113037.137627-8-pan@semihalf.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ssm2602.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/sound/soc/codecs/ssm2602.c b/sound/soc/codecs/ssm2602.c
index 464a4d7873bba..b797f620e3521 100644
--- a/sound/soc/codecs/ssm2602.c
+++ b/sound/soc/codecs/ssm2602.c
@@ -53,6 +53,18 @@ static const struct reg_default ssm2602_reg[SSM2602_CACHEREGNUM] = {
 	{ .reg = 0x09, .def = 0x0000 }
 };
 
+/*
+ * ssm2602 register patch
+ * Workaround for playback distortions after power up: activates digital
+ * core, and then powers on output, DAC, and whole chip at the same time
+ */
+
+static const struct reg_sequence ssm2602_patch[] = {
+	{ SSM2602_ACTIVE, 0x01 },
+	{ SSM2602_PWR,    0x07 },
+	{ SSM2602_RESET,  0x00 },
+};
+
 
 /*Appending several "None"s just for OSS mixer use*/
 static const char *ssm2602_input_select[] = {
@@ -588,6 +600,9 @@ static int ssm260x_component_probe(struct snd_soc_component *component)
 		return ret;
 	}
 
+	regmap_register_patch(ssm2602->regmap, ssm2602_patch,
+			      ARRAY_SIZE(ssm2602_patch));
+
 	/* set the update bits */
 	regmap_update_bits(ssm2602->regmap, SSM2602_LINVOL,
 			    LINVOL_LRIN_BOTH, LINVOL_LRIN_BOTH);
-- 
2.39.2



