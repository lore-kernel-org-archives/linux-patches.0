Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D8818026;
	Tue, 14 May 2024 11:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686488; cv=none; b=ZEN8f4U/bMFCsNVU5RorO9HVHdelMNNi+phJ4jhCCyZSjC1I4XaZZqVRFsEjLtR5GEGStb4LgCuGMBWWG6s2RlU3A/6z4knZAEO6gRHV6EUD3V2iQsY9wLQOa/oM2nRhtedrla9af1QhpO4mpVbfdAK5B4OjCgetY0/EcZEftzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686488; c=relaxed/simple;
	bh=DUBsEti82CBpVrtJoHCVc9jDeBQa/R9/u1h9rJekRw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bk8i+yARQfGCbWNDaXNaB2TCe/eCP0inIwVZY3QXAxz3eL+Y1QU1nfQ4Yh5v/IfhdzisbGMexm9+iDERk1VcZNZtt9O5SVigDXvuz+XdzbPrlHL/0y84QhAXzD0PgWqsx8UdBVojCjXjpzhTZWTnzeOIOihYmbdM7acRGmq/G38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKB+XUQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKB+XUQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A217AC2BD10;
	Tue, 14 May 2024 11:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686488;
	bh=DUBsEti82CBpVrtJoHCVc9jDeBQa/R9/u1h9rJekRw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKB+XUQgw8Pi49prmvEXmgKd1aOJb4B0zsdxr/a495rK+zqJa0Yhg1mqtQxhGvMfu
	 nEm3tkr1rOZhjDqzTrrL7DjTX87tQUurGGQafwGE6UqUy47lxNX2Itp8KmKrAwpWGD
	 0kpzG5ojyxUDRS/f7jt/RwfdlDOOm8GtI2lgJ4fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Marius Zachmann <mail@mariuszachmann.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/236] hwmon: (corsair-cpro) Protect ccp->wait_input_report with a spinlock
Date: Tue, 14 May 2024 12:18:38 +0200
Message-ID: <20240514101026.286311772@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksa Savic <savicaleksa83@gmail.com>

[ Upstream commit d02abd57e79469a026213f7f5827a98d909f236a ]

Through hidraw, userspace can cause a status report to be sent
from the device. The parsing in ccp_raw_event() may happen in
parallel to a send_usb_cmd() call (which resets the completion
for tracking the report) if it's running on a different CPU where
bottom half interrupts are not disabled.

Add a spinlock around the complete_all() in ccp_raw_event() and
reinit_completion() in send_usb_cmd() to prevent race issues.

Fixes: 40c3a4454225 ("hwmon: add Corsair Commander Pro driver")
Signed-off-by: Aleksa Savic <savicaleksa83@gmail.com>
Acked-by: Marius Zachmann <mail@mariuszachmann.de>
Link: https://lore.kernel.org/r/20240504092504.24158-4-savicaleksa83@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-cpro.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/corsair-cpro.c b/drivers/hwmon/corsair-cpro.c
index 543a741fe5473..486fb6a8c3566 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 #include <linux/types.h>
 
 #define USB_VENDOR_ID_CORSAIR			0x1b1c
@@ -77,6 +78,8 @@
 struct ccp_device {
 	struct hid_device *hdev;
 	struct device *hwmon_dev;
+	/* For reinitializing the completion below */
+	spinlock_t wait_input_report_lock;
 	struct completion wait_input_report;
 	struct mutex mutex; /* whenever buffer is used, lock before send_usb_cmd */
 	u8 *cmd_buffer;
@@ -118,7 +121,15 @@ static int send_usb_cmd(struct ccp_device *ccp, u8 command, u8 byte1, u8 byte2,
 	ccp->cmd_buffer[2] = byte2;
 	ccp->cmd_buffer[3] = byte3;
 
+	/*
+	 * Disable raw event parsing for a moment to safely reinitialize the
+	 * completion. Reinit is done because hidraw could have triggered
+	 * the raw event parsing and marked the ccp->wait_input_report
+	 * completion as done.
+	 */
+	spin_lock_bh(&ccp->wait_input_report_lock);
 	reinit_completion(&ccp->wait_input_report);
+	spin_unlock_bh(&ccp->wait_input_report_lock);
 
 	ret = hid_hw_output_report(ccp->hdev, ccp->cmd_buffer, OUT_BUFFER_SIZE);
 	if (ret < 0)
@@ -136,11 +147,12 @@ static int ccp_raw_event(struct hid_device *hdev, struct hid_report *report, u8
 	struct ccp_device *ccp = hid_get_drvdata(hdev);
 
 	/* only copy buffer when requested */
-	if (completion_done(&ccp->wait_input_report))
-		return 0;
-
-	memcpy(ccp->buffer, data, min(IN_BUFFER_SIZE, size));
-	complete_all(&ccp->wait_input_report);
+	spin_lock(&ccp->wait_input_report_lock);
+	if (!completion_done(&ccp->wait_input_report)) {
+		memcpy(ccp->buffer, data, min(IN_BUFFER_SIZE, size));
+		complete_all(&ccp->wait_input_report);
+	}
+	spin_unlock(&ccp->wait_input_report_lock);
 
 	return 0;
 }
@@ -515,7 +527,9 @@ static int ccp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ccp->hdev = hdev;
 	hid_set_drvdata(hdev, ccp);
+
 	mutex_init(&ccp->mutex);
+	spin_lock_init(&ccp->wait_input_report_lock);
 	init_completion(&ccp->wait_input_report);
 
 	hid_device_io_start(hdev);
-- 
2.43.0



