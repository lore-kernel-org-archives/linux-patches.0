Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91291E3DF2;
	Tue, 30 Sep 2025 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243900; cv=none; b=bCtztw/lfaiz56+yOVouiTHguBhqqBZGfwQDTaTvsjJK6Pbxjt3QuAH/V9YGipWlGbD/VLUuhAaig+XQZs/WEp8WjXNNJQs0EuoHNIBRLVQo3fiNtARmbK4Blua7Znx6mRVaSCFTEMyE+MsmjNmmGd/nhGuAozrcKEmossOqunM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243900; c=relaxed/simple;
	bh=bc0qDpzHA0wkhhE4INKxc8FeAuaF4i4nqrWI/9Cohp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyIP5Sn7GhYxdjw4rlbpDYv0b+QINN5x1uUom2BVtfncbzUAmuYRxCBwtNvF+rz1cUXnOPQEsLsVfXnm7tIUfRSXt2b/jWc5NAQqfEPbD460gM9JtAGAd6gKgtfb5mUwcq6fdbGsqNs/gapYpB9mzLIT9X0cWCWElW7bwx5d8R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duzVuUFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duzVuUFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E863C4CEF0;
	Tue, 30 Sep 2025 14:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243900;
	bh=bc0qDpzHA0wkhhE4INKxc8FeAuaF4i4nqrWI/9Cohp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duzVuUFYOXv070BPAj0axILHxxv2I99aqGWfvnRqwJo5EYLD4Pa+wK89JShbIhrKU
	 J4TBbkdDHVMb393RmcScl1fYqsG4jtKiZ875QPKaWN//1N+sY5zthK3Bw0mRCdRrai
	 wXRpNAj8vO+xYv3uTeDrJUBjdk36nb8qrwZa3fBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>,
	Yunseong Kim <ysk@kzalloc.com>,
	syzbot+8baacc4139f12fa77909@syzkaller.appspotmail.com,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 50/81] USB: gadget: dummy-hcd: Fix locking bug in RT-enabled kernels
Date: Tue, 30 Sep 2025 16:46:52 +0200
Message-ID: <20250930143821.777451418@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit 8d63c83d8eb922f6c316320f50c82fa88d099bea ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -758,8 +758,7 @@ static int dummy_dequeue(struct usb_ep *
 	if (!dum->driver)
 		return -ESHUTDOWN;
 
-	local_irq_save(flags);
-	spin_lock(&dum->lock);
+	spin_lock_irqsave(&dum->lock, flags);
 	list_for_each_entry(iter, &ep->queue, queue) {
 		if (&iter->req != _req)
 			continue;
@@ -769,15 +768,16 @@ static int dummy_dequeue(struct usb_ep *
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
 


