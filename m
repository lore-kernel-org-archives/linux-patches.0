Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3CB79945;
	Wed,  7 Aug 2024 15:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043721; cv=none; b=N0GRd00+uvVaCwnYGoRia4qniwqve8ts0xJz6S7tUqBG1xB44d/7UCSSo/qMjUYqgF5XuGBrZvJMGxSia/OAog9zU488OYIV0OafAMM6hMETO4+0ZemwbYlRgmTOTdM5xDRaHtDe1avP72L9YBx5ybOZkqvQ20EzojVHFMl4Kzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043721; c=relaxed/simple;
	bh=P5EM4ayrenF0CTzL0oxICcjikwuUBY2dObYWVuwHmg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeP+Hx4KfrDzxlL6vwV2u0WMIDi6SiC8up1Lp/8E15xXBQEZ8ZGusajyQlVcUU6jtMgnRTy2KAstkaUWnGkk7p6eozc3cfHjShR7QSrlKfHopaJQrRWVzYn1WiW7gOFxo5DxNWxpb6a7T/OoJLZBOqT18+7R7qtLaYnD1LmRNqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+jYIzM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+jYIzM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A919C32781;
	Wed,  7 Aug 2024 15:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043721;
	bh=P5EM4ayrenF0CTzL0oxICcjikwuUBY2dObYWVuwHmg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+jYIzM821HeN38llBTV0+AX5TLvPCGPiBrbeiGdMJuVDk4yO9k3q0Ui1f1oV/9A+
	 /BrGZKr+1BNPWBkWrUgmJIpooCwmofWtKafeJbTWH/kIOWvqiEqJYEeHWyalUOGeZb
	 uwkdjIIYGJ1tbJct8AlV8idZ4kww7Z5tyg0TCfMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"edmund.raile" <edmund.raile@proton.me>,
	Edmund Raile <edmund.raile@protonmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 75/86] Revert "ALSA: firewire-lib: operate for period elapse event in process context"
Date: Wed,  7 Aug 2024 17:00:54 +0200
Message-ID: <20240807150041.760924613@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Edmund Raile <edmund.raile@protonmail.com>

commit 3dab73ab925a51ab05543b491bf17463a48ca323 upstream.

Commit 7ba5ca32fe6e ("ALSA: firewire-lib: operate for period elapse event
in process context") removed the process context workqueue from
amdtp_domain_stream_pcm_pointer() and update_pcm_pointers() to remove
its overhead.

With RME Fireface 800, this lead to a regression since
Kernels 5.14.0, causing an AB/BA deadlock competition for the
substream lock with eventual system freeze under ALSA operation:

thread 0:
    * (lock A) acquire substream lock by
	snd_pcm_stream_lock_irq() in
	snd_pcm_status64()
    * (lock B) wait for tasklet to finish by calling
    	tasklet_unlock_spin_wait() in
	tasklet_disable_in_atomic() in
	ohci_flush_iso_completions() of ohci.c

thread 1:
    * (lock B) enter tasklet
    * (lock A) attempt to acquire substream lock,
    	waiting for it to be released:
	snd_pcm_stream_lock_irqsave() in
    	snd_pcm_period_elapsed() in
	update_pcm_pointers() in
	process_ctx_payloads() in
	process_rx_packets() of amdtp-stream.c

? tasklet_unlock_spin_wait
 </NMI>
 <TASK>
ohci_flush_iso_completions firewire_ohci
amdtp_domain_stream_pcm_pointer snd_firewire_lib
snd_pcm_update_hw_ptr0 snd_pcm
snd_pcm_status64 snd_pcm

? native_queued_spin_lock_slowpath
 </NMI>
 <IRQ>
_raw_spin_lock_irqsave
snd_pcm_period_elapsed snd_pcm
process_rx_packets snd_firewire_lib
irq_target_callback snd_firewire_lib
handle_it_packet firewire_ohci
context_tasklet firewire_ohci

Restore the process context work queue to prevent deadlock
AB/BA deadlock competition for ALSA substream lock of
snd_pcm_stream_lock_irq() in snd_pcm_status64()
and snd_pcm_stream_lock_irqsave() in snd_pcm_period_elapsed().

revert commit 7ba5ca32fe6e ("ALSA: firewire-lib: operate for period
elapse event in process context")

Replace inline description to prevent future deadlock.

Cc: stable@vger.kernel.org
Fixes: 7ba5ca32fe6e ("ALSA: firewire-lib: operate for period elapse event in process context")
Reported-by: edmund.raile <edmund.raile@proton.me>
Closes: https://lore.kernel.org/r/kwryofzdmjvzkuw6j3clftsxmoolynljztxqwg76hzeo4simnl@jn3eo7pe642q/
Signed-off-by: Edmund Raile <edmund.raile@protonmail.com>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20240730195318.869840-3-edmund.raile@protonmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/amdtp-stream.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -613,16 +613,8 @@ static void update_pcm_pointers(struct a
 		// The program in user process should periodically check the status of intermediate
 		// buffer associated to PCM substream to process PCM frames in the buffer, instead
 		// of receiving notification of period elapsed by poll wait.
-		if (!pcm->runtime->no_period_wakeup) {
-			if (in_softirq()) {
-				// In software IRQ context for 1394 OHCI.
-				snd_pcm_period_elapsed(pcm);
-			} else {
-				// In process context of ALSA PCM application under acquired lock of
-				// PCM substream.
-				snd_pcm_period_elapsed_under_stream_lock(pcm);
-			}
-		}
+		if (!pcm->runtime->no_period_wakeup)
+			queue_work(system_highpri_wq, &s->period_work);
 	}
 }
 
@@ -1752,11 +1744,14 @@ unsigned long amdtp_domain_stream_pcm_po
 {
 	struct amdtp_stream *irq_target = d->irq_target;
 
-	// Process isochronous packets queued till recent isochronous cycle to handle PCM frames.
 	if (irq_target && amdtp_stream_running(irq_target)) {
-		// In software IRQ context, the call causes dead-lock to disable the tasklet
-		// synchronously.
-		if (!in_softirq())
+		// use wq to prevent AB/BA deadlock competition for
+		// substream lock:
+		// fw_iso_context_flush_completions() acquires
+		// lock by ohci_flush_iso_completions(),
+		// amdtp-stream process_rx_packets() attempts to
+		// acquire same lock by snd_pcm_elapsed()
+		if (current_work() != &s->period_work)
 			fw_iso_context_flush_completions(irq_target->context);
 	}
 


