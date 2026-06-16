Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB1A466B79;
	Tue, 16 Jun 2026 16:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627442; cv=none; b=G8PyBU23EcUCtIq2+mwiUgPAYWO7PpB4H+Hzx/qohBwyQuftoLjrxKhWb2HVywlSLf2PSpcobdhZf+wyapOJwcntht+jDBnbX8LVVIbz+viQb+cBbWp2kN+toMG7DsCSgC4qpd9gy4crhpDrCKppK8vlJvNDVCCEU9960EBzD5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627442; c=relaxed/simple;
	bh=F2ffQaJzh7XPFRtZftclpK0dVuo4ChXcNFVhFe3aCYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JurLpd1W+Q6hhFzmFzqX55avX9xql6ODMjKnnXk42GBikGO7L50BfGlcZ6WgWihBA4fOSAEFf6uHIXhz21X4Fyn7bPyVwku4Gw0xY5taweTulXF5L7euWnw83TVB7ZeeP5EhuE0cGKnLJTCTHjOjK+RJWS7Wlp8Qut5F8ZNp6eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sr2SJJU6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sr2SJJU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287F01F000E9;
	Tue, 16 Jun 2026 16:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627441;
	bh=Iq4YLlUOYBFKKyfXYUKyoS0PgeQ5PqV4HcBfImJ3Y3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sr2SJJU63RFe2ATnpMhkajeUzL7+mNSf02wr1lyh7iUSJLCc8heHuUCdRl842H95d
	 4huI+dMKs6S1T+XoXYp+a7tzb7hA3SSu2NvPo5QoL66zknIWJmdCaG6qh2Hs/ZzBlh
	 RXO9c7OWM7mx/CuzSvltHoUTMS4Q95peipIuLo1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 144/261] ALSA: timer: Fix UAF at snd_timer_user_params()
Date: Tue, 16 Jun 2026 20:29:42 +0530
Message-ID: <20260616145051.753054636@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 053a401b592be424fea9d57c789f66cd5d8cec11 upstream.

At releasing a timer object, e.g. when a userspace timer
(CONFIG_SND_UTIMER) gets closed and snd_timer_free() is called, it
tries to detach the timer instances and release the resources.
However, it's still possible that other in-flight tasks are holding
the timer instance where the to-be-deleted timer object is associated,
and this may lead to racy accesses.

Fortunately, most of ioctls dealing with the timer instance list
already have the protection with register_mutex, and this also avoids
such races.  But, SNDRV_TIMER_IOCTL_PARAMS isn't protected, hence the
concurrent ioctl may lead to use-after-free.

This patch just adds the guard with register_mutex to protect
snd_timer_user_params() for covering the code path as a quick
workaround.  It's no hot-path but rather a rarely issued ioctl, so the
performance penalty doesn't matter.

Reported-by: Kyle Zeng <kylebot@openai.com>
Tested-by: Kyle Zeng <kylebot@openai.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260606161145.1933447-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/timer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -1791,6 +1791,7 @@ static int snd_timer_user_params(struct
 	struct snd_timer *t;
 	int err;
 
+	guard(mutex)(&register_mutex);
 	tu = file->private_data;
 	if (!tu->timeri)
 		return -EBADFD;


