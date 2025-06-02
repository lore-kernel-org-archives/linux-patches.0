Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF66421CC59;
	Mon,  2 Jun 2025 14:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874704; cv=none; b=KfDTpfRqALsWGJyPEjOW1nAqf/qjgWtVacCA6YRJ8DHCJ734of31BZtDiBpo0iwR8GQYKmIa4Mp+WVhhMLiIrYH0WQ2maDQU2vDvEymhNFYot/jGyCEtFUF6ydl/QzGHTr9L0j3+ETPu1Gh1qH31a1XoVeAqUkA3swWEH2pNTTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874704; c=relaxed/simple;
	bh=PdFiBNIlQeBYHf1TmsKXRHJOXlOhmSdCJ5quqBXrWrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hL8Pk9Xl0irsw96GJA6wDCYBLaUaJfXkGu1825ME09iZQI8pdU9gqetYiGlVC/TaNcZdmHHPXUyQTC5nljU/7wT4PXIgkQoLFALdzNHoAhfS0WgELgcz93edk0kV/hZIgVc7XKgnH7ycl3oGB6rjFY4y2M9/emDCvZ/jrQDmnqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxhZ1gYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxhZ1gYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD44C4CEEB;
	Mon,  2 Jun 2025 14:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874704;
	bh=PdFiBNIlQeBYHf1TmsKXRHJOXlOhmSdCJ5quqBXrWrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxhZ1gYjo6iGutJnt/WyBns+wwC83A3GlU98Ilen5tkOCyutuR6SnBWGmsF4rVV0F
	 8/ArjuEUB+OrWPq7kcC3/ulDCuy5hzOxXDnyBhJkJEXsR1x771575z8ZXDfh7ohZeF
	 +xYJIuiIG8hWMCaZ/Cn94naIcd/dljYFiIooUoyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 079/204] ALSA: es1968: Add error handling for snd_pcm_hw_constraint_pow2()
Date: Mon,  2 Jun 2025 15:46:52 +0200
Message-ID: <20250602134258.778512110@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 9e000f1b7f31684cc5927e034360b87ac7919593 upstream.

The function snd_es1968_capture_open() calls the function
snd_pcm_hw_constraint_pow2(), but does not check its return
value. A proper implementation can be found in snd_cx25821_pcm_open().

Add error handling for snd_pcm_hw_constraint_pow2() and propagate its
error code.

Fixes: b942cf815b57 ("[ALSA] es1968 - Fix stuttering capture")
Cc: stable@vger.kernel.org # v2.6.22
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20250514092444.331-1-vulab@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/es1968.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -1575,7 +1575,7 @@ static int snd_es1968_capture_open(struc
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct es1968 *chip = snd_pcm_substream_chip(substream);
 	struct esschan *es;
-	int apu1, apu2;
+	int err, apu1, apu2;
 
 	apu1 = snd_es1968_alloc_apu_pair(chip, ESM_APU_PCM_CAPTURE);
 	if (apu1 < 0)
@@ -1618,7 +1618,9 @@ static int snd_es1968_capture_open(struc
 	runtime->hw = snd_es1968_capture;
 	runtime->hw.buffer_bytes_max = runtime->hw.period_bytes_max =
 		calc_available_memory_size(chip) - 1024; /* keep MIXBUF size */
-	snd_pcm_hw_constraint_pow2(runtime, 0, SNDRV_PCM_HW_PARAM_BUFFER_BYTES);
+	err = snd_pcm_hw_constraint_pow2(runtime, 0, SNDRV_PCM_HW_PARAM_BUFFER_BYTES);
+	if (err < 0)
+		return err;
 
 	spin_lock_irq(&chip->substream_lock);
 	list_add(&es->list, &chip->substream_list);


