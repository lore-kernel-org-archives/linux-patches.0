Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15700307AD9;
	Wed,  3 Dec 2025 16:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779935; cv=none; b=MPW/+Hz01y9pNBjSNi6i+iHm8v/pcfm1LbcpKMZ543kaaqGZXw/4CcZAnKgPVExtMp6tHn91qcFpI2bMdnfCrBvVAuoRHg5LgK5nzEERBLzSorn0Gu9fbKJXT+E2vOQX8kxdjHPOWWf8dEWuuk02WvYOTj2tc7AM8tAxsU6o15w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779935; c=relaxed/simple;
	bh=EvlCL4vNjL0ZlBRbcAsv2B2cNvX6oLHLGKYStMmNtqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnDl/mPh3S0Pmxkga8jQPJ2N0fSCvAy49Y9hexzFiZ62OuNGoyhdBVIGwK4Ooiq7LSZIGWrC6l4hXgRBS8dk2X/KkLi63ryomhLjN6Cm4wrpYEvnFF8ncIy7tOiWmz0PqGIlTxlv8NkMEw43BHV3izkgcpZtsXjzaTQaNa/rpbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCxzOBbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCxzOBbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3226AC116B1;
	Wed,  3 Dec 2025 16:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779934;
	bh=EvlCL4vNjL0ZlBRbcAsv2B2cNvX6oLHLGKYStMmNtqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCxzOBbL0k94fXfz9vUNsZM6WK45BbSWV/lHzlzRrwbIvytCpJY+2ZlI4LKVqAAae
	 YExzFFyo7hlObzXAm4tFv0N1u3610BWlOZ8vboZjU6rFNi/5y+9PU5UEQAZllqIA9V
	 Dg/Vc5JPJN6h5h40bLkCRo4jbMf0U/TQUShxUSzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bfd77469c8966de076f7@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 406/568] ALSA: usb-audio: Fix potential overflow of PCM transfer buffer
Date: Wed,  3 Dec 2025 16:26:48 +0100
Message-ID: <20251203152455.557940099@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 05a1fc5efdd8560f34a3af39c9cf1e1526cc3ddf upstream.

The PCM stream data in USB-audio driver is transferred over USB URB
packet buffers, and each packet size is determined dynamically.  The
packet sizes are limited by some factors such as wMaxPacketSize USB
descriptor.  OTOH, in the current code, the actually used packet sizes
are determined only by the rate and the PPS, which may be bigger than
the size limit above.  This results in a buffer overflow, as reported
by syzbot.

Basically when the limit is smaller than the calculated packet size,
it implies that something is wrong, most likely a weird USB
descriptor.  So the best option would be just to return an error at
the parameter setup time before doing any further operations.

This patch introduces such a sanity check, and returns -EINVAL when
the packet size is greater than maxpacksize.  The comparison with
ep->packsize[1] alone should suffice since it's always equal or
greater than ep->packsize[0].

Reported-by: syzbot+bfd77469c8966de076f7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bfd77469c8966de076f7
Link: https://lore.kernel.org/690b6b46.050a0220.3d0d33.0054.GAE@google.com
Cc: Lizhi Xu <lizhi.xu@windriver.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20251109091211.12739-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1379,6 +1379,11 @@ int snd_usb_endpoint_set_params(struct s
 	ep->sample_rem = ep->cur_rate % ep->pps;
 	ep->packsize[0] = ep->cur_rate / ep->pps;
 	ep->packsize[1] = (ep->cur_rate + (ep->pps - 1)) / ep->pps;
+	if (ep->packsize[1] > ep->maxpacksize) {
+		usb_audio_dbg(chip, "Too small maxpacksize %u for rate %u / pps %u\n",
+			      ep->maxpacksize, ep->cur_rate, ep->pps);
+		return -EINVAL;
+	}
 
 	/* calculate the frequency in 16.16 format */
 	ep->freqm = ep->freqn;


