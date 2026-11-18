Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061503;
	b=TgdUHBqYHQcymwbD6lMcNKE/fPh1x0eb0/M9MbF99SAOj0ZPjmhDqmoriOdbPUu7LG90
	 F8cQzWGJd5YS2TflLrdePeBob/qwwr8IgEYx2fv7DyfAY5LVptm40hszaZXYx6kNPmYpY
	 kbblZ0lASwfmf5K1F1Q6l3G5cnULu+gZ7LtdcgLTmorkA3uuJzEyuG/7Lz7lnCBl7V1SQ
	 MvMnskaWk5EgV+pwb37E8AvLarplTdMsF1rg+IV8QKb9sHhcHIzuknEhyMdP8RXBY340k
	 La0JEEPJxf2J7k8G4BKE8S0aTnHI4clh2NsKfy8DQBW9Yc1JGU+x7MkAKtNZ1JhBbPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GRTuERCGxIME1S2sgQ2KYsBn/pnUr3aGp5xefEmWgIs=;
	b=qrteqenIVvl/1HuBzHGjIm4nyCcug23gI/PSFuP3iDjxqsZCc2icFQgexmzGkkLJ8dND
	 NinW/eg+bh4RVwdriuoJ/vPQwcyjNioZ5Lev7WhKxLyM3/3I7vpxlyXtLuqTZV+QGM17E
	 PAifI4KNZWiXRdR+kW/tpK/GgnWiH9m0FJoQB/0N7qWG4tAxyDYYN4L2jJ+MT7vMxGVBD
	 kfoGWD9DJqTJRcLjmNE40UmiEgQuD4Kv7afewmq1n6Uz1r0+HsXLA9o8IOw6i8Ths8SMF
	 IpU9lxv6zNxbTQBpbm53OUOAY8lxTCTct9d65RtjRfyNp61J6zDbCkNSrWWL8TjTIOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e0hC10w1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB54606A336;
	Thu, 19 Nov 2026 04:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e0hC10w1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B11C1F000C4;
	Thu, 19 Nov 2026 04:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061503;
	bh=GRTuERCGxIME1S2sgQ2KYsBn/pnUr3aGp5xefEmWgIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0hC10w1XvdmJ5HWYOiEDN6pLCYwwGXJGEuHfcyd+pvCuSKQP79hPmsQL77HMm1Rz
	 Qk/3WcaVIaY9YKXT8VkxnFkpwxP4dTxyD1vIQ5bbZa6GjL/ik3shC+krpm2zSJbF5c
	 1AlvgC3xPKqEvqMhQYF9F+YdDrakRLeTgwJ0E4VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1576/1848] ALSA: rawmidi: Drain input work before freeing the runtime
Date: Wed, 18 Nov 2026 16:00:14 +0100
Message-ID: <20261118150025.566009792@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 8c3529f0a8faaac7d73333486f69da1617ecc579 ]

The input runtime embeds event_work, so the work must be drained before
close_substream() frees the runtime. The cancellation in
snd_rawmidi_input_trigger() runs before close clears substream->opened,
leaving a window for snd_rawmidi_receive() to enqueue more work.

With a sequencer subscription to a USB MIDI input port, an in-flight
completion can overlap the last subscription's midisynth_unsubscribe():

1. snd_usbmidi_input_data() observes input_triggered and is delayed
   before calling snd_rawmidi_receive().
2. Unsubscribe enters close_substream(), clears input_triggered through
   the provider trigger callback and returns from cancel_work_sync().
   The substream is still opened.
3. The completion resumes. snd_rawmidi_receive() takes substream->lock,
   sees opened set and queues runtime->event_work before dropping the
   lock.
4. Close clears opened under that lock, closes the provider and frees
   the runtime. Stopping USB URBs does not drain the raw-MIDI work.
5. The queued work runs and snd_rawmidi_input_event_work() reads event
   or substream from the freed runtime, causing a use-after-free.

Cancel input event_work again after clearing opened, before closing the
provider or releasing the runtime's private data. Receive holds
substream->lock through its opened check and work enqueue, so once close
has cleared opened under that lock, no further receive can queue work.
The final cancellation therefore drains any late work before the
runtime is freed. Keep it outside the spinlock so a running callback can
finish.

Fixes: b3c705aa9e91 ("ALSA: rawmidi - Use workq for event handling")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/pm-pmb-98489078ab56528d8e4a-v2-9408ce8c8f3c70b5c10d@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/rawmidi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 0d91143eb4647..547109f033907 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -521,6 +521,9 @@ static void close_substream(struct snd_rawmidi *rmidi,
 				snd_rawmidi_output_trigger(substream, 0);
 		}
 	}
+	/* Drain input work queued after the earlier cancellation. */
+	if (substream->stream == SNDRV_RAWMIDI_STREAM_INPUT)
+		cancel_work_sync(&substream->runtime->event_work);
 	substream->ops->close(substream);
 	if (substream->runtime->private_free)
 		substream->runtime->private_free(substream);
-- 
2.53.0



