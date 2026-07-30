Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8CC41A4FF;
	Thu, 30 Jul 2026 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423030; cv=none; b=YnAtWM7wjV2JUYzRveKmGXOL2AmYdGDRYrUgKyjoM1PIxnk+rwvtsFL7n9BGC31BcDtJ+SXNLtWiKllYdIa51OTzLey9CjNrVxO37coZM85F8QDi0LyLGGml2r35P4hccdaNKgBySa94stIA5uQZHSkQsCKpKc36jHKtgOF+aE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423030; c=relaxed/simple;
	bh=ZHdgUGsPS8+TMyN/HdTFmDM6Rm+zvcnEUM4INB1++I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mt0JaIeOP3bWHDHyVS4f4S7uRJYUevYcwGPzLu0V3tYZBY2e6/ywHDZTb75NCKXwAFoPaFO4AyA8J1tlClZhmEvsCt8Ku+8oMgi5hylxmn44lHgonV/j2bGgpetap6/1/4cHlzl/g3zv/IVveDHg56CMnLze5ap3aShkIinp+Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLfeBjnc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLfeBjnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5771E1F000E9;
	Thu, 30 Jul 2026 14:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423028;
	bh=TPoAN/ket7LVYs7L/5B55xb5WN/1xSe0tEjLEVYuzN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLfeBjncgp1bx7J/Pn7Z4rbdyEMIKPcJpXN0KUz2W1EtO1MjJmSapKYvv0TuUM8wE
	 IlFkfRE1t+d2Qh+kOp2uLjHAXqRU7y5IWVLlIpbu1uiFJUpZfc1/m6q4Gvmmu+tW9w
	 xHr931/wHvk5Sf8jCjiaf+X0VPln53LF8gDfafdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 639/744] ASoC: fsl: imx-card: Skip sysclk reset for active DAIs in shutdown
Date: Thu, 30 Jul 2026 16:15:12 +0200
Message-ID: <20260730141457.853780613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chancel Liu <chancel.liu@nxp.com>

commit 9f86aea992568c2b4db78c80ff9508af9e050ff7 upstream.

In a full-duplex setup, when one direction (playback or capture) is
closed while the other is still running, imx_aif_shutdown() was
unconditionally calling snd_soc_dai_set_sysclk() with rate=0 for all
cpu/codec DAIs, which would disable the clock still needed by the
active stream.

Add snd_soc_dai_active() checks before clearing sysclk so that only
truly inactive DAIs have their clocks reset.

Fixes: 2260bc6ea8bd ("ASoC: imx-card: Add WM8524 support")
Cc: stable@vger.kernel.org
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Link: https://patch.msgid.link/20260710031333.3491445-1-chancel.liu@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/imx-card.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -496,11 +496,15 @@ static void imx_aif_shutdown(struct snd_
 	struct snd_soc_dai *codec_dai;
 	int i;
 
-	for_each_rtd_cpu_dais(rtd, i, cpu_dai)
-		snd_soc_dai_set_sysclk(cpu_dai, 0, 0, SND_SOC_CLOCK_OUT);
+	for_each_rtd_cpu_dais(rtd, i, cpu_dai) {
+		if (!snd_soc_dai_active(cpu_dai))
+			snd_soc_dai_set_sysclk(cpu_dai, 0, 0, SND_SOC_CLOCK_OUT);
+	}
 
-	for_each_rtd_codec_dais(rtd, i, codec_dai)
-		snd_soc_dai_set_sysclk(codec_dai, 0, 0, SND_SOC_CLOCK_IN);
+	for_each_rtd_codec_dais(rtd, i, codec_dai) {
+		if (!snd_soc_dai_active(codec_dai))
+			snd_soc_dai_set_sysclk(codec_dai, 0, 0, SND_SOC_CLOCK_IN);
+	}
 }
 
 static const struct snd_soc_ops imx_aif_ops = {


