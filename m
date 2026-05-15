Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888334315A;
	Fri, 15 May 2026 16:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861863; cv=none; b=JsNnBt9e/Hd5oknTkxPVdBxCosrr8gYKqJyX02SUZn9gkdbze56mDzFixVGBCTU8QWN7jS6FCdtkMfQZYzazf4HTgXnAgo0GAdvTbZBKle5SHYz7IsbrOBQPH+dtbXKvmOqAnQDTElh/URjbu64+8LdX5E1cjlKqgiVj6Ggk7GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861863; c=relaxed/simple;
	bh=x4gOSPn6zwODSf3b0xxw9P8HMJgAjpQpEFajEg9ot5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mx5s7hDbC6BxPfUbKfOrurJ04dTvuLwBhUxaNWendWW0lprrXMrfjCbJj9ri/Zlju92rukg5PpYwWqJWBvMmHOhPb4HD7O9Fl2jmAaJTf8fAbgLJIM+iX3sFquKKIeSASRoZISsDogs3URzrPk8D/445eCdK0QoSrWztGenFaaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LjtDF3K8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LjtDF3K8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEB4C2BCB0;
	Fri, 15 May 2026 16:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861863;
	bh=x4gOSPn6zwODSf3b0xxw9P8HMJgAjpQpEFajEg9ot5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjtDF3K8BsFQZYig8i4llJmRVByrN9Npk1DbjKK/n0FtK3xcZAs76NqOWEpGW75SF
	 3+uYBBf5xqIuTrCjHE6xnATgpl51TVehDCAZZBqhV22GmADXghig4ZS7vUnD5MFoRp
	 fTd6UMRRzihEwN5mQ/9Pd1MH9IV6nkzHl6ZZr5pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 003/188] HID: appletb-kbd: run inactivity autodim from workqueues
Date: Fri, 15 May 2026 17:47:00 +0200
Message-ID: <20260515154657.386134083@linuxfoundation.org>
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

commit 1654e53349d4e657b331de354313461f401f5063 upstream.

The autodim code in hid-appletb-kbd takes backlight_device->ops_lock
via backlight_device_set_brightness() -> mutex_lock() from two
different atomic contexts:

 * appletb_inactivity_timer() is a struct timer_list callback, so it
   runs in softirq context.  Every expiry triggers

     BUG: sleeping function called from invalid context at kernel/locking/mutex.c:591
     Call Trace:
      <IRQ>
      __might_resched
      __mutex_lock
      backlight_device_set_brightness
      appletb_inactivity_timer
      call_timer_fn
      run_timer_softirq

 * reset_inactivity_timer() is called from appletb_kbd_hid_event() and
   appletb_kbd_inp_event().  On real USB hardware these run in
   softirq/IRQ context (URB completion and input-event dispatch).
   When the Touch Bar has already been dimmed or turned off, the
   reset path calls backlight_device_set_brightness() directly to
   restore brightness, producing the same warning.

Both call sites hit the same mutex_lock()-from-atomic bug.  Fix them
together by moving the blocking work onto the system workqueue:

 * Convert the inactivity timer from struct timer_list to
   struct delayed_work; the callback (appletb_inactivity_work) now
   runs in process context where mutex_lock() is legal.
 * Add a dedicated struct work_struct restore_brightness_work and have
   reset_inactivity_timer() schedule it instead of calling
   backlight_device_set_brightness() directly.

Cancel both works synchronously during driver tear-down alongside the
existing backlight reference drop.

The semantics are unchanged (same delays, same state transitions on
dim, turn-off and user activity); only the execution context of the
sleeping call changes.  The timer field and callback are renamed to
match their new type; reset_inactivity_timer() keeps its name because
it is invoked from input event paths that read naturally as "reset
the inactivity timer".

Fixes: 93a0fc489481 ("HID: hid-appletb-kbd: add support for automatic brightness control while using the touchbar")
Cc: stable@vger.kernel.org
Signed-off-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-appletb-kbd.c |   44 ++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

--- a/drivers/hid/hid-appletb-kbd.c
+++ b/drivers/hid/hid-appletb-kbd.c
@@ -17,7 +17,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/backlight.h>
-#include <linux/timer.h>
+#include <linux/workqueue.h>
 #include <linux/input/sparse-keymap.h>
 
 #include "hid-ids.h"
