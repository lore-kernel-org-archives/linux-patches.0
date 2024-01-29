Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A7015AAD9;
	Mon, 29 Jan 2024 17:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548398; cv=none; b=jMK4Tp0dnsYYMUNwDGDzrze17CGyp8TY46iuNnxR0ugnRB/XG2g+QclwV99i+wHVRTnCfh11CmgkvUADpg85IFimE4Ae7A7qqj9jqXyq3KJZlu7TNcDzHUCI1mdD1qg/Sj5k/yC2xU1SwAaPppVW0d3+3hhKT3CnIo/siY0MMOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548398; c=relaxed/simple;
	bh=X+GejbycaQ1NCq6kbyPiA4BA4T/XdN8D9m1Wnq1qeRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6kIIfjzA5aSERvB2Mn71FDsNlWPHla/hH0/VVfKH4DZ5ILYkM0IfB5Od8fLQUEXcIHm03kylNqWQmWrKxbLWqLy8EacdAD0P6a2luqUQI4lKaMpaKmdCd1FztTid+UUbuctXXUsgNxFkJlwgvo18IXrXKskzG6swzwLZwKUFQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJ1Ot1Yo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJ1Ot1Yo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688BBC433F1;
	Mon, 29 Jan 2024 17:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548398;
	bh=X+GejbycaQ1NCq6kbyPiA4BA4T/XdN8D9m1Wnq1qeRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJ1Ot1YoIs6dbX9sBBMReKzH+TXhcuLIfkyX9iImglwDY2UhciDztY0X3wOyyaz48
	 9klE9MJy6kXq0WAF45Jl4GctAKTbHpZpXM5HofgGW1ATYD1hZtOqUhtr4+WO3WRsh9
	 If4lDYYN5+3vIoF8eB7cPEmOuzIxJQ2aQMMiKpHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Karlitskaya <allison.karlitskaya@redhat.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 176/185] block: Move checking GENHD_FL_NO_PART to bdev_add_partition()
Date: Mon, 29 Jan 2024 09:06:16 -0800
Message-ID: <20240129170004.245352604@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Lingfeng <lilingfeng3@huawei.com>

[ Upstream commit 7777f47f2ea64efd1016262e7b59fab34adfb869 ]

Commit 1a721de8489f ("block: don't add or resize partition on the disk
with GENHD_FL_NO_PART") prevented all operations about partitions on disks
with GENHD_FL_NO_PART in blkpg_do_ioctl() since they are meaningless.
However, it changed error code in some scenarios. So move checking
GENHD_FL_NO_PART to bdev_add_partition() to eliminate impact.

Fixes: 1a721de8489f ("block: don't add or resize partition on the disk with GENHD_FL_NO_PART")
Reported-by: Allison Karlitskaya <allison.karlitskaya@redhat.com>
Closes: https://lore.kernel.org/all/CAOYeF9VsmqKMcQjo1k6YkGNujwN-nzfxY17N3F-CMikE1tYp+w@mail.gmail.com/
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240118130401.792757-1-lilingfeng@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/ioctl.c           | 2 --
 block/partitions/core.c | 5 +++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index ebe4a2653622..47567ba1185a 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -20,8 +20,6 @@ static int blkpg_do_ioctl(struct block_device *bdev,
 	struct blkpg_partition p;
 	sector_t start, length;
 
-	if (disk->flags & GENHD_FL_NO_PART)
-		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 	if (copy_from_user(&p, upart, sizeof(struct blkpg_partition)))
diff --git a/block/partitions/core.c b/block/partitions/core.c
index b8112f52d388..3927f4283f6b 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -453,6 +453,11 @@ int bdev_add_partition(struct gendisk *disk, int partno, sector_t start,
 		goto out;
 	}
 
+	if (disk->flags & GENHD_FL_NO_PART) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (partition_overlaps(disk, start, length, -1)) {
 		ret = -EBUSY;
 		goto out;
-- 
2.43.0



