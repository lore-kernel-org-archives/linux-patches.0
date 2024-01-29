Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2A415A493;
	Mon, 29 Jan 2024 17:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548639; cv=none; b=S5iXE8cPOeajvw6wZB6qt0xkUQDMwKzgyEZ1/4UdGQzUD4mMBQRf6OI8dOT8hqbtW0S25pZaxp+4yTUf/XdlemVlHUQadE+g4Gb5M4W1svohfP56+fOO6RMMQox4VcNsSNNztgJrbUTgGwfUlZd4H2t8vUBX/vfft2Yj+inZs50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548639; c=relaxed/simple;
	bh=r3gUyyrBWGbgD400DRqJZKOFE2/qmGi9zaBsu2hmIYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSn4UZ/EvYt4ddnQyUZFCN2Ysxp+WR5jeXqrj5RleiYWZ6FwOGN2sk4Jd7I/XH28vUY7CKqgeU5uD/73MQmR0Wc/dqq1oyOm4kCR8ESFB1RqZDNfpx5NajT1N94701wMAlhHTSlgyoPE+Eyudebd3vcvWR3kdhwakAQ/43uI9S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4EuLr0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4EuLr0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E379BC433F1;
	Mon, 29 Jan 2024 17:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548639;
	bh=r3gUyyrBWGbgD400DRqJZKOFE2/qmGi9zaBsu2hmIYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4EuLr0c9ch5xnQ2KeOrhIoXq8WeHrS5hIouGQ8Qhb4dJkxOvCv1BCmFXLJ4mBZ3E
	 NQcnKp3xRnHcddkNuWs+yJbj2Wi0tcYwb4I3MbQDKooAsM+PLhn8pxncEc6UyOWykd
	 BsrKdSqh6U1axio+Z/U+2fi2u/40VyAMPMdG3940=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Karlitskaya <allison.karlitskaya@redhat.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 315/331] block: Move checking GENHD_FL_NO_PART to bdev_add_partition()
Date: Mon, 29 Jan 2024 09:06:19 -0800
Message-ID: <20240129170024.103558219@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a74ef911e279..d1d8e8391279 100644
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
index e137a87f4db0..e58c8b50350b 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -458,6 +458,11 @@ int bdev_add_partition(struct gendisk *disk, int partno, sector_t start,
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



