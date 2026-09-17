Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FF53939A3;
	Thu, 17 Sep 2026 15:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659039; cv=none; b=cEx3SCIS0yhiQOYEqrKyw8O2kEAqZ+j05RlH3mjbOZxiJ4RJdhP0v4EBegFz6hxEYuRtEOO1VfjB+cXEKoWJAvhbGe0I/yYLxl3Plj37mLTC/dYB4bBT+CLdXEZS9TnRXL9YYIvTDsuyXf5C2L/OnJt1MdvhQgz4Dmj6iy8idZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659039; c=relaxed/simple;
	bh=WtvHap/VksEFhF20HouaNm7/oh2GMUir+Q5mGIGDJz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPx+JranHpawk/7oXGhLgmRxGhh3GkzaahZnsl4xR+t3ulnhOjYVrR2BsBkxHSil4iPcOUKrYgSz+m+R+gQzRzAHXX8HRaU//BTgh4CzP7OGRO9jgFpYDFj4d1+aQeIKw7VvchNJUt0TAgzAjpwBdZmb4qLbUan5TL4SJjDa5Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PiVNNBp6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PiVNNBp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7C21F000FF;
	Thu, 17 Sep 2026 15:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659031;
	bh=c5dWH9Hm2wno2/xpJzKAD6OBX1rnfs/8f6hQgYUlm68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PiVNNBp6XJLoQ2Oq+KTyVWpj1kQzQOIyex0MCT7eTaizdnQlWpQTC0r1pR05w3Sha
	 k/VtCGwpUMPSsUJ/WFGGJdmVDFaFXqXGzZzBREhBHYJgyoT+NQzT//1ZJiEWHZICS9
	 napScQuTNLfT1P9OnP5E9guUuLYsz3F8gCMuE6D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 118/733] ASoC: ab8500: Repair the DAPM capture graph
Date: Thu, 17 Sep 2026 16:07:06 +0100
Message-ID: <20260917151353.940853277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 103fe1a37f040ef6ac9ed1cf33be786149d2bb15 ]

The capture stream routes point away from the stream widget. Digital
microphone mux routes are unconditional and bypass their enable bits,
and several widgets independently own shared AD path enable bits. The
dummy ADC and DAC widgets hide the resulting power graph errors.

Connect each real AIF widget to the stream and main supply, use the mux
item names on digital microphone routes, and model shared AD enables as
supplies. Also make the ANC DAPM switch writable.

