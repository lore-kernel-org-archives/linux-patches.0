Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026303;
	b=EBAAlUyYyO/iMSfDqi2eldZevuIQK7qS1QArgFgJFVw2eRNTcHcaGaiL/BFI/yRFvhtt
	 sHflVPWUmKh7k2mhGPgpEVbvXaF28NmcP803s93cU/gCBc3Nf29jtfIcHkBSZ0Q5NhDFN
	 YfEggQ09OSLlZAAmwsB8t1aSITL1E15H49rM2tzuaRGwPqA/u7c/SZA3VbSbgHw7wew7N
	 LOXDUwo4h8zF0VzCPJ71ITPF0eSkufKqn9wu15LUymRTbmutnRNnFK+4HWOVHvJGhekvr
	 POZ2S7ffyN4TV7JgvoIt4e0ZOLtvucXS/F//UAADwNIAvQ+yrtcI12T35LALuaidCtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rHxCnZfSQt/L2Q2Fro2b3ASQRs03yox5tqoxX75Iybk=;
	b=gtYE6SZDnKgaFlrY7e7rRajRNvzEkCEzOkRHiLhvgZuko2JLLwNAflNPzqTg9+1lANRj
	 O+ykW4BJQ4sC315I6K8w8cEHUs5qv/kDMK1wP80AYQMmiC8CmCJTpqOxyzxm5I0PmJ3Fg
	 DWTTa7iUnrgPHCTqY5BsVUWrSPSSedeGcw5I+E9iuwy61dvKODF3rSo55/YgIzScMn6S+
	 wdjWxoVndhWc7poId+YbA0vDoSzjMYxECcOcFHBjGjS9wOa06a5EzRp1R+DGGtQ5NwgKX
	 CLISIk8pFrAu1LKq0Pplv1m96+qSZ7mo8H/nkXPSzPLCN4jR3nvtEBUnXQ26yMPy1PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LWeLmR5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0F8606A320;
	Wed, 18 Nov 2026 18:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LWeLmR5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B841F000C4;
	Wed, 18 Nov 2026 18:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026302;
	bh=rHxCnZfSQt/L2Q2Fro2b3ASQRs03yox5tqoxX75Iybk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LWeLmR5avL30B7ieU8MhfT1dfrUMcjUGqpy8c0yx5yFbygfY8/FgXgVA9uo/XxSq
	 fAKCOqypSy1Gno9yhFA7sHhtZvIxOkGIhQHiIJxlI2pAqK1zSxMfWirGbeC4Y1uSmn
	 40GZypdGKb1CcEJdK86RBLBvbM60Ya3s1PAw707E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1388/2151] ALSA: rawmidi: Drain input work before freeing the runtime
Date: Wed, 18 Nov 2026 15:52:03 +0100
Message-ID: <20261118150212.566580360@linuxfoundation.org>
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
index 63c8978c98750..efbc9ff4c1150 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -557,6 +557,9 @@ static void close_substream(struct snd_rawmidi *rmidi,
 		substream->opened = 0;
 		substream->append = 0;
 	}
+	/* Drain input work queued after the earlier cancellation. */
+	if (substream->stream == SNDRV_RAWMIDI_STREAM_INPUT)
+		cancel_work_sync(&substream->runtime->event_work);
 	substream->ops->close(substream);
 	if (substream->runtime->private_free)
 		substream->runtime->private_free(substream);
-- 
2.53.0



