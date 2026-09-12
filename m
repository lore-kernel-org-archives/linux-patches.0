Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7DB2EC09B;
	Sat, 12 Sep 2026 13:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218637; cv=none; b=a/xiNAoFao4HSJ7r8hthXMCBb+DYHKiioRc7h2RscImZ6zrQC2uLix5FZqZnvPlINVYb7akk3vjPQZfXavnDaBjIGLczct0Vw0Oy2UmFQnHrdZWnwrV2RXXQtQHQf3ZjOjgH9PP0Qr5VM9EjX8Ch3iVnElZaULcVuy2/OAYK5hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218637; c=relaxed/simple;
	bh=hn2OmB9x1d+hDChoRNtWHa4VIWADuY757b6d0+od4go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABLOkXnYjNcO3eWX8EIY6D2tOeLVF/E9ZwJZbasstX3t+sJomVgCnuPSAG07HnHkt68X3yEy93PyYoqOamNiYRL2PehCKYta9XdpF4hgmZWgGZjUO1DZgqKaSwcEhZFrAUdn7pSdssiCNrbrWdaPe6En8/NhO0QwsBOJXDuZWTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/44FFcz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/44FFcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694EC1F00893;
	Sat, 12 Sep 2026 13:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218635;
	bh=V9jBAkS4EEq7HnmlLuW60Mcl3fLQX8TMCGlQi0xPiUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/44FFcz0fclui3CocnmlmjY2rIWHQRXJ8YUBxH8+wG4/0mEXQjXQsbiPvdrEdCzT
	 QJXkLgnhwhNVM4KNdmi4ABD1JbOdawvPB8o4/9BqpvZd2c97tNUqStNQWbci1omR5w
	 KKGQlkDny4Ujziweh3mtXIJkUIx1mglMY3OY2NW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1158/1376] block: mtip32xx: synchronize ioctls with device removal
Date: Sat, 12 Sep 2026 08:59:44 +0200
Message-ID: <20260912065633.363177396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 223faa9d5ffda..86a9c557a5d64 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3038,6 +3038,8 @@ static int mtip_block_ioctl(struct block_device *dev,
 	if (!dd)
 		return -ENOTTY;
 
+	guard(mutex)(&dd->ioctl_mutex);
+
 	if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag)))
 		return -ENOTTY;
 
@@ -3076,6 +3078,8 @@ static int mtip_block_compat_ioctl(struct block_device *dev,
 	if (!dd)
 		return -ENOTTY;
 
+	guard(mutex)(&dd->ioctl_mutex);
+
 	if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag)))
 		return -ENOTTY;
 
@@ -3700,6 +3704,7 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 	dd = kzalloc_node(sizeof(struct driver_data), GFP_KERNEL, my_node);
 	if (!dd)
 		return -ENOMEM;
+	mutex_init(&dd->ioctl_mutex);
 
 	/* Attach the private data to this PCI device.  */
 	pci_set_drvdata(pdev, dd);
@@ -3872,6 +3877,7 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 	}
 
 	set_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag);
+	mutex_lock(&dd->ioctl_mutex);
 
 	if (test_bit(MTIP_DDF_INIT_DONE_BIT, &dd->dd_flag))
 		del_gendisk(dd->disk);
@@ -3900,6 +3906,7 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 
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