@@ -62,7 +62,8 @@ struct appletb_kbd {
 	struct input_handle kbd_handle;
 	struct input_handle tpd_handle;
 	struct backlight_device *backlight_dev;
-	struct timer_list inactivity_timer;
+	struct delayed_work inactivity_work;
+	struct work_struct restore_brightness_work;
 	bool has_dimmed;
 	bool has_turned_off;
 	u8 saved_mode;
@@ -164,16 +165,18 @@ static int appletb_tb_key_to_slot(unsign
 	}
 }
 
-static void appletb_inactivity_timer(struct timer_list *t)
+static void appletb_inactivity_work(struct work_struct *work)
 {
-	struct appletb_kbd *kbd = timer_container_of(kbd, t, inactivity_timer);
+	struct appletb_kbd *kbd = container_of(to_delayed_work(work),
+					       struct appletb_kbd,
+					       inactivity_work);
 
 	if (kbd->backlight_dev && appletb_tb_autodim) {
 		if (!kbd->has_dimmed) {
 			backlight_device_set_brightness(kbd->backlight_dev, 1);
 			kbd->has_dimmed = true;
-			mod_timer(&kbd->inactivity_timer,
-				jiffies + secs_to_jiffies(appletb_tb_idle_timeout));
+			mod_delayed_work(system_wq, &kbd->inactivity_work,
+					 secs_to_jiffies(appletb_tb_idle_timeout));
 		} else if (!kbd->has_turned_off) {
 			backlight_device_set_brightness(kbd->backlight_dev, 0);
 			kbd->has_turned_off = true;
@@ -181,16 +184,25 @@ static void appletb_inactivity_timer(str
 	}
 }
 
+static void appletb_restore_brightness_work(struct work_struct *work)
+{
+	struct appletb_kbd *kbd = container_of(work, struct appletb_kbd,
+					       restore_brightness_work);
+
+	if (kbd->backlight_dev)
+		backlight_device_set_brightness(kbd->backlight_dev, 2);
+}
+
 static void reset_inactivity_timer(struct appletb_kbd *kbd)
 {
 	if (kbd->backlight_dev && appletb_tb_autodim) {
 		if (kbd->has_dimmed || kbd->has_turned_off) {
-			backlight_device_set_brightness(kbd->backlight_dev, 2);
 			kbd->has_dimmed = false;
 			kbd->has_turned_off = false;
+			schedule_work(&kbd->restore_brightness_work);
 		}
-		mod_timer(&kbd->inactivity_timer,
-			jiffies + secs_to_jiffies(appletb_tb_dim_timeout));
+		mod_delayed_work(system_wq, &kbd->inactivity_work,
+				 secs_to_jiffies(appletb_tb_dim_timeout));
 	}
 }
 
@@ -408,9 +420,11 @@ static int appletb_kbd_probe(struct hid_
 		dev_err_probe(dev, -ENODEV, "Failed to get backlight device\n");
 	} else {
 		backlight_device_set_brightness(kbd->backlight_dev, 2);
-		timer_setup(&kbd->inactivity_timer, appletb_inactivity_timer, 0);
-		mod_timer(&kbd->inactivity_timer,
-			jiffies + secs_to_jiffies(appletb_tb_dim_timeout));
+		INIT_DELAYED_WORK(&kbd->inactivity_work, appletb_inactivity_work);
+		INIT_WORK(&kbd->restore_brightness_work,
+			  appletb_restore_brightness_work);
+		mod_delayed_work(system_wq, &kbd->inactivity_work,
+				 secs_to_jiffies(appletb_tb_dim_timeout));
 	}
 
 	kbd->inp_handler.event = appletb_kbd_inp_event;
@@ -444,7 +458,8 @@ close_hw:
 stop_hw:
 	hid_hw_stop(hdev);
 	if (kbd->backlight_dev) {
-		timer_delete_sync(&kbd->inactivity_timer);
+		cancel_delayed_work_sync(&kbd->inactivity_work);
+		cancel_work_sync(&kbd->restore_brightness_work);
 		put_device(&kbd->backlight_dev->dev);
 	}
 	return ret;
@@ -461,7 +476,8 @@ static void appletb_kbd_remove(struct hi
 	hid_hw_stop(hdev);
 
 	if (kbd->backlight_dev) {
-		timer_delete_sync(&kbd->inactivity_timer);
+		cancel_delayed_work_sync(&kbd->inactivity_work);
+		cancel_work_sync(&kbd->restore_brightness_work);
 		put_device(&kbd->backlight_dev->dev);
 	}
 }


