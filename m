Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E644D26A1CF;
	Mon, 13 Apr 2026 16:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096847; cv=none; b=FccpPSB5I6zDUdoETLMAb7KPox4R3TEnS2FHqrkRrHYlgzc88A+ZCy/+WK5BNcfcms/FsT/YdK7fyd4qFu8+ISmJ+LJ6MFlImPb7B4FAnnVSIH1MZpW/i4T4OLbleDWJIvSb1vyJuIDwMCKG0lQ+JvzanmOO1JYqrhCPlIMfAVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096847; c=relaxed/simple;
	bh=1wvlKMfs0Mtm8n5AoktiFJFTgv62L150FVGxvhhT3pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j48iTnI1FNouFMsK1Ps+yG9t2WevP2fMEyCVsqE5CZ5jJvwlJcLsyTKcm3nUAaFRgCuq7NAc7eVx7ghlhlGVJ7KFU92+qwvoE7xzDc8GeY0X9CYPSZRh8X16uqlzLj08Et/awRdc3cVULvHhWuaNF1nGOe90H8b3joe3qSlWiiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyZs+CJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyZs+CJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771A5C2BCB0;
	Mon, 13 Apr 2026 16:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096846;
	bh=1wvlKMfs0Mtm8n5AoktiFJFTgv62L150FVGxvhhT3pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyZs+CJxuteGkyH91UlumRk+6JtvUIDoTXMhG7FLJk02wQMd9tj2juunZVY+YzXcU
	 Zib84y5RE8Otgdch+neCZrNczmJfGOcJcYPv4GYtnxu0/ZN7D06oTGcbD4krw8DtVa
	 Yc5lMc5DhujaotxIkmFRODGsvG90cFiWN4imYfWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Zimmermann <sigmaepsilon92@gmail.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 15/50] usb: gadget: f_hid: move list and spinlock inits from bind to alloc
Date: Mon, 13 Apr 2026 18:00:42 +0200
Message-ID: <20260413155725.080678853@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Zimmermann <sigmaepsilon92@gmail.com>

[ Upstream commit 4e0a88254ad59f6c53a34bf5fa241884ec09e8b2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_hid.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -1000,13 +1000,8 @@ static int hidg_bind(struct usb_configur
 	if (status)
 		goto fail;
 
-	spin_lock_init(&hidg->write_spinlock);
 	hidg->write_pending = 1;
 	hidg->req = NULL;
-	spin_lock_init(&hidg->read_spinlock);
-	init_waitqueue_head(&hidg->write_queue);
-	init_waitqueue_head(&hidg->read_queue);
-	INIT_LIST_HEAD(&hidg->completed_out_req);
 
 	/* create char device */
 	cdev_init(&hidg->cdev, &f_hidg_fops);
@@ -1275,6 +1270,12 @@ static struct usb_function *hidg_alloc(s
 
 	mutex_lock(&opts->lock);
 
+	spin_lock_init(&hidg->write_spinlock);
+	spin_lock_init(&hidg->read_spinlock);
+	init_waitqueue_head(&hidg->write_queue);
+	init_waitqueue_head(&hidg->read_queue);
+	INIT_LIST_HEAD(&hidg->completed_out_req);
+
 	device_initialize(&hidg->dev);
 	hidg->dev.release = hidg_release;
 	hidg->dev.class = &hidg_class;


