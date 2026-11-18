Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025945;
	b=HYevwp+FsI9ivPhQtg+UCLJsa+oUzbROHsT6e4Svh657jdg3dFW4Q+F7fR7rmRuFKGza
	 YSUml+IXK40BDdgSKBTxTGbIlb0NSg+WG/xATYWtcoy/vwwBzdDpBkQCq2iY6Lif6Apn8
	 j5WpQSlW3QU4Nul9d+Fd2YHa1qJcS+dOqRhV+uvuOMyAs82CoMldvavZT/filBK3nYW/N
	 /JqJDsO/J3mEyYjNZ5wwxVu72gjKyGpGCyOw2ucNk56rZtyBAjvodzs8XMUbWnxJnW3gp
	 uq1jGA6P2vxl5+pHycBqgeD+ndsUcTkByvCR1v/ePqv7B8AUuyaItihdfBXoZHAXwcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=39v5iY3FPEEOE6YC+a53Yxd+UUEPVOv6n2T5S1Xz3HE=;
	b=teqdct8wdqKuoZJ3FtFQ5XtOlx/hCWlSHaRWniMYpzxK0+gArgr+l/ad2tIunTJgQFe5
	 POsoVZAFW9QCt3/fciHeGE4tFVdN/yEaSfWt4YAmW7hqnMC9nkTIkE4854FfGKgUt91G7
	 TjT9luxgTrv8nCZnnG5ohreQ/y/I9YIkWaZBlyhENiqnxmw/IWN0ZzS0TdVy9BT3ZiSF5
	 SO8w7EB2Xcl8PhzJb5/O/G0GCFnzIOcpLD1o76pIslQv7VX+AzWDdNpGreoyuLM9UitmQ
	 KZrtqUOrh0svVxb4LhgYHYhYRanfqTY3bi6qsWEUwQKgNhRaiCN38VN0T9j1u7NUMew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TLmZjD6W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED19606A31C;
	Wed, 18 Nov 2026 18:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TLmZjD6W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8381F000C7;
	Wed, 18 Nov 2026 18:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025944;
	bh=39v5iY3FPEEOE6YC+a53Yxd+UUEPVOv6n2T5S1Xz3HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLmZjD6WUpOH5rfdiTqLRzv4d7B5V7otaC5wR6LKQ0TBMhOEX2Z2e2DghIac4IDs2
	 nMpw96Gnl29I9U/3eI6knNgMZpZMguiFGOQ5FcbRR4dZIgN7V32Lyuar5e73/Kx6Yg
	 kefR3EoITfZHyQpMkRE68wLFovKnH1OcpU4yPpmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1260/2151] ALSA: pcmtest: Fix a bogus pointer read in snd_pcmtst_pcm_pointer()
Date: Wed, 18 Nov 2026 15:49:55 +0100
Message-ID: <20261118150208.052211131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 905a07c711baf184d01aebd3cf9028a89bcd8b7f ]

Sashiko reported a potential bogus value for a pcmtest driver when a
concurrent call to PCM pointer is invoked while the pcmtest's timer
callback is running: since the position is updated in the timer
callback without locking, the following wrapping in inc_buf_pos()
might be screwed up:
	if (v_iter->buf_pos >= bytes)
		v_iter->buf_pos %= bytes;
Although it was reported as an OOB, the actual return is corrected
inside buffer_size, so no corruption is expected in this scenario, but
an error message could show a bogus value.

Also, the whole state is read and modified locklessly in the timer
callback, which can be racy against the pause operation, too.

For avoiding those races, simply put the PCM stream lock in the timer
callback (while the snd_pcm_period_elapsed() must be changed to its
*_under_stream_lock() variant for avoiding the deadlock).

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 315a3d57c64c ("ALSA: Implement the new Virtual PCM Test Driver")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172051.13240-7-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/pcmtest.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/drivers/pcmtest.c b/sound/drivers/pcmtest.c
index 1b95826e8754e..29fe119630153 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -345,6 +345,7 @@ static void timer_timeout(struct timer_list *data)
 	v_iter = timer_container_of(v_iter, data, timer_instance);
 	substream = v_iter->substream;
 
+	guard(pcm_stream_lock_irqsave)(substream);
 	if (v_iter->suspend)
 		return;
 
@@ -358,7 +359,7 @@ static void timer_timeout(struct timer_list *data)
 	v_iter->period_pos += v_iter->b_rw;
 	if (v_iter->period_pos >= v_iter->period_bytes) {
 		v_iter->period_pos %= v_iter->period_bytes;
-		snd_pcm_period_elapsed(substream);
+		snd_pcm_period_elapsed_under_stream_lock(substream);
 	}
 
 	if (!v_iter->suspend)
-- 
2.53.0



