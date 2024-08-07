Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6145A81AB1;
	Wed,  7 Aug 2024 15:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043477; cv=none; b=iMWS7M9QXziwUmr/tuEkR0oJZBOyuAKuDNnQhL6fm1kg8vu4c+G9XfQWZBsnHg3BmCvMGGfvpx71znTlhzKGB0PkGd+D2JSu8ACL5/xFcW+JniNPhr5aZJBvTaGrcBWu56ts/E33x+o0Qf+3KKhHeCQLHIWXoDmOAAYayA/HNWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043477; c=relaxed/simple;
	bh=8ULmwBtjZY+0MF4ieMPtifXj22Is+e/3HId8t5uj0aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4HZUTpwLH2vB4WTVQQInugLEVn2YbyCtM6rlB2FvShmEiQCxJ4lJEbNuUrDObz5z5rY93yVYsosUnlzIyVOpq7wifvJIxCTQ3eme1OkwXonKo/DHnwJCHwb5P92Xw7yVSfqcwOwtLxIcB5aPJxne4eebaz2vtzGzOtM94skE8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mkke48Sd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mkke48Sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8599C32781;
	Wed,  7 Aug 2024 15:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043477;
	bh=8ULmwBtjZY+0MF4ieMPtifXj22Is+e/3HId8t5uj0aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mkke48SdpLSNF02jnBzFxJ/VOJb8HqZ1/0RnfDP1PULonmWbWXXGaHzi2ddQsK4dl
	 ItqMltGR21ahqj8YEDkA6Tgqe4jkxDOLjRWLnIu2ZKk4q/Uu9oKMI014KP3yGvKdg/
	 JFMQIccucQVvJW4q043XRIdHMSbvLiRB3aVq1mJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"edmund.raile" <edmund.raile@proton.me>,
	Edmund Raile <edmund.raile@protonmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 105/121] Revert "ALSA: firewire-lib: operate for period elapse event in process context"
Date: Wed,  7 Aug 2024 17:00:37 +0200
Message-ID: <20240807150022.836287493@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -615,16 +615,8 @@ static void update_pcm_pointers(struct a
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
 
@@ -1866,11 +1858,14 @@ unsigned long amdtp_domain_stream_pcm_po
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
 


