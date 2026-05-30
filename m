Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91B986334;
	Sat, 30 May 2026 18:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166758; cv=none; b=t7rN4wwjBKDzE5xQ48KI1bZ3rPBdOJizA2YT/S1wgqhmDjTwrU8jqYkQmnp6HcbpryOjSP/5iiT+3jI9PzCvwxlHOSihvs7c8MIxX2/814BO4mzOvrAxwb/9Jf18BoRl676l8+QEZrxhNrNZSByHBwA8GFCXN0Mty7x4yfFj5zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166758; c=relaxed/simple;
	bh=msM/b+LKZIns3HhN/wz6ftlxJuP1F7ztilZW/nDIxjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrMRsXHLCXoMICESAWBM6FzMbts+2tzlTMDwDTOx/gs3ckNfpRobh9pScjrx0JAkP1Bo7Ks+DXZjq9UpDmg6UAhsBd+9xPCtcLQpT5eo1rQ/AkXaUESVtBB7c+UwmYE0VojRcdJyqDJ/upyER0Bowd/GkG6ogLnailFKQYufnhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWxYc/Xz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWxYc/Xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108391F00893;
	Sat, 30 May 2026 18:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166757;
	bh=7xEjd8aTr0Qz1K4E0WtVh/KPjIwxqhMeUpsfrXoH3mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWxYc/XzEcKC2RyJ7fA8uHSeQV6I7/pDRxY1LLldyp6DHD7DaeNI53v2J7AVVbk9l
	 B+4GHGdcPlOVtQe+HQlIG2FzkSenssgHkB7UHCZJteGbQdq0ABbHOVICd9Ncfa6FEY
	 42C67e/GaLe2eD2rAxm6XUKsuXO6pGAio5d5GZPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 462/589] mailbox: mailbox-test: make data_ready a per-instance variable
Date: Sat, 30 May 2026 18:05:43 +0200
Message-ID: <20260530160236.812203556@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 6e937f4e769e60947909e3525965f0137b9039e8 ]

While not the default case, multiple tests can be run simultaneously.
Then, data_ready being a global variable will be overwritten and the
per-instance lock will not help. Turn the global variable into a
per-instance one to avoid this problem.

Fixes: e339c80af95e ("mailbox: mailbox-test: don't rely on rx_buffer content to signal data ready")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-test.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mailbox/mailbox-test.c b/drivers/mailbox/mailbox-test.c
index 41efe64976598..113858fe168c3 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -27,8 +27,6 @@
 #define MBOX_HEXDUMP_MAX_LEN	(MBOX_HEXDUMP_LINE_LEN *		\
 				 (MBOX_MAX_MSG_LEN / MBOX_BYTES_PER_LINE))
 
-static bool mbox_data_ready;
-
 struct mbox_test_device {
 	struct device		*dev;
 	void __iomem		*tx_mmio;
@@ -41,6 +39,7 @@ struct mbox_test_device {
 	spinlock_t		lock;
 	struct mutex		mutex;
 	wait_queue_head_t	waitq;
+	bool			data_ready;
 	struct fasync_struct	*async_queue;
 	struct dentry		*root_debugfs_dir;
 };
@@ -161,7 +160,7 @@ static bool mbox_test_message_data_ready(struct mbox_test_device *tdev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tdev->lock, flags);
-	data_ready = mbox_data_ready;
+	data_ready = tdev->data_ready;
 	spin_unlock_irqrestore(&tdev->lock, flags);
 
 	return data_ready;
@@ -226,7 +225,7 @@ static ssize_t mbox_test_message_read(struct file *filp, char __user *userbuf,
 	*(touser + l) = '\0';
 
 	memset(tdev->rx_buffer, 0, MBOX_MAX_MSG_LEN);
-	mbox_data_ready = false;
+	tdev->data_ready = false;
 
 	spin_unlock_irqrestore(&tdev->lock, flags);
 
@@ -296,7 +295,7 @@ static void mbox_test_receive_message(struct mbox_client *client, void *message)
 				     message, MBOX_MAX_MSG_LEN);
 		memcpy(tdev->rx_buffer, message, MBOX_MAX_MSG_LEN);
 	}
-	mbox_data_ready = true;
+	tdev->data_ready = true;
 	spin_unlock_irqrestore(&tdev->lock, flags);
 
 	wake_up_interruptible(&tdev->waitq);
-- 
2.53.0



