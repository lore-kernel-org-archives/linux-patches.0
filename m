Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215706;
	b=Ll7snUlGGML8Kk7PML4deO9QoC4BQXMYB9FJNM0l+TPDVnEmSeO+jntxcKr8Lsan8bos
	 SpskBZjL585ly3QJT69d/3tFUZ9eu7CSTh6qLCVC2Zsi3SQTLL1vcDcQPRREfxixLJiu8
	 xddyfSYvtlKoXQ4gzGQvvnBm2TjWqrKdyFwrnqZUfi9N2cyfbFZXdkZRc4F/F2rpGQhO0
	 EjjQ94NKzjFRcpjR454gA+acJYoQdZH6OZ/9Nx8ax7eMZbmlP5VhS6mJ7ok6AGZJZ/Q0b
	 JMnuDyQeGktbVyQ/Ux0PPFIevFSvQA0DBAr/jdNIJsUyjPbxsXU83riZc4nWBp5jsdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Lg+26LLgQruHGf2gUL1HsaZrhLjDnGYpy0QK4Co6gI=;
	b=3ceIj3pGMj8uKZ3aVQXmdg80p3t/0sGmUIQFg8S29AM2VbpywqLE7Mfzu/27lFjeYkH4
	 Ou857ZrMAkRt48n1QMdgVOS2H8sAEnULBVi+YqyJls81hh5gysOyFO290w23YTrTAdkYD
	 hfmLO43sw6W2lJ5OlEQV1UiDOwgqzPWkfc1O/qSsWMC2f4vkIYxzOjmIhAV+Y+ttkeeLN
	 /epYJgnBb/AIH30maLdvBkX8pTcK97mGyZWkAzUdnM3wGgui0PJuX3UuL5oTnkRtjlJCt
	 4Zwnz5g70RzsypJTr1+ZaYj4pAtMtdJZBWqkpNE/DDNKgS2NO+Zc93pEwx/GHwOrfBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pVyegULP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7B9606A31A;
	Wed, 28 Oct 2026 19:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pVyegULP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA1A1F01825;
	Wed, 28 Oct 2026 19:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215705;
	bh=6Lg+26LLgQruHGf2gUL1HsaZrhLjDnGYpy0QK4Co6gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pVyegULPc259++OYxDoBx9LclvrXFI41CYhP5Er4TphpO8K0uq+LC53D60L6UzDwt
	 7BsKh2GmpZFSKk5QS0DrFui2IrOv4m4FUOhrp4wqtRu6Db5jHod+1O42V1AbxekHO1
	 TG+kMRd0c6LgzOqfMNDxoh8l3MYWnyKcS4q9jUOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan KS <karthiproffesional@gmail.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1303/1887] soc: aspeed: lpc-snoop: Fix usercopy overflow in snoop_file_read
Date: Wed, 28 Oct 2026 17:56:39 +0100
Message-ID: <20261028170529.080933591@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/soc/aspeed/aspeed-lpc-snoop.c | 33 +++++++++++++++++++--------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/soc/aspeed/aspeed-lpc-snoop.c b/drivers/soc/aspeed/aspeed-lpc-snoop.c
index 19780e37d8ea7..95978904c75db 100644
--- a/drivers/soc/aspeed/aspeed-lpc-snoop.c
+++ b/drivers/soc/aspeed/aspeed-lpc-snoop.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/interrupt.h>
 #include <linux/fs.h>
@@ -60,6 +61,7 @@ struct aspeed_lpc_snoop_model_data {
 
 struct aspeed_lpc_snoop_channel {
 	bool enabled;
+	spinlock_t		lock;
 	struct kfifo		fifo;
 	wait_queue_head_t	wq;
 	struct miscdevice	miscdev;
@@ -83,6 +85,7 @@ static ssize_t snoop_file_read(struct file *file, char __user *buffer,
 				size_t count, loff_t *ppos)
 {
 	struct aspeed_lpc_snoop_channel *chan = snoop_file_to_chan(file);
+	u8 *buf __free(kfree) = NULL;
 	unsigned int copied;
 	int ret = 0;
 
@@ -94,9 +97,16 @@ static ssize_t snoop_file_read(struct file *file, char __user *buffer,
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
@@ -120,11 +130,13 @@ static const struct file_operations snoop_fops = {
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
 
@@ -285,7 +297,7 @@ static int aspeed_lpc_snoop_probe(struct platform_device *pdev)
 	struct device *dev;
 	struct device_node *np;
 	u32 port;
-	int rc;
+	int rc, i;
 
 	dev = &pdev->dev;
 
@@ -293,6 +305,9 @@ static int aspeed_lpc_snoop_probe(struct platform_device *pdev)
 	if (!lpc_snoop)
 		return -ENOMEM;
 
+	for (i = 0; i < NUM_SNOOP_CHANNELS; i++)
+		spin_lock_init(&lpc_snoop->chan[i].lock);
+
 	np = pdev->dev.parent->of_node;
 	if (!of_device_is_compatible(np, "aspeed,ast2400-lpc-v2") &&
 	    !of_device_is_compatible(np, "aspeed,ast2500-lpc-v2") &&
-- 
2.53.0



