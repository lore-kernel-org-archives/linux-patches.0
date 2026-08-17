Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06273E4C94;
	Mon, 17 Aug 2026 13:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974436; cv=none; b=BwF52yPPm4W0euDybJGmP678zlFY73RFQasz8FtdMlBwOcCA8uT6cAXfmXwzjvJdkeXs3H/2E8yJu575IR89NFzAHs2sJ4jdrIgAR+uH+2EgcKkey7gmMPkMSkCe0B/9Ypil+9GKvz2mdIbiQKuYHF1HzalEPAKbcLBeaGpdLkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974436; c=relaxed/simple;
	bh=uLh5E+WQ/dH7Lt4H/7HzluafV1BqgHK+mGW8DST67H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6R8ERn+8wGH3wQi1taa96khQ03bJGsLNIZ4oVplADDisJDd0ePOWDjTKkKcif0ZHKB7xeIPu5F6zHWGkoQM5UINRs3ir3HIYqPDopo831JZDpi4RnpakhJzqQzd+jeStfL8duETXmTFKiff2ZImzHKABh+H4Ql3qOVlFUmPTW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3O5JkT9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3O5JkT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDC61F00A3A;
	Mon, 17 Aug 2026 13:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974431;
	bh=uAfarvOaQrBygu7W/+cE3kQliL4thSeRJbF5couAqjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3O5JkT9iTewP0FHrqgbzprv+Rb7pzBgObhGt0tRclD1zltHTyIgdpVRb8fqu0oe1
	 QMA3Nv9QDW8lGmB4AnGWrXvEVeCZ0/6rM3HTtlAkEv0zbtnQyv0Bc9vMRTlU7iUgAk
	 NBVWiCpOmH//DeH83KhK2ebQNHTyrLt05QpFM4ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 202/271] ALSA: us144mkii: re-anchor capture URBs on resubmission
Date: Mon, 17 Aug 2026 15:32:07 +0200
Message-ID: <20260817132545.135664876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baul Lee <baul.lee@xbow.com>

commit 2615f0fb90df8cf5a96133ca4be74294ed288604 upstream.

capture_urb_complete() resubmits each capture URB without anchoring it:

	usb_get_urb(urb);
	ret = usb_submit_urb(urb, GFP_ATOMIC);

Anchoring is a property of a submission, not of the URB.  The giveback
path calls usb_unanchor_urb() before urb->complete(), so an URB
resubmitted from its own completion handler is off the anchor.  The
capture URBs are anchored once, at stream start, so from the first
completion onward tascam->capture_anchor is empty.

tascam_free_urbs(), tascam_disconnect(), tascam_suspend() and the
stop-work path all call usb_kill_anchored_urbs(&tascam->capture_anchor)
to reap the capture URBs before anything is freed.  With the anchor empty
those calls return immediately and the URBs stay queued on the host
controller.

tascam_free_urbs() then returns the capture transfer buffers with
usb_free_coherent(), and snd_card_free() releases the snd_card
allocation that embeds tascam (card->private_data).  The controller
completes the queued URBs afterwards, writing device-supplied data into
the freed transfer buffer, and capture_urb_complete() dereferences the
freed driver object.

KASAN on 7.2.0-rc5 (arm64):

  BUG: KASAN: slab-use-after-free in dummy_timer
  Write of size 512 at addr ffff000015b62000
   __asan_memcpy
   dummy_timer
   hrtimer_run_softirq
  Allocated by task 64:
   usb_alloc_coherent
   tascam_alloc_urbs
   tascam_probe
  Freed by task 170:
   usb_free_coherent
   tascam_free_urbs
   tascam_disconnect
   usb_unbind_interface

  BUG: KASAN: slab-use-after-free in capture_urb_complete
  Read of size 4 at addr ffff0000170ee878
  Freed by task 170:
   release_card_device
   snd_card_free
   tascam_disconnect

Restore the usb_anchor_urb() between the reference count bump and the
resubmission.  That also makes the handler's usb_unanchor_urb() failure
arm meaningful again and restores usb_kill_anchored_urbs() as a barrier
on the disconnect, suspend and stop-work paths.

The anchoring was removed on the premise that the URB is already anchored
from the initial submission, which does not hold once the first giveback
has run.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: 5cff1529a2f9 ("ALSA: us144mkii: capture_urb_complete: redundant usb_anchor_urb corrupts anchor list on each resubmission")
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Link: https://patch.msgid.link/20260804123625.91769-1-baul.lee@xbow.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/usx2y/us144mkii_capture.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/usx2y/us144mkii_capture.c
+++ b/sound/usb/usx2y/us144mkii_capture.c
@@ -302,6 +302,7 @@ void capture_urb_complete(struct urb *ur
 	}
 
 	usb_get_urb(urb);
+	usb_anchor_urb(urb, &tascam->capture_anchor);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
 	if (ret < 0) {
 		dev_err_ratelimited(tascam->card->dev,


