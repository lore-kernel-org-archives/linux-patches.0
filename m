Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4E9CA6F;
	Sat, 12 Sep 2026 11:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211390; cv=none; b=DTknpwd0GBHd5POYtkufSXkIfj7RD/ozeHVENjbBAlNal7W352zKLIvhgzNzCAIH72AoT1jP5kIfu1uL31l9CENYd2paYNwmMUwmWTAeSHc6VoebIF55fBwy30kEFT2e1L/3ZsN7Y5hSpLjr4+M1zxwq823IT6ygV/fE82Oz09A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211390; c=relaxed/simple;
	bh=jKTcXimfmynqEAgAEsxn9+dOISYKV1gpnmo7vz9xhtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y07NsNpxW/oOBf4m/x8Wu8aU29XzJnRNiIC/d3K/Ze0tlCJ7e1KEisCNNVwUsQD9WprjDNwMJX/JdAP+Kt3/bRAZ26Dc2D75gRVbGPaEL1l66fw6uRvXEfUixON4I/mZr49ESMSXH8lfOjwoL10zMC2MXLwqCm00A99cvIp8iQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEVZDzK5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEVZDzK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1C81F000FF;
	Sat, 12 Sep 2026 11:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211389;
	bh=SLyXss+zYqxii/BjMQsk5/0W3OBnDxsjfu7F1ZXc854=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VEVZDzK5Y+bHFORZFlDsfm8ZWjozprHm7xpW2hl8DA5HVpoDp02AROVRg/C9LFu4I
	 tyyduQaFC5OchFz96kiFEXmB3nPHFZitpbiqvWJcq68uFSpSNWswnPZx/ubPJXW+kX
	 wcl8RU3+bzvB554sEIWntCkuOkO/ojsuDenjUuSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1221/1518] block: mtip32xx: synchronize ioctls with device removal
Date: Sat, 12 Sep 2026 08:56:30 +0200
Message-ID: <20260912065651.118377782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 567192e371a8f..a7bf990ce9c32 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3048,6 +3048,8 @@ static int mtip_block_ioctl(struct block_device *dev,
 	if (!dd)
 		return -ENOTTY;
 
+	guard(mutex)(&dd->ioctl_mutex);
+
 	if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag)))
 		return -ENOTTY;
 
@@ -3086,6 +3088,8 @@ static int mtip_block_compat_ioctl(struct block_device *dev,
 	if (!dd)
 		return -ENOTTY;
 
+	guard(mutex)(&dd->ioctl_mutex);
+
 	if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag)))
 		return -ENOTTY;
 
@@ -3711,6 +3715,7 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 	dd = kzalloc_node(sizeof(struct driver_data), GFP_KERNEL, my_node);
 	if (!dd)
 		return -ENOMEM;
+	mutex_init(&dd->ioctl_mutex);
 
 	/* Attach the private data to this PCI device.  */
 	pci_set_drvdata(pdev, dd);
@@ -3874,6 +3879,7 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 	}
 
 	set_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag);
+	mutex_lock(&dd->ioctl_mutex);
 
 	if (test_bit(MTIP_DDF_INIT_DONE_BIT, &dd->dd_flag))
 		del_gendisk(dd->disk);
@@ -3902,6 +3908,7 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 
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



