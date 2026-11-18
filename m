Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054278;
	b=Znuz/L00aXpMZlNSkEtx5x7rI1EHnvrSYsGxmHtvGtWG6q+MuW7CaMDwchzV5gT73YxK
	 J0OkZWnVpJW4icr78hEkNYKxxmlBeYQe+KzY/M7ib4X8hwVlb3nQAQmBjQZnGoRDsMuAG
	 Jk6HTFWDmSr8ttp770Jm8f+2Yu50bb5p7I/BjxAr9jYwFhOAgDPjESBNkKjg4I8i9gI61
	 zSDMrvy6Iv+S6DvgjZLgEbNcQaC8jitHCrDmuZbCKr9XO+UNnFbRCB3QiOvb/yw+VNi1X
	 D166TWHHOFeyOZTyLNcBlykwGkpSqItaP/OYdjPvHaZ+xXTlzHRHdhy43YXNbTCL2Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IV9/YRVxxWVouqQhgDGHn+zldb0PVZfmxZz2REdC5nE=;
	b=jJuhcxlfH35s/mFC/B+fiJQ6z0D2R5Tke7QL9SMQgQ3512Gylo1neR0MXDSJj70YPeHT
	 o/kKL2o1cT/yGuK3y93HRdJIOMrskeZn2HvTzOtky+GIiu/zK86PQlI+R7Dnr8X/iPxHm
	 eGFvrGEOE600aiQWaIppEsOnlUJQrRwyp6iiDqYlxOUgf4ynVGPfzHmFqjeroOgCRpp1F
	 kvaNwbKlRWigGdIonIvpVPrFY4cgpy49GjMMZPh5nOBYYRByvNBxWBCeOSZhhBjpy3zZz
	 dhdx60DZzwXcuI1LzyODSYIBrwNydmVWEtQuk0JTC3Pf9ORKNTunDdJ0/fqdGlMOXSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UWYP6nnQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C08606A320;
	Thu, 19 Nov 2026 02:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UWYP6nnQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0681F000C4;
	Thu, 19 Nov 2026 02:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054278;
	bh=IV9/YRVxxWVouqQhgDGHn+zldb0PVZfmxZz2REdC5nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UWYP6nnQyRxcANj0dbjVYvwik3nlTGPJESmCQD/OoMG/PHFpQq6dqvVMljhQJNnoR
	 lttq2NRRVaXyDcG5f+ZYBcuYA6nzp3QF8m1zV0RIE4cC5ctECh0PCWhS5gF0EafNMj
	 J4F2SHrQqmrCTVpCcXXFx92oyrPtPUD1DhHGVN2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1219/2214] ALSA: compress: fix buffer leak on failed SET_PARAMS
Date: Wed, 18 Nov 2026 15:48:15 +0100
Message-ID: <20261118150100.546504189@linuxfoundation.org>
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
[ sashal: retained goto out instead of return retval to preserve explicit params cleanup ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 6b7e51e8f663c..2d7567810029e 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -602,8 +602,15 @@ snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
 		}
 
 		retval = stream->ops->set_params(stream, params);
-		if (retval)
+		if (retval) {
+			/* the stream stays OPEN: drop the buffer of the rejected setup */
+			if (stream->runtime->state == SNDRV_PCM_STATE_OPEN &&
+			    !stream->runtime->dma_buffer_p) {
+				kfree(stream->runtime->buffer);
+				stream->runtime->buffer = NULL;
+			}
 			goto out;
+		}
 
 		stream->metadata_set = false;
 		stream->next_track = false;
-- 
2.53.0



