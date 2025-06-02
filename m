Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375D722538F;
	Mon,  2 Jun 2025 14:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874563; cv=none; b=JV80jdWDpnrp3/hp9ai6CbWsii6la6aqJi3jodUeJf1CeJymXrcLTDlrYhLuEVYSkV7GzI6LJP2K53/n8FfeXaHhwv9XGr6R0BM5eLijR40CkurxLrOjf8MJ7uivfiIr7vRvw6/47NsY0bOrj/2Uj/mJ/PcCgAlSfrt9wdqDNdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874563; c=relaxed/simple;
	bh=5LbsEKGuUej8fUPLZsFEUddsuUPYS0queJtkqM+tyvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNftC6wKtC2qqVr0as04LHG789MmSBlenMDDRNSqjPhXkuLSsQIwnqsTGMxtXUD4h45yFnQjpNpL14pzQz6X/ZGbjDr6GIglPA0vjIG5DbisSYi3v7EH9eKH1t08TguSPnoD6hz1N9KEhabEQNCQLt90iWPnNxsFO6g+Mqh/m/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eP9k+yq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eP9k+yq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A38EC4CEEB;
	Mon,  2 Jun 2025 14:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874562;
	bh=5LbsEKGuUej8fUPLZsFEUddsuUPYS0queJtkqM+tyvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eP9k+yq8SRzb740wzG0DXugaFkmZQ1qqkHNY4vIFAg8OXCbQpWoIVxbwaPdq9I0te
	 MegGN4d7kA6xSpt5OwZw1N2CV2n6FjE+MGmDrWhwxJj8ELMNcDZHpd295OaW8oZGeM
	 ZRflNd6m52Aq1ljV6RdlOJSak8ewqAWwCyr4RNCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Deslandes <quentin.deslandes@itdev.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/204] staging: axis-fifo: replace spinlock with mutex
Date: Mon,  2 Jun 2025 15:46:36 +0200
Message-ID: <20250602134258.154329133@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Deslandes <quentin.deslandes@itdev.co.uk>

[ Upstream commit 0443b3f4436321e1098fdf74432c8867016339da ]

Following the device's documentation guidance, reading a packet from the
device or writing a packet to it must be atomic. Previously, only
reading device's vacancy (before writing on it) or occupancy (before
reading from it) was locked. Hence, effectively reading the packet or
writing the packet wasn't locked at all. However, reading a packet (and
writing one, to a lesser extent) requires to read 3 different registers
in a specific order, without missing one or else we should reset the
device.

This patch fixes the device's locking mechanism on the FIFO character
device. As the device was using copy_from_user() and copy_to_user(), we
need to replace spinlocks with mutexes.

Signed-off-by: Quentin Deslandes <quentin.deslandes@itdev.co.uk>
Link: https://lore.kernel.org/r/20200121103958.12941-1-quentin.deslandes@itdev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c6e8d85fafa7 ("staging: axis-fifo: Remove hardware resets for user errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/axis-fifo/axis-fifo.c | 160 ++++++++++++++++----------
 1 file changed, 101 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/axis-fifo/axis-fifo.c b/drivers/staging/axis-fifo/axis-fifo.c
index 805437fa249a9..c1dd01c5c9ea6 100644
--- a/drivers/staging/axis-fifo/axis-fifo.c
+++ b/drivers/staging/axis-fifo/axis-fifo.c
@@ -16,7 +16,7 @@
 
 #include <linux/kernel.h>
 #include <linux/wait.h>
-#include <linux/spinlock_types.h>
+#include <linux/mutex.h>
 #include <linux/device.h>
 #include <linux/cdev.h>
 #include <linux/init.h>
@@ -134,9 +134,9 @@ struct axis_fifo {
 	int has_tx_fifo; /* whether the IP has the tx fifo enabled */
 
 	wait_queue_head_t read_queue; /* wait queue for asynchronos read */
-	spinlock_t read_queue_lock; /* lock for reading waitqueue */
+	struct mutex read_lock; /* lock for reading */
 	wait_queue_head_t write_queue; /* wait queue for asynchronos write */
-	spinlock_t write_queue_lock; /* lock for writing waitqueue */
+	struct mutex write_lock; /* lock for writing */
 	unsigned int write_flags; /* write file flags */
 	unsigned int read_flags; /* read file flags */
 
@@ -337,7 +337,21 @@ static void reset_ip_core(struct axis_fifo *fifo)
 	iowrite32(XLLF_INT_ALL_MASK, fifo->base_addr + XLLF_ISR_OFFSET);
 }
 
