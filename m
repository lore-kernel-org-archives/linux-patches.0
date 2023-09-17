Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324956FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E95C433C8;
	Sun, 17 Sep 2023 20:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983261;
	bh=+3LqHfeYc0G8S+v7qTEAtLr0U2PV67a3ot8IdKitMLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IxCdw4kWeC9Uxt5HVZJNc6TBRLz8gcpEDuA1cc4pgu9/sQePB/oo6PRivIGPY8RrN
	 1Yuns1hrZFwnpmrjc8bc+au/Da4Z6YjCkMvVSUwzewUvDdn60HDooLjsvK8D3FhUWX
	 a3TXQdJU/PXYqETNZ2tXVxBdkRtzpHO2VNU71nxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Lingfeng <lilingfeng3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 490/511] block: dont add or resize partition on the disk with GENHD_FL_NO_PART
Date: Sun, 17 Sep 2023 21:15:17 +0200
Message-ID: <20230917191125.565021706@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

[ Upstream commit 1a721de8489fa559ff4471f73c58bb74ac5580d3 ]

Commit a33df75c6328 ("block: use an xarray for disk->part_tbl") remove
disk_expand_part_tbl() in add_partition(), which means all kinds of
devices will support extended dynamic `dev_t`.
However, some devices with GENHD_FL_NO_PART are not expected to add or
resize partition.
Fix this by adding check of GENHD_FL_NO_PART before add or resize
partition.

Fixes: a33df75c6328 ("block: use an xarray for disk->part_tbl")
Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230831075900.1725842-1-lilingfeng@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/ioctl.c b/block/ioctl.c
index cd506a9029630..8f39e413f12a3 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -20,6 +20,8 @@ static int blkpg_do_ioctl(struct block_device *bdev,
 	struct blkpg_partition p;
 	long long start, length;
 
+	if (disk->flags & GENHD_FL_NO_PART)
+		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 	if (copy_from_user(&p, upart, sizeof(struct blkpg_partition)))
-- 
2.40.1



