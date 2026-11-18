Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060070;
	b=lQ7l8nN7dziKe5YgZmcCzf0OIQsL0ks90hfaVXUrA0JhxqIN/vzqAKKMf/QwVDsPG0/M
	 Nmzk9r4ZafcqV4PWl9ALrTdbZtpSu9GPyhGcCh4oHuMONvth8vVLY0vhgyrIlqWk0jGgf
	 NVZV9DRa4uY5am8K2xUUM9yMsMRmIESO7tO89LU2RRw9jkhanCOl+RIwBnzexx9RUQDnf
	 PXrbNAF9MpMqEvZK9vjuC2kTB31OZNcVoFfSFf0rm+rGJERXqmEByR/1VnOw5t1QvHqaF
	 aI5375fJTsIqKX+LKLpqvD3Xq3moKTvKXUTxdtwYevtyPXoHNU4LOgV2JRV/1G5kNbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VRmXJ9oTtnxNv4NXTw+QceE+4cxVEsUYOYxPUXrxTdE=;
	b=AS9B0dQvY73eTrb8N/3cBzNkEA9VVrhGk67TwSBzF5+OqSTFVptSJDer8N9i67S+Ybxj
	 LMcDBPMLyaMZbGM+9qAdehi+7zFFSQhSCjEbjhCNvs3TIwS0ENtlxFte+2gvmgE79ft/o
	 PZZOLjuvHKqRa9hqg3YyLE85rcwX6dqqIP52btIp6BrnymUZZ/5cXi02MfsKRuy4cE4ZR
	 5zxkHcms53pNqsuqy9YIk87af67amwMN3R+wItHlZc1W5N7syF8fhQNEGsnw4NaN5tSi8
	 aj9taXJd7eYDrgXNHEX4QJVTCeOl30VZaJnytgbuM7YohLg2vHeUiTowXLmf7RHdgrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tvo0+bpg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79F8606A326;
	Thu, 19 Nov 2026 03:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tvo0+bpg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39881F000C4;
	Thu, 19 Nov 2026 03:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060069;
	bh=VRmXJ9oTtnxNv4NXTw+QceE+4cxVEsUYOYxPUXrxTdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tvo0+bpgvM58qhM7U/yp2fAd4KH84zKHXc9bAgL0Od+TSiSHjDFOG4TK2m+l/5cqa
	 ppBCiUo/4uen/rxkkmIaTjk4i1r1dV3YqbK3ubCaAtZ4myqy1LivdIVLRmV2Uvml19
	 8/ftSgdhG0hR2Pb4/AKbtEdciEXUWpsQdkzqxqyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1026/1848] ALSA: compress: fix buffer leak on failed SET_PARAMS
Date: Wed, 18 Nov 2026 15:51:04 +0100
Message-ID: <20261118150000.225899560@linuxfoundation.org>
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
[ sashal: adapted the error exit from return retval to goto out to use the existing cleanup path ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index d43bfe5623e99..bd1031bf987eb 100644
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



