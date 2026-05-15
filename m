Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1003C76A0;
	Fri, 15 May 2026 16:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861861; cv=none; b=XHtaHOZoVb8/+kGBHa8GG8+MGfKXgImmsBgHD6Q1XblKJ/nGvpKfBMXY6kxmN/BjAN9Bk6/orLdbKzo178WQiAY+1WOhO2zP73EbRG/3mmc1j7AZ4zMxyT8GReM3UZZzlKOeOO+PKpbviiK9xhbNmG1qLi33/GDEZgVIKIUBkK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861861; c=relaxed/simple;
	bh=ZIFj9J5MbGwZchrGzDeRf0VRgmpNOY21cdWxI4pzEfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5Frtg8U+8Bj3/tHKI6kQJLRGK8pYiedplFmKv1R7z8WQLQ5J0NJhwcOau+4B7jzbiFCujxEmYfvontIeltpk8RkdkzBWE63mkXYOhSgFbN8oy4iM+n6CK3Z6yQ1JbSrymHYJBssm1D/zLm6t/iymtLMv4rOMatLRpZp+WiTtAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9ZTzcLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9ZTzcLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F845C2BCB0;
	Fri, 15 May 2026 16:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861860;
	bh=ZIFj9J5MbGwZchrGzDeRf0VRgmpNOY21cdWxI4pzEfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9ZTzcLxxDtEx1SekaOYWhxytGnU/rm/B858T+o0cZE8N4FRi8DYcDavW5ZN4+vj7
	 BbICA13M7T6jukZXSNaOzs0gEE21MqC0G9iyxIri3aVVkQ3WoFnxoJ/VNXZTWbM9rr
	 OSeN+XTQEoLcByTRBWfgWowg/GPBUEdCLXlstO3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 002/188] HID: appletb-kbd: fix UAF in inactivity-timer cleanup path
Date: Fri, 15 May 2026 17:46:59 +0200
Message-ID: <20260515154657.364742646@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Sangyun Kim <sangyun.kim@snu.ac.kr>

commit 4db2af929279c799b5653a39eb0795c72baffca4 upstream.

Commit 38224c472a03 ("HID: appletb-kbd: fix slab use-after-free bug in
appletb_kbd_probe") added timer_delete_sync(&kbd->inactivity_timer) to
both the probe close_hw error path and appletb_kbd_remove(), but the
way it was wired in left the inactivity timer reachable during driver
tear-down via two distinct windows.

Window A -- put_device() before timer_delete_sync():

	put_device(&kbd->backlight_dev->dev);
	timer_delete_sync(&kbd->inactivity_timer);

The inactivity_timer softirq reads kbd->backlight_dev and calls
backlight_device_set_brightness() -> mutex_lock(&ops_lock).  If a
concurrent hid_appletb_bl unbind drops the last devm reference
between these two calls, the backlight_device is freed and the
mutex_lock() touches freed memory.

Window B -- backlight cleanup before hid_hw_stop():

	if (kbd->backlight_dev) {
		timer_delete_sync(...);
		put_device(...);
	}
	hid_hw_close(hdev);
	hid_hw_stop(hdev);

Even after Window A is closed, hid_hw_close()/hid_hw_stop() still run
afterwards, so a late ".event" callback from the HID core (USB URB
completion on real Apple hardware) can arrive after
timer_delete_sync() drained the softirq but before put_device() drops
the reference.  That callback reaches reset_inactivity_timer(), which
calls mod_timer() and re-arms the timer.  The freshly re-armed timer
can then fire on the about-to-be-freed backlight_device.

Both windows produce the same KASAN slab-use-after-free:

  BUG: KASAN: slab-use-after-free in __mutex_lock+0x1aab/0x21c0
  Read of size 8 at addr ffff88803ee9a108 by task swapper/0/0
  Call Trace:
   <IRQ>
   __mutex_lock
   backlight_device_set_brightness
   appletb_inactivity_timer
   call_timer_fn
   run_timer_softirq
   handle_softirqs
  Allocated by task N:
   devm_backlight_device_register
   appletb_bl_probe
  Freed by task M:
   (concurrent hid_appletb_bl unbind path)

Close both windows at once by reworking the tear-down in
appletb_kbd_remove() and in the probe close_hw error path so that

 1) hid_hw_close()/hid_hw_stop() run before the backlight cleanup,
    guaranteeing no further .event callback can fire and re-arm the
    timer, and
 2) inside the "if (kbd->backlight_dev)" block, timer_delete_sync()
    runs before put_device(), so the softirq is drained before the
    final reference is dropped.

Fixes: 38224c472a03 ("HID: appletb-kbd: fix slab use-after-free bug in appletb_kbd_probe")
Cc: stable@vger.kernel.org
Signed-off-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-appletb-kbd.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/hid/hid-appletb-kbd.c
+++ b/drivers/hid/hid-appletb-kbd.c
@@ -440,13 +440,13 @@ static int appletb_kbd_probe(struct hid_
 unregister_handler:
 	input_unregister_handler(&kbd->inp_handler);
 close_hw:
-	if (kbd->backlight_dev) {
-		put_device(&kbd->backlight_dev->dev);
-		timer_delete_sync(&kbd->inactivity_timer);
-	}
 	hid_hw_close(hdev);
 stop_hw:
 	hid_hw_stop(hdev);
+	if (kbd->backlight_dev) {
+		timer_delete_sync(&kbd->inactivity_timer);
+		put_device(&kbd->backlight_dev->dev);
+	}
 	return ret;
 }
 
@@ -457,13 +457,13 @@ static void appletb_kbd_remove(struct hi
 	appletb_kbd_set_mode(kbd, APPLETB_KBD_MODE_OFF);
 
 	input_unregister_handler(&kbd->inp_handler);
+	hid_hw_close(hdev);
+	hid_hw_stop(hdev);
+
 	if (kbd->backlight_dev) {
-		put_device(&kbd->backlight_dev->dev);
 		timer_delete_sync(&kbd->inactivity_timer);
+		put_device(&kbd->backlight_dev->dev);
 	}
-
-	hid_hw_close(hdev);
-	hid_hw_stop(hdev);
 }
 
 #ifdef CONFIG_PM


