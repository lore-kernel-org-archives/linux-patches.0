Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88822C1E33;
	Wed, 23 Apr 2025 15:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422044; cv=none; b=VFIhUjkbEake/BKQkvgnQYRX+kb2bCqqzy2UilgSbH4Y5ew4OK/xHpUukK3wnAGplNB/bVJv1Ls22htVFbMato5QLBf1OSYmIGrO9HBJ2IeaTG5Bsl6lakq2sasKw53Ejmvclo1T6HM2YT6QUSZc0PRFZ/u2sZ9Zfty1/3LDZXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422044; c=relaxed/simple;
	bh=5pgt83/LlkZ7UjKxdvfQfvBaFWAIYd5DkSYTk+tes3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1yvbKLSa2b5Bl77MwClR3/IRT9iuHRKoPdekpZZZNvJGufQRMy8KMei6r7bN8vC3ve01Yb47bggtQOZGvknFRjNvNQ70YdEaOGtKgTnoRtTK5uAWCuO0GIt9uYUS0thR/PodFA5pFhanWMzqd+P9DoS0U0xB42H7CEw+dcNqoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKFWk3BB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKFWk3BB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68982C4AF0D;
	Wed, 23 Apr 2025 15:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422044;
	bh=5pgt83/LlkZ7UjKxdvfQfvBaFWAIYd5DkSYTk+tes3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JKFWk3BBuyb1WwZiT2PEa+Dg+hOJ2IygX6YAapLrmNVCizq7W8uHJnx2FvrDTkFy7
	 JSIIMnZE+PVbc2LzdVT55ltVp7GSQalg0n4t+Z25BJ4AFQp0K2u/sMOyaI9om3SvHs
	 fmQhwitjP/cVUBSMFSq2KWlGFn9mSo1dwnKNgE68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 268/393] block: fix resource leak in blk_register_queue() error path
Date: Wed, 23 Apr 2025 16:42:44 +0200
Message-ID: <20250423142654.432829863@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4990a19e60133..74839f6f2e0cb 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -854,6 +854,8 @@ int blk_register_queue(struct gendisk *disk)
 out_debugfs_remove:
 	blk_debugfs_remove(disk);
 	mutex_unlock(&q->sysfs_lock);
+	if (queue_is_mq(q))
+		blk_mq_sysfs_unregister(disk);
 out_put_queue_kobj:
 	kobject_put(&disk->queue_kobj);
 	mutex_unlock(&q->sysfs_dir_lock);
-- 
2.39.5



