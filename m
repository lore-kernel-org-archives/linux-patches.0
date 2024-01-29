Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E5F15CD49;
	Mon, 29 Jan 2024 17:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548331; cv=none; b=X2Syx8e2kpOV1xWEQ3YvJ3rcnSFN95hRmZRurjg/sz3j/DgV0yBKJNTgQ0Cft3vhAo7SBh/+g5R0PGAUYREC3N100EPbqHDKdEGOgdeUAs2LUD/vr14EctGFCgsH5lxqzlHCV9owrXNbTM3F9s27Xqx5SNdM6Wxx6Duj/IlzDMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548331; c=relaxed/simple;
	bh=TmsxVF/uYqxsg8V8ckbVnBt0alSsBkpJvYdNMCa7Brc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7aLoHhju2i5fX7sbUUhj+7SYgYMuoLbAxgnPr1HytSoq0cdArHJ/YIRCbr0MOyvfd6AtO8BhtAS4qp7HBrcfubzQ+d15gNDOuxm/BlbO2k2SrVCbxIfLItwmsths9h6AxIQmanTFFRs0OqT++HMPF9MoBHA3ejv8NX7jadfC/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mo7rxV3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mo7rxV3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B89C43394;
	Mon, 29 Jan 2024 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548331;
	bh=TmsxVF/uYqxsg8V8ckbVnBt0alSsBkpJvYdNMCa7Brc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mo7rxV3GAVq+hWIwTeaoONLqSvGxKN/wLcg9QyutMqokfAhDKVlaNcZ/n1CL1nntr
	 +xiK7jdTV2FFZcUhHCzzlHiAdVBIJ+3jAfyBMT9mD7L1U77flWj4+n0lQkrXBwZFro
	 4dfSi0/lBXa5ig9Fo0b5aSUXZiPwOOIl2a0YWCGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Karlitskaya <allison.karlitskaya@redhat.com>,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 329/346] block: Move checking GENHD_FL_NO_PART to bdev_add_partition()
Date: Mon, 29 Jan 2024 09:06:00 -0800
Message-ID: <20240129170026.158425808@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 9c73a763ef88..438f79c564cf 100644
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
index f47ffcfdfcec..f14602022c5e 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -447,6 +447,11 @@ int bdev_add_partition(struct gendisk *disk, int partno, sector_t start,
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



