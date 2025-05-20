Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF23C2459CD;
	Tue, 20 May 2025 13:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749306; cv=none; b=bTpq72EgaI77tojkKSCBhlIwrZfkTNLt+lV/g2cJaiqx3Fk17kMSUCUakTXRiBidc7kG76s2Q2u2u0nj6DxXS05EfCIcwjhXQootdJjNlfGsMoGg9Owzx/3+HVLYQS+u5k43aRsIqpnK9H81fvEM/RDrkA4Nh2fNWkY+VJJ/w7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749306; c=relaxed/simple;
	bh=D3F5FFqKYWb/oSvlcNL8MM+PArU4uQcUBG47+B1r1dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYD4xkREnbDJvjKMoeNeV5e313gCg/Rx2XZV1iW+rC++IHhHjHz4abJumvTjI0qpUQqQJn+ODxwdiX8JTMUlRFit9MRJQjHzsb/8FCzp/lklz8NGNjtfG1q52V64x2VAvTZ2YXHzukpZED11WcYC0lrlt5AJq2KKHMiHVTXxCys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ykb6xBXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ykb6xBXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50720C4CEE9;
	Tue, 20 May 2025 13:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749306;
	bh=D3F5FFqKYWb/oSvlcNL8MM+PArU4uQcUBG47+B1r1dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ykb6xBXx2s/z5DvqSvBMPc2DYllzhJox4lqwUL8JqFBtm6P14QZWuEOhuVPQ/mSaf
	 dTp+RZ/VlAT93/23+5KNHWKYOBxQ1Wuauq0cG1isXsJ78t/+XeCWkHUqZGkBvxFGpt
	 DB3LcnOE+tjMtLCCQKrMmwfTlhXSW6dkp19zzOcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 33/59] ALSA: es1968: Add error handling for snd_pcm_hw_constraint_pow2()
Date: Tue, 20 May 2025 15:50:24 +0200
Message-ID: <20250520125755.174877450@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1569,7 +1569,7 @@ static int snd_es1968_capture_open(struc
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct es1968 *chip = snd_pcm_substream_chip(substream);
 	struct esschan *es;
-	int apu1, apu2;
+	int err, apu1, apu2;
 
 	apu1 = snd_es1968_alloc_apu_pair(chip, ESM_APU_PCM_CAPTURE);
 	if (apu1 < 0)
@@ -1613,7 +1613,9 @@ static int snd_es1968_capture_open(struc
 	runtime->hw = snd_es1968_capture;
 	runtime->hw.buffer_bytes_max = runtime->hw.period_bytes_max =
 		calc_available_memory_size(chip) - 1024; /* keep MIXBUF size */
-	snd_pcm_hw_constraint_pow2(runtime, 0, SNDRV_PCM_HW_PARAM_BUFFER_BYTES);
+	err = snd_pcm_hw_constraint_pow2(runtime, 0, SNDRV_PCM_HW_PARAM_BUFFER_BYTES);
+	if (err < 0)
+		return err;
 
 	spin_lock_irq(&chip->substream_lock);
 	list_add(&es->list, &chip->substream_list);


