Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062463;
	b=3T+fzRraT5IVzq9uA3wy8AGdzCEX2Seg3hJMBhfDe/2sJJLl0zCAa4UfjDz/YkR/y3Z8
	 9ygC5HaDFVZuT7q0B2ZdGjxKW78YmhQwurFfaOPdPfttgqYIXJmLjVGXFXyT9b++6kw1U
	 snyc0BZg6vFOjyFlla3QiLpNptfqkqbH1z6p848Ef3m3VPlxv2co52+P3OPnCj4aC6dFL
	 yF3R1BxDqXqmmHIqH/tJBHlVGYAm6ZpkpVaTAG2Q+Mt1BGn8rDM7aCofUZXGKHr6IZyNn
	 McysHoIKxbNJ4DszIIObzhDf10rGPrVQJLYHaCMIOsy0csnJ8YnZbHcxmclAm6bmFFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zph4vbU4LvzfpVJtFPe/Xmle3TZJNJTOBfW5j3ASCPk=;
	b=EqAzvD4Qg5qTFrhREB6cEUsZWfe76jMNTHveIZtYcOdarMGn/1Wwkymdshai/dChBwBU
	 bEcvEG+B8g2UWxx4immvhwXRlF99xHvBNPWZNVSjvjiYaKvjTr67tRwhRwwx+lbMWzcsn
	 TrklXhwEAMglLU6rgc7o0PsSN9PUA+QgjRm33cPJmCRJwTU/ajsWDvOtblzcIRaqzaNOa
	 OJC2oXxpXe/dnjO3KA0GgWNjhAdt/zbSNEYNmi7kzHyM6D9Um6D73H2LlNjABNs9AeHqE
	 5sWO4fY19/iGIslhsrWkcKZjdGD5MOU9o5Obh916GcSyoURC7CpIZX1sDA/eVAW7cHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ey0sErNJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EA7606A65A;
	Sat,  7 Nov 2026 14:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ey0sErNJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29E31F008A1;
	Sat,  7 Nov 2026 14:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062463;
	bh=Zph4vbU4LvzfpVJtFPe/Xmle3TZJNJTOBfW5j3ASCPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ey0sErNJLAf0vWYoRPAnRVHRdnbLkEDoPWzvVZ0K9UhXSsnnJfPNh1GGtyU4dKP2g
	 wWsARs54Tpg1NjWaynuqr3/jkAYUfgskOpOaoO1aK+8NOWTmnIDRj6tRunNG/1NWhz
	 Ya4lij8OoCuxCPWuRN/tu0WGQ8jReNjfaVXcFoYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1369/1536] ALSA: compress: fix buffer leak on failed SET_PARAMS
Date: Sat,  7 Nov 2026 08:56:25 -0500
Message-ID: <20261107135036.291499326@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d81a890b60c65..0d5b3c655e849 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -585,8 +585,15 @@ snd_compr_set_params(struct snd_compr_stream *stream, unsigned long arg)
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