-/* reads a single packet from the fifo as dictated by the tlast signal */
+/**
+ * axis_fifo_write() - Read a packet from AXIS-FIFO character device.
+ * @f Open file.
+ * @buf User space buffer to read to.
+ * @len User space buffer length.
+ * @off Buffer offset.
+ *
+ * As defined by the device's documentation, we need to check the device's
+ * occupancy before reading the length register and then the data. All these
+ * operations must be executed atomically, in order and one after the other
+ * without missing any.
+ *
+ * Returns the number of bytes read from the device or negative error code
+ *	on failure.
+ */
 static ssize_t axis_fifo_read(struct file *f, char __user *buf,
 			      size_t len, loff_t *off)
 {
@@ -351,36 +365,37 @@ static ssize_t axis_fifo_read(struct file *f, char __user *buf,
 	u32 tmp_buf[READ_BUF_SIZE];
 
 	if (fifo->read_flags & O_NONBLOCK) {
-		/* opened in non-blocking mode
-		 * return if there are no packets available
+		/*
+		 * Device opened in non-blocking mode. Try to lock it and then
+		 * check if any packet is available.
 		 */
-		if (!ioread32(fifo->base_addr + XLLF_RDFO_OFFSET))
+		if (!mutex_trylock(&fifo->read_lock))
 			return -EAGAIN;
+
+		if (!ioread32(fifo->base_addr + XLLF_RDFO_OFFSET)) {
+			ret = -EAGAIN;
+			goto end_unlock;
+		}
 	} else {
 		/* opened in blocking mode
 		 * wait for a packet available interrupt (or timeout)
 		 * if nothing is currently available
 		 */
-		spin_lock_irq(&fifo->read_queue_lock);
-		ret = wait_event_interruptible_lock_irq_timeout
-			(fifo->read_queue,
-			 ioread32(fifo->base_addr + XLLF_RDFO_OFFSET),
-			 fifo->read_queue_lock,
-			 (read_timeout >= 0) ? msecs_to_jiffies(read_timeout) :
+		mutex_lock(&fifo->read_lock);
+		ret = wait_event_interruptible_timeout(fifo->read_queue,
+			ioread32(fifo->base_addr + XLLF_RDFO_OFFSET),
+			(read_timeout >= 0) ? msecs_to_jiffies(read_timeout) :
 				MAX_SCHEDULE_TIMEOUT);
-		spin_unlock_irq(&fifo->read_queue_lock);
 
-		if (ret == 0) {
-			/* timeout occurred */
-			dev_dbg(fifo->dt_device, "read timeout");
-			return -EAGAIN;
-		} else if (ret == -ERESTARTSYS) {
-			/* signal received */
-			return -ERESTARTSYS;
-		} else if (ret < 0) {
-			dev_err(fifo->dt_device, "wait_event_interruptible_timeout() error in read (ret=%i)\n",
-				ret);
-			return ret;
+		if (ret <= 0) {
+			if (ret == 0) {
+				ret = -EAGAIN;
+			} else if (ret != -ERESTARTSYS) {
+				dev_err(fifo->dt_device, "wait_event_interruptible_timeout() error in read (ret=%i)\n",
+					ret);
+			}
+
+			goto end_unlock;
 		}
 	}
 
@@ -388,14 +403,16 @@ static ssize_t axis_fifo_read(struct file *f, char __user *buf,
 	if (!bytes_available) {
 		dev_err(fifo->dt_device, "received a packet of length 0 - fifo core will be reset\n");
 		reset_ip_core(fifo);
-		return -EIO;
+		ret = -EIO;
+		goto end_unlock;
 	}
 
 	if (bytes_available > len) {
 		dev_err(fifo->dt_device, "user read buffer too small (available bytes=%zu user buffer bytes=%zu) - fifo core will be reset\n",
 			bytes_available, len);
 		reset_ip_core(fifo);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto end_unlock;
 	}
 
 	if (bytes_available % sizeof(u32)) {
@@ -404,7 +421,8 @@ static ssize_t axis_fifo_read(struct file *f, char __user *buf,
 		 */
 		dev_err(fifo->dt_device, "received a packet that isn't word-aligned - fifo core will be reset\n");
 		reset_ip_core(fifo);
-		return -EIO;
+		ret = -EIO;
+		goto end_unlock;
 	}
 
 	words_available = bytes_available / sizeof(u32);
@@ -424,16 +442,37 @@ static ssize_t axis_fifo_read(struct file *f, char __user *buf,
 		if (copy_to_user(buf + copied * sizeof(u32), tmp_buf,
 				 copy * sizeof(u32))) {
 			reset_ip_core(fifo);
-			return -EFAULT;
+			ret = -EFAULT;
+			goto end_unlock;
 		}
 
 		copied += copy;
 		words_available -= copy;
 	}
 
-	return bytes_available;
+	ret = bytes_available;
+
+end_unlock:
+	mutex_unlock(&fifo->read_lock);
+
+	return ret;
 }
 
+/**
+ * axis_fifo_write() - Write buffer to AXIS-FIFO character device.
+ * @f Open file.
+ * @buf User space buffer to write to the device.
+ * @len User space buffer length.
+ * @off Buffer offset.
+ *
+ * As defined by the device's documentation, we need to write to the device's
+ * data buffer then to the device's packet length register atomically. Also,
+ * we need to lock before checking if the device has available space to avoid
+ * any concurrency issue.
+ *
+ * Returns the number of bytes written to the device or negative error code
+ *	on failure.
+ */
 static ssize_t axis_fifo_write(struct file *f, const char __user *buf,
 			       size_t len, loff_t *off)
 {
@@ -466,12 +505,17 @@ static ssize_t axis_fifo_write(struct file *f, const char __user *buf,
 	}
 
 	if (fifo->write_flags & O_NONBLOCK) {
-		/* opened in non-blocking mode
-		 * return if there is not enough room available in the fifo
+		/*
+		 * Device opened in non-blocking mode. Try to lock it and then
+		 * check if there is any room to write the given buffer.
 		 */
+		if (!mutex_trylock(&fifo->write_lock))
+			return -EAGAIN;
+
 		if (words_to_write > ioread32(fifo->base_addr +
 					      XLLF_TDFV_OFFSET)) {
-			return -EAGAIN;
+			ret = -EAGAIN;
+			goto end_unlock;
 		}
 	} else {
 		/* opened in blocking mode */
@@ -479,30 +523,22 @@ static ssize_t axis_fifo_write(struct file *f, const char __user *buf,
 		/* wait for an interrupt (or timeout) if there isn't
 		 * currently enough room in the fifo
 		 */
-		spin_lock_irq(&fifo->write_queue_lock);
-		ret = wait_event_interruptible_lock_irq_timeout
-			(fifo->write_queue,
-			 ioread32(fifo->base_addr + XLLF_TDFV_OFFSET)
+		mutex_lock(&fifo->write_lock);
+		ret = wait_event_interruptible_timeout(fifo->write_queue,
+			ioread32(fifo->base_addr + XLLF_TDFV_OFFSET)
 				>= words_to_write,
-			 fifo->write_queue_lock,
-			 (write_timeout >= 0) ?
-				msecs_to_jiffies(write_timeout) :
+			(write_timeout >= 0) ? msecs_to_jiffies(write_timeout) :
 				MAX_SCHEDULE_TIMEOUT);
-		spin_unlock_irq(&fifo->write_queue_lock);
 
-		if (ret == 0) {
-			/* timeout occurred */
-			dev_dbg(fifo->dt_device, "write timeout\n");
-			return -EAGAIN;
-		} else if (ret == -ERESTARTSYS) {
-			/* signal received */
-			return -ERESTARTSYS;
-		} else if (ret < 0) {
-			/* unknown error */
-			dev_err(fifo->dt_device,
-				"wait_event_interruptible_timeout() error in write (ret=%i)\n",
-				ret);
-			return ret;
+		if (ret <= 0) {
+			if (ret == 0) {
+				ret = -EAGAIN;
+			} else if (ret != -ERESTARTSYS) {
+				dev_err(fifo->dt_device, "wait_event_interruptible_timeout() error in write (ret=%i)\n",
+					ret);
+			}
+
+			goto end_unlock;
 		}
 	}
 
@@ -516,7 +552,8 @@ static ssize_t axis_fifo_write(struct file *f, const char __user *buf,
 		if (copy_from_user(tmp_buf, buf + copied * sizeof(u32),
 				   copy * sizeof(u32))) {
 			reset_ip_core(fifo);
-			return -EFAULT;
+			ret = -EFAULT;
+			goto end_unlock;
 		}
 
 		for (i = 0; i < copy; i++)
@@ -527,10 +564,15 @@ static ssize_t axis_fifo_write(struct file *f, const char __user *buf,
 		words_to_write -= copy;
 	}
 
+	ret = copied * sizeof(u32);
+
 	/* write packet size to fifo */
-	iowrite32(copied * sizeof(u32), fifo->base_addr + XLLF_TLR_OFFSET);
+	iowrite32(ret, fifo->base_addr + XLLF_TLR_OFFSET);
+
+end_unlock:
+	mutex_unlock(&fifo->write_lock);
 
-	return (ssize_t)copied * sizeof(u32);
+	return ret;
 }
 
 static irqreturn_t axis_fifo_irq(int irq, void *dw)
@@ -756,8 +798,8 @@ static int axis_fifo_probe(struct platform_device *pdev)
 	init_waitqueue_head(&fifo->read_queue);
 	init_waitqueue_head(&fifo->write_queue);
 
-	spin_lock_init(&fifo->read_queue_lock);
-	spin_lock_init(&fifo->write_queue_lock);
+	mutex_init(&fifo->read_lock);
+	mutex_init(&fifo->write_lock);
 
 	/* ----------------------------
 	 *   init device memory space
-- 
2.39.5



