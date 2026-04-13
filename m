Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767D823D7E3;
	Mon, 13 Apr 2026 16:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096212; cv=none; b=Ee8i/kszYx3JSjXs6Jhi28meUqsRv8zyT+rULMr1EfPhL7WcriA+0hXiCDX57niOLgqVkTRHgKKbwQhzTT9B4+OkxVL+F7KKNQw9V3tsMgnBkSytoZSXOblV4cgP5c29tLa3J66p5E3m+snz9fOwPJ6IRQBu1XkqfELr8msjEHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096212; c=relaxed/simple;
	bh=qZXCtpng1xF+M4bvj27OdVbIKdbApOMkrxl9YM/h2Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujfzLSDQ6MP/Qv8YDG5eZKJxCBKxvzbCzKPeG4kMNPwm0AbeoTRklP8owpnc5vYtgkjJmuowwnmil56Eto8XscZ/YVkOP9TLp54i57cRTp1b9eqVxA/FzmLXOiFw9hZPIZ0ezmFNIBtwwsJtTZKi52SfnR7x9bg9scwZGEfiZsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vnx/vxAN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vnx/vxAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06248C2BCAF;
	Mon, 13 Apr 2026 16:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096212;
	bh=qZXCtpng1xF+M4bvj27OdVbIKdbApOMkrxl9YM/h2Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vnx/vxANKDedJBUtJphibsM8RGGozfogqLEz20PZxvE7E9LDQoz773TA+EReGBENf
	 iDvot/rJuLRSXuyF44SHgdiTy+X1yVC/VUBz3JxbtNd2ppYPW7U6S4xwt2Aa5GdRjK
	 xNel7XKB0VVGWr1GpbwKoyJqXqKtzZzrqmvg6aOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.19 11/86] Input: uinput - take event lock when submitting FF request "event"
Date: Mon, 13 Apr 2026 17:59:18 +0200
Message-ID: <20260413155731.995975486@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit ff14dafde15c11403fac61367a34fea08926e9ee upstream.

To avoid racing with FF playback events and corrupting device's event
queue take event_lock spinlock when calling uinput_dev_event() when
submitting a FF upload or erase "event".

Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Link: https://patch.msgid.link/adXkf6MWzlB8LA_s@google.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/uinput.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -25,8 +25,10 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/lockdep.h>
 #include <linux/miscdevice.h>
 #include <linux/overflow.h>
+#include <linux/spinlock.h>
 #include <linux/input/mt.h>
 #include "../input-compat.h"
 
@@ -76,6 +78,8 @@ static int uinput_dev_event(struct input
 	struct uinput_device	*udev = input_get_drvdata(dev);
 	struct timespec64	ts;
 
+	lockdep_assert_held(&dev->event_lock);
+
 	ktime_get_ts64(&ts);
 
 	udev->buff[udev->head] = (struct input_event) {
@@ -147,6 +151,7 @@ static void uinput_request_release_slot(
 static int uinput_request_send(struct uinput_device *udev,
 			       struct uinput_request *request)
 {
+	unsigned long flags;
 	int retval = 0;
 
 	spin_lock(&udev->state_lock);
@@ -160,7 +165,9 @@ static int uinput_request_send(struct ui
 	 * Tell our userspace application about this new request
 	 * by queueing an input event.
 	 */
+	spin_lock_irqsave(&udev->dev->event_lock, flags);
 	uinput_dev_event(udev->dev, EV_UINPUT, request->code, request->id);
+	spin_unlock_irqrestore(&udev->dev->event_lock, flags);
 
  out:
 	spin_unlock(&udev->state_lock);


