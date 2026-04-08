Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D02385513;
	Wed,  8 Apr 2026 18:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672276; cv=none; b=Q/M1P+QM/NPVKGI/s639uBds/s80UP5nbRAOaX0wIt/2/lYR5tcdkUxwrb4jpn1x1lUMMeg6d6pdO/l+sg3pRsUYC/88plQbnuuo80oF5BnFZCBAUOHaUvC0quFw37fl4NjC38cCHEJo04BEvh9WKshEQvqCZk8EP6MmCrDxRug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672276; c=relaxed/simple;
	bh=WG04Abk588gfNqaGjRrrArR7CTDOnLX+Zhx6ep63ffw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fa1HmXhzffPbzrDcl/eossouwiL5DL/rWtm+gTznVFIuHsRKEoxy8/IQ5OafnR2aUtWrBECspfABM7D/hnrr+9oD9y/wwVO2Z1T22YlqhSz7e3h/xoWfB0KhHGf5Wx6X/+0F6Pg5NYBbclpvhEuRvdS7fpWlm2y+O04SZZtjXHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qg2WCwyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qg2WCwyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2A3C19421;
	Wed,  8 Apr 2026 18:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672276;
	bh=WG04Abk588gfNqaGjRrrArR7CTDOnLX+Zhx6ep63ffw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qg2WCwyK34JSkH2Q9uZZkVTI6NqpEwxo4jMLJNFO8SL8x2BUEc+0XWXyNHrLzs0FH
	 RiwZl6+t1BR0PeXRTTxRirpP03PL+2lMsjIvpHfOAm7Vsi1SZoV+lDUnEdsK0pg7kx
	 /L0+MdGo8QiCMz5I5Q3G/YZUJPf3pvtm/HwYJSuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 256/312] USB: dummy-hcd: Fix interrupt synchronization error
Date: Wed,  8 Apr 2026 20:02:53 +0200
Message-ID: <20260408175943.308355733@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Alan Stern <stern@rowland.harvard.edu>

commit 2ca9e46f8f1f5a297eb0ac83f79d35d5b3a02541 upstream.

This fixes an error in synchronization in the dummy-hcd driver.  The
error has a somewhat involved history.  The synchronization mechanism
was introduced by commit 7dbd8f4cabd9 ("USB: dummy-hcd: Fix erroneous
synchronization change"), which added an emulated "interrupts enabled"
flag together with code emulating synchronize_irq() (it waits until
all current handler callbacks have returned).

But the emulated interrupt-disable occurred too late, after the driver
containing the handler callback routines had been told that it was
unbound and no more callbacks would occur.  Commit 4a5d797a9f9c ("usb:
gadget: dummy_hcd: fix gpf in gadget_setup") tried to fix this by
moving the synchronize_irq() emulation code from dummy_stop() to
dummy_pullup(), which runs before the unbind callback.

There still were races, though, because the emulated interrupt-disable
still occurred too late.  It couldn't be moved to dummy_pullup(),
because that routine can be called for reasons other than an impending
unbind.  Therefore commits 7dc0c55e9f30 ("USB: UDC core: Add
udc_async_callbacks gadget op") and 04145a03db9d ("USB: UDC: Implement
udc_async_callbacks in dummy-hcd") added an API allowing the UDC core
to tell dummy-hcd exactly when emulated interrupts and their callbacks
should be disabled.

That brings us to the current state of things, which is still wrong
because the emulated synchronize_irq() occurs before the emulated
interrupt-disable!  That's no good, beause it means that more emulated
interrupts can occur after the synchronize_irq() emulation has run,
leading to the possibility that a callback handler may be running when
the gadget driver is unbound.

To fix this, we have to move the synchronize_irq() emulation code yet
again, to the dummy_udc_async_callbacks() routine, which takes care of
enabling and disabling emulated interrupt requests.  The
synchronization will now run immediately after emulated interrupts are
disabled, which is where it belongs.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: 04145a03db9d ("USB: UDC: Implement udc_async_callbacks in dummy-hcd")
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/c7bc93fe-4241-4d04-bd56-27c12ba35c97@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -912,21 +912,6 @@ static int dummy_pullup(struct usb_gadge
 	spin_lock_irqsave(&dum->lock, flags);
 	dum->pullup = (value != 0);
 	set_link_state(dum_hcd);
-	if (value == 0) {
-		/*
-		 * Emulate synchronize_irq(): wait for callbacks to finish.
-		 * This seems to be the best place to emulate the call to
-		 * synchronize_irq() that's in usb_gadget_remove_driver().
-		 * Doing it in dummy_udc_stop() would be too late since it
-		 * is called after the unbind callback and unbind shouldn't
-		 * be invoked until all the other callbacks are finished.
-		 */
-		while (dum->callback_usage > 0) {
-			spin_unlock_irqrestore(&dum->lock, flags);
-			usleep_range(1000, 2000);
-			spin_lock_irqsave(&dum->lock, flags);
-		}
-	}
 	spin_unlock_irqrestore(&dum->lock, flags);
 
 	usb_hcd_poll_rh_status(dummy_hcd_to_hcd(dum_hcd));
@@ -949,6 +934,20 @@ static void dummy_udc_async_callbacks(st
 
 	spin_lock_irq(&dum->lock);
 	dum->ints_enabled = enable;
+	if (!enable) {
+		/*
+		 * Emulate synchronize_irq(): wait for callbacks to finish.
+		 * This has to happen after emulated interrupts are disabled
+		 * (dum->ints_enabled is clear) and before the unbind callback,
+		 * just like the call to synchronize_irq() in
+		 * gadget/udc/core:gadget_unbind_driver().
+		 */
+		while (dum->callback_usage > 0) {
+			spin_unlock_irq(&dum->lock);
+			usleep_range(1000, 2000);
+			spin_lock_irq(&dum->lock);
+		}
+	}
 	spin_unlock_irq(&dum->lock);
 }
 


