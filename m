Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3860346B3
	for <patches@lists.linux.dev>; Wed, 13 Jul 2022 17:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF88C34114
	for <patches@lists.linux.dev>; Wed, 13 Jul 2022 17:32:52 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 13 Jul 2022 18:32:48 +0100
Resent-Message-ID: <Ys8BwCCxh/7wIsu7@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 13 Jul 2022 15:25:03 +0100
Received: from ams.source.kernel.org ([145.40.68.75])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=/8Ij=XS=arm.com=alexandru.elisei@kernel.org>)
	id 1oBdIT-004RL1-UW
	for broonie@sirena.co.uk; Wed, 13 Jul 2022 15:25:03 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id A82A6B8201A
	for <broonie@sirena.co.uk>; Wed, 13 Jul 2022 14:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 5F6B4C3411E; Wed, 13 Jul 2022 14:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTP id 0755BC34114
	for <broonie@kernel.org>; Wed, 13 Jul 2022 14:24:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 0755BC34114
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC0A41424;
	Wed, 13 Jul 2022 07:24:57 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 867113F73D;
	Wed, 13 Jul 2022 07:24:56 -0700 (PDT)
Date: Wed, 13 Jul 2022 15:25:27 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Chen-Yu Tsai <wenst@chromium.org>, Liam Girdwood <lgirdwood@gmail.com>,
	alsa-devel@alsa-project.org
Message-ID: <Ys7SS/ueE66CBpZK@monolith.localdoman>
References: <20220713130451.31481-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220713130451.31481-1-broonie@kernel.org>
X-SA-Exim-Connect-IP: 145.40.68.75
X-SA-Exim-Mail-From: SRS0=/8Ij=XS=arm.com=alexandru.elisei@kernel.org
Subject: Re: [PATCH] ASoC: rockchip-i2s: Undo BCLK pinctrl changes
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: ysecvIRu69MY

Hi,

On Wed, Jul 13, 2022 at 02:04:51PM +0100, Mark Brown wrote:
> The version of the BCLK pinctrl management changes that made it into
> v5.19 has caused problems on some systems due to overly strict DT
> requirements but attempts to fix it have caused further breakage on
> other platforms.  Just drop the changes for this release, we already
> have a better version queued for -next.

For what it's worth, I am now able to boot my rockpro64-v2 with this patch.

Thanks,
Alex

