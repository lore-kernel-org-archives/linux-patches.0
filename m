Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F4A3AFB1C;
	Fri,  4 Sep 2026 05:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498971; cv=none; b=OHZCfrMb3NOCTDO5r6RKhH+M306uoJ7FyYErnh2SeKT+qK0ZgWFZYwCo82lATl1XoLE99hkAu22Vniz7KjJ3voInSGwajhvU296QsPRvWATiCfze2+sgaqvW6w+x29772J3NaTOd7fjm/ESaIFlO6z5JneBn6x3EpfFfZo0hYI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498971; c=relaxed/simple;
	bh=56zxXNTwvgz0Aaej/V8r0y7+PGOtwlBv1DhhqVPYoT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qR09EocIPolIZ17bjWyZlRPnJNDa4JPsxCfttB8S+nzC63L/GIGgkr0ue8rSjbAbmBMmuWz4rVi9F/fqaPGYl2yxKKmzPQYiIFvGh7i+d7NGj1FXX1VULtVWkCw2Yx/pRSdJCo/42s0sW3TgtZ6Hw7eFrslZYJcxmkmbydpXP3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4gBgon0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4gBgon0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE731F00A3D;
	Fri,  4 Sep 2026 05:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498970;
	bh=FaMI4ABiUeDWMfvD4KY0Aef/5ixq0TY/LMz+fl9XQS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4gBgon0vlirlY2PIh6o/uxn+VDqwg9rgC5Nx4CAhfNH3MenKcufvSoCYxCR/8YNY
	 ThaNyz4fZfqimxNtQGKzz4hn6AVAkxoN58sN2PUBnOG5gnR9cg/cibm9kxw113oHT5
	 vfnmi49fyCvAxNBjijgkTQclRlWXvsioZWWhd86s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 251/713] HID: sony: fix UAF of ghl_poke_timer / ghl_urb at driver unbind
Date: Fri,  4 Sep 2026 06:53:39 +0200
Message-ID: <20260904045809.463107550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit a26705bd2e2728833e7a538ce91e58a5eeff496a upstream.

For GHL (Guitar Hero Live) dongles, sony_probe() arms a periodic timer:
ghl_magic_poke() (the timer callback) submits sc->ghl_urb, and the URB
completion ghl_magic_poke_cb() re-arms the timer with mod_timer().

sony_remove() drained the timer with timer_delete_sync() and then freed
the URB with usb_free_urb():

	timer_delete_sync(&sc->ghl_poke_timer);
	usb_free_urb(sc->ghl_urb);

timer_delete_sync() does not block re-arming, and while the URB is in
flight the timer is not pending, so the sync delete is a no-op. A URB
completion that runs after the delete re-arms the timer, and usb_free_urb()
only drops a reference -- it does not kill an in-flight URB. sc is
allocated with devm_kzalloc() and freed once sony_remove() returns, so the
re-armed ghl_poke_timer (embedded in sc) then fires on freed memory, a
use-after-free from timer softirq. This is a disconnect/rmmod race.

Poison the URB first, then shut the timer down, before freeing the URB.
usb_poison_urb() kills any in-flight URB and permanently rejects further
submissions, so a poke timer that is still pending cannot re-submit the
URB from ghl_magic_poke() in the window before timer_shutdown_sync() runs.
usb_kill_urb() would not suffice: it only cancels the in-flight URB and
leaves it submittable once it returns, so the pending timer could
re-submit it and put a fresh URB in flight over the freed sc.
timer_shutdown_sync() then drains any last callback and blocks re-arming.
The probe error path is unaffected: it is only reached before the timer
is armed.

Reproduced under KASAN on next-20260710 via dummy_hcd + raw-gadget
emulation of the GHL PS4 dongle (VID 0x1430 / PID 0x07bb): hid-sony binds
and arms the poke timer, the poke URB is held in flight, the driver is
unbound (freeing sc), then the URB is released. The completion re-arms the
timer on the freed sc, and the re-armed timer fires ~8 s later:

  BUG: KASAN: slab-use-after-free in ghl_magic_poke+0x98/0xb0
  Read of size 8 at addr ffff88810b02fd50 by task swapper/0/0
   ghl_magic_poke+0x98/0xb0
   call_timer_fn+0x35/0x2b0
   __run_timers+0x69c/0x9a0
   run_timer_softirq+0x173/0x2a0
  Allocated by task 169:  sony_probe
  Freed by task 338:      devres_release_group <- hid_device_remove (sony_remove)

Found by 0sec (https://0sec.ai) using automated source analysis.

Fixes: cc894ac55360 ("HID: sony: support for ghlive ps3/wii u dongles")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:multi-model
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-sony.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -2424,7 +2424,9 @@ static void sony_remove(struct hid_devic
 	struct sony_sc *sc = hid_get_drvdata(hdev);
 
 	if (sc->quirks & (GHL_GUITAR_PS3WIIU | GHL_GUITAR_PS4)) {
-		timer_delete_sync(&sc->ghl_poke_timer);
+		/* poison, not kill: a pending timer must not re-submit during teardown */
+		usb_poison_urb(sc->ghl_urb);
+		timer_shutdown_sync(&sc->ghl_poke_timer);
 		usb_free_urb(sc->ghl_urb);
 	}
 


