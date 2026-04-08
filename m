Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E2C3BB4A;
	Wed,  8 Apr 2026 19:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674974; cv=none; b=jVRp7cm1EPIosglYc1UMtzrTk2NtQ+jDntgW2naF7ervgVHOOu8o/0K91hL4NQ0xnfWjGWiVP3W3s4E9QrZAB2kO39gEuYjjUe5UZsak+vyNGmVUtj8ztC5F8Q1ifPd0NFZhY4OLf8OtHJU37n9G4cJtbdykztaOQ7wj29YEb4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674974; c=relaxed/simple;
	bh=BkvcciFQdfzrknvbTFDHtfCVccZja8BHt1Go6ArZsKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEVEbs/xOETee2mh84H/1Y/K1NZMFinIcUal7tSi8AufY8XfJ/i2/Q0LbE4xiR9PAxDCyStVvXP5DLxHdamB93PUrd85mlawJ9FjUaskdG/NtW/9V9UNtkT5ErfOkkVDmh9X84A/rE3Zmirfo9IISxL5IOB94hS8XRqz8G2ST3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mptK/gBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mptK/gBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C9CC2BC87;
	Wed,  8 Apr 2026 19:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674974;
	bh=BkvcciFQdfzrknvbTFDHtfCVccZja8BHt1Go6ArZsKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mptK/gBo0qIl3limsKKMAHm4RCZoNsdgAGchnFY7a3mdQIqLFFz5dYyWSfTrh4eTQ
	 Fe3C9Y8D1L4v4aaoV+I8kjtGf+QsJn9VoXSxsX1Fkk/ugqzg+cxKap50djxcKOBbFz
	 DoYpy5QZuIACg+whW30ohRKSswNGQ1taqxXdGSI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Zimmermann <sigmaepsilon92@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.19 305/311] usb: gadget: f_hid: move list and spinlock inits from bind to alloc
Date: Wed,  8 Apr 2026 20:05:05 +0200
Message-ID: <20260408175950.755246751@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

From: Michael Zimmermann <sigmaepsilon92@gmail.com>

commit 4e0a88254ad59f6c53a34bf5fa241884ec09e8b2 upstream.

There was an issue when you did the following:
- setup and bind an hid gadget
- open /dev/hidg0
- use the resulting fd in EPOLL_CTL_ADD
- unbind the UDC
- bind the UDC
- use the fd in EPOLL_CTL_DEL

When CONFIG_DEBUG_LIST was enabled, a list_del corruption was reported
within remove_wait_queue (via ep_remove_wait_queue). After some
debugging I found out that the queues, which f_hid registers via
poll_wait were the problem. These were initialized using
init_waitqueue_head inside hidg_bind. So effectively, the bind function
re-initialized the queues while there were still items in them.

The solution is to move the initialization from hidg_bind to hidg_alloc
to extend their lifetimes to the lifetime of the function instance.

Additionally, I found many other possibly problematic init calls in the
bind function, which I moved as well.

Signed-off-by: Michael Zimmermann <sigmaepsilon92@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260331184844.2388761-1-sigmaepsilon92@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_hid.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -1262,17 +1262,8 @@ static int hidg_bind(struct usb_configur
 	if (status)
 		goto fail;
 
-	spin_lock_init(&hidg->write_spinlock);
 	hidg->write_pending = 1;
 	hidg->req = NULL;
-	spin_lock_init(&hidg->read_spinlock);
-	spin_lock_init(&hidg->get_report_spinlock);
-	init_waitqueue_head(&hidg->write_queue);
-	init_waitqueue_head(&hidg->read_queue);
-	init_waitqueue_head(&hidg->get_queue);
-	init_waitqueue_head(&hidg->get_id_queue);
-	INIT_LIST_HEAD(&hidg->completed_out_req);
-	INIT_LIST_HEAD(&hidg->report_list);
 
 	INIT_WORK(&hidg->work, get_report_workqueue_handler);
 	hidg->workqueue = alloc_workqueue("report_work",
@@ -1608,6 +1599,16 @@ static struct usb_function *hidg_alloc(s
 
 	mutex_lock(&opts->lock);
 
+	spin_lock_init(&hidg->write_spinlock);
+	spin_lock_init(&hidg->read_spinlock);
+	spin_lock_init(&hidg->get_report_spinlock);
+	init_waitqueue_head(&hidg->write_queue);
+	init_waitqueue_head(&hidg->read_queue);
+	init_waitqueue_head(&hidg->get_queue);
+	init_waitqueue_head(&hidg->get_id_queue);
+	INIT_LIST_HEAD(&hidg->completed_out_req);
+	INIT_LIST_HEAD(&hidg->report_list);
+
 	device_initialize(&hidg->dev);
 	hidg->dev.release = hidg_release;
 	hidg->dev.class = &hidg_class;


