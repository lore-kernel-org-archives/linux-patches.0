Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060877;
	b=LElWomTHDO7FzqNZP+0Oyq016KnD/GN8IVUPxU9Z7z+5kWmk5Qk4ezyPTgTWfmIvrbW2
	 pMsqRc0JNhWCQpgDdDB6wPG32lh+7K22UUmwOX5u1TnrnNKW5uvGZMUluEL0mk/fXGnOO
	 Yr/j6jYl2YekYtdCW30SUtCUssrooA0cmVBUFhx6Yj12f4uYUHdukTHEM0hWrLxiyDJX4
	 VESfVpXRsN07V0uTaOJaLwsSf+Z4gtBtO/bfBS2iGbSQWQ1+2sBz3DMsnsbrOu+V2zt1L
	 WrkFEMMtFjFUr0g19me/Zy/AOSCLSAT54giv19LqzLtK3C4iKZ57AFXGbRDJKMsgQBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ft149Pd9ercNWvYFOb5QLX5D0SaniM3FEDIG+rTYaTA=;
	b=t63kF4XCulprH+lId2HDhjtC1BQqAFYoOoa5/dWSqzyvpGng7baEPQhsIsnKH5cn6U/E
	 UdPRK6uh8rqAGoB+YFIyr9FCbsgNItzUDFR6O+Ix/UqZUP4OPOyW4+/xvgFj1oH0Esru8
	 /IpLDk+gEEAF6wo0L6ZeE3PqHxVJv2zFknY1JFp9FGp/lLV/KT2MTYbg0HN7ZBCRJ7hCR
	 aC9BvJKi9QaBwVdaaPgcwf4UI1pDVtaUztLGZgqp6HTea1Dcr1yTJw1k/ZcJGqkr2jlnm
	 b050PaEUA+TdieK/t616s94KnmsAJa7o9m9ZYs1OUd7Y/YT1S/F/GEC0JkXRgU0P8WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVjieDeU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3083F606A32C;
	Thu, 19 Nov 2026 04:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yVjieDeU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818301F000C4;
	Thu, 19 Nov 2026 04:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060877;
	bh=ft149Pd9ercNWvYFOb5QLX5D0SaniM3FEDIG+rTYaTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yVjieDeUorApyKf56INepmS9EQ2scE3MPGniJfHzCKP3az+OnyG5R/OemHcbBFsDZ
	 0mUkDdkiDULTzLBlyKh3auhpJ1hI/83FhzQXigegYJj+thvThh2lHq1LrqXzQ+5Qb8
	 /CeWZONIBhz9RfnAWTYVsXFYmFbx6FPRerVQAE5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e08e0a15269eefa87790@syzkaller.appspotmail.com,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1356/1848] mtd: block: prevent reclaim I/O during request processing
Date: Wed, 18 Nov 2026 15:56:34 +0100
Message-ID: <20261118150016.386534524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit d498b2ddda99eed28cde177b1620dbcea246a1c4 ]

The blktrans request callbacks run under dev->lock and may allocate
memory with GFP_KERNEL. For example, mtdblock_writesect() uses vmalloc()
to allocate its eraseblock cache. Direct reclaim can then recurse into
block I/O and deadlock on resources held by the request being processed.
syzbot reports a circular locking dependency involving the device mutex
and fs_reclaim.

Commit d5ba1c8ffd0b ("mtd: don't use PF_MEMALLOC") removed PF_MEMALLOC
from the MTD request thread. That flag had prevented direct reclaim,
so its removal made allocations during request processing eligible for
reclaim without excluding I/O.

Wrap request processing in mtd_queue_rq() in a NOIO scope. This covers
both the request and background callbacks, including allocations made
by lower MTD drivers, and prevents reclaim from initiating filesystem
or block I/O.

Fixes: d5ba1c8ffd0b ("mtd: don't use PF_MEMALLOC")
Assisted-by: Codex:gpt-6-astra
Reported-by: syzbot+e08e0a15269eefa87790@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e08e0a15269eefa87790
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtd_blkdevs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index dd0d0bf5f57f9..ae5ac5d5451d9 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -18,6 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/hdreg.h>
 #include <linux/mutex.h>
+#include <linux/sched/mm.h>
 #include <linux/uaccess.h>
 
 #include "mtdcore.h"
@@ -186,6 +187,7 @@ static blk_status_t mtd_queue_rq(struct blk_mq_hw_ctx *hctx,
 				 const struct blk_mq_queue_data *bd)
 {
 	struct mtd_blktrans_dev *dev;
+	unsigned int noio_flags;
 
 	dev = hctx->queue->queuedata;
 	if (!dev) {
@@ -193,10 +195,13 @@ static blk_status_t mtd_queue_rq(struct blk_mq_hw_ctx *hctx,
 		return BLK_STS_IOERR;
 	}
 
+	/* Reclaim must not recurse into I/O while processing requests. */
+	noio_flags = memalloc_noio_save();
 	spin_lock_irq(&dev->queue_lock);
 	list_add_tail(&bd->rq->queuelist, &dev->rq_list);
 	mtd_blktrans_work(dev);
 	spin_unlock_irq(&dev->queue_lock);
+	memalloc_noio_restore(noio_flags);
 
 	return BLK_STS_OK;
 }
-- 
2.53.0



