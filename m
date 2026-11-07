Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065049;
	b=j7T05wbUhIL+1FtjRTSc1lzY6bC2nqA2WhgYP+whCni9qN60a60oAN1iKZRd5O3JlBCk
	 LimU/Gsb/C847TBV/xJbQ8jqJcdAKzmAXCWL3wJwQ60OCVak8YhDbbQaYkWDE0Vy+U6BO
	 fVJt4RNmWBHFSId8F54wOMt2HRJ/86rKyxUt8OIySnE+gyy2xG5FIKvYSU1GgtWMeCEGU
	 pC0/TjnaU2ybcMIJ3REvpy3u7Hm3Wjpv936wnqVJ1ZYbyHqisycHpn7VfnUnIMEhrSd32
	 IF2V7HMp+IVYmsvbYmUulTXE6KiaiLFvLOSyrxuaiIWwpl6ZcyD74Y4WBJ1HXJj21/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065049;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u5/dXTKrIPAjn1ZItDQuNzFg608XJ38K2R18UdAHHzs=;
	b=rFo1GHu1GsPM1+bZXWXYU2mGe7iYh6vneSVn8o4e4j0teVbZfzMVZwIAY+1Hu09d1Agv
	 m/QW2Hc6HU/uCL1YvhhhfEfsto3XTici7lwkNExTk0x/lyyFLFSWDeQMGPi6Wp2ekQYFu
	 3ciI6QNI8gYFAOXtSnxY1h48PJaNNd+oqmtddbbgzbATkaRe1JErkrGNwiG57XlfRgPAi
	 8c+jRqUohgLoaP17j1yctOHXH7OP26bGq887tZbNQXQV8/gJYWfbH+zw9rQrVy77hMFGE
	 zRBlo8gcet+sgzUuY8YUhf4KMqTsMpNK70bmriJp4mdEr+BmCqUOSOqxBb0Tv5SiD5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HY316X9l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9C2606A9CC;
	Sat,  7 Nov 2026 15:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HY316X9l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8C21F0089F;
	Sat,  7 Nov 2026 15:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065049;
	bh=u5/dXTKrIPAjn1ZItDQuNzFg608XJ38K2R18UdAHHzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HY316X9laNXzpvAV5DelfF40nQY7GJg7jcEt1g+/WbQIJslWxRwpaDyByBECPYc9c
	 sScA/s1U0QuPx0q2IubC2rV9m+IYKfCulgyVG8lvWMovwUovrfoQu2gIXnQfWYuIB+
	 IoywWBXi50WrfLy8mmwcvqF6n9bHrsX4A6Bu7ERg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0900/1257] ALSA: compress: fix buffer leak on failed SET_PARAMS
Date: Sat,  7 Nov 2026 08:53:16 -0500
Message-ID: <20261107135004.186692512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit fbc74ca9fbf7e0b8f6872ccac62f9f4a1f3b5e53 ]

When the driver has neither ops->copy nor a preallocated dma_buffer_p,
snd_compr_allocate_buffer() kmallocs runtime->buffer. If
ops->set_params() then rejects the parameters, SET_PARAMS fails, the
stream stays in the OPEN state and keeps the buffer. The next
SET_PARAMS allocates a new buffer and overwrites the pointer, so
repeated SET_PARAMS calls with parameters that the driver rejects leak
one buffer per call.

Release the framework-owned buffer when ops->set_params() fails on an
OPEN stream, so that a failed SET_PARAMS leaves no buffer behind and
the buffer is allocated only once per successful setup. Use the same
ownership check as snd_compr_free().

Fixes: b21c60a4edd2 ("ALSA: core: add support for compress_offload")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261019144533.30665-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 7c397b1c9231f..85abcca385024 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -674,8 +674,15 @@ snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
 			return -ENOMEM;
 
 		retval = stream->ops->set_params(stream, params);
-		if (retval)
+		if (retval) {
+			/* the stream stays OPEN: drop the buffer of the rejected setup */
+			if (stream->runtime->state == SNDRV_PCM_STATE_OPEN &&
+			    !stream->runtime->dma_buffer_p) {
+				kfree(stream->runtime->buffer);
+				stream->runtime->buffer = NULL;
+			}
 			return retval;
+		}
 
 		if (stream->next_track)
 			return retval;
-- 
2.53.0



