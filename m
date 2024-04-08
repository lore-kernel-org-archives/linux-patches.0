Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838E78060C;
	Mon,  8 Apr 2024 14:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585139; cv=none; b=i+UlLOFAR49uD0I8VNy39veBqXsB67+kWpjn7b0ozCSjLuV+yDavuQCqXs9BclTA7+NFMRhpdpB99LdXIKV0DIUjqITtKGlRdNhBLx43wnxluPh/lB65kAssOgmB0B90fBCu1ZhRME4T8FWZJR5jzWvnrE7RzZUmy6vMBb9UdRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585139; c=relaxed/simple;
	bh=lVY+yN1OYKdi2t/agMTrgOAXOXVLMfY/07X5L/1KYH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6FC4jmmPdM6b6WV+AajZ0ip3nHE/wcqBv0onQdKqg6PLWthvLfONkJJco06vOKzQu/kvuIF6s/0pWDRAeIITb9Z++WYHETtgyaYUi2B3woS+qvCi1DGHu2M7lgle9uVZb0gAwfN1Ne3lUd/x0P2pWAvDkSC3tOOUXItClXOaEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPTNeTxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPTNeTxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4100C433C7;
	Mon,  8 Apr 2024 14:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585139;
	bh=lVY+yN1OYKdi2t/agMTrgOAXOXVLMfY/07X5L/1KYH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPTNeTxeDVPKaUJLhUSsfkmlxPGEyD8MTgaJhzXkaP5MrvfwiwBfnJInahzsuCrXd
	 3YWzAO+2owUlM6fmpJQME6w3WDQBrAM0OBww4+JAO10kISigGgqv4Ub56g2bb6Y8Q/
	 nMH2Zup0LSTpsN6oRQ/SSkyUEhmloZiuW14IWSXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 675/690] HID: uhid: Use READ_ONCE()/WRITE_ONCE() for ->running
Date: Mon,  8 Apr 2024 14:59:01 +0200
Message-ID: <20240408125424.165561338@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jann Horn <jannh@google.com>

[ Upstream commit c8e7ff41f819b0c31c66c5196933c26c18f7681f ]

The flag uhid->running can be set to false by uhid_device_add_worker()
without holding the uhid->devlock. Mark all reads/writes of the flag
that might race with READ_ONCE()/WRITE_ONCE() for clarity and
correctness.

Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/uhid.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index ba0ca652b9dab..09da654d2b05c 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -84,7 +84,7 @@ static void uhid_device_add_worker(struct work_struct *work)
 		 * However, we do have to clear the ->running flag and do a
 		 * wakeup to make sure userspace knows that the device is gone.
 		 */
-		uhid->running = false;
+		WRITE_ONCE(uhid->running, false);
 		wake_up_interruptible(&uhid->report_wait);
 	}
 }
@@ -194,9 +194,9 @@ static int __uhid_report_queue_and_wait(struct uhid_device *uhid,
 	spin_unlock_irqrestore(&uhid->qlock, flags);
 
 	ret = wait_event_interruptible_timeout(uhid->report_wait,
-				!uhid->report_running || !uhid->running,
+				!uhid->report_running || !READ_ONCE(uhid->running),
 				5 * HZ);
-	if (!ret || !uhid->running || uhid->report_running)
+	if (!ret || !READ_ONCE(uhid->running) || uhid->report_running)
 		ret = -EIO;
 	else if (ret < 0)
 		ret = -ERESTARTSYS;
@@ -237,7 +237,7 @@ static int uhid_hid_get_report(struct hid_device *hid, unsigned char rnum,
 	struct uhid_event *ev;
 	int ret;
 
-	if (!uhid->running)
+	if (!READ_ONCE(uhid->running))
 		return -EIO;
 
 	ev = kzalloc(sizeof(*ev), GFP_KERNEL);
@@ -279,7 +279,7 @@ static int uhid_hid_set_report(struct hid_device *hid, unsigned char rnum,
 	struct uhid_event *ev;
 	int ret;
 
-	if (!uhid->running || count > UHID_DATA_MAX)
+	if (!READ_ONCE(uhid->running) || count > UHID_DATA_MAX)
 		return -EIO;
 
 	ev = kzalloc(sizeof(*ev), GFP_KERNEL);
@@ -580,7 +580,7 @@ static int uhid_dev_destroy(struct uhid_device *uhid)
 	if (!uhid->hid)
 		return -EINVAL;
 
-	uhid->running = false;
+	WRITE_ONCE(uhid->running, false);
 	wake_up_interruptible(&uhid->report_wait);
 
 	cancel_work_sync(&uhid->worker);
@@ -594,7 +594,7 @@ static int uhid_dev_destroy(struct uhid_device *uhid)
 
 static int uhid_dev_input(struct uhid_device *uhid, struct uhid_event *ev)
 {
-	if (!uhid->running)
+	if (!READ_ONCE(uhid->running))
 		return -EINVAL;
 
 	hid_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input.data,
@@ -605,7 +605,7 @@ static int uhid_dev_input(struct uhid_device *uhid, struct uhid_event *ev)
 
 static int uhid_dev_input2(struct uhid_device *uhid, struct uhid_event *ev)
 {
-	if (!uhid->running)
+	if (!READ_ONCE(uhid->running))
 		return -EINVAL;
 
 	hid_input_report(uhid->hid, HID_INPUT_REPORT, ev->u.input2.data,
@@ -617,7 +617,7 @@ static int uhid_dev_input2(struct uhid_device *uhid, struct uhid_event *ev)
 static int uhid_dev_get_report_reply(struct uhid_device *uhid,
 				     struct uhid_event *ev)
 {
-	if (!uhid->running)
+	if (!READ_ONCE(uhid->running))
 		return -EINVAL;
 
 	uhid_report_wake_up(uhid, ev->u.get_report_reply.id, ev);
@@ -627,7 +627,7 @@ static int uhid_dev_get_report_reply(struct uhid_device *uhid,
 static int uhid_dev_set_report_reply(struct uhid_device *uhid,
 				     struct uhid_event *ev)
 {
-	if (!uhid->running)
+	if (!READ_ONCE(uhid->running))
 		return -EINVAL;
 
 	uhid_report_wake_up(uhid, ev->u.set_report_reply.id, ev);
-- 
2.43.0



