Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5E642189D;
	Wed,  4 Feb 2026 15:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218424; cv=none; b=uapKxciFeQZESsPBB5+L4P2U3MgX8I56EY0QOTnwqG+Y4r52Uv6+cQyKRik9V3+TKj63rnZ7X5knBIFv0quj+edKqkj59PLvvZJ0YRgnMI/cZc+D8pDztvbOgKp5BFJoUKglWXY2rukH08Ral+MsUqPrtdrmggV2YrOKAbrKu1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218424; c=relaxed/simple;
	bh=rneGumcGLSl/rPcDY+0xI+N0i8FGhcC5zWWACzQf7n0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drjJp1vl1evfit2rApAl5dEs9jSGEitmRg3yYxBTj4bRUkJsfw6DvIvGOgt/L+lGwaAE0A6WzH3xr5KxZClnXM0VjrWSEKr89xbIqqowGaB4Nfb6MCu404PCaYewpd0mgnlCmr7BG2LKgZ8j6e1di6mHKAD8vzZ1j9Ixz2i4tcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCu5PlD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCu5PlD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B861EC4CEF7;
	Wed,  4 Feb 2026 15:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218424;
	bh=rneGumcGLSl/rPcDY+0xI+N0i8FGhcC5zWWACzQf7n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCu5PlD40LFjraH9Jpt+90uQwwTKRjzpkVwMAqpJfMR0m1xTlm0N0aXkOfMHz6ww5
	 62NDUIKVtgDQM82gXSGGtXXzYEUWHampTUYicwHuqOhfqHOaOuw2wuFFagxEtB9B70
	 wTbxdixajvEk4FzQVCu8U0b6pbFxzzNAuNdHgeIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 26/72] ASoC: fsl: imx-card: Do not force slot width to sample width
Date: Wed,  4 Feb 2026 15:40:29 +0100
Message-ID: <20260204143846.573371497@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


