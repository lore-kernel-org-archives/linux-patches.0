Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625553;
	b=TMXQU0g8UDRqPGe1oH5NlNW4Tapr37qgGz1Mlj+OihJVtk1v4LCZUK6mKLuh4qMXAev+
	 IkzjaO68tiXPsIrI/tEq7X1FCy0vHp8TYImWesoEDwB3c1n+hBw47J1hwbOOOP7KvCUBx
	 iEwzCD/g70BkoBKSSnI9M/5h+mgfZb1CVsKpvLkYYAPAaQ8ROvK0M4saJt1cm7a+ybYnI
	 5YqL067cOheLfUXLoJ+gPbP56lTPqLWzfK5DAwVBVEQ4XWWnuRtPxVvG4kJM8/++mUGwp
	 +0Oby+hwVEl4b9I+pVS7nZcKodEbR5t7TEX1lnPU604l8bLFfIwokAObp1RANFwD5cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nwi9ecTsbpIAMZDphsjivu7mfQoXBm75+fukJFVdcdI=;
	b=g5ZuGTHRb83VIk+zjS9vmzyeTACIROFtinc1mgbLxCwzBEu3um2R03AAl2vG/VZPnA5A
	 NHzK1pEtb73NDV4qRNYx3WI5tn2k721zzoVS7zDvIstC3EiX2v9X2mygSTbfrjlSE841S
	 FF5o68VYBEzltVlvS2r/tA083+I33iGr3gE0JzPCeL2rM017xDXQcfHdbRJlOmvd9KSWG
	 CWFRXoXseGJX8gk9izOiYAapp8ZcgHgQhAQDog+5D5r9XYnPdHXyMoGvjdZ4sh8euWTHB
	 mNIkbYFx1Rt/m1Ohntqeb2Wczsu0lBPZ/9PiilttW/Q4B8U36ANrQOMdz5uwWa1GB9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFJQ8zxj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99A7606A31E;
	Wed, 25 Nov 2026 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFJQ8zxj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271401F000C4;
	Wed, 25 Nov 2026 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625553;
	bh=Nwi9ecTsbpIAMZDphsjivu7mfQoXBm75+fukJFVdcdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zFJQ8zxjnNH0SV1IOE+vEWkIY2IATY6F3aFqhdSNJqIvb3HZnzDqlkQhn5q86EBFd
	 6lr8RDvI2b9aKDvxixBXm3LdigwMHiU8dTmSxwULUkl6MHmM/Fhj5oH0RhPKd0IIsU
	 Bi0ZiMUijVlwMoJ7rBhQ/2DNJxUeaNFdOcKwXyD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergei Nizovtsev <snizovtsev@cloudlinux.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 553/816] ALSA: caiaq: Kill EP1 URB before unregistering the input device
Date: Wed, 25 Nov 2026 15:35:01 +0100
Message-ID: <20261125143901.983402724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Nizovtsev <snizovtsev@cloudlinux.com>

commit 5d325345185015024a86abca4cc5fa6a3f75294e upstream.

