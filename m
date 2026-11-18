Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048616;
	b=125TatHw644AKeXDQRd9Y/xjwodt47gDC1c9QD1W6a2kvNjM/1K63l6JB+tKzGTKauoH
	 bvTWeOxujVYI7wPdI6GpZQR75X3tPAYjlYRw/M2bx/2EMeUvHOC7hFKQJz5pEF33jbn9J
	 fAhN3Vp2xjVRMze/fVvpxBFAngEEIUH0G0bFFtYMGyVdv1gu0W74K/qY/9QKmt6CLacpi
	 IJiTuQurYrYrTcTTaP+FvZ4CGSrdcHbK7BxyOcysmV9yK8r7bwYB3mFNx4lcg+5mmj8MY
	 hz4QchPlRbcKUravrQEiIrR8QyVITxhT4O6y7zUdf0hHmQMPoXOZybKIK7Omwxr2CkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kRwJXKtP60L+x2T05uLbWKOTpyoDHt4d5IEDerrQZgs=;
	b=ZNopfNVNx5jYXkaonPP6nZ6zQwT0bjLpiCS6lvmBLO+U2k24JvB+0g+ZPbC03HS5A+zx
	 0z1O3GFaaBOWPzZNu2LT/Q60TrmNx1bGtEel6irBjGIREykJOS3vTQybep67LTu2c20uN
	 rIRjHN90T2LI7/UTXhE5iKaJxY9MQO7D0WAIDjic1p5gCUwkMgdv9viiVBeOsSd5Wz4IT
	 gKX9npE5GCAx/ScPCepBdhDA05ni87tlSbWGD2BzSt1GRPiZI/N1dV6FXua/Li6ajBiW3
	 uvh9utBYe1Zun8Q60PZB0MB52KvHXNEMiz69wQsu0bUErmZcBh1PPVHNVtDn/oBiVJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zLGv18Nl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B433606A31C;
	Thu, 19 Nov 2026 00:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zLGv18Nl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD00A1F000C4;
	Thu, 19 Nov 2026 00:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048616;
	bh=kRwJXKtP60L+x2T05uLbWKOTpyoDHt4d5IEDerrQZgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zLGv18NlYQGYfmAtFjfSAU1lWTCV2pSV8OJRizEKXsTwloe27Og0DxGcbZGTdflhk
	 i1TV1x0ilurZGVFrqeKzCjIZdELaOCAVpBxfq10y9yW+LPzZryD+i9DC95Y3JTF3Tm
	 g2e/r96MiGLVdsVf8i5TRlHGwHLksHpzO5iEpK98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e08e0a15269eefa87790@syzkaller.appspotmail.com,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2058/2857] mtd: block: prevent reclaim I/O during request processing
Date: Wed, 18 Nov 2026 15:51:32 +0100
Message-ID: <20261118150315.515298899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 8ee60605a6dcc..f62fa9171705d 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -18,6 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/hdreg.h>
 #include <linux/mutex.h>
+#include <linux/sched/mm.h>
 #include <linux/uaccess.h>
 
 #include "mtdcore.h"
@@ -167,6 +168,7 @@ static blk_status_t mtd_queue_rq(struct blk_mq_hw_ctx *hctx,
 				 const struct blk_mq_queue_data *bd)
 {
 	struct mtd_blktrans_dev *dev;
+	unsigned int noio_flags;
 
 	dev = hctx->queue->queuedata;
 	if (!dev) {
@@ -174,10 +176,13 @@ static blk_status_t mtd_queue_rq(struct blk_mq_hw_ctx *hctx,
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



