Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054407;
	b=ZwTP/qdDuEpZxYmfZl8NsmGMZ3+0O0CRnvvlrnQOPIAWIR/MEFOo/Rj405ImTo79xV7e
	 /9u+FWQvc1FybkNfh/43wl6SICwW/cYvH+aqAaxtTz+e+Zy1OsZucq3RCVy14PLDK0phg
	 wxObvlBrT8A++NfBmCKxd/Gx7RYanvN8DzeUjP2A5vDFX+GhxvxOusXh+i+d/yctJIQ7N
	 mfOFcOqYjMYzUhcfMSbQe8eJuFv9eL0Mr2EBLjoVMYfU2jtQvxvE8dLhgbE9w391307RW
	 YcJV43IYe81wa5e2DoF4nXEfKHmPoLCTFQC1CTjlMmzP+UrQtL/Oy5siIb4G8TIUIpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ayr2JZg9b5ID2dSkQAjsiHiqBvqTovOEzYJNn76ke4w=;
	b=oUvMbDPwTq4O1vjk4ljJkiCso1r5JZ2Hq99757BxmyWSauJf8if5evLHJx5FA2Gy0w+1
	 /SRNSmowitlJIquZcSsDk8Jgn0xNHVNQgHT1Y+srHYZ+c61IGDGn+f54HdDlRnhkMo3qs
	 cYWuri0mPGtfmLgYp+rkyPrzViaQtPlEJ+ecbmNsBRgwpcXfhjI461g5WE0Hfcjc15uZh
	 GlcvIDRerce6EwUqu3bXoTh18i7qp1PpvMTH0LF8vFn/ooi3IZGq1kKUYTKAApV1qzkNv
	 d5ofldZrUPYJzyK6BUqWOoIJV757oSrzhmk1hP/lCTO4Ws8lBeYyaIMR2pVCVBe1zvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1AzYPNjU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1336606A330;
	Thu, 19 Nov 2026 02:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1AzYPNjU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D0C1F000C4;
	Thu, 19 Nov 2026 02:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054406;
	bh=ayr2JZg9b5ID2dSkQAjsiHiqBvqTovOEzYJNn76ke4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1AzYPNjUrN9on/x9+CvZTO5FOi3LD9SryC2Uhi+BT9mW5HgjJl8MWVrcxbie8StW5
	 8vcqO/hOLGeTg/4G2nS56/qHrbyl2ZYqUiSZUzeJIiY0XmqA8+jR4+25GWEyJgh3mf
	 zrSQ7YYO3Pn9izjbELRAzkEGcQHDoGjxFO6R62rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Cao <treebacker@foxmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1246/2214] ALSA: pcm: Prevent O_APPEND open on OSS streams
Date: Wed, 18 Nov 2026 15:48:42 +0100
Message-ID: <20261118150101.549087880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted the is_oss_stream insertion context because snd_pcm_dma_buffer_sync() is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm.c        | 2 ++
 sound/core/pcm_local.h  | 6 ++++++
 sound/core/pcm_native.c | 6 ------
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 9df2e819035f2..8bad50bf00e13 100644
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
index fe9689b8a6a64..f43ecb904069c 100644
--- a/sound/core/pcm_local.h
+++ b/sound/core/pcm_local.h
@@ -73,4 +73,10 @@ void snd_pcm_sync_stop(struct snd_pcm_substream *substream, bool sync_irq);
 		for ((subs) = (pcm)->streams[str].substream; (subs); \
 		     (subs) = (subs)->next)
 
+#if IS_ENABLED(CONFIG_SND_PCM_OSS)
+#define is_oss_stream(substream)	((substream)->oss.oss)
+#else
+#define is_oss_stream(substream)	false
+#endif
+
 #endif	/* __SOUND_CORE_PCM_LOCAL_H */
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index e861404d393b6..c6ae68f35f2f8 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -720,12 +720,6 @@ int snd_pcm_runtime_buffer_set_silence(struct snd_pcm_runtime *runtime)
 }
 EXPORT_SYMBOL_GPL(snd_pcm_runtime_buffer_set_silence);
 
-#if IS_ENABLED(CONFIG_SND_PCM_OSS)
-#define is_oss_stream(substream)	((substream)->oss.oss)
-#else
-#define is_oss_stream(substream)	false
-#endif
-
 static void pcm_qos_req_clear(struct snd_pcm_substream *substream)
 {
 	if (cpu_latency_qos_request_active(&substream->latency_pm_qos_req))
-- 
2.53.0



