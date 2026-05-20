Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBE53FC5B4;
	Wed, 20 May 2026 17:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296670; cv=none; b=gEoun9AXSm617BW8KEEbGDR/XjzsKvbi0ew+G1ueBQFGsFugsdPUtPkkpnwxerfICvrHtxJ1pEv5/ZfHCYwc98KP3yw4Y/GceFY+z7OJLvdm5Qab0DdbDvVpo8oM3XgzUuWZFPgdCxGorElXefUEsOwAXuAemAHW/d0wEFTKpxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296670; c=relaxed/simple;
	bh=Tx1JCQCVXE8flOqS9cotWN1Kf/s8cN9VpLPIe5iY9Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vE1wR9f3oD7NNmziFSvw7ht01gs1n3uY9wi1owz1Wrycz61hcJv7W2Z72piF+yNV8rbzC0LVm6NlIofCuJPfiiMnMro9c8DcFWzS0fwKaP+aZwMrwbuhebFA5OeDFQI//HXPEEyMuZWlhrg64yGfq68HJi5smRPQ0I1raJYdt/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ni3ei2iP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ni3ei2iP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E30C1F00896;
	Wed, 20 May 2026 17:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296669;
	bh=oLvz2/0eLWTPr0quGleIkzTY40aAy3XEmAqZA5gty1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ni3ei2iP7/oc/ePYqn/+2kRfnZVCNj71q+oo5ntksc/Ql+vf+M4b1cApY6/3dXF4m
	 0h0v6iwBBtWWMGbODzbAi6bY1w7ciDr1vethOzwiwhsdfku2iwdplLv8SSNaiq4OAV
	 1C2wbiblf/+/sc6m4UyTcF0TCAh71UOJPw9iOSsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0887/1146] mailbox: mailbox-test: make data_ready a per-instance variable
Date: Wed, 20 May 2026 18:18:57 +0200
Message-ID: <20260520162208.312448328@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index b341a64a1e312..41c8c7f3da9d8 100644
--- a/drivers/mailbox/mailbox-test.c
+++ b/drivers/mailbox/mailbox-test.c
@@ -28,8 +28,6 @@
 #define MBOX_HEXDUMP_MAX_LEN	(MBOX_HEXDUMP_LINE_LEN *		\
 				 (MBOX_MAX_MSG_LEN / MBOX_BYTES_PER_LINE))
 
-static bool mbox_data_ready;
-
 struct mbox_test_device {
 	struct device		*dev;
 	void __iomem		*tx_mmio;
@@ -42,6 +40,7 @@ struct mbox_test_device {
 	spinlock_t		lock;
 	struct mutex		mutex;
 	wait_queue_head_t	waitq;
+	bool			data_ready;
 	struct fasync_struct	*async_queue;
 	struct dentry		*root_debugfs_dir;
 };
@@ -162,7 +161,7 @@ static bool mbox_test_message_data_ready(struct mbox_test_device *tdev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tdev->lock, flags);
-	data_ready = mbox_data_ready;
+	data_ready = tdev->data_ready;
 	spin_unlock_irqrestore(&tdev->lock, flags);
 
 	return data_ready;
@@ -227,7 +226,7 @@ static ssize_t mbox_test_message_read(struct file *filp, char __user *userbuf,
 	*(touser + l) = '\0';
 
 	memset(tdev->rx_buffer, 0, MBOX_MAX_MSG_LEN);
-	mbox_data_ready = false;
+	tdev->data_ready = false;
 
 	spin_unlock_irqrestore(&tdev->lock, flags);
 
@@ -297,7 +296,7 @@ static void mbox_test_receive_message(struct mbox_client *client, void *message)
 				     message, MBOX_MAX_MSG_LEN);
 		memcpy(tdev->rx_buffer, message, MBOX_MAX_MSG_LEN);
 	}
-	mbox_data_ready = true;
+	tdev->data_ready = true;
 	spin_unlock_irqrestore(&tdev->lock, flags);
 
 	wake_up_interruptible(&tdev->waitq);
-- 
2.53.0



