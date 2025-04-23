Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE01627FD63;
	Wed, 23 Apr 2025 14:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420005; cv=none; b=avLeUDUFENASDKvjCda6WcTWJ6SFWsbm/i2c44PV5/8Ju9jLZFoKbzzL9zllT6iELZm6HP6NH5OU5brQfL9mZDvpbOoabwOt518hKb3yN2a2lqgY9oRlqCDs+MQV/J9FVUebDGqxEXn/KDKNMd34ODjaQ5Qjwtn/baTdPZvi1tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420005; c=relaxed/simple;
	bh=1bMxgsDzKRnpeiIKgnLoR23Cd0Xksp4ieD86VVj+odE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWqFa8YY/I7v/5O/VRzCb8RkVZdJW8Ar/PfVpwC8Kme60uWUwX7Qs7LTvyxeMoAkLJlV5+KAYYZf/cgQDdRzaUX8QcUt1HO7k94y0Nueohq/DjNybfFhC7Enq9XBn8HtxAwLGvYJN0Gl5xWzs4CuNj2pe2DvIC0FLxM3IjNh41o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIXK3W9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIXK3W9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6562C4CEE2;
	Wed, 23 Apr 2025 14:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420005;
	bh=1bMxgsDzKRnpeiIKgnLoR23Cd0Xksp4ieD86VVj+odE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIXK3W9j5O5GP8IWqQaWPNuPQypCl9X7kX9Svd0n8UmPFgk2p8O2Ro/7vy92InDeX
	 G0y15bqRpg/SN8ftmr1Y11u0E0FdNuimyj44fmIz3S880UQNVTAWgLrB6PftulgUfB
	 quMs0aZW8inWzEmykrX8zECuws+v6+nOsIItsl3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 051/241] block: fix resource leak in blk_register_queue() error path
Date: Wed, 23 Apr 2025 16:41:55 +0200
Message-ID: <20250423142622.591031963@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit 40f2eb9b531475dd01b683fdaf61ca3cfd03a51e ]

When registering a queue fails after blk_mq_sysfs_register() is
successful but the function later encounters an error, we need
to clean up the blk_mq_sysfs resources.

Add the missing blk_mq_sysfs_unregister() call in the error path
to properly clean up these resources and prevent a memory leak.

Fixes: 320ae51feed5 ("blk-mq: new multi-queue block IO queueing mechanism")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250412092554.475218-1-zhengqixing@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 6f548a4376aa4..7802186849074 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -824,6 +824,8 @@ int blk_register_queue(struct gendisk *disk)
 out_debugfs_remove:
 	blk_debugfs_remove(disk);
 	mutex_unlock(&q->sysfs_lock);
+	if (queue_is_mq(q))
+		blk_mq_sysfs_unregister(disk);
 out_put_queue_kobj:
 	kobject_put(&disk->queue_kobj);
 	return ret;
-- 
2.39.5



