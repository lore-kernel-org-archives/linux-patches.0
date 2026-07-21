Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95C635AC0E;
	Tue, 21 Jul 2026 18:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657590; cv=none; b=O7WAcPj6oJsFG9NGaniiqAn0fy/JHnZ9gHaLb4oGd9WAmiWYx0ROUZ4A+CgEI5/NRnt5i6Gfys/5YAlalz7ELUUNUEDqIHS8KtEc7WQlrzQ+/UiKLJ2MKbP3keKi305ZNY+qiqKpP7zQxivcymo2L3rhyFlvcc/peCahnNjPr6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657590; c=relaxed/simple;
	bh=JXqJJi9FFngnlNpc2bfG+6o+UUAyXFpiJvDADBnL5E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOWfBz+gToiyfuzArorlrkAbHVXyRV7eq9j1K6Ma5IRNg+bguwGuXIf+Y3lTwU7LPxg4ZMqr0BKxV6n5Hos2FZ+h55O+xwBtq7ezFJrpiVlNnEHIbgKqx7g1V6tQHl+OuzjRCqVzr2peLim2VE/ofwWP3bPh4k2UrQE4W+0j40s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfX7RxAZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfX7RxAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5231F000E9;
	Tue, 21 Jul 2026 18:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657589;
	bh=yH+8pa8Gv3eC8phxTst1b7DVRx3WMQlwpGNwcXffobg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfX7RxAZmoyT36NCqJudTxbR4Qpsy3/SE6nTPv9QL36cqVVbimI4S7Qv+F4QypNyb
	 75C9bBW1trYR6ZDuH5gDLUWCtpLgzwH4k7w19BF3XaUXdNqAwE5lKqUFmUR/MgWuJJ
	 qOBvcJo6vxhhtvKS23qFLmYI+eynN7Vq+jhsy/8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0821/1611] ALSA: usb-audio: Kill MIDI 2.0 URBs before freeing endpoints
Date: Tue, 21 Jul 2026 17:15:37 +0200
Message-ID: <20260721152533.856168739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 32a3102df15c51..50b04e5a190b62 100644
--- a/sound/usb/midi2.c
+++ b/sound/usb/midi2.c
@@ -470,6 +470,11 @@ static int create_midi2_endpoint(struct snd_usb_midi2_interface *umidi,
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



