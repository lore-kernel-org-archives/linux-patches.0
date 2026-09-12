Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C044B32E757;
	Sat, 12 Sep 2026 16:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231606; cv=none; b=MuWSQsLk7fGt8xpB0MFZ0SISLKgrn8BTu46Gq1AqMfEvPGxkM8iLlUp+HOrny5A3VYkonKVGX6DgtRY5qa5LDNKhMBmVqwDkE9/3AQffHZ7YEm7xHl4nj+Q1CGIK1ijBZuoXSyOtIa+YF9wBqLzSLGwbUpatCkBA6kAfQy5DRgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231606; c=relaxed/simple;
	bh=AxsKCaWfNk70CzjbBZA6J5buX0nMkFH6oB7bS7vnOfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPuU33AVTCBvwFqmbJXq0FxUWFeP3lWzFktzS+pWGi7xGIODiw0H8KGRsAV7Y1FAbsS83+qw+bk1shifYwmmO8AR9f/TGUnh0VWTlwjBY75vM/9ixNN1kytHUOTZLhCDEnSwgPmlVP6qw248vkKQgzUW6rkI7RmRqHdXkFxUPvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3zm6QZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3zm6QZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782891F000FF;
	Sat, 12 Sep 2026 16:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231605;
	bh=CpWwU2Lo0KlpUKolV0a5XDTNNRlUFOr8ZIw200WbMio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3zm6QZ1hDzjV1jUQngz9hD6q2xvqXkDPGZGMSNjzFogQqnOMbb/w0KEzRpY9OVJp
	 YlvY45K6CKqKuXxAHzhfWM5LNxyefckX8yRcvFyPqacCJhFSYsDCz9PocCFhYPqnPC
	 3/hEDu3rEeY6nbREIOQH1WbY9O10yje8R45x8uYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1033/1191] block: mtip32xx: synchronize ioctls with device removal
Date: Sat, 12 Sep 2026 09:02:41 +0200
Message-ID: <20260912065611.383844318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit 68940f841d013192086a0f6d7cfbac2cd079e228 ]

The ioctl handlers only test REMOVE_PENDING before entering
mtip_hw_ioctl(). Removal can set that bit immediately afterwards and free
dd->port in mtip_hw_exit() while an ioctl still dereferences it. An already
open block device can reach the handlers while del_gendisk() is in
progress.

Serialize both native and compat ioctls with removal. Set REMOVE_PENDING
before taking the mutex so new callers fail after an in-flight ioctl has
drained, and hold the mutex until the port has been torn down.

Fixes: 88523a61558a ("block: Add driver for Micron RealSSD pcie flash cards")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260806060441.676-1-getshell@seu.edu.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/mtip32xx/mtip32xx.c | 7 +++++++
 drivers/block/mtip32xx/mtip32xx.h | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 815d77ba63819..c52b05daccdd0 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3053,6 +3053,8 @@ static int mtip_block_ioctl(struct block_device *dev,
 	if (!dd)
 		return -ENOTTY;
 
+	guard(mutex)(&dd->ioctl_mutex);
+
 	if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag)))
 		return -ENOTTY;
 
@@ -3091,6 +3093,8 @@ static int mtip_block_compat_ioctl(struct block_device *dev,
 	if (!dd)
 		return -ENOTTY;
 
+	guard(mutex)(&dd->ioctl_mutex);
+
 	if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag)))
 		return -ENOTTY;
 
@@ -3716,6 +3720,7 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 	dd = kzalloc_node(sizeof(struct driver_data), GFP_KERNEL, my_node);
 	if (!dd)
 		return -ENOMEM;
+	mutex_init(&dd->ioctl_mutex);
 
 	/* Attach the private data to this PCI device.  */
 	pci_set_drvdata(pdev, dd);
@@ -3888,6 +3893,7 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 	}
 
 	set_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag);
+	mutex_lock(&dd->ioctl_mutex);
 
 	if (test_bit(MTIP_DDF_INIT_DONE_BIT, &dd->dd_flag))
 		del_gendisk(dd->disk);
@@ -3916,6 +3922,7 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 
 	/* De-initialize the protocol layer. */
 	mtip_hw_exit(dd);
+	mutex_unlock(&dd->ioctl_mutex);
 
 	if (dd->isr_workq) {
 		destroy_workqueue(dd->isr_workq);
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index f7328f19ac5c2..0963c07b58457 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -12,6 +12,7 @@
 #define __MTIP32XX_H__
 
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/ata.h>
 #include <linux/interrupt.h>
@@ -432,6 +433,7 @@ struct driver_data {
 	struct request_queue *queue; /* Our request queue. */
 
 	struct blk_mq_tag_set tags; /* blk_mq tags */
+	struct mutex ioctl_mutex;
 
 	struct mtip_port *port; /* Pointer to the port data structure. */
 
-- 
2.53.0



