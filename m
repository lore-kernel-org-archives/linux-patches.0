Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4E93537FC;
	Wed,  8 Apr 2026 18:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672273; cv=none; b=BfZOhihXy6OKVzha9zFYnPlmnhyL3+KlP6SVUXYGfh2oVcsRqkvNloV5GkGouA6ZzJPE7Ip7qTnrDYgvAVsxStLpPnGu70vrsb4Rmd9cbymAIgO1cD+vWjFh1nunWHQQCD72++tZ6v8dbW7OY4jZx5FKjE3V0y3lULkovQA6dzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672273; c=relaxed/simple;
	bh=F/97+6CanWAGssZ74JTlCm54BCw6kJ+k9a+Uuj0kT4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhX/1A4eVkCWx2aySQGEKmjWaIZ1/Cu4bUnBXoeXWWqYJ8Myrzj667dlCpKYjQt3qXdY5HyDDhbCneVnyHoYfpFcfetiCoCqV4dmf+n+oYnb+6EFqFEPwVeWDPgyYvaZg7Ny+o0MjKIbcPSHRiFeizmgIJYE92lRmCk8+lhR49w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqyEb9b0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqyEb9b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0973C19421;
	Wed,  8 Apr 2026 18:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672273;
	bh=F/97+6CanWAGssZ74JTlCm54BCw6kJ+k9a+Uuj0kT4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqyEb9b0WOv/WZAa0ZgFTh1XKJrtbyION/hkW273oEfBUhYx6AjUxG7sTUf89TDu3
	 vPNzh3LP8yv4zlrYoSDoEedW0Ojw0COYXU3q/8W9Gj27zdaxjKa4inoAp5juEeJddV
	 69NmVrNQqTv4N/PyYyTFU6yhp4KPDihGocUGdVIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+19bed92c97bee999e5db@syzkaller.appspotmail.com,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 255/312] USB: dummy-hcd: Fix locking/synchronization error
Date: Wed,  8 Apr 2026 20:02:52 +0200
Message-ID: <20260408175943.271830069@linuxfoundation.org>
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

commit 616a63ff495df12863692ab3f9f7b84e3fa7a66d upstream.

Syzbot testing was able to provoke an addressing exception and crash
in the usb_gadget_udc_reset() routine in
drivers/usb/gadgets/udc/core.c, resulting from the fact that the
routine was called with a second ("driver") argument of NULL.  The bad
caller was set_link_state() in dummy_hcd.c, and the problem arose
because of a race between a USB reset and driver unbind.

These sorts of races were not supposed to be possible; commit
7dbd8f4cabd9 ("USB: dummy-hcd: Fix erroneous synchronization change"),
along with a few followup commits, was written specifically to prevent
them.  As it turns out, there are (at least) two errors remaining in
the code.  Another patch will address the second error; this one is
concerned with the first.

The error responsible for the syzbot crash occurred because the
stop_activity() routine will sometimes drop and then re-acquire the
dum->lock spinlock.  A call to stop_activity() occurs in
set_link_state() when handling an emulated USB reset, after the test
of dum->ints_enabled and before the increment of dum->callback_usage.
This allowed another thread (doing a driver unbind) to sneak in and
grab the spinlock, and then clear dum->ints_enabled and dum->driver.
Normally this other thread would have to wait for dum->callback_usage
to go down to 0 before it would clear dum->driver, but in this case it
didn't have to wait since dum->callback_usage had not yet been
incremented.

The fix is to increment dum->callback_usage _before_ calling
stop_activity() instead of after.  Then the thread doing the unbind
will not clear dum->driver until after the call to
usb_gadget_udc_reset() safely returns and dum->callback_usage has been
decremented again.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: syzbot+19bed92c97bee999e5db@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/68fc7c9c.050a0220.346f24.023c.GAE@google.com/
Tested-by: syzbot+19bed92c97bee999e5db@syzkaller.appspotmail.com
Fixes: 7dbd8f4cabd9 ("USB: dummy-hcd: Fix erroneous synchronization change")
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/46135f42-fdbe-46b5-aac0-6ca70492af15@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -461,8 +461,13 @@ static void set_link_state(struct dummy_
 
 		/* Report reset and disconnect events to the driver */
 		if (dum->ints_enabled && (disconnect || reset)) {
-			stop_activity(dum);
 			++dum->callback_usage;
+			/*
+			 * stop_activity() can drop dum->lock, so it must
+			 * not come between the dum->ints_enabled test
+			 * and the ++dum->callback_usage.
+			 */
+			stop_activity(dum);
 			spin_unlock(&dum->lock);
 			if (reset)
 				usb_gadget_udc_reset(&dum->gadget, dum->driver);


