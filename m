Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECFFD2F24
	for <patches@lists.linux.dev>; Thu,  3 Feb 2022 11:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290A4C340E4
	for <patches@lists.linux.dev>; Thu,  3 Feb 2022 11:12:45 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Thu, 3 Feb 2022 11:12:42 +0000
Resent-Message-ID: <Yfu4qqvGYaBRqrKV@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Thu, 03 Feb 2022 09:21:44 +0000
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=7cc7=SS=puri.sm=martin.kepplinger@kernel.org>)
	id 1nFYJC-00HBZs-BY
	for broonie@sirena.co.uk; Thu, 03 Feb 2022 09:21:44 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 56E5D60D29
	for <broonie@sirena.co.uk>; Thu,  3 Feb 2022 09:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id CEA93C340EC; Thu,  3 Feb 2022 09:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB6AAC340E4
	for <broonie@kernel.org>; Thu,  3 Feb 2022 09:21:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org BB6AAC340E4
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=puri.sm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=puri.sm
Received: from localhost (localhost [127.0.0.1])
	by comms.puri.sm (Postfix) with ESMTP id 2FD6DDFAB9;
	Thu,  3 Feb 2022 01:21:33 -0800 (PST)
Received: from comms.puri.sm ([127.0.0.1])
	by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rGQv4tBnuPp7; Thu,  3 Feb 2022 01:21:32 -0800 (PST)
Message-ID: <77418b2bac0c91002488f126db5a9d5b79416782.camel@puri.sm>
From: Martin Kepplinger <martin.kepplinger@puri.sm>
To: Charles Keepax <ckeepax@opensource.cirrus.com>, broonie@kernel.org
Cc: lgirdwood@gmail.com, shengjiu.wang@nxp.com, daniel.baluta@nxp.com, 
	patches@opensource.cirrus.com, alsa-devel@alsa-project.org
Date: Thu, 03 Feb 2022 10:21:28 +0100
In-Reply-To: <20220202164545.30457-1-ckeepax@opensource.cirrus.com>
References: <20220202164545.30457-1-ckeepax@opensource.cirrus.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=7cc7=SS=puri.sm=martin.kepplinger@kernel.org
Subject: Re: [PATCH] ASoC: wm8962: Allow switching between analog and
 digital inputs
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: pPK4PTBdVRNB

Am Mittwoch, dem 02.02.2022 um 16:45 +0000 schrieb Charles Keepax:
> When the DMIC_ENA bit is set the analogue inputs are disconnected
> from
> the digital core of the chip, in favour of the digital microphones.
> Currently the driver will always enable DMIC_ENA whilst the GPIOs are
> configured for the DMIC function, this means the user can't currently
> use both the analog inputs and the digital inputs in one system.
> 
> Add an additional DAPM mutex that allows switching between analog and
> digital inputs into the digital core.
> 
> Reported-by: Martin Kepplinger <martin.kepplinger@puri.sm>

Hi Charles, thank you again very much for this! You can make this

Reported-and-tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>


> Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
> ---
>  sound/soc/codecs/wm8962.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
> index a5584ba962dcf..2c41d31956aa8 100644
> --- a/sound/soc/codecs/wm8962.c
> +++ b/sound/soc/codecs/wm8962.c
> @@ -2049,6 +2049,13 @@ static SOC_ENUM_SINGLE_DECL(hpoutl_enum,
>  static const struct snd_kcontrol_new hpoutl_mux =
>         SOC_DAPM_ENUM("HPOUTL Mux", hpoutl_enum);
>  
> +static const char * const input_mode_text[] = { "Analog", "Digital"
> };
> +
> +static SOC_ENUM_SINGLE_VIRT_DECL(input_mode_enum, input_mode_text);
> +
> +static const struct snd_kcontrol_new input_mode_mux =
> +       SOC_DAPM_ENUM("Input Mode", input_mode_enum);
> +
>  static const struct snd_kcontrol_new inpgal[] = {
>  SOC_DAPM_SINGLE("IN1L Switch", WM8962_LEFT_INPUT_PGA_CONTROL, 3, 1,
> 0),
>  SOC_DAPM_SINGLE("IN2L Switch", WM8962_LEFT_INPUT_PGA_CONTROL, 2, 1,
> 0),
> @@ -2147,6 +2154,9 @@ SND_SOC_DAPM_MIXER("MIXINR", WM8962_PWR_MGMT_1,
> 4, 0,
>  
>  SND_SOC_DAPM_AIF_IN("DMIC_ENA", NULL, 0, WM8962_PWR_MGMT_1, 10, 0),
>  
> +SND_SOC_DAPM_MUX("Input Mode L", SND_SOC_NOPM, 0, 0,
> &input_mode_mux),
> +SND_SOC_DAPM_MUX("Input Mode R", SND_SOC_NOPM, 0, 0,
> &input_mode_mux),
> +
>  SND_SOC_DAPM_ADC("ADCL", "Capture", WM8962_PWR_MGMT_1, 3, 0),
>  SND_SOC_DAPM_ADC("ADCR", "Capture", WM8962_PWR_MGMT_1, 2, 0),
>  
> @@ -2226,16 +2236,19 @@ static const struct snd_soc_dapm_route
> wm8962_intercon[] = {
>  
>         { "DMIC_ENA", NULL, "DMICDAT" },
>  
> +       { "Input Mode L", "Analog", "MIXINL" },
> +       { "Input Mode L", "Digital", "DMIC_ENA" },
> +       { "Input Mode R", "Analog", "MIXINR" },
> +       { "Input Mode R", "Digital", "DMIC_ENA" },
> +
>         { "ADCL", NULL, "SYSCLK" },
>         { "ADCL", NULL, "TOCLK" },
> -       { "ADCL", NULL, "MIXINL" },
> -       { "ADCL", NULL, "DMIC_ENA" },
> +       { "ADCL", NULL, "Input Mode L" },
>         { "ADCL", NULL, "DSP2" },
>  
>         { "ADCR", NULL, "SYSCLK" },
>         { "ADCR", NULL, "TOCLK" },
> -       { "ADCR", NULL, "MIXINR" },
> -       { "ADCR", NULL, "DMIC_ENA" },
> +       { "ADCR", NULL, "Input Mode R" },
>         { "ADCR", NULL, "DSP2" },
>  
>         { "STL", "Left", "ADCL" },


