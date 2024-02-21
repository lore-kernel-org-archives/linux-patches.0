Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209597EEE4;
	Wed, 21 Feb 2024 13:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522378; cv=none; b=TJvjHbGIagY0a7WULYUGB3SP/1dPvYzcBCQgbIQZAQTIUdJhCRb1BhEgyFD6MpnJlwjZZUICu7/T6aLgCY5Oe3uDd2weamMF7UZxbnbXkAYEJHO56Q8tLHImsMQK8OQZtseKe3t+Y4fCfjJDyUgLETYIj5M+c/fRG+ZeiVp6trA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522378; c=relaxed/simple;
	bh=LzTvuewFVBbNlLsQco//tITg21e9ZzJ+pe9F30Dvdqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUo8DBktoT5QJQ0NqUqAyRYMCjt0iNJuRue/e7xJSD4KXj6epabpTwCy/xqPRmB47jfTn4SijMfbuRwSRCl/+Kd5ZlDsCCqRnJzCZomOIMURPw12BpPKHJL7vmFp5DoqDZsP8iOF7Ksq1k1TMKUoRUvCA9RRDaFq1S9rblCMEPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L33IMDVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L33IMDVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86970C433C7;
	Wed, 21 Feb 2024 13:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522378;
	bh=LzTvuewFVBbNlLsQco//tITg21e9ZzJ+pe9F30Dvdqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L33IMDVGOjtPNuHcVrCFfB4C49gJuYqzmPueQKEA1+e8tZEWpZ6uWl5j45Y4Rnet6
	 E9+aed7qoJ1s4pSTxmjkG24iGh/y5ZvpvtVUiVxm6zG0TlEsSZD+RHWhIHqndR12vW
	 wsV4hk9PiRUuUcOek1veycLlVe1tsNmfsvtoYOIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Karlitskaya <allison.karlitskaya@redhat.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/476] block: Move checking GENHD_FL_NO_PART to bdev_add_partition()
Date: Wed, 21 Feb 2024 14:02:51 +0100
Message-ID: <20240221130012.415628881@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0a3cf9aeec7d..7a939c178660 100644
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
index 1ead8c001561..b6a941889bb4 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -463,6 +463,11 @@ int bdev_add_partition(struct gendisk *disk, int partno, sector_t start,
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



