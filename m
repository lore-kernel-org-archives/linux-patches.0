Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A6320316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGq7f+v5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90718C433C8;
	Mon,  6 Nov 2023 13:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276630;
	bh=e/HEEpzhW+FAaao3+F4a4a0uUpNTZm+kyemaTM3TF9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGq7f+v53LaF4t8GyTxrXrzRIAdpXHgKYzqZ/sT6qltG2FVFY8Wr0UFsQc6R1mDRh
	 MUjdbIFDrXfFYwem90ZYm3b4MIRRxw5NRtLp6eLLTMAjc4QVhOnNxe2EiiiO5v1rVb
	 VT5+1r3FnI1xp9Q/Wx95jkcy/kZjaGIQlTihL7VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rau <David.Rau.opensource@dm.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 43/88] ASoC: da7219: Correct the process of setting up Gnd switch in AAD
Date: Mon,  6 Nov 2023 14:03:37 +0100
Message-ID: <20231106130307.425644837@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rau <David.Rau.opensource@dm.renesas.com>

[ Upstream commit e8ecffd9962fe051d53a0761921b26d653b3df6b ]

Enable Gnd switch to improve stability when Jack insert event
occurs, and then disable Gnd switch after Jack type detection
is finished.

Signed-off-by: David Rau <David.Rau.opensource@dm.renesas.com>
Link: https://lore.kernel.org/r/20231017021258.5929-1-David.Rau.opensource@dm.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/da7219-aad.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/da7219-aad.c b/sound/soc/codecs/da7219-aad.c
index 581b334a6631d..3bbe850916493 100644
--- a/sound/soc/codecs/da7219-aad.c
+++ b/sound/soc/codecs/da7219-aad.c
@@ -59,9 +59,6 @@ static void da7219_aad_btn_det_work(struct work_struct *work)
 	bool micbias_up = false;
 	int retries = 0;
 
-	/* Disable ground switch */
-	snd_soc_component_update_bits(component, 0xFB, 0x01, 0x00);
-
 	/* Drive headphones/lineout */
 	snd_soc_component_update_bits(component, DA7219_HP_L_CTRL,
 			    DA7219_HP_L_AMP_OE_MASK,
@@ -155,9 +152,6 @@ static void da7219_aad_hptest_work(struct work_struct *work)
 		tonegen_freq_hptest = cpu_to_le16(DA7219_AAD_HPTEST_RAMP_FREQ_INT_OSC);
 	}
 
-	/* Disable ground switch */
-	snd_soc_component_update_bits(component, 0xFB, 0x01, 0x00);
-
 	/* Ensure gain ramping at fastest rate */
 	gain_ramp_ctrl = snd_soc_component_read(component, DA7219_GAIN_RAMP_CTRL);
 	snd_soc_component_write(component, DA7219_GAIN_RAMP_CTRL, DA7219_GAIN_RAMP_RATE_X8);
@@ -421,6 +415,11 @@ static irqreturn_t da7219_aad_irq_thread(int irq, void *data)
 			 * handle a removal, and we can check at the end of
 			 * hptest if we have a valid result or not.
 			 */
+
+			cancel_delayed_work_sync(&da7219_aad->jack_det_work);
+			/* Disable ground switch */
+			snd_soc_component_update_bits(component, 0xFB, 0x01, 0x00);
+
 			if (statusa & DA7219_JACK_TYPE_STS_MASK) {
 				report |= SND_JACK_HEADSET;
 				mask |=	SND_JACK_HEADSET | SND_JACK_LINEOUT;
-- 
2.42.0



