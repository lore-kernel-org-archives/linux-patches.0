Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217A1136675;
	Tue, 14 May 2024 10:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682892; cv=none; b=N0Fmo8cDY9xkyUoP8dekxzbYl12ZTPzSBtV61T4vI0wUKt2ghdVykk2A0zLI4RtoJScM3Vv+vAk+wiVZeyPLXDUgySP7h0At2/VW+kt78OIMlpGNLP50H8143molwIsU3hWEMbnVzmJWgwJsz5FCiooB/Cv2NDiI/PjGEyy4tgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682892; c=relaxed/simple;
	bh=wpH5qPce3Iq8XDs6DjJ5tC/D9TDanMyldgTnyi1N7dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQxwdyQ1C/biL4tEMtODfhUAo2zEbnYLB+AFHhz3Ja1hpw2I+yz/9abDp5+EFI+DIFLIqqQq8sfxUSW1zf0C5yP7BTJMWNCOfuaWoKQsvbzqn1LX/iYK8lCq6jy5xdxYa6b+DapYPQZWCsPFGTBFeZ8TyNFMQ305+6zNTPjeGyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htxRSYvA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htxRSYvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EB1C32781;
	Tue, 14 May 2024 10:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682891;
	bh=wpH5qPce3Iq8XDs6DjJ5tC/D9TDanMyldgTnyi1N7dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htxRSYvAtak6xTcfAFYs89BnG9h8tmPqPqze+piHSojmVueh2PshSz1MqRVAQ0n9Q
	 HMpPzoS3dJC/m+2nFeG8E1T6W/+QVQWiQg1p8g4SdWZsRpo1KAaI8Sqwj3T6/lxfth
	 //8eVJ62M+aoiKSYDWZ3gOQeNvlDvy4oPCaI7+hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 128/336] ASoC: codecs: ES8326: Solve error interruption issue
Date: Tue, 14 May 2024 12:15:32 +0200
Message-ID: <20240514101043.434502185@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <zhangyi@everest-semi.com>

[ Upstream commit 8a655cee6c9d4588570ad0cb099c5660f9a44a12 ]

We got an error report about headphone type detection and button detection.
We fixed the headphone type detection error by adjusting the debounce timer
configuration. And we fixed the button detection error by disabling the
button detection feature when the headphone are unplugged and enabling it
when headphone are plugged in.

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
Link: https://msgid.link/r/20240402062043.20608-2-zhangyi@everest-semi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index cbcd02ec6ba42..fd1af97412bdd 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -757,6 +757,7 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 		regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x01);
 		regmap_write(es8326->regmap, ES8326_SYS_BIAS, 0x0a);
 		regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF, 0x0f, 0x03);
+		regmap_write(es8326->regmap, ES8326_INT_SOURCE, ES8326_INT_SRC_PIN9);
 		/*
 		 * Inverted HPJACK_POL bit to trigger one IRQ to double check HP Removal event
 		 */
@@ -779,6 +780,8 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 			 * set auto-check mode, then restart jack_detect_work after 400ms.
 			 * Don't report jack status.
 			 */
+			regmap_write(es8326->regmap, ES8326_INT_SOURCE,
+					(ES8326_INT_SRC_PIN9 | ES8326_INT_SRC_BUTTON));
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x01);
 			es8326_enable_micbias(es8326->component);
 			usleep_range(50000, 70000);
@@ -901,7 +904,7 @@ static int es8326_resume(struct snd_soc_component *component)
 	regmap_write(es8326->regmap, ES8326_VMIDSEL, 0x0E);
 	regmap_write(es8326->regmap, ES8326_ANA_LP, 0xf0);
 	usleep_range(10000, 15000);
-	regmap_write(es8326->regmap, ES8326_HPJACK_TIMER, 0xe9);
+	regmap_write(es8326->regmap, ES8326_HPJACK_TIMER, 0xd9);
 	regmap_write(es8326->regmap, ES8326_ANA_MICBIAS, 0xcb);
 	/* set headphone default type and detect pin */
 	regmap_write(es8326->regmap, ES8326_HPDET_TYPE, 0x83);
@@ -952,8 +955,7 @@ static int es8326_resume(struct snd_soc_component *component)
 	es8326_enable_micbias(es8326->component);
 	usleep_range(50000, 70000);
 	regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x00);
-	regmap_write(es8326->regmap, ES8326_INT_SOURCE,
-		    (ES8326_INT_SRC_PIN9 | ES8326_INT_SRC_BUTTON));
+	regmap_write(es8326->regmap, ES8326_INT_SOURCE, ES8326_INT_SRC_PIN9);
 	regmap_write(es8326->regmap, ES8326_INTOUT_IO,
 		     es8326->interrupt_clk);
 	regmap_write(es8326->regmap, ES8326_SDINOUT1_IO,
-- 
2.43.0



