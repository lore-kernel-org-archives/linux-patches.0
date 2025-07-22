Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3197548EE;
	Tue, 22 Jul 2025 14:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193604; cv=none; b=PiuJuXu7wDocZKvLiylf/lIp5Dx3q0ECA00af7bB6JIhcUDGB5uV9nzWNSgMexVM5IO1DbBeEPF9+RGYfwMHafWaBgd5Rh6DxaLppAlUmDqQWd16IpgKtOfBu1/z16G8btbqGy+8R5cDnnkowcUOy+M80K9iP1KH2fhcTB5HNjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193604; c=relaxed/simple;
	bh=x/z8CBRwU3HPS6zsB9xh3uVqPMUzIGIQLvfEpR05Hxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkEBrJOsMkRO1MaBiXoxkZAuVg8iPJudII1nVrE6C/icE2QDT8NMC5wpHv5qCTgK2nBHGMUnlnYcYIezEK3/IQ7gvQDFt8eQQtFQw//AG+MtWHu+QliobWQFk3T1f5SdzIR3KIybLTfoKTfLK/QIM7Jh+Sb2AQLpqAIghF/Ym2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXR/LzM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXR/LzM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FAFC4CEF1;
	Tue, 22 Jul 2025 14:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193604;
	bh=x/z8CBRwU3HPS6zsB9xh3uVqPMUzIGIQLvfEpR05Hxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXR/LzM3MBPN0KvrDqHhmoxy+gE9yX5n9HaBwx8R0t1jsUxaHOs1rJcDGMxwzGavr
	 24/rBmd1jp5QqcHKHvHJOVbAjGig5odWokQ97+MtUS6et3z+gbR1/ruV43pD0Lj2Qb
	 tEuuFWtwJtZzsDEhh1WLbC0PTsV83PfAKhHZktbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Vinod Koul <vkoul@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 109/187] ALSA: compress_offload: tighten ioctl command number checks
Date: Tue, 22 Jul 2025 15:44:39 +0200
Message-ID: <20250722134349.826772125@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 19c4096ccdd809c6213e2e62b0d4f57c880138cd ]

The snd_compr_ioctl() ignores the upper 24 bits of the ioctl command
number and only compares the number of the ioctl command, which can
cause unintended behavior if an application tries to use an unsupprted
command that happens to have the same _IOC_NR() value.

Remove the truncation to the low bits and compare the entire ioctl
command code like every other driver does.

Fixes: b21c60a4edd2 ("ALSA: core: add support for compress_offload")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Vinod Koul <vkoul@kernel.org>
Link: https://patch.msgid.link/20250710063059.2683476-1-arnd@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 48 +++++++++++++++++------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 840bb9cfe7890..a66f258cafaa8 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -1269,62 +1269,62 @@ static long snd_compr_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 	stream = &data->stream;
 
 	guard(mutex)(&stream->device->lock);
-	switch (_IOC_NR(cmd)) {
-	case _IOC_NR(SNDRV_COMPRESS_IOCTL_VERSION):
+	switch (cmd) {
+	case SNDRV_COMPRESS_IOCTL_VERSION:
 		return put_user(SNDRV_COMPRESS_VERSION,
 				(int __user *)arg) ? -EFAULT : 0;
-	case _IOC_NR(SNDRV_COMPRESS_GET_CAPS):
+	case SNDRV_COMPRESS_GET_CAPS:
 		return snd_compr_get_caps(stream, arg);
 #ifndef COMPR_CODEC_CAPS_OVERFLOW
-	case _IOC_NR(SNDRV_COMPRESS_GET_CODEC_CAPS):
+	case SNDRV_COMPRESS_GET_CODEC_CAPS:
 		return snd_compr_get_codec_caps(stream, arg);
 #endif
-	case _IOC_NR(SNDRV_COMPRESS_SET_PARAMS):
+	case SNDRV_COMPRESS_SET_PARAMS:
 		return snd_compr_set_params(stream, arg);
-	case _IOC_NR(SNDRV_COMPRESS_GET_PARAMS):
+	case SNDRV_COMPRESS_GET_PARAMS:
 		return snd_compr_get_params(stream, arg);
-	case _IOC_NR(SNDRV_COMPRESS_SET_METADATA):
+	case SNDRV_COMPRESS_SET_METADATA:
 		return snd_compr_set_metadata(stream, arg);
-	case _IOC_NR(SNDRV_COMPRESS_GET_METADATA):
+	case SNDRV_COMPRESS_GET_METADATA:
 		return snd_compr_get_metadata(stream, arg);
 	}
 
 	if (stream->direction == SND_COMPRESS_ACCEL) {
 #if IS_ENABLED(CONFIG_SND_COMPRESS_ACCEL)
-		switch (_IOC_NR(cmd)) {
-		case _IOC_NR(SNDRV_COMPRESS_TASK_CREATE):
+		switch (cmd) {
+		case SNDRV_COMPRESS_TASK_CREATE:
 			return snd_compr_task_create(stream, arg);
-		case _IOC_NR(SNDRV_COMPRESS_TASK_FREE):
+		case SNDRV_COMPRESS_TASK_FREE:
 			return snd_compr_task_seq(stream, arg, snd_compr_task_free_one);
-		case _IOC_NR(SNDRV_COMPRESS_TASK_START):
+		case SNDRV_COMPRESS_TASK_START:
 			return snd_compr_task_start_ioctl(stream, arg);
-		case _IOC_NR(SNDRV_COMPRESS_TASK_STOP):
+		case SNDRV_COMPRESS_TASK_STOP:
 			return snd_compr_task_seq(stream, arg, snd_compr_task_stop_one);
-		case _IOC_NR(SNDRV_COMPRESS_TASK_STATUS):
+		case SNDRV_COMPRESS_TASK_STATUS:
 			return snd_compr_task_status_ioctl(stream, arg);
 		}
 #endif
 		return -ENOTTY;
 	}
 
-	switch (_IOC_NR(cmd)) {
-	case _IOC_NR(SNDRV_COMPRESS_TSTAMP):
+	switch (cmd) {
+	case SNDRV_COMPRESS_TSTAMP:
 		return snd_compr_tstamp(stream, arg);
-	case _IOC_NR(SNDRV_COMPRESS_AVAIL):
+	case SNDRV_COMPRESS_AVAIL:
 		return snd_compr_ioctl_avail(stream, arg);
-	case _IOC_NR(SNDRV_COMPRESS_PAUSE):
+	case SNDRV_COMPRESS_PAUSE:
 		return snd_compr_pause(stream);
-	case _IOC_NR(SNDRV_COMPRESS_RESUME):
+	case SNDRV_COMPRESS_RESUME:
 		return snd_compr_resume(stream);
-	case _IOC_NR(SNDRV_COMPRESS_START):
+	case SNDRV_COMPRESS_START:
 		return snd_compr_start(stream);
-	case _IOC_NR(SNDRV_COMPRESS_STOP):
+	case SNDRV_COMPRESS_STOP:
 		return snd_compr_stop(stream);
-	case _IOC_NR(SNDRV_COMPRESS_DRAIN):
+	case SNDRV_COMPRESS_DRAIN:
 		return snd_compr_drain(stream);
-	case _IOC_NR(SNDRV_COMPRESS_PARTIAL_DRAIN):
+	case SNDRV_COMPRESS_PARTIAL_DRAIN:
 		return snd_compr_partial_drain(stream);
-	case _IOC_NR(SNDRV_COMPRESS_NEXT_TRACK):
+	case SNDRV_COMPRESS_NEXT_TRACK:
 		return snd_compr_next_track(stream);
 	}
 
-- 
2.39.5



