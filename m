Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE264415F38;
	Tue, 21 Jul 2026 17:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656329; cv=none; b=usqdg+FEuRrDqaJY7qWmLl38q0boW6M7Uz8HZW4bkkbAvTIOlp5vnTrDU1hgGtokuGm1CoO8xGIDs23GjbIZ5Ak3w+iadoFuKi3dXK7gk65w/pEP+XFpwD5vypVjDQMBp3FfMKa+HR/b7LQrSlRi7mbVpDxVOYIxaLxlRSmIBo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656329; c=relaxed/simple;
	bh=kFtimvM9dHinxGdf9mlNGzYIXCw4Ht4AG4LXng2tQmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uqjHTVhFDP6aYJVR7mrmrpE8Fp9rupd68MyLH6U8s7HfmHD8hJhvEfmenTc1qzg/F3ZlZ2/GDgZJ9+ts8W+4kHImJsnAwS7q08esi/s8tJENEuwPLrnP5yGjiVrcVDAXhl4DN2NPBZxcPV2RrVb5qaLmGsq7Afxtq0yvTyWS1Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/ZncEfJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/ZncEfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6421F000E9;
	Tue, 21 Jul 2026 17:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656328;
	bh=22WW78VvTEQv1ovmyYjNGamp+PwzqBMZbm5HRZr/QqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/ZncEfJbIAeeUF/VwJqV7J/2lnVHFf5+pD6Qg+cPy+lUeW+QcLIbCMjftrKct1GU
	 t0x9r0yInMpVeuXamEvu9FeoKeLlc8V3YZO1k9deAZnc8Dj8WLMCB2DLV86yoA4aRD
	 RxHZ79EXweEEpLzq9PjW30P1Y7iTM4W3TKp10xtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0346/1611] ALSA: usb-audio: qcom: Initialize offload control return value
Date: Tue, 21 Jul 2026 17:07:42 +0200
Message-ID: <20260721152522.907748087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 2b5632d72fca0841bea283da2e3a478d24118508 ]

snd_usb_offload_create_ctl() returns ret after walking the USB PCM list,
but ret is only assigned after a playback stream passes the endpoint and
PCM-index filters.

If all playback streams are skipped, for example because there is no
playback endpoint or because all PCM indexes exceed the 0xff control
range, the function returns an uninitialized stack value.

Initialize ret to 0 so the no-control-created path returns deterministic
success, while preserving the existing negative error return when
snd_ctl_add() fails.

Fixes: a67656f011d1 ("ALSA: usb-audio: qcom: Add USB offload route kcontrol")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260605-alsa-usb-qcom-offload-ret-init-v1-1-dc72fcc4bd3b@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/qcom/mixer_usb_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/qcom/mixer_usb_offload.c b/sound/usb/qcom/mixer_usb_offload.c
index 2adeb64f4d33f4..005138714f7249 100644
--- a/sound/usb/qcom/mixer_usb_offload.c
+++ b/sound/usb/qcom/mixer_usb_offload.c
@@ -113,7 +113,7 @@ int snd_usb_offload_create_ctl(struct snd_usb_audio *chip, struct device *bedev)
 	struct snd_usb_substream *subs;
 	struct snd_usb_stream *as;
 	char ctl_name[48];
-	int ret;
+	int ret = 0;
 
 	list_for_each_entry(as, &chip->pcm_list, list) {
 		subs = &as->substream[SNDRV_PCM_STREAM_PLAYBACK];
-- 
2.53.0



