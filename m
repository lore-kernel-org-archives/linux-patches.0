Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1494C30BF68;
	Mon, 13 Apr 2026 16:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098564; cv=none; b=LADMjmZDvti0w1eTNBzZc8hls2UvjcadwzOL3XWtJ8b58m/FRYvpeI+XILDC/OBtkQrRUu5F41NEusGFiX6RqifdxyXHibHjYfqZfyTnfTxGEVsbHKkrhZvEawBvJroo76Zbfy+8LtyuDeIMqEeL1owdkmFQx972uJnIG9DyLyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098564; c=relaxed/simple;
	bh=jBZpZSDQ1k4VA21pVm9ermQisv9Lqrue+1cRn22y+2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcrrBIdm+a/ckkRcIjJIG8tr2A/QjSTybNhDSkei0wdeTGWBgbmv0xZ7cgHCaFKif7XbX4BxJi4hpyF27YOXFTn0RovYvRADhelmkmLpLIrdI9XD97nbKOpJUpeHmviwb4XS/kW2FvCQb4M5oVag+ngpfAgXXoG2gxMvOMMM9ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGe2+FLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGe2+FLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D03C2BCAF;
	Mon, 13 Apr 2026 16:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098563;
	bh=jBZpZSDQ1k4VA21pVm9ermQisv9Lqrue+1cRn22y+2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGe2+FLCEuPDTjCQ18LMQAG8pzekxcNbOII/S5MQvJfj0sdVM2m9LU0xyp0eK7SZt
	 6NGSBwjckNm/MOR4QlZnhhIFku9FPWubu+Ek2u9DbptCdeqrM7tjaPROOL4M/dZahq
	 IGwpPcnJWTVk0WLLE4+6iSfGZTrOgS4/TqMh2dwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Zimmermann <sigmaepsilon92@gmail.com>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 546/570] usb: gadget: f_hid: move list and spinlock inits from bind to alloc
Date: Mon, 13 Apr 2026 18:01:17 +0200
Message-ID: <20260413155850.900334918@linuxfoundation.org>
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
@@ -996,13 +996,8 @@ static int hidg_bind(struct usb_configur
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
@@ -1272,6 +1267,12 @@ static struct usb_function *hidg_alloc(s
 	mutex_lock(&opts->lock);
 	++opts->refcnt;
 
+	spin_lock_init(&hidg->write_spinlock);
+	spin_lock_init(&hidg->read_spinlock);
+	init_waitqueue_head(&hidg->write_queue);
+	init_waitqueue_head(&hidg->read_queue);
+	INIT_LIST_HEAD(&hidg->completed_out_req);
+
 	device_initialize(&hidg->dev);
 	hidg->dev.release = hidg_release;
 	hidg->dev.class = hidg_class;


