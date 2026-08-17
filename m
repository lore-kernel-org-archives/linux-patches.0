Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D481B2E7BD6;
	Mon, 17 Aug 2026 15:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979008; cv=none; b=dX8UDzX1qhm6+dKqo121jJYQcoMsQQYZwR87NB46YEaV0JHLcNmfSgQoOtdVODNFoMhUD3ZibrP8aQs9852tAbjUJk6GG+sYrdpkdO770LYYUHHqFyGSL+ZS907XpouScRmt7kj8G7JKYug/BP5M1peX/QD66L8BvX8giBrubng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979008; c=relaxed/simple;
	bh=A/AATUARXHGtL7qfOoQZbR5QYq3dmx8hXMdR8vXNk0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3CviIP+Ucpvtwjvq23L0eZ/fd618cxXCh9GI5mRcVodJu0GVYYz1HOFtj/HaImbdQ6dep6TKFu9vrG2t5RASCpyeOhJe92J5IMAzp9r5CJGyYzl2zYttK0nh5k3Lq+N5EIzdqHl1GkqJCuwH66grfQ1vVAJ6SBBGIFvjdY1xbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WM7nAUgF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WM7nAUgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E711F000E9;
	Mon, 17 Aug 2026 15:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979006;
	bh=aIcZbfqNHf2jfWcNBiKwoMzvejhGX0IgV13H9WAc5HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WM7nAUgFQy9NAYWEquUiNYiwavcEryRBJZYNMzdZESzxSz7LSpYMNrp3TMSFu2JU5
	 fw2R4gVZ1SLYKPiCftOM8K6JBAUcCvymvqzJzsO4nSPs1fPKb0X/JSeJwhHNMNuuTK
	 4BLEuTd5fYTPhf44HM86HKhOTW5KV+AfLq9XwejA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH 6.1 077/609] usb: gadget: f_midi: cancel pending IN work before freeing the midi object
Date: Mon, 17 Aug 2026 15:26:13 +0200
Message-ID: <20260817132546.109921238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 5650c18d93a1db7e27cb5a40b394747eb4686d5b upstream.

The f_midi driver embeds a work item (midi->work) whose handler,
f_midi_in_work(), dereferences the enclosing struct f_midi through
container_of().  This work is armed from two sites: f_midi_complete(),
on a normal IN-endpoint completion, and f_midi_in_trigger(), on an ALSA
rawmidi output-stream start.

Neither f_midi_disable() nor f_midi_unbind() cancels midi->work.
f_midi_disable() only disables the endpoints and drains the in_req_fifo;
it does not synchronize the work item, and the sound card is released
asynchronously to the final free of the midi object.

The midi object is reference-counted (midi->free_ref) and is freed in
f_midi_free() only once both the usb_function reference and the rawmidi
private_data reference have been dropped.  In f_midi_unbind(),
f_midi_disable() runs before the sound card is released, so while the
USB endpoints are already disabled the rawmidi device is still usable by
an open substream.  A concurrent userspace write on such a substream can
reach f_midi_in_trigger() and queue midi->work again after
f_midi_disable() has returned.  A work item armed this way may still be
pending when the last reference drops and f_midi_free() proceeds to
kfree(midi), letting f_midi_in_work() dereference the struct after it
has been freed, a use-after-free.

For this reason cancelling midi->work in f_midi_disable() would not be
sufficient: the ALSA trigger path can rearm the work after disable()
returns.  Cancelling at the refcount-zero free site is the boundary
after which neither arming source can survive, because by then both
references that keep the midi object alive have been dropped: the USB
endpoints are already disabled and the rawmidi device has been released.

Fix this by calling cancel_work_sync(&midi->work) in the refcount-zero
block of f_midi_free(), before the embedded work_struct is freed along
with the rest of the structure.  opts->lock is a sleeping mutex, so
calling cancel_work_sync() under it is permitted, and the handler takes
midi->transmit_lock rather than opts->lock, so no self-deadlock can
occur while it waits for a running instance of the work to finish.

This issue was found by an in-house static analysis tool.

Fixes: 8653d71ce3763 ("usb/gadget: f_midi: Replace tasklet with work")
Cc: stable <stable@kernel.org>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260709150717.399083-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -1302,6 +1302,7 @@ static void f_midi_free(struct usb_funct
 	opts = container_of(f->fi, struct f_midi_opts, func_inst);
 	mutex_lock(&opts->lock);
 	if (!--midi->free_ref) {
+		cancel_work_sync(&midi->work);
 		kfree(midi->id);
 		kfifo_free(&midi->in_req_fifo);
 		kfree(midi);


