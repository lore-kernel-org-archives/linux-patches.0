Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063518;
	b=mz6YW79O7rKWS67urW7f7I0rTXTgPc9gv7nTmANfZ0jdhJhlqKbYPHSnvartkktxVjvt
	 dsxvgepO9iE+1/upU1kQ3LC0rCfdQRCAjgYwxNTyEp1jfpudHVi7EDwHwEQJ7v1XuLZLn
	 kwOYAcRlP39IGiY1RT2FsFQXoVqldoTdGTHEyFmyxSUeIKIT9zcipglBwPJKP62qn+rPY
	 LprsR0nFbZugX06NbSjQqGjXYbgcP9cq906AfyKu8YzbO9MEy3eeKMbBe5mbAEWN015cM
	 4Ahubm5vHi3UrzOhr5bat9SHMilXo46A/ZkPGIHPYdMa5z4xRAWua5zz/2tG4Ry4Q9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ahe4IChpZ882BFE6SFo7Xo4s3XAWB0w5xIL8kx/UW3M=;
	b=w9Q28ZahIkDlCXge0lZ5RZ+yQNWDCp6iCqUuk+4KJAoOql5xyOKnq1z++iy09/aTrQzh
	 L+XUKvLw0GVumSqMB0Od1mgaSipxhkpHyo/+mbx9GHVfcl+ebKBTUqgF9lu8/MEZyK8xP
	 WPljnLy71tsOk9TCgR2d5FnvzuHtEFhKYtjUpkMrXpFoBkIpM3Vh3LgRq4TArFvsbedlM
	 SZzMeU6Y6F2bbrm4Bg+JwJ89OH3yyBsNQAmr5aWOvoOEZXmsMmgaSrN35eTjCRidmx4Xg
	 320ACGZo+pGmmCNPt9ypNRAGPPDludbWWRNBpiDpC+WBCha64Rx6Paw1SRHKE3Ch1Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HSNsoKev;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CA0606B8BD;
	Sat,  7 Nov 2026 14:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HSNsoKev
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BFF1F008A2;
	Sat,  7 Nov 2026 14:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063517;
	bh=ahe4IChpZ882BFE6SFo7Xo4s3XAWB0w5xIL8kx/UW3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSNsoKev56FxEraBx9rbJPhXdHYi4ivvGmznSEyiYJu4cOlEzGEmrcvViFRQNwMQl
	 HZZOOpRd941PLJCObEYP4T0xARPj0M90AttEQexgUcjmIaOlF04z6dBSlzC/nzy9IN
	 hWZGxtm/YBrASZfFax3I+/PLCpfC8R6zlkITD3QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 659/869] ALSA: compress: fix buffer leak on failed SET_PARAMS
Date: Sat,  7 Nov 2026 08:55:41 -0500
Message-ID: <20261107134915.419974437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 065cdfaef1eaa..c4114186b0d11 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -661,8 +661,15 @@ snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
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



