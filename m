Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF337340293;
	Sat, 30 May 2026 17:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161823; cv=none; b=kUmYxZubAU7YaDYLOtoyd6bggzVM3Zgn9ANYpX01GVAsS1HtcENZRgVR3V04Ah4+6NvuoNb5zo5COYzrYnos+lMsy4vQi8i3eZgu9dZnSySWcLwimhkKHv3GDwMSigIiKJyfRg5LRhupVcTa5pHe8ChEPUuHq2RlYkkZarVyLyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161823; c=relaxed/simple;
	bh=SIIsNrtTEMh+Qw+ORh0OHRCCjNIxI3mOUUczk5cM1HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQ3p8+PS1ZcomN5hxP2y+hQbXgNiCpKLEfI5BEdDYNUxFfMLN6vZVdiWzQdEl6Do0HQXoBvSB5z8/Q1NbN7ZuVd2hbON6xuBuC595zWWCOL1oT7n2ri0AqS/C+zzvu7OTHlcPeZx4y4Pa5PLS/+uCxKHW6QYbzNR9mig57olpGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gb+Fa/6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gb+Fa/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B731F00893;
	Sat, 30 May 2026 17:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161822;
	bh=wf/dlg6fSIVZTjcj2GvMmV9zAT0pu807dTvf+BVwyK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2gb+Fa/6PF2vbPZSgKx5V6Wv61Kpt9OBGfZgbQ29vhXPuaaZ92kb/55RSy5CmvLM0
	 PwxCRKXoQb9GIpcyd7NSqqyRLXZ5CBMv5CliP5LAAXjRF282j3LFLkGr/vU4XdEKLh
	 Lch40QHLgGzg4Lnqk633KKZklyu1+8YdlyfsUU+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 730/969] mailbox: mailbox-test: make data_ready a per-instance variable
Date: Sat, 30 May 2026 18:04:14 +0200
Message-ID: <20260530160320.702876657@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



