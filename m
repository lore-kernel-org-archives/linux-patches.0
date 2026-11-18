Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053952;
	b=alcKHSZFYsJHkKL88HqmBEf1lsBDLdMpbr9Iep8d2hmc4soMbbaKAtEddPHAWjcfBpO8
	 m6LpvrkEPX+1JlELvpht6cmY7T5R+WOo/NXR0atQQWuBqTE/mdVCtEGd0oKttim5lgCeo
	 m/VaRBlai1bteUqIWa0or8H9aftcGmJDeL+xjH6VSj/K/4rUVgnK7yZqCCUExNdWzfink
	 kSBPmt8rb2n947Z9pGyaZw9t9ZDMqg6Sv1VBs1E8p0nPs3EdWkBEuBfuWawvgIqgdGo3P
	 QbxIDm+PtL5VIO1faAJEHgdxdSqDXUFDg3rpSWWaLoDKN2BYao8VUhGf32rLxr7W/Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EmZQKGlvfukItddylLQoM2dwe3ASZx+OHzhneWSaAZU=;
	b=xXWd25AFNhRGmy0Q01hQwM8eeTOvV9/UtpmzOgPdEkieK+RbSqjuNn2n8Cg2V7vxLRXF
	 YAHbUV3Qy72bO0AY4eyXqWBh7swQwRBjU42JAT0YhCBKZUx9BuCuGP1JaORpJXWWSag2M
	 ZcsGoVfSeqC2dW/TOwrmJYWUdYjbIrENoXBDpzr3e/lIfrZowacOr9zOwXVN2OsCi9gV3
	 +hl1kSjB1vmEhnB+9Jkb5UZ9UfMULJgDeTITnKT2/K86X3FojyINBm9C+HTyDOzk1nAI/
	 +Pl+zHFlQyeiE1g0NsnR3JyH8AS8kNzPCRlNdLCVK7d78voHSg0ydZExB5CHr37Ja5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KIORNEaf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335C3606A31C;
	Thu, 19 Nov 2026 02:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KIORNEaf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B7E1F000C4;
	Thu, 19 Nov 2026 02:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053952;
	bh=EmZQKGlvfukItddylLQoM2dwe3ASZx+OHzhneWSaAZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KIORNEafUGiVdLIKLERD8+fOOSB3+z9TvYfETi+YFtBGFzggkmys/nKPYngLr7CBF
	 EujUNBCSDAwWucTzrDdox7wn77ZRXgc00ei8t3OQEuQ8NqY/7MjClPSrFgkyn2zqZd
	 /1lyuwmz2W7OT9sFtJJHPs9H4kFkyEwCobXTyWig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1101/2214] xen-blkfront: Fix IO race during unplug
Date: Wed, 18 Nov 2026 15:46:17 +0100
Message-ID: <20261118150056.230672397@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ross Lagerwall <ross.lagerwall@citrix.com>

[ Upstream commit 61b6d1df1d6234c38a6ea7e4f58e7da035ef6ab4 ]

During unplug, blkfront stops the hw queues and marks the disk as dead,
then later during removal calls del_gendisk(). However, IO issued after
the hw queues are stopped but before the call to del_gendisk() will be
queued but never handled. This causes del_gendisk() to hang forever
waiting for the queue refcount to drop to zero.

This can be reproduced by issuing IO during an artificial delay after
stopping the hw queues.

Fix this by simply not stopping the hw queues directly. Marking the disk
as dead already freezes the queue which prevents new requests being
added and it synchronously runs the hw queues to clear anything pending.
If the hw queues are stopped when calling blk_mark_disk_dead(), running
the hw queues is a no-op and can leave queued requests unprocessed.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Acked-by: Roger Pau Monné <roger@xenproject.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261006163411.2583538-1-ross.lagerwall@citrix.com>
[ sashal: Retained set_capacity(info->gd, 0) and its surrounding braces because blk_mark_disk_dead() does not reset capacity. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkfront.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 02dc4a67ac82f..31dd69e3e6ed5 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2157,8 +2157,7 @@ static void blkfront_closing(struct blkfront_info *info)
 		return;
 
 	/* No more blkif_request(). */
-	if (info->rq && info->gd) {
-		blk_mq_stop_hw_queues(info->rq);
+	if (info->gd) {
 		blk_mark_disk_dead(info->gd);
 		set_capacity(info->gd, 0);
 	}
-- 
2.53.0



