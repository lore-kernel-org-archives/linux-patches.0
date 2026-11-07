Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062278;
	b=fTgyse0IbW+enIPgwQRBC87bWZ6Scp4vo8mFgbQfRvkClmKfjcKkG9mhTiCTmB30Wpf3
	 CF1hzh8kWrnbY+b2eOAKBlT9fT83WsScQSnPujjUyOPELQQ7Z4tQe885r+CVkg3fR6b1F
	 iq0f2iEKAFyUEpgTTeD2+KcKZ3C1JitFlGaC5Zg324OVuERc+6N0YBsS1fliNqpYAurv4
	 bD6wz0CwU1Ppk+kTxyyZ/4tikNaltDk/nwFGrTn+Q7R09j3atQmHA+ChZuDmW3Wyxw5+w
	 jmj3n7lNT9380gaCvcRXvlyWwq0y2oJTc9XHOZ10VIVWgAx5sZR+85Q49EhpyqIs3zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ayFuuXQ9rwDsYQNSZxQBwo/nBP2SmGp+jM7Vm7+eIzM=;
	b=QODAd+v/+yUPHgdqY3jpNc0TdXnnzQ6dcRMdbUYNx/50+e8VkEF7/+GT60ohDzbJW/+z
	 HRrKdCS6h3s+U48CMttO4//S5w4dES4lBNvbw25WPoBYf6ILKH2s6U16yaBjbGK+I1Aub
	 0/H4r6hX1LQJ5+6R9LgTGeRZFNPsdQk1AeCxHTuZzhskXzmcJWp0Ua+3oR/WbdrKZewOA
	 t8Hs0v5plWMQwmgfDF4Ph5njcVxZVw7U3JZIcxgc5quxWQJq/DoF0EFmP+2OOjpwqykDC
	 0WYwivjSoWqd55r7U2R8PJXSsrTseAKYVecmSVCOPVgmFQjvCfXSTu0mvp6QPYjoDPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2epMhyK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C45606D804;
	Sat,  7 Nov 2026 14:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K2epMhyK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1751A1F0089F;
	Sat,  7 Nov 2026 14:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062278;
	bh=ayFuuXQ9rwDsYQNSZxQBwo/nBP2SmGp+jM7Vm7+eIzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2epMhyKrSHE1wCIpAAS51imre655ynbyXIbfln/I9Aj5kh9YvjOfA9srsiw/VFHv
	 kO8I32scy6BYky3Q02hgJMpchL0v2BCDsp9Y+Fd2w3++575ucjsl1H06md/nPqTZhc
	 yWNsN8DFVlKqT8uZTaSjg9wPqClweX8KnmuodWoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger@xenproject.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1218/1536] xen-blkfront: Fix IO race during unplug
Date: Sat,  7 Nov 2026 08:53:54 -0500
Message-ID: <20261107135031.965191891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/xen-blkfront.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index c47ea29238db2..914d89aa051f4 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2134,10 +2134,8 @@ static void blkfront_closing(struct blkfront_info *info)
 		return;
 
 	/* No more blkif_request(). */
-	if (info->rq && info->gd) {
-		blk_mq_stop_hw_queues(info->rq);
+	if (info->gd)
 		blk_mark_disk_dead(info->gd);
-	}
 
 	for_each_rinfo(info, rinfo, i) {
 		/* No more gnttab callback work. */
-- 
2.53.0



