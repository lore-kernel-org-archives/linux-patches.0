Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019227;
	b=qV10xMTx3YTgiqKmvKVOaKpQs1vogYTYpXAeTMD/aK9dlkgQXgH/UAdbxceCf1EJ4DlC
	 FBrOgF01M2rXf45LxWRgdCaiwyhI9rvGRQmp+2LgGKhPeXRy3XC8qUtKd9wcEBKVgH5hW
	 KmTOI48TH8FgfYl20XbkO2OL9Nbzvf1EEiN5a23WQoFRS5+UBCAC6NY3j7b2f9g0o2uPa
	 MPvmQrAUwcFKu7bMBE1Ck+IVOyhCQH0c+CY+D5VYeBrdtBffBdbREXr4BD/oSp+4Ne5+5
	 7Lu6i5X2/sppHE1Lj0laDFRiq+/iHN+6JDqxHFWpleIIqC2FIDj/LpuYifUaUEXKsBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sb7ccwVFJSA95oVyti/NVVCW+XSczh1QYO/4hr13w8M=;
	b=i8Vlq3O37NbOUvDUkfOkjXTzEN3g8RWTIc4yMKd5DN5iHP4zI/qCjSKQipZoMoOsT7bR
	 1oQRv1kfkqPRzz9sryiOHnjOzFJFExq8y+HOcq97KdeBal0HdzAhTiRF4mJinWvpGF0/h
	 /KKxe6/MY7zQFWHZS/gAhAKEHqhXupiNQ1naOeLy4x1m6BRpBS3Vm02GkcWIhqSUg9wye
	 GAus1i/YRlPSgmuKGRiKQx9rA8BpT8afnW5HWX6k4XLIoAQfERwKuAMqUB5W6HBHLpDPJ
	 wcq90GnSiJwk4FdfrQ25ZSmoSd0fIxPe0/Tr8DrgLiL2O6kgqbfgOER9cr/387CLVJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itLxKO2B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54502606A33B;
	Wed, 18 Nov 2026 16:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itLxKO2B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619501F000C4;
	Wed, 18 Nov 2026 16:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019226;
	bh=sb7ccwVFJSA95oVyti/NVVCW+XSczh1QYO/4hr13w8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itLxKO2BbDsK7HzHnKR3dkeCz911Jb0sw59D1whmRFtduqQrxgpY/iZZYekiXe0B+
	 CZ83EBAm07NLWRh0rl/NvHzwnM/Zzz1X0IDOaBu9T/buth9ehJaXT6EwGO+xjqd+wR
	 j8mxCp0r6gFd9Y39xVfGRF5SFjTKFDKfrdiw1WdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1520/2651] ALSA: pcmtest: Fix a bogus pointer read in snd_pcmtst_pcm_pointer()
Date: Wed, 18 Nov 2026 15:46:00 +0100
Message-ID: <20261118150342.712951480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 186e982d42e1a..fea9580593e66 100644
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



