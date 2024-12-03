Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BC11B3942;
	Tue,  3 Dec 2024 14:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237603; cv=none; b=pUueToyUqFVoctwaNjrBNkTmWir/rT/BH340wR2lI+icTk6sItPDVhZd/pC8EsNfyh4/VSNxglwgb+v4EnGDUxYUB7HLZF56WsGXBfAmxWfdjecSxZUuEpBHgSUq/Z+QAdJgV8EtjWg6sDr5EhJKAw4DJhx649+4JASW8SSn5LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237603; c=relaxed/simple;
	bh=ceIlcqodVsVT2CGVNt8FNJqzhcvBIn8lcA2cqHolpFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgmEJbEo3KO0MAw+OBmDXsbD1RTTPce4ur1ZRFwJFWuwxCQKv9B3Pzu9iuTtaZz6zvmYtqNtdiNaiISCf2XQaOGrTle1YIhVULtSPLNx3HUzsM5QQcjR7USP2texryvj1fUOE/eofegyehGMch6bb0NVrCZGqFk0qn4LVIRZyl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfODM6M8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfODM6M8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B841C4CECF;
	Tue,  3 Dec 2024 14:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237603;
	bh=ceIlcqodVsVT2CGVNt8FNJqzhcvBIn8lcA2cqHolpFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfODM6M8I2AFOK3d5lRZohn/oF34f1AFgYvtT7JsZi2+5GrqehzbymDP7HUtQXBp4
	 l4BjNa8tkVIOn4Mx1M0eX2GjM1zjgrhxJequr3bu8FVrt14eSSRaMmD4DwY+uqMM6K
	 WjyrjrINpTjJZzP61Y+7WPwtJS5ioWQ0g9G9JYo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Skladowski <a39.skl@gmail.com>,
	Mohammad Rafi Shaik <quic_mohs@quicinc.com>,
	Prasad Kumpatla <quic_pkumpatl@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 018/817] ASoC: codecs: wcd937x: relax the AUX PDM watchdog
Date: Tue,  3 Dec 2024 15:33:10 +0100
Message-ID: <20241203143956.353387556@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit 107a5c853eef5336a9846e7dd2f9184b6e3c07c7 ]

On a system with wcd937x, rxmacro and Qualcomm audio DSP, which is pretty
common set of devices on Qualcomm platforms, and due to the order of how
DAPM widgets are powered on (they are sorted), there is a small time window
when wcd937x chip is online and expects the flow of incoming data but
rxmacro is not yet online. When wcd937x is programmed to receive data
via AUX port then its AUX PDM watchdog is enabled in
wcd937x_codec_enable_aux_pa(). If due to some reasons the rxmacro and
soundwire machinery are delayed to start streaming data, then there is
a chance for this AUX PDM watchdog to reset the wcd937x codec. Such event
is not logged as a message and only wcd937x IRQ counter is increased
however there could be a lot of other reasons for that IRQ.
There is a similar opportunity for such delay during DAPM widgets power
down sequence.

If wcd937x codec reset happens on the start of the playback, then there
will be no sound and if such reset happens at the end of a playback then
it may generate additional clicks and pops noises.

On qrb4210 RB2 board without any debugging bits the wcd937x resets are
sometimes observed at the end of a playback though not always.
With some debugging messages or with some tracing enabled the AUX PDM
watchdog resets the wcd937x codec at the start of a playback and there
is no sound output at all.

In this patch:
 - TIMEOUT_SEL bit in PDM_WD_CTL2 register is set to increase the watchdog
reset delay to 100ms which eliminates the AUX PDM watchdog IRQs on
qrb4210 RB2 board completely and decreases the number of unwanted clicks
noises;

 - HOLD_OFF bit postpones triggering such watchdog IRQ till wcd937x codec
reset which usually happens at the end of a playback. This allows to
actually output some sound in case of debugging.

Cc: Adam Skladowski <a39.skl@gmail.com>
Cc: Mohammad Rafi Shaik <quic_mohs@quicinc.com>
Cc: Prasad Kumpatla <quic_pkumpatl@quicinc.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://patch.msgid.link/20241022033132.787416-3-alexey.klimov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd937x.c | 10 ++++++++--
 sound/soc/codecs/wcd937x.h |  4 ++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wcd937x.c b/sound/soc/codecs/wcd937x.c
index 63b25c321a03d..3c1224d8f2dff 100644
--- a/sound/soc/codecs/wcd937x.c
+++ b/sound/soc/codecs/wcd937x.c
@@ -715,12 +715,17 @@ static int wcd937x_codec_enable_aux_pa(struct snd_soc_dapm_widget *w,
 	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
 	struct wcd937x_priv *wcd937x = snd_soc_component_get_drvdata(component);
 	int hph_mode = wcd937x->hph_mode;
+	u8 val;
 
 	switch (event) {
 	case SND_SOC_DAPM_PRE_PMU:
+		val = WCD937X_DIGITAL_PDM_WD_CTL2_EN |
+		      WCD937X_DIGITAL_PDM_WD_CTL2_TIMEOUT_SEL |
+		      WCD937X_DIGITAL_PDM_WD_CTL2_HOLD_OFF;
 		snd_soc_component_update_bits(component,
 					      WCD937X_DIGITAL_PDM_WD_CTL2,
-					      BIT(0), BIT(0));
+					      WCD937X_DIGITAL_PDM_WD_CTL2_MASK,
+					      val);
 		break;
 	case SND_SOC_DAPM_POST_PMU:
 		usleep_range(1000, 1010);
@@ -741,7 +746,8 @@ static int wcd937x_codec_enable_aux_pa(struct snd_soc_dapm_widget *w,
 					hph_mode);
 		snd_soc_component_update_bits(component,
 					      WCD937X_DIGITAL_PDM_WD_CTL2,
-					      BIT(0), 0x00);
+					      WCD937X_DIGITAL_PDM_WD_CTL2_MASK,
+					      0x00);
 		break;
 	}
 
diff --git a/sound/soc/codecs/wcd937x.h b/sound/soc/codecs/wcd937x.h
index 37bff16e88ddd..a2bd47a93e507 100644
--- a/sound/soc/codecs/wcd937x.h
+++ b/sound/soc/codecs/wcd937x.h
@@ -391,6 +391,10 @@
 #define WCD937X_DIGITAL_PDM_WD_CTL0		0x3465
 #define WCD937X_DIGITAL_PDM_WD_CTL1		0x3466
 #define WCD937X_DIGITAL_PDM_WD_CTL2		0x3467
+#define WCD937X_DIGITAL_PDM_WD_CTL2_HOLD_OFF	BIT(2)
+#define WCD937X_DIGITAL_PDM_WD_CTL2_TIMEOUT_SEL	BIT(1)
+#define WCD937X_DIGITAL_PDM_WD_CTL2_EN		BIT(0)
+#define WCD937X_DIGITAL_PDM_WD_CTL2_MASK	GENMASK(2, 0)
 #define WCD937X_DIGITAL_INTR_MODE		0x346A
 #define WCD937X_DIGITAL_INTR_MASK_0		0x346B
 #define WCD937X_DIGITAL_INTR_MASK_1		0x346C
-- 
2.43.0



