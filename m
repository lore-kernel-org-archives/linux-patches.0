Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11704156F9;
	Fri,  4 Sep 2026 06:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501739; cv=none; b=Ewl3+ruNtKisXmKcCjirc/759HfL/9S3g/34/31Ik6Mt0lIpDmKO0i/7tOQJpGZBKXgCZo957QN0dTr6KmucMahkAYF6DQz7zXeKekG1RdFIG0XXyXKqFnzBmFv0RV1pnZFfqSapdqBchR27VHFQMArqwnEeuGIR1DLzssqw+5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501739; c=relaxed/simple;
	bh=wgGsbNJbN1IiWPr3hrxdAn10gY5/uHp8YrlYiwKRdH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfSDSImw2cP33Td0gyuZHkt9ow6nPMo2SMBxot/2UVExf+WxRX8FHitcfpdiz4ZaogSmA1IyMhiKGbw+W/WRQh0frtd80MlBOJeJeRNwNytcdxJwDGkOTbRWEMdL9sD7VM8FOucOrnWhnLFzOWaIlD+quw9OHhtY4zBSQ+VA4bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxNAHyVM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxNAHyVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560F11F00A3D;
	Fri,  4 Sep 2026 06:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501737;
	bh=M4jJzUbc7tAjmvzQ3KePP96lSRY72SiVpRQ68ijq2/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxNAHyVMw32Z9q7RkBKwclr0GJuS5Wawgv+aZfVHfPL97jyeUb67+ThG22fEr6Xq4
	 kM7egGuvAIZNjm+zS+zb5U8BAkRebXE7I8rW9nBBf/bQYgASxxsBTqNpKzmgAf4BB9
	 HIMO6wZKZTDlxSA7r2UwvjICp+90k9CTE08Ybq38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 488/552] ALSA: bcd2000: clear the URB pointers on disconnect
Date: Fri,  4 Sep 2026 07:00:45 +0200
Message-ID: <20260904045801.731243070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Baul Lee <baul.lee@xbow.com>

commit 459d3a64766f5ca2f1886daeaf24582831a5f5ab upstream.

bcd2000_free_usb_related_resources() frees both URBs and leaves the
pointers behind:

	usb_kill_urb(bcd2k->midi_out_urb);
	usb_kill_urb(bcd2k->midi_in_urb);

	usb_free_urb(bcd2k->midi_out_urb);
	usb_free_urb(bcd2k->midi_in_urb);

The rawmidi device outlives that call.  A substream that is still open
when the device is unplugged reaches bcd2000_midi_send() from the
trigger path on close.  That function writes to the freed URB and then
hands it to the USB core:

	bcd2k->midi_out_urb->transfer_buffer_length = BUFSIZE;
	...
	ret = usb_submit_urb(bcd2k->midi_out_urb, GFP_ATOMIC);

usb_kill_urb() does not stop a later submission either, so a submit that
races the disconnect can requeue the URB after it has been reaped.
midi_in_urb is exposed the same way: bcd2000_input_complete() resubmits
it from the completion handler.

KASAN on 7.2.0-rc5 (arm64):

  BUG: KASAN: slab-use-after-free in bcd2000_midi_send [snd_bcd2000]
  Write of size 4 at addr ffff00001827d388 by task bpoc/168
   __asan_store4
   bcd2000_midi_send [snd_bcd2000]
   bcd2000_midi_output_trigger [snd_bcd2000]
   snd_rawmidi_kernel_write1
   close_substream.part.0
  Freed by task 168:
   usb_free_urb
   bcd2000_disconnect [snd_bcd2000]

  BUG: KASAN: slab-use-after-free in usb_submit_urb
  Read of size 8 at addr ffff00001827d3b8 by task bpoc/168

Clear both pointers after freeing and test them on the paths that can
still run.  Poison the URBs before freeing them: usb_poison_urb() waits
for a running completion handler and rejects any later submission, so
after it returns the input path is quiesced and only the rawmidi trigger
path can still reach bcd2000_midi_send().  No unpoison is needed; the
URBs are freed on the next line.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: b47a22290d58 ("ALSA: MIDI driver for Behringer BCD2000 USB device")
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Link: https://patch.msgid.link/20260805013428.38204-1-baul.lee@xbow.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/bcd2000/bcd2000.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/sound/usb/bcd2000/bcd2000.c
+++ b/sound/usb/bcd2000/bcd2000.c
@@ -134,6 +134,9 @@ static void bcd2000_midi_send(struct bcd
 	if (!midi_out_substream)
 		return;
 
+	if (!bcd2k->midi_out_urb)
+		return;
+
 	/* copy command prefix bytes */
 	memcpy(bcd2k->midi_out_buf, device_cmd_prefix,
 		sizeof(device_cmd_prefix));
@@ -178,7 +181,7 @@ static int bcd2000_midi_output_close(str
 {
 	struct bcd2000 *bcd2k = substream->rmidi->private_data;
 
-	if (bcd2k->midi_out_active) {
+	if (bcd2k->midi_out_active && bcd2k->midi_out_urb) {
 		usb_kill_urb(bcd2k->midi_out_urb);
 		bcd2k->midi_out_active = 0;
 	}
@@ -348,11 +351,13 @@ static int bcd2000_init_midi(struct bcd2
 static void bcd2000_free_usb_related_resources(struct bcd2000 *bcd2k,
 						struct usb_interface *interface)
 {
-	usb_kill_urb(bcd2k->midi_out_urb);
-	usb_kill_urb(bcd2k->midi_in_urb);
+	usb_poison_urb(bcd2k->midi_out_urb);
+	usb_poison_urb(bcd2k->midi_in_urb);
 
 	usb_free_urb(bcd2k->midi_out_urb);
 	usb_free_urb(bcd2k->midi_in_urb);
+	bcd2k->midi_out_urb = NULL;
+	bcd2k->midi_in_urb = NULL;
 
 	if (bcd2k->intf) {
 		usb_set_intfdata(bcd2k->intf, NULL);


