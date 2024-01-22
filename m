Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249B5162E5C;
	Tue, 23 Jan 2024 00:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970189; cv=none; b=LeCaPb+wVUXJ4eew8zzMsCinigZiT3W3pbzCiirkn3VXGivazjBr7DePwPfVERjxUiziPISZVWnpC7Oyp5F3VDv/KAX1o1oNaSUD0TepKqyQk84Jnv1FGhCPiQM0tX7CbZ0B2/VjsD6w4IMixROlErcwPZcYLZrTr20XZWpgL/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970189; c=relaxed/simple;
	bh=fOf5ri59UeJGqLqiNc+MKOf5bpSfv2Ze3iJIrjh+cc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fekwqkXudqVq8yzl32Obrn9iCsLCCxSuerrCeW0uR4CLKl/YXdE6MThZjIVnHZXhj0Vmhitg6GEaaewIfNO9+Uvh50WohItjM8XLT2874cd+3tABisNvLEHMdHxr6jpl6imyjc+tmLOXpSwENT1VaaO8yX9ptA4s8RkEZXM97Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhwNY6nq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhwNY6nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1ACC43394;
	Tue, 23 Jan 2024 00:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970189;
	bh=fOf5ri59UeJGqLqiNc+MKOf5bpSfv2Ze3iJIrjh+cc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhwNY6nq+hNnjRuxBMpV6q8doLBDWfDkDJHq/m/0C15l5lYB3Fz42iIEuSsD01x4W
	 X7VQEKlF3gKnirNQ26CFyDKAm0Jr3FZYpe+vAVCP7x4eO9O1T83c635+ShyhEpUWcW
	 25qfdwIibmR4MitVJ23PCclgxCTlBeGC59C1xkO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 587/641] ALSA: aloop: Introduce a function to get if access is interleaved mode
Date: Mon, 22 Jan 2024 15:58:11 -0800
Message-ID: <20240122235836.579919346@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit cdac6e1f716419ce307ad3e44a718557a5469c17 ]

There's a use case that playback stream of a loopback cable works on
RW_INTERLEAVED mode while capture stream works on MMAP_INTERLEAVED mode:

aplay -Dhw:Loopback,0,0 S32_48K_2ch.wav;
arecord -Dplughw:Loopback,1,0 -fS32_LE -r16000 -c2 cap.wav;

The plug plugin handles only slave PCM support MMAP mode. Not only plug
plugin but also other plugins like direct plugins(dmix/dsnoop/dshare)
work on MMAP access mode. In this case capture stream is the slave
PCM works on MMAP_INTERLEAVED mode. However loopback_check_format()
rejects this access setting and return:

arecord: pcm_read:2240: read error: Input/output error

To fix it a function called is_access_interleaved() is introduced to
get if access is interleaved mode. If both access of capture stream and
playback stream is interleaved mode loopback_check_format() will allow
this kind of access setting.

Fixes: 462494565c27 ("ALSA: aloop: Add support for the non-interleaved access mode")
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Link: https://lore.kernel.org/r/20240111025219.2678764-1-chancel.liu@nxp.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index e87dc67f33c6..1c65e0a3b13c 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -322,6 +322,17 @@ static int loopback_snd_timer_close_cable(struct loopback_pcm *dpcm)
 	return 0;
 }
 
+static bool is_access_interleaved(snd_pcm_access_t access)
+{
+	switch (access) {
+	case SNDRV_PCM_ACCESS_MMAP_INTERLEAVED:
+	case SNDRV_PCM_ACCESS_RW_INTERLEAVED:
+		return true;
+	default:
+		return false;
+	}
+};
+
 static int loopback_check_format(struct loopback_cable *cable, int stream)
 {
 	struct snd_pcm_runtime *runtime, *cruntime;
@@ -341,7 +352,8 @@ static int loopback_check_format(struct loopback_cable *cable, int stream)
 	check = runtime->format != cruntime->format ||
 		runtime->rate != cruntime->rate ||
 		runtime->channels != cruntime->channels ||
-		runtime->access != cruntime->access;
+		is_access_interleaved(runtime->access) !=
+		is_access_interleaved(cruntime->access);
 	if (!check)
 		return 0;
 	if (stream == SNDRV_PCM_STREAM_CAPTURE) {
@@ -369,7 +381,8 @@ static int loopback_check_format(struct loopback_cable *cable, int stream)
 							&setup->channels_id);
 			setup->channels = runtime->channels;
 		}
-		if (setup->access != runtime->access) {
+		if (is_access_interleaved(setup->access) !=
+		    is_access_interleaved(runtime->access)) {
 			snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_VALUE,
 							&setup->access_id);
 			setup->access = runtime->access;
@@ -584,8 +597,7 @@ static void copy_play_buf(struct loopback_pcm *play,
 			size = play->pcm_buffer_size - src_off;
 		if (dst_off + size > capt->pcm_buffer_size)
 			size = capt->pcm_buffer_size - dst_off;
-		if (runtime->access == SNDRV_PCM_ACCESS_RW_NONINTERLEAVED ||
-		    runtime->access == SNDRV_PCM_ACCESS_MMAP_NONINTERLEAVED)
+		if (!is_access_interleaved(runtime->access))
 			copy_play_buf_part_n(play, capt, size, src_off, dst_off);
 		else
 			memcpy(dst + dst_off, src + src_off, size);
@@ -1544,8 +1556,7 @@ static int loopback_access_get(struct snd_kcontrol *kcontrol,
 	mutex_lock(&loopback->cable_lock);
 	access = loopback->setup[kcontrol->id.subdevice][kcontrol->id.device].access;
 
-	ucontrol->value.enumerated.item[0] = access == SNDRV_PCM_ACCESS_RW_NONINTERLEAVED ||
-					     access == SNDRV_PCM_ACCESS_MMAP_NONINTERLEAVED;
+	ucontrol->value.enumerated.item[0] = !is_access_interleaved(access);
 
 	mutex_unlock(&loopback->cable_lock);
 	return 0;
-- 
2.43.0



