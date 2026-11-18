Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038821;
	b=qifT32nGyfKeuSWLPKg1tgfbq9tdWve4fZTRLXGW9iKnQGg6E2Vl270uPgWHOoI+vCLf
	 utNGTDwbrz/65Fhm2W+kfQJhQBVWU4MWmTFxE+MTu42nx0fxcNuhwv5XWNPND/k4ZXIcK
	 qpEbsUwDPRkZYn+mzj/sAS9zgZQSCW6HL4NIj44GVumeLa8JfSaDdNSfmgG9MtS6NvQwt
	 0YFy5rWPIYkWYCyG5AEEn9NhH8ksw7o5aUYb4XM+5YzvtF0E7rWV8aPArXrBj+eIHpk0L
	 4EoFsCnqc9x0C58ZQrHVU5y+FAw8s8RwhZWaxpGpQJZPDHa4pJir7DqRTRtQkWtFZrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q6M4XBaqd/XgfDQDY9tmBgZ7oQejCKv7dlasl2PVlz8=;
	b=FY1iQHaaolkjQGIzFJvVMDcqyXTJph2JvQ/ehdi1H5CPepYKxDZdbmxyME/SztnkHx4f
	 9cuJOtLrxNXyzN/w5H7BTH6/9AGm47RiAZG0zhARcb53kVbhkuErAx16MSWD2vspBpx59
	 YNmTIo2wCC815xspoKvimempoVen8ZZY5WDGwVa+qtWMfeO6VxilDA76xQQ1mnDk6Zhct
	 EYbpFzoGXuQZNgxDIFa3G63Pd1lubwSVnhCBZc5y9XBrVxReJ+N239gwdE1hpE3SE6Vfm
	 cJnZ0BrshNzVF+Lcvs6r8y1iPpgk1lykqO4pJOHD/PrI0URKyVcwjwuQmrUwBZkgYEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zqDMYGjh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380C0606A32C;
	Wed, 18 Nov 2026 21:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zqDMYGjh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D831F000C6;
	Wed, 18 Nov 2026 21:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038821;
	bh=q6M4XBaqd/XgfDQDY9tmBgZ7oQejCKv7dlasl2PVlz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zqDMYGjhPUzAvN1uz6xVXuaAcVwmlg1NbUhU4lZql8xREZrDQMQconpTNsuUywPGH
	 fBM6KLMVP1zIwxwE+E87NE2IOlEL5j4tXvBFdRm55BkpO6CQ79skc8lqZoKVYcGJPo
	 G25Wi7X0QuEc9cQWjH/270frXQS9eDWIAVDZn0Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1872/3318] ALSA: compress: fix buffer leak on failed SET_PARAMS
Date: Wed, 18 Nov 2026 15:41:34 +0100
Message-ID: <20261118150418.127009949@linuxfoundation.org>
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
index b7c0ff1b9b5a1..79a10e258c51b 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -607,8 +607,15 @@ snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
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
 			return retval;
+		}
 
 		if (stream->next_track)
 			return retval;
-- 
2.53.0



