Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1B7372B31;
	Wed, 20 May 2026 18:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301324; cv=none; b=FJtVKvCC48bCqKz/u6OwBAQpA1i/7i3XHApvrJrocdM0exOtA1zPnwmoLYYJXSyi7nsBNNV3v0N5Gg9eqkeotYp6uP9SkvJ7siHNx3C2vLOMHjKUdBLEfgcAf87A3d9v0JpJhHGjrLXtMoz+gibPmHgK63vn2Yc1VzQb5TaP698=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301324; c=relaxed/simple;
	bh=A9Kopseykg7YLj8SGZHWN2Gtdoak8mWRt7cHd9d8wVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjR1dctscNQwr3l/PMLEuSDHSeC28Qse+c4H20vp7RM9IA87Odd1MqzXGYPB8bMnMgxuilg2XaFQC9ON8YIboaONG5Ro56s/CJslAqwGXfXaQDU7kWkKQmd9XGbiBPISJqEFQZTs9gdel+52smEgtv8xLsBO8mZBgaM6CsxC2Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1c0wM2D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1c0wM2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5861F00897;
	Wed, 20 May 2026 18:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301322;
	bh=jax0x/BqadyF//WCxrAY8R9RPWh2Jmkju2DL2b+HYnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1c0wM2Dm4Qr46sat0jvbo96Bm4Kb3R+3aZV3MaH6sIm97nQBbJJHXc2rRQOGOcqO
	 ObSXT6PCjV799TpQCROzPAKpTlKIuMKkNHAvotQPz+l76+XU7wvliIfWHpwwjY2RSC
	 GnIN4GQC9SjZ35bOpBB4w4oFfTtWvZZEZ0LQoJME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 510/666] mailbox: mailbox-test: make data_ready a per-instance variable
Date: Wed, 20 May 2026 18:22:01 +0200
Message-ID: <20260520162122.316767382@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9eeb0b61b887c..b4ed96be815db 100644
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