snd_disconnect() unregisters the input device via
snd_usb_caiaq_input_disconnect() and only afterwards kills the EP1
command URB (cdev->ep1_in_urb). The EP1 completion handler
usb_ep1_command_reply_dispatch() feeds snd_usb_caiaq_input_dispatch()
for EP1_CMD_READ_{ERP,ANALOG,IO} replies, which report into
cdev->input_dev. Since commit b04dcbb7f7b1 ("ALSA: caiaq: Use
snd_card_free_when_closed() at disconnection") the input device is
unregistered from snd_usb_caiaq_input_disconnect() but cdev->input_dev
is cleared only later, in snd_usb_caiaq_input_free() from the card
destructor. As the dispatch guard only tests cdev->input_dev for NULL,
an EP1 reply that completes after input_unregister_device() but before
cdev->ep1_in_urb is killed reports into an input device that has
already been unregistered and, with no evdev client holding it open,
freed.

Normally the window is closed by the USB core: usb_unbind_interface()
calls usb_disable_interface() before ->disconnect(), which flushes the
EP1 URB as long as endpoint 0x81 belongs to the interface being
unbound. But caiaq addresses EP1 through the device-wide pipe
usb_rcvbulkpipe(usb_dev, 0x1) without checking which interface owns
the endpoint. If a device declares it in another interface, the URB
stays live across snd_disconnect() of the interface that owns the card.

This needs a crafted device descriptor; a device that has EP1 in the
interface caiaq is bound to is not affected.

Kill cdev->ep1_in_urb (and the paired midi_out_urb) before the input
and audio disconnect helpers, so no EP1 completion can run once the
input device has been unregistered.

Reproduced under KASAN with raw-gadget + dummy_hcd emulating an Audio
Kontrol 1 (17cc:0815) with the EP1 bulk pair in interface 1: only
interface 0 was bound to snd-usb-caiaq and then unbound through sysfs
while the gadget flooded EP1 with EP1_CMD_READ_ERP replies. With no PCM
stream running the window is very short and was only hit by stalling
the unbinding CPU with a kgdb breakpoint at
snd_usb_caiaq_audio_disconnect(). With the fix applied, the same test
runs clean.

  BUG: KASAN: slab-use-after-free in input_event+0x3a/0xc0
  Read of size 8 at addr ffff8880151a4028 by task sh/118

  Call Trace:
   <IRQ>
   input_event+0x3a/0xc0
   snd_usb_caiaq_input_dispatch+0xab2/0xf00
   usb_ep1_command_reply_dispatch+0x1f3/0x580
   __usb_hcd_giveback_urb+0x246/0x400
   dummy_timer+0x1415/0x3380
   __hrtimer_run_queues+0x39d/0x800
   hrtimer_run_softirq+0x187/0x2d0
   handle_softirqs+0x1ff/0x930
   __irq_exit_rcu+0x15b/0x210
   irq_exit_rcu+0xe/0x20
   sysvec_apic_timer_interrupt+0x81/0xb0
   </IRQ>
   <TASK>
   asm_sysvec_apic_timer_interrupt+0x1a/0x20
  RIP: 0010:snd_usb_caiaq_audio_disconnect+0x0/0x70
   snd_disconnect+0x81/0x110
   usb_unbind_interface+0x1a0/0x860
   device_release_driver_internal+0x2c5/0x470
   unbind_store+0xde/0x100
   </TASK>

  Allocated by task 80:
   input_allocate_device+0x47/0x340
   snd_usb_caiaq_input_init+0x4c/0x1ac0
   snd_probe+0xab3/0x1160
   usb_probe_interface+0x2ea/0x810

  Freed by task 118:
   kfree+0x1ea/0x5c0
   input_dev_release+0xab/0xd0
   device_release+0xcf/0x250
   kobject_put+0x169/0x320
   snd_disconnect+0x79/0x110
   usb_unbind_interface+0x1a0/0x860

Fixes: b04dcbb7f7b1 ("ALSA: caiaq: Use snd_card_free_when_closed() at disconnection")
Cc: stable@vger.kernel.org
Signed-off-by: Sergei Nizovtsev <snizovtsev@cloudlinux.com>
Assisted-by: Claude:claude-opus-4-8
Link: https://patch.msgid.link/20261112094904.2430318-1-snizovtsev@cloudlinux.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/caiaq/device.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -593,14 +593,19 @@ static void snd_disconnect(struct usb_in
 
 	snd_card_disconnect(card);
 
+	/*
+	 * Kill the EP1 URB before disconnecting the input device: its
+	 * completion reports into cdev->input_dev, which input_disconnect()
+	 * frees without clearing the pointer.
+	 */
+	usb_kill_urb(cdev->ep1_in_urb);
+	usb_kill_urb(cdev->midi_out_urb);
+
 #ifdef CONFIG_SND_USB_CAIAQ_INPUT
 	snd_usb_caiaq_input_disconnect(cdev);
 #endif
 	snd_usb_caiaq_audio_disconnect(cdev);
 
-	usb_kill_urb(cdev->ep1_in_urb);
-	usb_kill_urb(cdev->midi_out_urb);
-
 	snd_card_free_when_closed(card);
 }
 


