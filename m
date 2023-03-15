Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844464431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC592C433EF;
	Wed, 15 Mar 2023 12:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883711;
	bh=Hj+XlBTIjGwPR8kKUgh8MRzNjjR262C/o9btYzaCeT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtGZ8vWKxYOXeBeVD9DUK/NE7CecX4T9AAcStGcGdP6Oe71PIaT1TFXW9PyeKNL8O
	 +tK/nEB7JA0uUmD9zkG2q9ScuFRzc3T9240ojeWHZZAY7CqyDye3mGTSkHSYef8Rmx
	 1lGajgEoLpcsNuK2bQ9OvmHd1i2UMGJaHsjYFQ2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2bcc0d79e548c4f62a59@syzkaller.appspotmail.com,
	Julian Ruess <julianr@linux.ibm.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 102/143] block: fix wrong mode for blkdev_put() from disk_scan_partitions()
Date: Wed, 15 Mar 2023 13:13:08 +0100
Message-Id: <20230315115743.603682735@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 428913bce1e67ccb4dae317fd0332545bf8c9233 ]

If disk_scan_partitions() is called with 'FMODE_EXCL',
blkdev_get_by_dev() will be called without 'FMODE_EXCL', however, follow
blkdev_put() is still called with 'FMODE_EXCL', which will cause
'bd_holders' counter to leak.

Fix the problem by using the right mode for blkdev_put().

Reported-by: syzbot+2bcc0d79e548c4f62a59@syzkaller.appspotmail.com
Link: https://lore.kernel.org/lkml/f9649d501bc8c3444769418f6c26263555d9d3be.camel@linux.ibm.com/T/
Tested-by: Julian Ruess <julianr@linux.ibm.com>
Fixes: e5cfefa97bcc ("block: fix scan partition for exclusively open device again")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 85ae755913e9e..0b6928e948f31 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -385,7 +385,7 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 	if (IS_ERR(bdev))
 		ret =  PTR_ERR(bdev);
 	else
-		blkdev_put(bdev, mode);
+		blkdev_put(bdev, mode & ~FMODE_EXCL);
 
 	if (!(mode & FMODE_EXCL))
 		bd_abort_claiming(disk->part0, disk_scan_partitions);
-- 
2.39.2



