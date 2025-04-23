Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A7727FD7A;
	Wed, 23 Apr 2025 14:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419821; cv=none; b=jznZpA92Upllzh3sTI0sFWCFHNBEcXTsvURNQcf7rTKVovdkiuNSuXqcMnEJkW850xs6jflfrULgpRldcg0hGsmwGm3TfeCbqbMdMhgzjqWsKREG4vE4Ab5e02g3siVWsKxumYjr58SyHZkIlE5eKzMByrx3WReiELWVAU4BO/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419821; c=relaxed/simple;
	bh=hrw0lWoRmNfgGUM4taXDz4rEaVUrgy+psqi0CdN2SQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyL344v+lAK2QEnDUUnqq+arBZjxY5V01OZ4i/b2jELQkI7z2/NWiHeJkPkGr+3oPZNaF1VCd21EZFPm9RHuNHnEPPytRUPu3xesr/ix4/mc7UaV2d7RkGJj7Sl8lFz6MKbYEkzaCmNaT72QpBjnx1AkamDWrwI0NPYpT77HvG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbdAHWeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbdAHWeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C336C4CEE2;
	Wed, 23 Apr 2025 14:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419821;
	bh=hrw0lWoRmNfgGUM4taXDz4rEaVUrgy+psqi0CdN2SQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbdAHWeLQcZ8G4xBPugOpgdkndH+tDRx9dBgFJdYdTEgR3sALcMYGIg9sS3/58Zmk
	 2Hvj/hcEEhsrY5PGHDgwYtMT82OZssrX6N4NAdtALxVM6EDJnXVrXmypHHDPgVA5CJ
	 7YoBVhRP0UjvKZ7B76k0Mz4HRtLwMkDxKnFQASwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/223] block: fix resource leak in blk_register_queue() error path
Date: Wed, 23 Apr 2025 16:41:57 +0200
Message-ID: <20250423142618.969086093@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 692b27266220f..0e2520d929e1d 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -813,6 +813,8 @@ int blk_register_queue(struct gendisk *disk)
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



