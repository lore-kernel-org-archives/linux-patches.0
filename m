Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038877;
	b=2cm734Prwu+6rOlcjKlUONP+1j81VWqHcF8ENBTXUUSEM6BTfcxIKi41XwPqfnWb6tFD
	 0soiqHZPZpxE5bIvhI/5QfhstPO+ISLUHXzkz6a52up/Rs+8jYnn+AnfGrPHm2bfQZ19V
	 VrMC8poE1KhDnSJp89Ur1yESFPoyV9mUlM5Vt8Mo8uPfb2er4w3FYEJ8c9vIk0Ym9YtvK
	 7bjMkUBXHVEreeZ4MWLLS8RWz7M9mmz9mnv5sRxetVSr7G31ntH5UtMSMrp3U/pCXNLfa
	 Z043359SyzApwo8V66Uq0O1xwZ+oMMOnlRcdzaXgTzm5vSOmkYgyJcgl/TG5bHIm1Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e5w3kQDtksUfTfe6VVHPkmFTYKCxi0uAql+6M4D2yT8=;
	b=pWV8pd4ONrd+59cjyg8edSQYB7PETM3PEwmkrIO43z8OkcKlk03ZrXtwcr5croSa0Rqp
	 SJfg1HtB2Ny0qP5WJQw22lZZ5wR/S9wU70HbF0zczp5pw/mTs7JMYc/3hyd6kS4hnyXmj
	 Di2zbYJou3LSicKQiOut171dTBR/RvkEgocSOWglU+VMCi0jK7T2tUTpXG7rMlpyjxm0o
	 hJlkTlU99ohZc30nTbd56CXg2D3DMSjSy1GtdyvVREMNCdmYJ0MbT6rSxbd94IzYIUTX+
	 Tu/Gc4HRPuus2/eflqJplQJArboLNj+izK//u8023C9o2iWQ74MKB1b++smUsMBAVVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adTp5Nam;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F188606A31C;
	Wed, 18 Nov 2026 21:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adTp5Nam
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8911F000C4;
	Wed, 18 Nov 2026 21:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038876;
	bh=e5w3kQDtksUfTfe6VVHPkmFTYKCxi0uAql+6M4D2yT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adTp5NamSNxkVMRpwIZ0rYwYjB0rq7iLPCk8oGbpoUWIm0E4TqJgXZS0TVXcmZn51
	 BJ3Q61EZUrcSqP2OYzblH844kSQQ69sCnJp2SINT04c0Eg/5XL/dAYzgG8Awd27aFt
	 FmJz9r+QMuO4vTFD1t0bCUPt71i49Js34Ho+5rVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Cao <treebacker@foxmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1899/3318] ALSA: pcm: Prevent O_APPEND open on OSS streams
Date: Wed, 18 Nov 2026 15:42:01 +0100
Message-ID: <20261118150418.981036539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm.c        | 2 ++
 sound/core/pcm_local.h  | 6 ++++++
 sound/core/pcm_native.c | 6 ------
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 6d0c9c37796c2..af5bfb86656fd 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -933,6 +933,8 @@ int snd_pcm_attach_substream(struct snd_pcm *pcm, int stream,
 			return -ENODEV;
 		if (! SUBSTREAM_BUSY(substream))
 			return -EBADFD;
+		if (is_oss_stream(substream))
+			return -EINVAL;
 		substream->ref_count++;
 		*rsubstream = substream;
 		return 0;
diff --git a/sound/core/pcm_local.h b/sound/core/pcm_local.h
index ecb21697ae3a4..4b134d435c24f 100644
--- a/sound/core/pcm_local.h
+++ b/sound/core/pcm_local.h
@@ -80,4 +80,10 @@ static inline void snd_pcm_dma_buffer_sync(struct snd_pcm_substream *substream,
 		snd_dma_buffer_sync(snd_pcm_get_dma_buf(substream), mode);
 }
 
+#if IS_ENABLED(CONFIG_SND_PCM_OSS)
+#define is_oss_stream(substream)	((substream)->oss.oss)
+#else
+#define is_oss_stream(substream)	false
+#endif
+
 #endif	/* __SOUND_CORE_PCM_LOCAL_H */
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 989e822c1059c..42570787e815d 100644
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



