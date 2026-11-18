Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047391;
	b=gsPVHKBIAhdHk/IEmSelDH/8RuFRKw1T4EL9Y2i0fyXqcihfCRZJO3E9vWFn9kRUbSpe
	 R0Lg2UWK1Dcl9vF8H5O9kEQdz9+C4HHHwfUgC45DdZkdRRpuXoyGrVVgecmVJcVREl/kv
	 +R+rE5nJ1IMTfHs93aTlznNIKskrlRjLbYgMs8zn79qlPcxxPxQ1b/b4qoez60mXgoYTh
	 MroTBl8ttEKY1kjtxlRNkbESbDeLA0KqPzc9FNdf83yM32qFqGYYFm2WDeVTlRBUgy7dG
	 7ZGxzfRU1Rr8Gt1k2wk9aX1eMB+P/IuDhNfl/kLvZXsKUn0WbSRxdJvCqYMITHEcLzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sXqbKLKbiqw9v4RTTlKCZPm4/qvG+kkuu9LK061snpk=;
	b=03JOA0bTOeHddZFTcJJg/RQ+cHUCrN0SeDxe9BsVsa70OkU0rWm/x7dHsAmFfFcOdj0v
	 r9XPpxghGrDGKfBU8V3eY3tKwEGHHzB8FK5S0u6tWyNn540BFItq/9BbkMerqQSRj76aY
	 Cr3gxM0mGTG0BuatYCIDX1BpIaVUrx0Xol0Sg6lGxLn/8hc6GyxpgGDdI7HCN/PVKqXTg
	 GA5/uVG7FGL4plt25YsgElbr4HCNwHf2IwCm9Ln+HaJC0pDzXRv5Vu7I0r5QHXo6FfG0D
	 XvX+2/U6xqBR5eYcqXGMdrR2lUes5zZ1h3U127/O6msQE0q9FANYCzYwHcghTi9WoZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=toUAiMd6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6335A606A31C;
	Thu, 19 Nov 2026 00:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=toUAiMd6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A351F000C5;
	Thu, 19 Nov 2026 00:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047391;
	bh=sXqbKLKbiqw9v4RTTlKCZPm4/qvG+kkuu9LK061snpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=toUAiMd6Yl7Frg2XcTcBmIX4GnaiwKp1s6b2+ZiBWW4HKOOcLxqvJy61QuIQvVo23
	 vSr0KdWij00SA65nLxI5ovnf+HlpRxj2Cf50CZfaungneIfheANdW6H3OoLiw9szz6
	 oC3OF1m7z45I77+OF8HVi4jbMJRYvTZnHQUbpdmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1622/2857] ALSA: compress: fix buffer leak on failed SET_PARAMS
Date: Wed, 18 Nov 2026 15:44:16 +0100
Message-ID: <20261118150259.745793437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Retained goto out instead of a direct return to preserve explicit params cleanup. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index e961d79f076bb..08289fe8d5519 100644
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



