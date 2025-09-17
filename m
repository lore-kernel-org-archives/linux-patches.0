Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E03A3161B6;
	Wed, 17 Sep 2025 13:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114186; cv=none; b=IzAjaK0jx3jfKPowSFLhGS4EzjynWBTvDd2df38tpN0iDrgyPz0ZNWFYnoP/AmbVylznB1hSdRXcroL5AwBoiQ/iI+vaXSVzerB7BQ+AYyy/ISJvsQWLcSmeP3TGVP6wgEUdgSpZTs+2MBSEKaIZioFUVjubktAxbZT87TlTRE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114186; c=relaxed/simple;
	bh=b+cg9zF2V9xZustJcnua7ea9/S8HuDaYJm5b8zgfoNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5YVnh2vzfae26aNIG9POG99jgCAYAsaZy6hoMVobGtzlKjy+PchJQCMFHB4ivz401QpOJXt9s0+f5O+TB6P4w8e+hzJMUmgGSKVcNlw4VBTPOyyzJd2YFEANar88OvjapZGONeFNkB3DAF3ItYEDx6gxZ8V5oZy5vt6c0uhsVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQzxU9UU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQzxU9UU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DEBC4CEF0;
	Wed, 17 Sep 2025 13:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114186;
	bh=b+cg9zF2V9xZustJcnua7ea9/S8HuDaYJm5b8zgfoNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQzxU9UUnwHW5jxOkeF8X8fLXc11ABxjnrBnsJMEIg4lokjJhjYDUy2EAQ1RXucfR
	 5s8MFb+OMS9fPE749+4G+NRf+DbgeMqsXtSZx3QIwvrKVrV2lCinY6NEm12rVEaCQM
	 A6Q7RRarrcKfGKeAfwNsbOIMIyu3Cp5XuxUBRDs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>,
	Yunseong Kim <ysk@kzalloc.com>,
	syzbot+8baacc4139f12fa77909@syzkaller.appspotmail.com,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 6.1 70/78] USB: gadget: dummy-hcd: Fix locking bug in RT-enabled kernels
Date: Wed, 17 Sep 2025 14:35:31 +0200
Message-ID: <20250917123331.290710739@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 8d63c83d8eb922f6c316320f50c82fa88d099bea upstream.

Yunseong Kim and the syzbot fuzzer both reported a problem in
RT-enabled kernels caused by the way dummy-hcd mixes interrupt
management and spin-locking.  The pattern was:

	local_irq_save(flags);
	spin_lock(&dum->lock);
	...
	spin_unlock(&dum->lock);
	...		// calls usb_gadget_giveback_request()
	local_irq_restore(flags);

The code was written this way because usb_gadget_giveback_request()
needs to be called with interrupts disabled and the private lock not
held.

While this pattern works fine in non-RT kernels, it's not good when RT
is enabled.  RT kernels handle spinlocks much like mutexes; in particular,
spin_lock() may sleep.  But sleeping is not allowed while local
interrupts are disabled.

To fix the problem, rewrite the code to conform to the pattern used
elsewhere in dummy-hcd and other UDC drivers:

	spin_lock_irqsave(&dum->lock, flags);
	...
	spin_unlock(&dum->lock);
	usb_gadget_giveback_request(...);
	spin_lock(&dum->lock);
	...
	spin_unlock_irqrestore(&dum->lock, flags);

This approach satisfies the RT requirements.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Fixes: b4dbda1a22d2 ("USB: dummy-hcd: disable interrupts during req->complete")
Reported-by: Yunseong Kim <ysk@kzalloc.com>
Closes: <https://lore.kernel.org/linux-usb/5b337389-73b9-4ee4-a83e-7e82bf5af87a@kzalloc.com/>
Reported-by: syzbot+8baacc4139f12fa77909@syzkaller.appspotmail.com
Closes: <https://lore.kernel.org/linux-usb/68ac2411.050a0220.37038e.0087.GAE@google.com/>
Tested-by: syzbot+8baacc4139f12fa77909@syzkaller.appspotmail.com
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: stable@vger.kernel.org
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/bb192ae2-4eee-48ee-981f-3efdbbd0d8f0@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -764,8 +764,7 @@ static int dummy_dequeue(struct usb_ep *
 	if (!dum->driver)
 		return -ESHUTDOWN;
 
-	local_irq_save(flags);
-	spin_lock(&dum->lock);
+	spin_lock_irqsave(&dum->lock, flags);
 	list_for_each_entry(iter, &ep->queue, queue) {
 		if (&iter->req != _req)
 			continue;
@@ -775,15 +774,16 @@ static int dummy_dequeue(struct usb_ep *
 		retval = 0;
 		break;
 	}
-	spin_unlock(&dum->lock);
 
 	if (retval == 0) {
 		dev_dbg(udc_dev(dum),
 				"dequeued req %p from %s, len %d buf %p\n",
 				req, _ep->name, _req->length, _req->buf);
+		spin_unlock(&dum->lock);
 		usb_gadget_giveback_request(_ep, _req);
+		spin_lock(&dum->lock);
 	}
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&dum->lock, flags);
 	return retval;
 }
 


