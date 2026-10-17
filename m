Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B367404E;
	Sat, 17 Oct 2026 16:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254762; cv=none; b=c383/wRCp8G77asf7/lLhJf2L5xwKriczRAUOjftjq6Q8QMNzIgRQJiLs67WjPnff2m1x9DYjmoUnoI5P6JVnbe1hiwkxztqxI3dm7hfWx3A+4wxaw6sb6zXKV0FAFq69MaX8bhvsA2S+FVfpqE+SUosWOfvWNSNR3lmqfqbr1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254762; c=relaxed/simple;
	bh=8P3YckJgsPLJAp/BNG35kquTH8vCQxa7hyiQ5M3eifU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgnF+57Yv49oDCyI48LNrvCMbsc2pC2dtZYhGVnyjH0jWZWEW3ZhNlSoyGIPD/axLdey1vLq1x1CDI/1gf+t29apNcHIlVIj8O81G3wOEudHsZOUPBNtRF6AWoup4d6QsUX6PKFIrC6SUqqiywk6HzYUedCMyjEx2QCKw7qcBfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tElPAYm4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tElPAYm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8E41F000C4;
	Sat, 17 Oct 2026 16:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254761;
	bh=7ZwFQy+hvNr24IDWZLE3bsbagck7SZ3/LYN31K8QrOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tElPAYm43AYpOtL+MNK/T3HK7THolhLx53seQmXRJeTKj6XVynXnTRUAM3jRr2qzz
	 wVtgJvHwh9+fTUsLRxXaCyCJJ2c++kwdwCBJ1FEu3XO+QTxIGzxWr09Z3oTv9s5yM+
	 dEVzbzFlF82IsHitqNT02cvrKUyIFufasCGAm+8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan KS <karthiproffesional@gmail.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 516/869] soc: aspeed: lpc-snoop: Fix usercopy overflow in snoop_file_read
Date: Sat, 17 Oct 2026 17:55:57 +0200
Message-ID: <20261017160050.328352526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 drivers/soc/aspeed/aspeed-lpc-snoop.c | 31 ++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/aspeed/aspeed-lpc-snoop.c b/drivers/soc/aspeed/aspeed-lpc-snoop.c
index fc3a2c41cc107..35f58eb0f134c 100644
--- a/drivers/soc/aspeed/aspeed-lpc-snoop.c
+++ b/drivers/soc/aspeed/aspeed-lpc-snoop.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/interrupt.h>
 #include <linux/fs.h>
@@ -59,6 +60,7 @@ struct aspeed_lpc_snoop_model_data {
 
 struct aspeed_lpc_snoop_channel {
 	bool enabled;
+	spinlock_t		lock;
 	struct kfifo		fifo;
 	wait_queue_head_t	wq;
 	struct miscdevice	miscdev;
@@ -82,6 +84,7 @@ static ssize_t snoop_file_read(struct file *file, char __user *buffer,
 				size_t count, loff_t *ppos)
 {
 	struct aspeed_lpc_snoop_channel *chan = snoop_file_to_chan(file);
+	u8 *buf __free(kfree) = NULL;
 	unsigned int copied;
 	int ret = 0;
 
@@ -93,9 +96,16 @@ static ssize_t snoop_file_read(struct file *file, char __user *buffer,
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
@@ -119,11 +129,13 @@ static const struct file_operations snoop_fops = {
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
 
@@ -292,6 +304,9 @@ static int aspeed_lpc_snoop_probe(struct platform_device *pdev)
 	if (!lpc_snoop)
 		return -ENOMEM;
 
+	spin_lock_init(&lpc_snoop->chan[0].lock);
+	spin_lock_init(&lpc_snoop->chan[1].lock);
+
 	np = pdev->dev.parent->of_node;
 	if (!of_device_is_compatible(np, "aspeed,ast2400-lpc-v2") &&
 	    !of_device_is_compatible(np, "aspeed,ast2500-lpc-v2") &&
-- 
2.53.0



