Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBD52EF9BC;
	Thu,  3 Jul 2025 15:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554831; cv=none; b=ugW1MkXsK6U/wPYVTwiqdgdYlVcCHmkzOTE6PPN2EhXp0h55JUCpBCibddhdgkYcEVZq1MmHPoq1QrC/mrdgXdaBBq44RlZvGtPWD/q9JWbi67Cijm9gKKTqutYL+Ld03JiCu2P6f2vmoSn5dERamhxw8m+bPp4icAMWInVu1UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554831; c=relaxed/simple;
	bh=dES3D7HfvDVdMW5xeXm3w2biPcVktBlfCNSH4HhZWjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6TdOlOZxbwzPXdL6Cyo9dn9xd5M0zPbVamkAXv6WeSyuBTDiGqdiMQkUhR+eGkdonjLMqwfCNlWIC1YUBvoC40P023LHKbrCdVr3ugQUWMR/ZB0bbBM/oOUvJffvPCtBVXLSg82X9YMTXu7b0bwI5Nbwf5SoMyQDJpjONdVr1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VRM6djUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VRM6djUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D137C4CEED;
	Thu,  3 Jul 2025 15:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554831;
	bh=dES3D7HfvDVdMW5xeXm3w2biPcVktBlfCNSH4HhZWjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRM6djUimZYH6v4Gw9xgEVa0lfpNa9T4ga2JMHSGaFfrZvs62dcddRop6XMAUB9xn
	 lv3jvEabmv3wctcsom06IJ3L/twoghlKBR0Ad8N8/y9WaG8NmZmwFY4MjjmUXn7A4L
	 gtXSM4jYtmkClvaGJTX6kz9h2osgOQMKDqA03ME4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Korsgaard <peter@korsgaard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 062/263] usb: gadget: f_hid: wake up readers on disable/unbind
Date: Thu,  3 Jul 2025 16:39:42 +0200
Message-ID: <20250703144006.793166064@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Korsgaard <peter@korsgaard.com>

[ Upstream commit 937a8a3a8d46a3377b4195cd8f2aa656666ebc8b ]

Similar to how it is done in the write path.

Add a disabled flag to track the function state and use it to exit the read
loops to ensure no readers get stuck when the function is disabled/unbound,
protecting against corruption when the waitq and spinlocks are reinitialized
in hidg_bind().

Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
Link: https://lore.kernel.org/r/20250318152207.330997-1-peter@korsgaard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_hid.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index c7a05f842745b..d8bd2d82e9ec6 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -75,6 +75,7 @@ struct f_hidg {
 	/* recv report */
 	spinlock_t			read_spinlock;
 	wait_queue_head_t		read_queue;
+	bool				disabled;
 	/* recv report - interrupt out only (use_out_ep == 1) */
 	struct list_head		completed_out_req;
 	unsigned int			qlen;
@@ -329,7 +330,7 @@ static ssize_t f_hidg_intout_read(struct file *file, char __user *buffer,
 
 	spin_lock_irqsave(&hidg->read_spinlock, flags);
 
-#define READ_COND_INTOUT (!list_empty(&hidg->completed_out_req))
+#define READ_COND_INTOUT (!list_empty(&hidg->completed_out_req) || hidg->disabled)
 
 	/* wait for at least one buffer to complete */
 	while (!READ_COND_INTOUT) {
@@ -343,6 +344,11 @@ static ssize_t f_hidg_intout_read(struct file *file, char __user *buffer,
 		spin_lock_irqsave(&hidg->read_spinlock, flags);
 	}
 
+	if (hidg->disabled) {
+		spin_unlock_irqrestore(&hidg->read_spinlock, flags);
+		return -ESHUTDOWN;
+	}
+
 	/* pick the first one */
 	list = list_first_entry(&hidg->completed_out_req,
 				struct f_hidg_req_list, list);
@@ -387,7 +393,7 @@ static ssize_t f_hidg_intout_read(struct file *file, char __user *buffer,
 	return count;
 }
 
-#define READ_COND_SSREPORT (hidg->set_report_buf != NULL)
+#define READ_COND_SSREPORT (hidg->set_report_buf != NULL || hidg->disabled)
 
 static ssize_t f_hidg_ssreport_read(struct file *file, char __user *buffer,
 				    size_t count, loff_t *ptr)
@@ -1012,6 +1018,11 @@ static void hidg_disable(struct usb_function *f)
 	}
 	spin_unlock_irqrestore(&hidg->get_report_spinlock, flags);
 
+	spin_lock_irqsave(&hidg->read_spinlock, flags);
+	hidg->disabled = true;
+	spin_unlock_irqrestore(&hidg->read_spinlock, flags);
+	wake_up(&hidg->read_queue);
+
 	spin_lock_irqsave(&hidg->write_spinlock, flags);
 	if (!hidg->write_pending) {
 		free_ep_req(hidg->in_ep, hidg->req);
@@ -1097,6 +1108,10 @@ static int hidg_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 		}
 	}
 
+	spin_lock_irqsave(&hidg->read_spinlock, flags);
+	hidg->disabled = false;
+	spin_unlock_irqrestore(&hidg->read_spinlock, flags);
+
 	if (hidg->in_ep != NULL) {
 		spin_lock_irqsave(&hidg->write_spinlock, flags);
 		hidg->req = req_in;
-- 
2.39.5



