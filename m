Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859363D413D;
	Wed,  4 Feb 2026 14:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217191; cv=none; b=qHxxHB88QF+hwGQVriRC3JuzINRn2OegvoNi6cNE4o43mJVgnLM635KfrsD8ydL64U9/Xu4uGx9pUF1ot9vCFklw455JlvclB4indszTR63ADOAFdcUIqk89kc4AzjSyOovwGvVPMbpVS/rzvxthdHwt0U4PAJmgN4UKbaKzrIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217191; c=relaxed/simple;
	bh=uMxIuzftJnZNmB6LyLiW7H6lvYr+RNaF9hgRw9qj5vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cekkbgjZPlDgOuStfPHbutl4JqBN+Z6dWGNaQzSNn/dqdcoKhh7FGgmKpVEMW24g8IscaQuqXznLFSThiQpYNy4ArnHsAfZuGeG8VGELSaYUknv5JeQ6SOZQ6E1PNaG77yuAeoOxZNzVtPcGRpBrXU28OlcKAfzKgOJp94yUjFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJTYMdH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJTYMdH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021C9C116C6;
	Wed,  4 Feb 2026 14:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217191;
	bh=uMxIuzftJnZNmB6LyLiW7H6lvYr+RNaF9hgRw9qj5vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJTYMdH2d6zN1B1EDDDbeVtRyoWNHHKFjCA/7EygurCjKmXCf+qwslP3fbLyTi12t
	 o7XKAVdgyVeqLiQrupV8+JqtqIyzB/QGyrTt7snmbanxZo12lNep/6gbskWaKwj1fP
	 6Ubfpj3HPyExq7jGvxJhDX9YVc13yDcSu22cZdto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 151/206] ASoC: fsl: imx-card: Do not force slot width to sample width
Date: Wed,  4 Feb 2026 15:39:42 +0100
Message-ID: <20260204143903.642792981@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@gmail.com>

commit 9210f5ff6318163835d9e42ee68006be4da0f531 upstream.

imx-card currently sets the slot width to the physical sample width
for I2S links. This breaks controllers that use fixed-width slots
(e.g. 32-bit FIFO words), causing the unused bits in the slot to
contain undefined data when playing 16-bit streams.

Do not override the slot width in the machine driver and let the CPU
DAI select an appropriate default instead. This matches the behavior
of simple-audio-card and avoids embedding controller-specific policy
in the machine driver.

On an i.MX8MP-based board using SAI as the I2S master with 32-bit slots,
playing 16-bit audio resulted in spurious frequencies and an incorrect
SAI data waveform, as the slot width was forced to 16 bits. After this
change, audio artifacts are eliminated and the 16-bit samples correctly
occupy the first half of the 32-bit slot, with the remaining bits padded
with zeroes.

Cc: stable@vger.kernel.org
Fixes: aa736700f42f ("ASoC: imx-card: Add imx-card machine driver")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://patch.msgid.link/20260118205030.1532696-1-festevam@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/imx-card.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -314,7 +314,6 @@ static int imx_aif_hw_params(struct snd_
 			      SND_SOC_DAIFMT_PDM;
 		} else {
 			slots = 2;
-			slot_width = params_physical_width(params);
 			fmt = (rtd->dai_link->dai_fmt & ~SND_SOC_DAIFMT_FORMAT_MASK) |
 			      SND_SOC_DAIFMT_I2S;
 		}