Fixes: 679d7abdc754 ("ASoC: codecs: Add AB8500 codec-driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260831-ab8500-codec-fixes-v1-2-f85024e717e3@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ab8500-codec.c | 120 +++++++++++++++-----------------
 1 file changed, 56 insertions(+), 64 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 2f920eb907254..7137561ef9309 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -258,7 +258,7 @@ static const struct snd_kcontrol_new dapm_anc_in_select[] = {
 /* ANC - Enable/Disable */
 static const struct snd_kcontrol_new dapm_anc_enable[] = {
 	SOC_DAPM_SINGLE("Switch", AB8500_ANCCONF1,
-			AB8500_ANCCONF1_ENANC, 0, 0),
+			AB8500_ANCCONF1_ENANC, 1, 0),
 };
 
 /* ANC to Earpiece - Mute */
@@ -340,12 +340,6 @@ static const struct snd_soc_dapm_widget ab8500_dapm_widgets[] = {
 
 	/* DA/AD */
 
-	SND_SOC_DAPM_INPUT("ADC Input"),
-	SND_SOC_DAPM_ADC("ADC", "ab8500_0c", SND_SOC_NOPM, 0, 0),
-
-	SND_SOC_DAPM_DAC("DAC", NULL, SND_SOC_NOPM, 0, 0),
-	SND_SOC_DAPM_OUTPUT("DAC Output"),
-
 	SND_SOC_DAPM_AIF_IN("DA_IN1", NULL, 0, SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_AIF_IN("DA_IN2", NULL, 0, SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_AIF_IN("DA_IN3", NULL, 0, SND_SOC_NOPM, 0, 0),
@@ -537,9 +531,8 @@ static const struct snd_soc_dapm_widget ab8500_dapm_widgets[] = {
 	SND_SOC_DAPM_MIXER("AD3 Channel Volume",
 			SND_SOC_NOPM, 0, 0,
 			NULL, 0),
-	SND_SOC_DAPM_MIXER("AD3 Enable",
-			AB8500_ADPATHENA, AB8500_ADPATHENA_ENAD34, 0,
-			NULL, 0),
+	SND_SOC_DAPM_SUPPLY("AD34 Enable", AB8500_ADPATHENA,
+			    AB8500_ADPATHENA_ENAD34, 0, NULL, 0),
 
 	/* Mic 2 */
 
@@ -598,9 +591,8 @@ static const struct snd_soc_dapm_widget ab8500_dapm_widgets[] = {
 			SND_SOC_NOPM, 0, 0,
 			NULL, 0),
 
-	SND_SOC_DAPM_MIXER("AD12 Enable",
-			AB8500_ADPATHENA, AB8500_ADPATHENA_ENAD12, 0,
-			NULL, 0),
+	SND_SOC_DAPM_SUPPLY("AD12 Enable", AB8500_ADPATHENA,
+			    AB8500_ADPATHENA_ENAD12, 0, NULL, 0),
 
 	/* HD Capture path */
 
@@ -614,12 +606,8 @@ static const struct snd_soc_dapm_widget ab8500_dapm_widgets[] = {
 	SND_SOC_DAPM_MIXER("AD6 Channel Volume",
 			SND_SOC_NOPM, 0, 0,
 			NULL, 0),
-	SND_SOC_DAPM_MIXER("AD57 Enable",
-			AB8500_ADPATHENA, AB8500_ADPATHENA_ENAD5768, 0,
-			NULL, 0),
-	SND_SOC_DAPM_MIXER("AD68 Enable",
-			AB8500_ADPATHENA, AB8500_ADPATHENA_ENAD5768, 0,
-			NULL, 0),
+	SND_SOC_DAPM_SUPPLY("AD5768 Enable", AB8500_ADPATHENA,
+			    AB8500_ADPATHENA_ENAD5768, 0, NULL, 0),
 
 	/* Digital Microphone path */
 
@@ -651,10 +639,6 @@ static const struct snd_soc_dapm_widget ab8500_dapm_widgets[] = {
 	SND_SOC_DAPM_MIXER("AD4 Channel Volume",
 			SND_SOC_NOPM, 0, 0,
 			NULL, 0),
-	SND_SOC_DAPM_MIXER("AD4 Enable",
-			AB8500_ADPATHENA, AB8500_ADPATHENA_ENAD34,
-			0, NULL, 0),
-
 	/* Acoustical Noise Cancellation path */
 
 	SND_SOC_DAPM_INPUT("ANC Configure Input"),
@@ -702,24 +686,17 @@ static const struct snd_soc_dapm_route ab8500_dapm_routes[] = {
 	{"Main Supply", NULL, "Audio Power"},
 	{"Main Supply", NULL, "Audio Analog Power"},
 
-	{"DAC", NULL, "ab8500_0p"},
-	{"DAC", NULL, "Main Supply"},
-	{"ADC", NULL, "ab8500_0c"},
-	{"ADC", NULL, "Main Supply"},
-
 	/* ANC Configure */
 	{"ANC Configure Input", NULL, "Main Supply"},
 	{"ANC Configure Output", NULL, "ANC Configure Input"},
 
-	/* AD/DA */
-	{"ADC", NULL, "ADC Input"},
-	{"DAC Output", NULL, "DAC"},
-
 	/* Powerup charge pump if DA1/2 is in use */
 
 	{"DA_IN1", NULL, "ab8500_0p"},
+	{"DA_IN1", NULL, "Main Supply"},
 	{"DA_IN1", NULL, "Charge Pump"},
 	{"DA_IN2", NULL, "ab8500_0p"},
+	{"DA_IN2", NULL, "Main Supply"},
 	{"DA_IN2", NULL, "Charge Pump"},
 
 	/* Headset path */
@@ -754,8 +731,10 @@ static const struct snd_soc_dapm_route ab8500_dapm_routes[] = {
 	/* HF or LineOut path */
 
 	{"DA_IN3", NULL, "ab8500_0p"},
+	{"DA_IN3", NULL, "Main Supply"},
 	{"DA3 Channel Volume", NULL, "DA_IN3"},
 	{"DA_IN4", NULL, "ab8500_0p"},
+	{"DA_IN4", NULL, "Main Supply"},
 	{"DA4 Channel Volume", NULL, "DA_IN4"},
 
 	{"Speaker Left Source", "Audio Path", "DA3 Channel Volume"},
@@ -813,8 +792,10 @@ static const struct snd_soc_dapm_route ab8500_dapm_routes[] = {
 	/* Vibrator path */
 
 	{"DA_IN5", NULL, "ab8500_0p"},
+	{"DA_IN5", NULL, "Main Supply"},
 	{"DA5 Channel Volume", NULL, "DA_IN5"},
 	{"DA_IN6", NULL, "ab8500_0p"},
+	{"DA_IN6", NULL, "Main Supply"},
 	{"DA6 Channel Volume", NULL, "DA_IN6"},
 
 	{"VIB1 DAC", NULL, "DA5 Channel Volume"},
@@ -856,13 +837,15 @@ static const struct snd_soc_dapm_route ab8500_dapm_routes[] = {
 	{"AD1 Channel Volume", NULL, "AD1 Source Select"},
 	{"AD2 Channel Volume", NULL, "AD2 Source Select"},
 
-	{"AD12 Enable", NULL, "AD1 Channel Volume"},
-	{"AD12 Enable", NULL, "AD2 Channel Volume"},
+	{"AD1 Channel Volume", NULL, "AD12 Enable"},
+	{"AD2 Channel Volume", NULL, "AD12 Enable"},
 
-	{"AD_OUT1", NULL, "ab8500_0c"},
-	{"AD_OUT1", NULL, "AD12 Enable"},
-	{"AD_OUT2", NULL, "ab8500_0c"},
-	{"AD_OUT2", NULL, "AD12 Enable"},
+	{"ab8500_0c", NULL, "AD_OUT1"},
+	{"AD_OUT1", NULL, "Main Supply"},
+	{"AD_OUT1", NULL, "AD1 Channel Volume"},
+	{"ab8500_0c", NULL, "AD_OUT2"},
+	{"AD_OUT2", NULL, "Main Supply"},
+	{"AD_OUT2", NULL, "AD2 Channel Volume"},
 
 	/* Mic 1 */
 
@@ -879,11 +862,11 @@ static const struct snd_soc_dapm_route ab8500_dapm_routes[] = {
 	{"AD3 Source Select", "Mic 1", "MIC1 ADC"},
 
 	{"AD3 Channel Volume", NULL, "AD3 Source Select"},
+	{"AD3 Channel Volume", NULL, "AD34 Enable"},
 
-	{"AD3 Enable", NULL, "AD3 Channel Volume"},
-
-	{"AD_OUT3", NULL, "ab8500_0c"},
-	{"AD_OUT3", NULL, "AD3 Enable"},
+	{"ab8500_0c", NULL, "AD_OUT3"},
+	{"AD_OUT3", NULL, "Main Supply"},
+	{"AD_OUT3", NULL, "AD3 Channel Volume"},
 
 	/* HD Capture path */
 
@@ -892,14 +875,15 @@ static const struct snd_soc_dapm_route ab8500_dapm_routes[] = {
 
 	{"AD5 Channel Volume", NULL, "AD5 Source Select"},
 	{"AD6 Channel Volume", NULL, "AD6 Source Select"},
+	{"AD5 Channel Volume", NULL, "AD5768 Enable"},
+	{"AD6 Channel Volume", NULL, "AD5768 Enable"},
 
-	{"AD57 Enable", NULL, "AD5 Channel Volume"},
-	{"AD68 Enable", NULL, "AD6 Channel Volume"},
-
-	{"AD_OUT57", NULL, "ab8500_0c"},
-	{"AD_OUT57", NULL, "AD57 Enable"},
-	{"AD_OUT68", NULL, "ab8500_0c"},
-	{"AD_OUT68", NULL, "AD68 Enable"},
+	{"ab8500_0c", NULL, "AD_OUT57"},
+	{"AD_OUT57", NULL, "Main Supply"},
+	{"AD_OUT57", NULL, "AD5 Channel Volume"},
+	{"ab8500_0c", NULL, "AD_OUT68"},
+	{"AD_OUT68", NULL, "Main Supply"},
+	{"AD_OUT68", NULL, "AD6 Channel Volume"},
 
 	/* Digital Microphone path */
 
@@ -910,17 +894,25 @@ static const struct snd_soc_dapm_route ab8500_dapm_routes[] = {
 	{"DMic 5", NULL, "V-DMIC"},
 	{"DMic 6", NULL, "V-DMIC"},
 
-	{"AD1 Source Select", NULL, "DMic 1"},
-	{"AD2 Source Select", NULL, "DMic 2"},
-	{"AD3 Source Select", NULL, "DMic 3"},
-	{"AD5 Source Select", NULL, "DMic 5"},
-	{"AD6 Source Select", NULL, "DMic 6"},
+	{"DMIC1", NULL, "DMic 1"},
+	{"DMIC2", NULL, "DMic 2"},
+	{"DMIC3", NULL, "DMic 3"},
+	{"DMIC4", NULL, "DMic 4"},
+	{"DMIC5", NULL, "DMic 5"},
+	{"DMIC6", NULL, "DMic 6"},
+
+	{"AD1 Source Select", "DMic 1", "DMIC1"},
+	{"AD2 Source Select", "DMic 2", "DMIC2"},
+	{"AD3 Source Select", "DMic 3", "DMIC3"},
+	{"AD5 Source Select", "DMic 5", "DMIC5"},
+	{"AD6 Source Select", "DMic 6", "DMIC6"},
 
-	{"AD4 Channel Volume", NULL, "DMic 4"},
-	{"AD4 Enable", NULL, "AD4 Channel Volume"},
+	{"AD4 Channel Volume", NULL, "DMIC4"},
+	{"AD4 Channel Volume", NULL, "AD34 Enable"},
 
-	{"AD_OUT4", NULL, "ab8500_0c"},
-	{"AD_OUT4", NULL, "AD4 Enable"},
+	{"ab8500_0c", NULL, "AD_OUT4"},
+	{"AD_OUT4", NULL, "Main Supply"},
+	{"AD_OUT4", NULL, "AD4 Channel Volume"},
 
 	/* LineIn Bypass path */
 
@@ -945,13 +937,13 @@ static const struct snd_soc_dapm_route ab8500_dapm_routes[] = {
 
 	/* Sidetone Filter path */
 
-	{"Sidetone Left Source", "LineIn Left", "AD12 Enable"},
-	{"Sidetone Left Source", "LineIn Right", "AD12 Enable"},
-	{"Sidetone Left Source", "Mic 1", "AD3 Enable"},
+	{"Sidetone Left Source", "LineIn Left", "AD1 Channel Volume"},
+	{"Sidetone Left Source", "LineIn Right", "AD2 Channel Volume"},
+	{"Sidetone Left Source", "Mic 1", "AD3 Channel Volume"},
 	{"Sidetone Left Source", "Headset Left", "DA_IN1"},
-	{"Sidetone Right Source", "LineIn Right", "AD12 Enable"},
-	{"Sidetone Right Source", "Mic 1", "AD3 Enable"},
-	{"Sidetone Right Source", "DMic 4", "AD4 Enable"},
+	{"Sidetone Right Source", "LineIn Right", "AD2 Channel Volume"},
+	{"Sidetone Right Source", "Mic 1", "AD3 Channel Volume"},
+	{"Sidetone Right Source", "DMic 4", "AD4 Channel Volume"},
 	{"Sidetone Right Source", "Headset Right", "DA_IN2"},
 
 	{"STFIR1 Control", NULL, "Sidetone Left Source"},
-- 
2.53.0



