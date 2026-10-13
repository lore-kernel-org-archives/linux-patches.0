Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCC64F3EDB;
	Tue, 13 Oct 2026 12:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893843; cv=none; b=SIxG6/TubnqexAiWm+FU9ay/XUSFTxW8M3JsNGOwxJiFmM6LECJgTY93EwnNCOeke8/Tkul9tLpZuIPiYCoz3GBfAv+oJXFT/LGwYcjGUyxEJCV12CaZ0WVz8WeysVssMVNEzJxpGx+LTXVMpqBqk3SH3y0/V50UHtl+qoWaf5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893843; c=relaxed/simple;
	bh=tBDDHSbUmSSfIoZrYX+Q8pg12gvbPByjNBrb5sfO88Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Do1mCtPI2OaZAS//mO5JHh+Hc7foiljgkKI3K3Adj2Y/BM33dkoDcrUnevzsTgwyhqIho9icg9ynldWClLI5WkP3Nq0HIfTv4At+0G0uxpbclVyTCX5mDvEJLKdG2dO9tKbQlxBsFlg9EfS37hdSXc5N2zVraO2ctCkeGzTqi5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKbsrGIA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKbsrGIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66971F000FF;
	Tue, 13 Oct 2026 12:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893842;
	bh=g8itwd0nl+Pt1BA32eR8/ZwojsBepVElVVu03ESN1js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cKbsrGIAFSYLhcK/ykb1dugjbjYH92xMUSapCuaXs5S8ybn7NBBfMKE6ZGqYtGgNK
	 9HR8txk/k6BRII1sS/cjmJVY+ytAG+mACkSjJARqbHpT77u3I+KdbKOx6uqJc6uwat
	 U9WLXQHc/jHyAxwdgAsS8SkPrTvHvkRvYTx1fYeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan KS <karthiproffesional@gmail.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 344/621] soc: aspeed: lpc-snoop: Fix usercopy overflow in snoop_file_read
Date: Tue, 13 Oct 2026 13:35:39 +0200
Message-ID: <20261013112929.016050799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthikeyan KS <karthiproffesional@gmail.com>

[ Upstream commit 1acef6d85bfd98bd9dfe1f08bffa397a4dda8a6f ]

put_fifo_with_discard() acts as both producer and consumer on the kfifo:
it calls kfifo_skip() (advances out) and kfifo_put() (advances in) from
the IRQ handler without synchronizing with snoop_file_read(), which also
consumes via kfifo_to_user(). On SMP systems this concurrent access can
leave (in - out) larger than the ring buffer, so __kfifo_to_user()'s clamp
to (in - out) is ineffective and kfifo_copy_to_user() can attempt a
copy_to_user() past the kmalloc-2k backing store:

  usercopy: Kernel memory exposure attempt detected from SLUB object
  'kmalloc-2k' (offset 0, size 2049)!
  kernel BUG at mm/usercopy.c!
  Call trace:
   usercopy_abort
   __check_heap_object
   __check_object_size
   kfifo_copy_to_user
   __kfifo_to_user
   snoop_file_read
   vfs_read

Serialize kfifo access with a per-channel spinlock shared between the
IRQ handler (producer) and the file reader (consumer).  Annotate @fifo
with __guarded_by(&lock) and opt the driver into context analysis so the
compiler enforces that all fifo access holds the lock.

Fixes: 3772e5da4454 ("drivers/misc: Aspeed LPC snoop output using misc chardev")
Signed-off-by: Karthikeyan KS <karthiproffesional@gmail.com>
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/aspeed/aspeed-lpc-snoop.c | 29 +++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/aspeed/aspeed-lpc-snoop.c b/drivers/soc/aspeed/aspeed-lpc-snoop.c
index b03310c0830d2..486d43406bc6d 100644
--- a/drivers/soc/aspeed/aspeed-lpc-snoop.c
+++ b/drivers/soc/aspeed/aspeed-lpc-snoop.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/dev_printk.h>
 #include <linux/interrupt.h>
@@ -74,6 +75,7 @@ struct aspeed_lpc_snoop_channel_cfg {
 struct aspeed_lpc_snoop_channel {
 	const struct aspeed_lpc_snoop_channel_cfg *cfg;
 	bool enabled;
+	spinlock_t		lock;
 	struct kfifo		fifo;
 	wait_queue_head_t	wq;
 	struct miscdevice	miscdev;
@@ -114,6 +116,7 @@ static ssize_t snoop_file_read(struct file *file, char __user *buffer,
 				size_t count, loff_t *ppos)
 {
 	struct aspeed_lpc_snoop_channel *chan = snoop_file_to_chan(file);
+	u8 *buf __free(kfree) = NULL;
 	unsigned int copied;
 	int ret = 0;
 
@@ -125,9 +128,16 @@ static ssize_t snoop_file_read(struct file *file, char __user *buffer,
 		if (ret == -ERESTARTSYS)
 			return -EINTR;
 	}
-	ret = kfifo_to_user(&chan->fifo, buffer, count, &copied);
-	if (ret)
-		return ret;
+
+	count = min_t(size_t, count, SNOOP_FIFO_SIZE);
+
+	buf = kmalloc(count, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	copied = kfifo_out_spinlocked(&chan->fifo, buf, count, &chan->lock);
+	if (copied && copy_to_user(buffer, buf, copied))
+		return -EFAULT;
 
 	return copied;
 }
@@ -151,11 +161,13 @@ static const struct file_operations snoop_fops = {
 /* Save a byte to a FIFO and discard the oldest byte if FIFO is full */
 static void put_fifo_with_discard(struct aspeed_lpc_snoop_channel *chan, u8 val)
 {
-	if (!kfifo_initialized(&chan->fifo))
-		return;
-	if (kfifo_is_full(&chan->fifo))
-		kfifo_skip(&chan->fifo);
-	kfifo_put(&chan->fifo, val);
+	scoped_guard(spinlock, &chan->lock) {
+		if (!kfifo_initialized(&chan->fifo))
+			return;
+		if (kfifo_is_full(&chan->fifo))
+			kfifo_skip(&chan->fifo);
+		kfifo_put(&chan->fifo, val);
+	}
 	wake_up_interruptible(&chan->wq);
 }
 
@@ -239,6 +251,7 @@ static int aspeed_lpc_enable_snoop(struct device *dev,
 	if (!channel->miscdev.name)
 		return -ENOMEM;
 
+	spin_lock_init(&channel->lock);
 	rc = kfifo_alloc(&channel->fifo, SNOOP_FIFO_SIZE, GFP_KERNEL);
 	if (rc)
 		return rc;
-- 
2.53.0



