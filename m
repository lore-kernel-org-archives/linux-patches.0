Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE86471257;
	Tue, 21 Jul 2026 19:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662807; cv=none; b=kB6F8rek0p4+gipaqcORksF3ASbR9pWDxiRhVdmNCH+CExmd98KuHd0YnuluOoQ57hNxIXNKdFJ4+jYmxa80/NH+f4niqs19J3UKZfC66Q5P50wVESlZP+fNflBWjmcHHp0mrUOzi0gNj824jcbb4xmyoAXnd3xigL0kRVRcLis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662807; c=relaxed/simple;
	bh=TdSziSXKrqlaBoMB47ddgMkC89ecYkDeS8LT0pZn7FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8lNJMiKq8jX5yJbIr/MBgppKYkKggUzrcfXr47gX3rLm5BO/wQVSPDi+M2U+tpsJH9b6//bejr/SnRHIViIcyUZ8KCWf3FQrCAQnZrggoaeBQo31B6YhOpeR1f3Sq0OJ9eVQCv7AC6+NdUY9qvdiIsX0ymKYJR+87UrZ+1T1U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBZ7Tibm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBZ7Tibm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A621F000E9;
	Tue, 21 Jul 2026 19:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662806;
	bh=pB7AFv7YFjq7WkAGvSKUk6t076JA8Rf7OO/Xvofr5Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uBZ7TibmKuSQtghIi1EYW/2IqZ6PjcfEIp4x5trQvW5KnQzcAtejS/QqlmyE2O5fO
	 lzOrUzJGqrFP5isg/rC+/LWE4e1Zqff13BlyLVsQ/5QeNXiNczlZL6bD1Aa+hLIyuo
	 bPBbVolsu236aEqYe151Q2tgVffoz6TNizioaj3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0583/1276] ALSA: usb-audio: Kill MIDI 2.0 URBs before freeing endpoints
Date: Tue, 21 Jul 2026 17:17:06 +0200
Message-ID: <20260721152459.162705689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit f199c8a8bdd54296d3458777e70fe82a78bd9817 ]

MIDI 2.0 input URBs are started during snd_usb_midi_v2_create(). A
later setup failure can still jump to snd_usb_midi_v2_free(), which
currently frees each endpoint and its coherent URB buffers without first
stopping the submitted URBs. A completion can then dereference the
embedded URB context and endpoint state after they have been freed, or
try to resubmit from the stale endpoint.

This was observed as a KASAN slab-use-after-free in
input_urb_complete().

The buggy scenario involves two paths, with each column showing the order
within that path:

probe error path:                         USB completion path:
1. start_input_streams() submits          1. The HCD still owns a
   input URBs.                               submitted input URB.
2. A later setup helper returns           2. input_urb_complete() runs
   an error.                                 with urb->context in ep.
3. snd_usb_midi_v2_free() frees           3. The completion reads ep
   endpoint storage and URB buffers.         state and can requeue URBs.

Make the endpoint destructor follow the same teardown ordering used for
disconnect when the endpoint has not already been disconnected: publish
ep->disconnected, kill the URBs synchronously, and drain the endpoint
before freeing URB buffers and endpoint storage. The guard avoids
repeating the stop sequence after the normal
snd_usb_midi_v2_disconnect_all() path, while still synchronizing the
direct MIDI 2.0 create-error free path.

Validation reproduced this kernel report:
BUG: KASAN: slab-use-after-free in input_urb_complete+0x37/0x1b0
Workqueue: usb_hub_wq hub_event
RIP: 0010:_raw_spin_unlock_irq+0x2e/0x50
Read of size 8
Call trace:
  dump_stack_lvl+0x77/0xb0
  print_report+0xce/0x5f0
  input_urb_complete+0x37/0x1b0 (sound/usb/midi2.c:186)
  srso_alias_return_thunk+0x5/0xfbef5
  __virt_addr_valid+0x19f/0x330
  kasan_report+0xe0/0x110
  __usb_hcd_giveback_urb+0x112/0x1d0
  dummy_timer+0xaaa/0x19a0
  lock_is_held_type+0x9a/0x110
  __lock_acquire+0x467/0x28b0
  mark_held_locks+0x40/0x70
  _raw_spin_unlock_irqrestore+0x44/0x60
  lockdep_hardirqs_on_prepare+0xbb/0x1a0
  __hrtimer_run_queues+0x101/0x520
  hrtimer_run_softirq+0xd0/0x130
  handle_softirqs+0x15b/0x670
  __irq_exit_rcu+0xd0/0x170
  irq_exit_rcu+0xe/0x20
  sysvec_apic_timer_interrupt+0x6c/0x80
  asm_sysvec_apic_timer_interrupt+0x1a/0x20

Fixes: d9c99876868c ("ALSA: usb-audio: Create UMP blocks from USB MIDI GTBs")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/20260618170010.191433-1-zzzccc427@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/midi2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/usb/midi2.c b/sound/usb/midi2.c
index 6f04aa7f685b7a..95c21c9bf906cf 100644
--- a/sound/usb/midi2.c
+++ b/sound/usb/midi2.c
@@ -478,6 +478,11 @@ static int create_midi2_endpoint(struct snd_usb_midi2_interface *umidi,
 static void free_midi2_endpoint(struct snd_usb_midi2_endpoint *ep)
 {
 	list_del(&ep->list);
+	if (!ep->disconnected) {
+		ep->disconnected = 1;
+		kill_midi_urbs(ep, false);
+		drain_urb_queue(ep);
+	}
 	free_midi_urbs(ep);
 	kfree(ep);
 }
-- 
2.53.0



