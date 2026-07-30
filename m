Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EC142047A;
	Thu, 30 Jul 2026 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425456; cv=none; b=svfT0srH5+UiBMTR+ZXJ2+KovGiWM9IKUwnLw6OwNXnaXmvGbyVT/MmVAV2ZYvH54inYvetoLdvg28mhN3D1qohN+x/qs2V7iLiCdNvdBwNKVco49ks6iR1TxlYbo5CGEAa4gU3bZTjThhj2kN3M/gByz/ula7T82acjOWvt9Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425456; c=relaxed/simple;
	bh=uVlrb43Ut+q+cS0FBA/XlipvaXwDkqlNiPnhlGkmQSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9gRpCm3yQAqxq5Wx8A1Npf4VTe9KZsePrDJmTFK5Pq0D/z9QcvsYgoEdHbhsCcaELpr6+Y0OW8/tvifM/TnRalhroTntOVFPIyUCWirIls7YIJqZlU6+7T1Kc2L8kXRdC2zfsKtpSeUBznMEznLaUg0bGynkwudcfAHOZeETCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uY2m4esU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uY2m4esU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712EF1F000E9;
	Thu, 30 Jul 2026 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425455;
	bh=hcKru4yBfo9quItNWiCK1SvfWEVpJyAMwuSZKQb1jcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uY2m4esU6BQ5ZmScKE6C/JtByuC8xHGGsK3yVRnXLNX4DD6zLDKhdFR0bKt8z7Jx0
	 P8NutfqT3VJtGpKDU5bEg4eOis5a49TWD4Hr2q2BcRq+1pYETBqKT9GVQRyWL+lxiB
	 8nAqgAkStRmWojONt47eQ0Lgq4BDWZOk2dwAtPNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/602] ASoC: meson: aiu: fifo-spdif: soft reset the S/PDIF datapath on start/stop
Date: Thu, 30 Jul 2026 16:07:46 +0200
Message-ID: <20260730141437.554054812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit 6b59c53c8adc2b522327407af5e1793a65b67e4b ]

The I2S FIFO soft-resets its fast domain on start (AIU_RST_SOFT bit 0 +
AIU_I2S_SYNC read in aiu_fifo_i2s_trigger), mirroring the downstream
vendor driver's audio_out_i2s_enable(). The S/PDIF FIFO has no equivalent:
it only toggles the IEC958 DCU, so a stale datapath FIFO can be replayed,
producing the "machine gun noise" buffer underrun - on start when switching
outputs, and on stop when playback ends. The latter is audible on devices
with an always-on S/PDIF-fed DAC (e.g. the ES7144 on the WeTek Play2).

The vendor driver resets the IEC958 fast domain (AIU_RST_SOFT bit 2) on
both enable and disable (audio_hw_958_enable), and when reconfiguring
(audio_hw_958_reset clears AIU_958_DCU_FF_CTRL then resets). Do the same:
reset before enabling the DCU on start, and before disabling on stop.

Fixes: 6ae9ca9ce986bf ("ASoC: meson: aiu: add i2s and spdif support")
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://patch.msgid.link/20260627131205.808800-1-christianshewitt@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/aiu-fifo-spdif.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/meson/aiu-fifo-spdif.c b/sound/soc/meson/aiu-fifo-spdif.c
index e0e00ec026dcc4..a9861c5d663745 100644
--- a/sound/soc/meson/aiu-fifo-spdif.c
+++ b/sound/soc/meson/aiu-fifo-spdif.c
@@ -24,6 +24,7 @@
 #define AIU_MEM_IEC958_CONTROL_MODE_16BIT	BIT(7)
 #define AIU_MEM_IEC958_CONTROL_MODE_LINEAR	BIT(8)
 #define AIU_MEM_IEC958_BUF_CNTL_INIT		BIT(0)
+#define AIU_RST_SOFT_958_FAST			BIT(2)
 
 #define AIU_FIFO_SPDIF_BLOCK			8
 
@@ -68,11 +69,15 @@ static int fifo_spdif_trigger(struct snd_pcm_substream *substream, int cmd,
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		snd_soc_component_write(component, AIU_RST_SOFT,
+					AIU_RST_SOFT_958_FAST);
 		fifo_spdif_dcu_enable(component, true);
 		break;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 	case SNDRV_PCM_TRIGGER_STOP:
+		snd_soc_component_write(component, AIU_RST_SOFT,
+					AIU_RST_SOFT_958_FAST);
 		fifo_spdif_dcu_enable(component, false);
 		break;
 	default:
-- 
2.53.0



