Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BC330DED5;
	Mon, 13 Apr 2026 16:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098484; cv=none; b=OQ+lLb48XwC5W96+L7PE+3w51Oq+yXbATTVw3GIbnT1pnHB5iKNqeN2hAN5oixS2LlNRQ0Ui710nw3/m/7yeG3qc+q3g8009sW7zK8n6We66/xckmMx59jsLeXaAlRc7Ea8CiS2sCXDU+yxJpBN68/XU1gCk/v+wNinq4CxMj1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098484; c=relaxed/simple;
	bh=J/rJtCC/Uujb1IikRcS5Z85BrBvLMirNGk7R6NWNc3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgnVfmTAeEDerju0Mo5b0FjT+Mn+2BlWLhtt+wQMoMtMz7nKurHvDrxGmlhuE6UJgGCto8SknHcMhfsWPl8W9S2+7e+3cIsif1LYonOajLW/5f4ajy+nh/5GhAM/9zuBrLT4NBhdJWUlS1xW1J4waZfAKLfOdw3gSAviVk+vWL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SU0FwjWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SU0FwjWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DA0C2BCB6;
	Mon, 13 Apr 2026 16:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098484;
	bh=J/rJtCC/Uujb1IikRcS5Z85BrBvLMirNGk7R6NWNc3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SU0FwjWAVW4MZ0JkqMAzTt7dy1/I3hriT0yJv5icv/hO9T/BlkZy9vqMhUgcwN/X+
	 mY1us41h4JWOx2bjshTQg+etZj9yGSgwNNvZG8A55AoSfTn85P/vtnFluVIpdD8ZBC
	 PuSr8RKR/ViLIzWahBUCV0hadUTteKdu9vpnAjAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 510/570] Input: uinput - take event lock when submitting FF request "event"
Date: Mon, 13 Apr 2026 18:00:41 +0200
Message-ID: <20260413155849.554877274@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -75,6 +77,8 @@ static int uinput_dev_event(struct input
 	struct uinput_device	*udev = input_get_drvdata(dev);
 	struct timespec64	ts;
 
+	lockdep_assert_held(&dev->event_lock);
+
 	ktime_get_ts64(&ts);
 
 	udev->buff[udev->head] = (struct input_event) {
@@ -146,6 +150,7 @@ static void uinput_request_release_slot(
 static int uinput_request_send(struct uinput_device *udev,
 			       struct uinput_request *request)
 {
+	unsigned long flags;
 	int retval = 0;
 
 	spin_lock(&udev->state_lock);
@@ -159,7 +164,9 @@ static int uinput_request_send(struct ui
 	 * Tell our userspace application about this new request
 	 * by queueing an input event.
 	 */
+	spin_lock_irqsave(&udev->dev->event_lock, flags);
 	uinput_dev_event(udev->dev, EV_UINPUT, request->code, request->id);
+	spin_unlock_irqrestore(&udev->dev->event_lock, flags);
 
  out:
 	spin_unlock(&udev->state_lock);