> 
> Fixes: 26b9f2fa7b1c ("ASoC: rockchip: i2s: Fix NULL pointer dereference when pinctrl is not found")
> Fixes: a5450aba737d ("ASoC: rockchip: i2s: switch BCLK to GPIO")
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  sound/soc/rockchip/rockchip_i2s.c | 163 ++++++------------------------
>  1 file changed, 31 insertions(+), 132 deletions(-)
> 
> diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
> index c9fedf6eb2e6..4ce5d2579387 100644
> --- a/sound/soc/rockchip/rockchip_i2s.c
> +++ b/sound/soc/rockchip/rockchip_i2s.c
> @@ -13,7 +13,6 @@
>  #include <linux/of_gpio.h>
>  #include <linux/of_device.h>
>  #include <linux/clk.h>
> -#include <linux/pinctrl/consumer.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/regmap.h>
>  #include <linux/spinlock.h>
> @@ -55,40 +54,8 @@ struct rk_i2s_dev {
>  	const struct rk_i2s_pins *pins;
>  	unsigned int bclk_ratio;
>  	spinlock_t lock; /* tx/rx lock */
> -	struct pinctrl *pinctrl;
> -	struct pinctrl_state *bclk_on;
> -	struct pinctrl_state *bclk_off;
>  };
>  
> -static int i2s_pinctrl_select_bclk_on(struct rk_i2s_dev *i2s)
> -{
> -	int ret = 0;
> -
> -	if (!IS_ERR(i2s->pinctrl) && !IS_ERR_OR_NULL(i2s->bclk_on))
> -		ret = pinctrl_select_state(i2s->pinctrl,
> -				     i2s->bclk_on);
> -
> -	if (ret)
> -		dev_err(i2s->dev, "bclk enable failed %d\n", ret);
> -
> -	return ret;
> -}
> -
> -static int i2s_pinctrl_select_bclk_off(struct rk_i2s_dev *i2s)
> -{
> -
> -	int ret = 0;
> -
> -	if (!IS_ERR(i2s->pinctrl) && !IS_ERR_OR_NULL(i2s->bclk_off))
> -		ret = pinctrl_select_state(i2s->pinctrl,
> -				     i2s->bclk_off);
> -
> -	if (ret)
> -		dev_err(i2s->dev, "bclk disable failed %d\n", ret);
> -
> -	return ret;
> -}
> -
>  static int i2s_runtime_suspend(struct device *dev)
>  {
>  	struct rk_i2s_dev *i2s = dev_get_drvdata(dev);
> @@ -125,49 +92,38 @@ static inline struct rk_i2s_dev *to_info(struct snd_soc_dai *dai)
>  	return snd_soc_dai_get_drvdata(dai);
>  }
>  
> -static int rockchip_snd_txctrl(struct rk_i2s_dev *i2s, int on)
> +static void rockchip_snd_txctrl(struct rk_i2s_dev *i2s, int on)
>  {
>  	unsigned int val = 0;
>  	int retry = 10;
> -	int ret = 0;
>  
>  	spin_lock(&i2s->lock);
>  	if (on) {
> -		ret = regmap_update_bits(i2s->regmap, I2S_DMACR,
> -				I2S_DMACR_TDE_ENABLE, I2S_DMACR_TDE_ENABLE);
> -		if (ret < 0)
> -			goto end;
> +		regmap_update_bits(i2s->regmap, I2S_DMACR,
> +				   I2S_DMACR_TDE_ENABLE, I2S_DMACR_TDE_ENABLE);
>  
> -		ret = regmap_update_bits(i2s->regmap, I2S_XFER,
> -				I2S_XFER_TXS_START | I2S_XFER_RXS_START,
> -				I2S_XFER_TXS_START | I2S_XFER_RXS_START);
> -		if (ret < 0)
> -			goto end;
> +		regmap_update_bits(i2s->regmap, I2S_XFER,
> +				   I2S_XFER_TXS_START | I2S_XFER_RXS_START,
> +				   I2S_XFER_TXS_START | I2S_XFER_RXS_START);
>  
>  		i2s->tx_start = true;
>  	} else {
>  		i2s->tx_start = false;
>  
> -		ret = regmap_update_bits(i2s->regmap, I2S_DMACR,
> -				I2S_DMACR_TDE_ENABLE, I2S_DMACR_TDE_DISABLE);
> -		if (ret < 0)
> -			goto end;
> +		regmap_update_bits(i2s->regmap, I2S_DMACR,
> +				   I2S_DMACR_TDE_ENABLE, I2S_DMACR_TDE_DISABLE);
>  
>  		if (!i2s->rx_start) {
> -			ret = regmap_update_bits(i2s->regmap, I2S_XFER,
> -					I2S_XFER_TXS_START |
> -					I2S_XFER_RXS_START,
> -					I2S_XFER_TXS_STOP |
> -					I2S_XFER_RXS_STOP);
> -			if (ret < 0)
> -				goto end;
> +			regmap_update_bits(i2s->regmap, I2S_XFER,
> +					   I2S_XFER_TXS_START |
> +					   I2S_XFER_RXS_START,
> +					   I2S_XFER_TXS_STOP |
> +					   I2S_XFER_RXS_STOP);
>  
>  			udelay(150);
> -			ret = regmap_update_bits(i2s->regmap, I2S_CLR,
> -					I2S_CLR_TXC | I2S_CLR_RXC,
> -					I2S_CLR_TXC | I2S_CLR_RXC);
> -			if (ret < 0)
> -				goto end;
> +			regmap_update_bits(i2s->regmap, I2S_CLR,
> +					   I2S_CLR_TXC | I2S_CLR_RXC,
> +					   I2S_CLR_TXC | I2S_CLR_RXC);
>  
>  			regmap_read(i2s->regmap, I2S_CLR, &val);
>  
> @@ -182,57 +138,44 @@ static int rockchip_snd_txctrl(struct rk_i2s_dev *i2s, int on)
>  			}
>  		}
>  	}
> -end:
>  	spin_unlock(&i2s->lock);
> -	if (ret < 0)
> -		dev_err(i2s->dev, "lrclk update failed\n");
> -
> -	return ret;
>  }
>  
> -static int rockchip_snd_rxctrl(struct rk_i2s_dev *i2s, int on)
> +static void rockchip_snd_rxctrl(struct rk_i2s_dev *i2s, int on)
>  {
>  	unsigned int val = 0;
>  	int retry = 10;
> -	int ret = 0;
>  
>  	spin_lock(&i2s->lock);
>  	if (on) {
> -		ret = regmap_update_bits(i2s->regmap, I2S_DMACR,
> +		regmap_update_bits(i2s->regmap, I2S_DMACR,
>  				   I2S_DMACR_RDE_ENABLE, I2S_DMACR_RDE_ENABLE);
> -		if (ret < 0)
> -			goto end;
>  
> -		ret = regmap_update_bits(i2s->regmap, I2S_XFER,
> +		regmap_update_bits(i2s->regmap, I2S_XFER,
>  				   I2S_XFER_TXS_START | I2S_XFER_RXS_START,
>  				   I2S_XFER_TXS_START | I2S_XFER_RXS_START);
> -		if (ret < 0)
> -			goto end;
>  
>  		i2s->rx_start = true;
>  	} else {
>  		i2s->rx_start = false;
>  
> -		ret = regmap_update_bits(i2s->regmap, I2S_DMACR,
> +		regmap_update_bits(i2s->regmap, I2S_DMACR,
>  				   I2S_DMACR_RDE_ENABLE, I2S_DMACR_RDE_DISABLE);
> -		if (ret < 0)
> -			goto end;
>  
>  		if (!i2s->tx_start) {
> -			ret = regmap_update_bits(i2s->regmap, I2S_XFER,
> +			regmap_update_bits(i2s->regmap, I2S_XFER,
>  					   I2S_XFER_TXS_START |
>  					   I2S_XFER_RXS_START,
>  					   I2S_XFER_TXS_STOP |
>  					   I2S_XFER_RXS_STOP);
> -			if (ret < 0)
> -				goto end;
> +
>  			udelay(150);
> -			ret = regmap_update_bits(i2s->regmap, I2S_CLR,
> +			regmap_update_bits(i2s->regmap, I2S_CLR,
>  					   I2S_CLR_TXC | I2S_CLR_RXC,
>  					   I2S_CLR_TXC | I2S_CLR_RXC);
> -			if (ret < 0)
> -				goto end;
> +
>  			regmap_read(i2s->regmap, I2S_CLR, &val);
> +
>  			/* Should wait for clear operation to finish */
>  			while (val) {
>  				regmap_read(i2s->regmap, I2S_CLR, &val);
> @@ -244,12 +187,7 @@ static int rockchip_snd_rxctrl(struct rk_i2s_dev *i2s, int on)
>  			}
>  		}
>  	}
> -end:
>  	spin_unlock(&i2s->lock);
> -	if (ret < 0)
> -		dev_err(i2s->dev, "lrclk update failed\n");
> -
> -	return ret;
>  }
>  
>  static int rockchip_i2s_set_fmt(struct snd_soc_dai *cpu_dai,
> @@ -487,26 +425,17 @@ static int rockchip_i2s_trigger(struct snd_pcm_substream *substream,
>  	case SNDRV_PCM_TRIGGER_RESUME:
>  	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
>  		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
> -			ret = rockchip_snd_rxctrl(i2s, 1);
> +			rockchip_snd_rxctrl(i2s, 1);
>  		else
> -			ret = rockchip_snd_txctrl(i2s, 1);
> -		/* Do not turn on bclk if lrclk open fails. */
> -		if (ret < 0)
> -			return ret;
> -		i2s_pinctrl_select_bclk_on(i2s);
> +			rockchip_snd_txctrl(i2s, 1);
>  		break;
>  	case SNDRV_PCM_TRIGGER_SUSPEND:
>  	case SNDRV_PCM_TRIGGER_STOP:
>  	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> -		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
> -			if (!i2s->tx_start)
> -				i2s_pinctrl_select_bclk_off(i2s);
> -			ret = rockchip_snd_rxctrl(i2s, 0);
> -		} else {
> -			if (!i2s->rx_start)
> -				i2s_pinctrl_select_bclk_off(i2s);
> -			ret = rockchip_snd_txctrl(i2s, 0);
> -		}
> +		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
> +			rockchip_snd_rxctrl(i2s, 0);
> +		else
> +			rockchip_snd_txctrl(i2s, 0);
>  		break;
>  	default:
>  		ret = -EINVAL;
> @@ -807,36 +736,6 @@ static int rockchip_i2s_probe(struct platform_device *pdev)
>  	}
>  
>  	i2s->bclk_ratio = 64;
> -	i2s->pinctrl = devm_pinctrl_get(&pdev->dev);
> -	if (IS_ERR(i2s->pinctrl)) {
> -		dev_err(&pdev->dev, "failed to find i2s pinctrl\n");
> -		ret = PTR_ERR(i2s->pinctrl);
> -		goto err_clk;
> -	}
> -
> -	i2s->bclk_on = pinctrl_lookup_state(i2s->pinctrl,
> -				   "bclk_on");
> -	if (IS_ERR_OR_NULL(i2s->bclk_on))
> -		dev_err(&pdev->dev, "failed to find i2s default state\n");
> -	else
> -		dev_dbg(&pdev->dev, "find i2s bclk state\n");
> -
> -	i2s->bclk_off = pinctrl_lookup_state(i2s->pinctrl,
> -				  "bclk_off");
> -	if (IS_ERR_OR_NULL(i2s->bclk_off))
> -		dev_err(&pdev->dev, "failed to find i2s gpio state\n");
> -	else
> -		dev_dbg(&pdev->dev, "find i2s bclk_off state\n");
> -
> -	i2s_pinctrl_select_bclk_off(i2s);
> -
> -	i2s->playback_dma_data.addr = res->start + I2S_TXDR;
> -	i2s->playback_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
> -	i2s->playback_dma_data.maxburst = 4;
> -
> -	i2s->capture_dma_data.addr = res->start + I2S_RXDR;
> -	i2s->capture_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
> -	i2s->capture_dma_data.maxburst = 4;
>  
>  	dev_set_drvdata(&pdev->dev, i2s);
>  
> -- 
> 2.30.2
> 
