Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060025;
	b=kUNKvBbxH18tP/Wd2gL4hiTAhXujG70OR+D/tHLHny521HcQn+/k3Kxx0az+uw9KzI9W
	 e5VR36iBUMC2S0Ncl/tohSL3TK+dAVSdRqBai06oDBNVCK7kXRR0DuUMtpT7ndWZj0E4l
	 1/e6FLJej5R6pBIa47qw3I5vjD3muDiag0vCjr/jQAL6QZIc8fRwVV/WkYT3Va8iMpXAo
	 T3TSouDxLPc7WGbHVJynyiv2H7okSbQuEgUyRs2nhv5a99mCEnvhoZ5T2j7bMc/N1Yqis
	 iLnZAXm7SixlGskLCZp0CpB2isNlU3YyUKmgOVt06VbUqOZb4zYd3okwn7MNn/M7gnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+V4gYMgnhCDzW/a5jpAG7R18DD+AvXV5R0B6zUCx7wA=;
	b=j5zThs8M7vpimYq2tQicpkf3mgMtr48PNXYS611lZfkiy7vPTqH9j+Pn2W75JF6TJ0Io
	 VYoO2DDI3l2XWFcSQAcFYwgGK+rz8UPDAIY3WcVrYJRRyuSlLp0f8CEZ5QQizoTqj2iJl
	 aXfgE6twb4hENUoOns3Cj5Pl5pVn1sJy9RcXU38g8sp4IStU/H80T4rR/mapV8wWaCbuj
	 8lCgNQev7Ocif3PzNMUb2s3QknYO6V1IwG2mLQF4Euigjr+G1dD5IX5MPtO6EpuHyWn9O
	 reEPMcX6+sGhT0tgtNVkQwTUBcvMDOfjvwEzkzn80fB1mpp1KunAUvF35sQrBlpwawg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XTW5giUr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31172606A320;
	Thu, 19 Nov 2026 03:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XTW5giUr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365C21F000C4;
	Thu, 19 Nov 2026 03:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060024;
	bh=+V4gYMgnhCDzW/a5jpAG7R18DD+AvXV5R0B6zUCx7wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XTW5giUrU1zzFjtK9LDJmb4Xqn9R2ULwUDQz/71yBVWB0vmVMzrfHfvklNt8467Hp
	 PgxtNSq4yT1IQM2IUrKaqTfWcYl1vijSErrw3JBtx1Ng3Jqtq2+1Qs2czFbymmrtvz
	 rZg31CIFI850/o/WxYj3s9FQT9V3ef4neaiDBf38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Cao <treebacker@foxmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1050/1848] ALSA: pcm: Prevent O_APPEND open on OSS streams
Date: Wed, 18 Nov 2026 15:51:28 +0100
Message-ID: <20261118150001.262662313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9017bc3d13da0ea4e63be618c87143a7b69185e6 ]

ALSA PCM core accepts to re-use the existing stream when O_APPEND is
passed, and it's been used for dmix, etc.  However, this mode isn't
supposed to be used for OSS: the OSS stream allows re-configuration
via its hw_params/hw_refine procedure even while it's being mmapped,
so it implies the usage of only a single stream.  Because of this
assumption, the sanity check is skipped for OSS streams, and if user
may attach to an existing OSS stream with O_APPEND, it may result in a
UAF of the mapped pages which could be used as a privilege escalation
exploit.

For addressing it, this patch simply prohibits the O_APPEND behavior
on the OSS stream.  O_APPEND is never used for OSS layer itself, so
this can't break for the right applications.

Fixes: 0df63e44c3e3 ("[ALSA] Add O_APPEND flag support to PCM")
Cc: stable@vger.kernel.org
Reported-by: Bo Cao <treebacker@foxmail.com>
Link: https://lore.kernel.org/tencent_E90BB4F086165FAA3313723567A5C675EA06@qq.com
Link: https://patch.msgid.link/20261103155844.120838-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Adjusted context for relocating the is_oss_stream macro because surrounding helpers are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm.c        | 2 ++
 sound/core/pcm_local.h  | 6 ++++++
 sound/core/pcm_native.c | 6 ------
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index bec81f6ba6ba5..d4eb842784143 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -930,6 +930,8 @@ int snd_pcm_attach_substream(struct snd_pcm *pcm, int stream,
 			return -ENODEV;
 		if (! SUBSTREAM_BUSY(substream))
 			return -EBADFD;
+		if (is_oss_stream(substream))
+			return -EINVAL;
 		substream->ref_count++;
 		*rsubstream = substream;
 		return 0;
diff --git a/sound/core/pcm_local.h b/sound/core/pcm_local.h
index b3e8be5aeafb3..353f675724337 100644
--- a/sound/core/pcm_local.h
+++ b/sound/core/pcm_local.h
@@ -72,4 +72,10 @@ struct page *snd_pcm_sgbuf_ops_page(struct snd_pcm_substream *substream,
 
 #define PCM_RUNTIME_CHECK(sub) snd_BUG_ON(!(sub) || !(sub)->runtime)
 
+#if IS_ENABLED(CONFIG_SND_PCM_OSS)
+#define is_oss_stream(substream)	((substream)->oss.oss)
+#else
+#define is_oss_stream(substream)	false
+#endif
+
 #endif	/* __SOUND_CORE_PCM_LOCAL_H */
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 40020c5dceda0..7b6902bf0fd12 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -702,12 +702,6 @@ int snd_pcm_runtime_buffer_set_silence(struct snd_pcm_runtime *runtime)
 }
 EXPORT_SYMBOL_GPL(snd_pcm_runtime_buffer_set_silence);
 
-#if IS_ENABLED(CONFIG_SND_PCM_OSS)
-#define is_oss_stream(substream)	((substream)->oss.oss)
-#else
-#define is_oss_stream(substream)	false
-#endif
-
 static int snd_pcm_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params)
 {
-- 
2.53.0



