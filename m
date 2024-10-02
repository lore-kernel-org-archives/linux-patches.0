Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152FB1D1E69;
	Wed,  2 Oct 2024 14:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880261; cv=none; b=qqGW9pg/Mez8ODy0+tfC2SyeOvbgx/uE9ANOGcTfYT3PWv3Kr+HEg4xWxmlTcuLZLqA+epzCbJwC6K1ikaW7SEWwiJ65XhaY8DYUF2urRBWQyvsq7kBOuu866yUkbPBr6Al5rZYoJ8Vtm/AEvU/Yf2KRrM+5MRw4QmnnGrB1TvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880261; c=relaxed/simple;
	bh=zckAbYWN/tI2HjtC5p559FPKlJto0oCmxQSYWJwVtxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBjthRM/xAH4rEVoY//UozGGwg++V/yrsKDIgDVCtPnY+1PccxdOqV+wJ0/HOldzMMmQxr7TGdsdew2cJmAaaSV53FQyswv0gdemGDq+ESzx34OHHV/va8bQFfIsELOWDEOh6Sju4+AZ+3dz4u6GuM6Zqht5jRGKhijSykTivtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyn5KGuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyn5KGuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92315C4CEC2;
	Wed,  2 Oct 2024 14:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880261;
	bh=zckAbYWN/tI2HjtC5p559FPKlJto0oCmxQSYWJwVtxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyn5KGuZOZ6b3pd5oZYf8eg7Xn1fjaNVvbkYcQNZKPXQ0NrWmh7VhJELiJdKsgaS0
	 8Q6OC2Kr3v8HV48MOZyRzJi5HZvmkOtBOBSPkc4MOFKzBdeAeODub9NFh1gIKGrAkj
	 1NiJunRTHgg3/aw6GEVTlEuJTV1VU3CvQ2wYHWrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 368/538] Revert "dm: requeue IO if mapping table not yet available"
Date: Wed,  2 Oct 2024 15:00:07 +0200
Message-ID: <20241002125806.954064302@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit c8691cd0fc11197515ed148de0780d927bfca38b ]

This reverts commit fa247089de9936a46e290d4724cb5f0b845600f5.

The following sequence of commands causes a livelock - there will be
workqueue process looping and consuming 100% CPU:

dmsetup create --notable test
truncate -s 1MiB testdata
losetup /dev/loop0 testdata
dmsetup load test --table '0 2048 linear /dev/loop0 0'
dd if=/dev/zero of=/dev/dm-0 bs=16k count=1 conv=fdatasync

The livelock is caused by the commit fa247089de99. The commit claims that
it fixes a race condition, however, it is unknown what the actual race
condition is and what program is involved in the race condition.

When the inactive table is loaded, the nodes /dev/dm-0 and
/sys/block/dm-0 are created. /dev/dm-0 has zero size at this point. When
the device is suspended and resumed, the nodes /dev/mapper/test and
/dev/disk/* are created.

If some program opens a block device before it is created by dmsetup or
lvm, the program is buggy, so dm could just report an error as it used to
do before.

Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: fa247089de99 ("dm: requeue IO if mapping table not yet available")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-rq.c |  4 +++-
 drivers/md/dm.c    | 11 ++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index f7e9a3632eb3d..499f8cc8a39fb 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -496,8 +496,10 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 		map = dm_get_live_table(md, &srcu_idx);
 		if (unlikely(!map)) {
+			DMERR_LIMIT("%s: mapping table unavailable, erroring io",
+				    dm_device_name(md));
 			dm_put_live_table(md, srcu_idx);
-			return BLK_STS_RESOURCE;
+			return BLK_STS_IOERR;
 		}
 		ti = dm_table_find_target(map, 0);
 		dm_put_live_table(md, srcu_idx);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8ec0a263744a5..5dd0a42463a2b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1817,10 +1817,15 @@ static void dm_submit_bio(struct bio *bio)
 	struct dm_table *map;
 
 	map = dm_get_live_table(md, &srcu_idx);
+	if (unlikely(!map)) {
+		DMERR_LIMIT("%s: mapping table unavailable, erroring io",
+			    dm_device_name(md));
+		bio_io_error(bio);
+		goto out;
+	}
 
-	/* If suspended, or map not yet available, queue this IO for later */
-	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) ||
-	    unlikely(!map)) {
+	/* If suspended, queue this IO for later */
+	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
 		if (bio->bi_opf & REQ_NOWAIT)
 			bio_wouldblock_error(bio);
 		else if (bio->bi_opf & REQ_RAHEAD)
-- 
2.43.0



