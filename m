Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C6841C2F5;
	Wed,  4 Feb 2026 15:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218711; cv=none; b=JdjNC4fdBtEtrJox5vNWSQ1z07y8Vz/tSvKUNA8TCPu0AGxALzg77jG3Q2G4ZohN1fxztHJkW4Uwl8HxNPTW5MwFklzpj6Kp2OxMwPYGPWMxRMQEfGn9szuf9NUrZfsQ0fdL4He16eUDxrgIcnPY2KLfjR+I/NXDNCr5eae8vzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218711; c=relaxed/simple;
	bh=w7g5OUDPkeGSkB2p46TdxbkTcCVcD/E/FinkEBWaoro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0M1RtXWJpUvfprtUFRENth6WKdqz1WiuYKF7gOchunTy5JdKiHgqjrWZSDygYp56tqyACALJAPM3395OpB2GFHTF7D+gUsbjkixfLG8JHbw0AJ7amteYbGSWs6Pao+g3SR0yTTs2i7mUDRGneTgTJE9Jk3XWYviDRtutm3bRWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLFSnC/4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLFSnC/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC11C4CEF7;
	Wed,  4 Feb 2026 15:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218711;
	bh=w7g5OUDPkeGSkB2p46TdxbkTcCVcD/E/FinkEBWaoro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLFSnC/4jBcii5HutA85nus/li+5cEXhT7fxPcM2beUy9ulp32Rnv5+4tkOCqMAUz
	 sL/JKNvdVO4XMs4DOMOZ7h77Drc27cPCBleHusV4nF8USFO4PvxWsv7DKHbpy2f9OU
	 z8ez9jig/j8NUl/tJ9wSLa0w5F19ljqRvhIaB8Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 38/87] ASoC: fsl: imx-card: Do not force slot width to sample width
Date: Wed,  4 Feb 2026 15:40:36 +0100
Message-ID: <20260204143848.284498988@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -313,7 +313,6 @@ static int imx_aif_hw_params(struct snd_
 			      SND_SOC_DAIFMT_PDM;
 		} else {
 			slots = 2;
-			slot_width = params_physical_width(params);
 			fmt = (rtd->dai_link->dai_fmt & ~SND_SOC_DAIFMT_FORMAT_MASK) |
 			      SND_SOC_DAIFMT_I2S;
 		}


