Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64D13EB0EF;
	Mon, 17 Aug 2026 14:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975560; cv=none; b=HjZDk2Q2ko3ANqqV+72hs2FCXxCblfS6Bi1xW87gXE8AYBWtAQ0U99f6HLqcJev/4G9eo3POLRNrG6SbmQ50RJMvEmnMKpaAUsYzTUGwD3TKCAOsJ0TvBSSPO3auNsO8P7rXIfEF7LhXncCtUvSzSj23aPpQICAf8GH2gG/+dYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975560; c=relaxed/simple;
	bh=E25hkhdAH3ZSleqWYuF22rz2s7nquDTPldZHM+vI7Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zxk4/DcRjatB3GsyHyvS1W5ewgeZXnPd3l2FKPIAUXxAXX1zV2x++wewhd0EV7hwLHmoSytaf2c2xh7A7YOIJ5o8VI1XZ83dwBJo0f+FC5pfq0oszkWrF2Im2eC7rkDAIDKKi+dGV7WcOcmfRCab1rTRfbN32XmMraBv7evhVgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFBvvTEn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFBvvTEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8141F00A3E;
	Mon, 17 Aug 2026 14:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975558;
	bh=jVrBWqzLzbrn6LsQNeP9fTKbVftcGBXp0EyPVMP9CAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFBvvTEnLpd4FQt8weK77Kg+17DnoYW61hQjPb5Zgqfj5tHot6F90g5e15SnwHeNa
	 p7VrIV8hdDN4fDIIZ1rS50bu5RGOzy4qnbrGXYSDi3qab/7dOAvE5e6onVPqr7COyu
	 X/vjFLR4gZgSknYVseJkTIEruG+/3joOYfrZrzuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/389] ASoC: meson: aiu: fifo-spdif: soft reset the S/PDIF datapath on start/stop
Date: Mon, 17 Aug 2026 15:27:48 +0200
Message-ID: <20260817132540.080150903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 44eb6faacf44d0..124d2d9ce71605 100644
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



