Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56F34431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09052C433EF;
	Wed, 15 Mar 2023 12:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678884123;
	bh=RYRK5pU0obzR6PafdUd1j1wq+w9QAsWtn+eSgmN5Ur4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mh5wcNV145hbMWbSC9VSTnS0mVCSLP8grQLt9WVdwMom2RcYWzzXDj5hE/2Trt6ae
	 X/7poAL3O/KfcDs7SgC+vs+CpbZeDwjayKop3/IR4PW35f5pTAyNA+m9Ql6QJftUtC
	 9/i+VjjdPiz6qy7NHZJiQOoc9jEQdSxtkB/q9s4g=
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
Subject: [PATCH 6.2 098/141] block: fix wrong mode for blkdev_put() from disk_scan_partitions()
Date: Wed, 15 Mar 2023 13:13:21 +0100
Message-Id: <20230315115742.988754010@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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
index 6cdaeb7169004..9c4c9aa559ab8 100644
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



