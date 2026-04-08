Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C697AB67E;
	Wed,  8 Apr 2026 18:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673477; cv=none; b=EHwFffqCSFUkt8XRooqllUaKO8iHEJirGSOpYxo1RrBJi6BX8wg6V7UFCYMHOQ/aFa9vu1K3UBfyS5zU3GrGbc5xKEEnAz/eiQkHRM4qQH7OhY6VTf97Qs7QabjKCvDgnPWLI0Zs4txovrxMrlE0W8gY71DXhm1l3kp7Buh+ezM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673477; c=relaxed/simple;
	bh=sX+5U6MOpH6wZWsJrP3qPJ0+lkruYa+Nmn5NkqlCzfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEGprkOT8o9keAHSAL3BHbb2gKxKW5Ix41v8IR58a2bTtSv4WbG1ZnVWdSIojqelk7A9uvZl0H6urEDrE5alOYOVEmfSV+IHIzFRz2QHeVauXQsV8Njz93NXr0XDmLSTJP1ayOXoeCTIMmBDUj7Ekjv1/0EWrnp70FR+6AGHqGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvc+z2JQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvc+z2JQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9DFC19425;
	Wed,  8 Apr 2026 18:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673477;
	bh=sX+5U6MOpH6wZWsJrP3qPJ0+lkruYa+Nmn5NkqlCzfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cvc+z2JQLiwZDMxz4NSBHwRUJZ0XrbDSTpRrEGctZL0FrhKQh9mS6IqH1nstUgVjO
	 X5kFSLTIypOMR0n/wOg+7XSf+6tVTNth7lFTHKPY5V3CWBNblYAOud0jiCnAfHCJPb
	 ZzEkVVMVm3bKQNWRWetyUYqajN/LovBzxzHEZW0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	syzbot+19bed92c97bee999e5db@syzkaller.appspotmail.com,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 246/277] USB: dummy-hcd: Fix locking/synchronization error
Date: Wed,  8 Apr 2026 20:03:51 +0200
Message-ID: <20260408175943.044040541@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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
@@ -462,8 +462,13 @@ static void set_link_state(struct dummy_
 
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


