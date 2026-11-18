Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055374;
	b=5h2tx+VnNLFxUjPKEjmNIOYnoUJqlomXLckwgpSnz1T4ia+dB5ZvyhaWJnfzZVFuPrWo
	 99LOslDTIyGaH3/zTGqqBiuhwGWixDI6xEDGBBKig59Zby0Ix6O4ERRqns/93iq60Csq2
	 6CETPnkBY4yIkbuJhXPPGxXMSj5iwsMlyAhsLYvXzcvVCwBSggm9YP6mTmdlfSEfyNFdd
	 4zzipZQIEBoE3g/HDgoQVqVoDpQDRyNfn2if0KM9u71yQ15PQdvpWvwOOazED+TKwZGOU
	 h5SB6xC1MnwNfHd1Im+uwYBt6Cjq4aQQa+sd2wU9tjGjBJHvAEXagDK82wH9y21Ekcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rWGoxAzVM+I3mLFomeZnGlUlJK5bjAhqHef8mLJiLdk=;
	b=ctYwt4fEPL6DRUZPwgN9hUBgNcQjSZoN5grhUpAQWcp+cMh2oycykfsmmr2bcMPe6EOB
	 PN3fu9DErS2+1NMVE5tZp/5gzc1ch9FKcqnhxlRLUZcDv+V2wutGpIJacQQNl5+i7k59U
	 3pQfa4K6t6jyc2f9NVjCsK6txdPIZ3hjen9q8yWf0xOUFI6l7FzJnHc71DVs6ne3O2oJQ
	 99FoS2KrqDzevGOeNkwXn4NfhTcEMH4OspLJOAX2c8MszKUFgmaW0DyKAqheuQ9t+6/Jt
	 +VmBnJpYekJlWamOgUdd/SqcYZNx0erx6OBMVsbsNSNSrCo0KjG3L74p0BwhF4OO8xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="r0FDFS/C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47299606A33E;
	Thu, 19 Nov 2026 02:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r0FDFS/C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500FB1F000C5;
	Thu, 19 Nov 2026 02:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055373;
	bh=rWGoxAzVM+I3mLFomeZnGlUlJK5bjAhqHef8mLJiLdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r0FDFS/CZi8ukH5nTHQ0jjDMhYrATzEzzmUrNwRUW7ACq8d5ae25w1RKZAz/bGE/8
	 NM1qCjD+yLOtkRG6QuDzfPKh5PloOj547sSUG5R7qWXL/GXTR285biPZfFaHJknkOt
	 8bM2cHQsmBdcAQwSZvCr3SPc2Xd16/+lwWmzD1Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e08e0a15269eefa87790@syzkaller.appspotmail.com,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1609/2214] mtd: block: prevent reclaim I/O during request processing
Date: Wed, 18 Nov 2026 15:54:45 +0100
Message-ID: <20261118150116.305514507@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5288a6aaf1828..9d43eb86bb742 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -18,6 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/hdreg.h>
 #include <linux/mutex.h>
+#include <linux/sched/mm.h>
 #include <linux/uaccess.h>
 
 #include "mtdcore.h"
@@ -166,6 +167,7 @@ static blk_status_t mtd_queue_rq(struct blk_mq_hw_ctx *hctx,
 				 const struct blk_mq_queue_data *bd)
 {
 	struct mtd_blktrans_dev *dev;
+	unsigned int noio_flags;
 
 	dev = hctx->queue->queuedata;
 	if (!dev) {
@@ -173,10 +175,13 @@ static blk_status_t mtd_queue_rq(struct blk_mq_hw_ctx *hctx,
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



