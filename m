Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C6038C407;
	Fri,  7 Aug 2026 15:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115232; cv=none; b=TRqa1w8DxeyUK2tAX9FNpS0+1qOD7KHseypOFF+l2WyRNdIoWWlpqWe+gAcxtqI3hhtqrLpzhlmUb/iFkh8U7e+eQCudi/2CbplowhfIZYcUUl725AHOupDvgV461gW6RRe49JKXQbJqPk/UVw31RSiLnuh2OTjaIxcGBKuIZy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115232; c=relaxed/simple;
	bh=bvyj/aaixdMo5lfDm3bxZmRMtC1OV7bQDh7AnCKctsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1IEwSRm2WrMtYzamIhc4mJRH/vNyiahrp+EHWbkqMHdHzN1HJ8IhdNUqjX4FrtQFo/rG/FxKhCWzXi7zWEc0JxYz5CJVb2e0EWprJnxzhmpp9xuPmIsMebE3xTSNkBfleAZvrtnmOPeSCE+AtN43KiR58oRFrU3GQUlHvh9qZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWgZgJLM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWgZgJLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1481F00A3A;
	Fri,  7 Aug 2026 15:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115231;
	bh=49mxbZug5oUFo/WSp1qwIJMw0ghsP2zjch4PR4idPfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWgZgJLM/A5RJ8SKg27gKIcjI0p4CAMnmWajHVB3y6KTD62isylSG4ulPYo4E199G
	 iYn2uuEnQBz+X6Tfu+QkKOMYCLFrwtongUA3ZX9NscnXLxYIf+xjxj9BftiRWMB74l
	 RDnS1WF4r8i0jdTFofJHgkusGuyUVlfju2lcodj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 205/396] ALSA: seq: Fix division by zero in initialize_timer()
Date: Fri,  7 Aug 2026 16:36:05 +0200
Message-ID: <20260807143428.701175989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

commit 21e19688433452dfbbbe6b2bb670dea6eb92f0f6 upstream.

A userspace-driven ALSA timer (SND_UTIMER) lets an unprivileged user set
the backing snd_timer's hardware resolution to an arbitrary 64-bit value
via SNDRV_TIMER_IOCTL_CREATE. snd_utimer_create() only rejects zero.

When such a timer is bound to a sequencer queue, initialize_timer()
computes the tick period as

	tmr->ticks = 1000000000 / (r * freq);

where r is that user-controlled resolution and freq is the sequencer
update rate in Hz, clamped to MIN_FREQUENCY..MAX_FREQUENCY (10..6250).
A resolution of 2^63 makes the 64-bit product r * freq wrap to zero for
any even freq, including DEFAULT_FREQUENCY (1000), so the division faults
with a divide-by-zero.

The division runs under tmr->lock with interrupts disabled, so the oops
leaves the spinlock held and hangs the CPU. It is reachable by an
unprivileged user with access to /dev/snd/timer and /dev/snd/seq.

  Oops: divide error: 0000 [#1] SMP KASAN PTI
  CPU: 7 UID: 1000 PID: 456 Comm: alsa_seq_utimer Not tainted 7.2.0-rc4+
  RIP: 0010:initialize_timer.constprop.0+0x20a/0x2d0
   snd_seq_timer_start+0x15e/0x2b0
   snd_seq_control_queue+0x56f/0xba0
   snd_seq_write+0x3e0/0x730

Reject an overflowing product with check_mul_overflow() and fall back to
a single tick, which also avoids feeding a wrapped-but-nonzero divisor
(e.g. 2^63 * 1000 mod 2^64 == 0, or other resolutions wrapping to a small
value) into the period computation.

Fixes: 37745918e0e7 ("ALSA: timer: Introduce virtual userspace-driven timers")
Cc: <stable@vger.kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Link: https://patch.msgid.link/DF8A3844-AD5E-4B8A-9CFC-BD83C212BA38@doyensec.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/seq/seq_timer.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/sound/core/seq/seq_timer.c
+++ b/sound/core/seq/seq_timer.c
@@ -362,11 +362,10 @@ static int initialize_timer(struct snd_s
 	tmr->ticks = 1;
 	if (!(t->hw.flags & SNDRV_TIMER_HW_SLAVE)) {
 		unsigned long r = snd_timer_resolution(tmr->timeri);
-		if (r) {
-			tmr->ticks = (unsigned int)(1000000000uL / (r * freq));
-			if (! tmr->ticks)
-				tmr->ticks = 1;
-		}
+		unsigned long den;
+
+		if (r && !check_mul_overflow(r, freq, &den))
+			tmr->ticks = max(1U, (unsigned int)(1000000000uL / den));
 	}
 	tmr->initialized = 1;
 	return 0;


