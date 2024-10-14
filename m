Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB68B611E;
	Mon, 14 Oct 2024 15:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918333; cv=none; b=iy+lUvcObO6qu3j1en2KcJC89DWZhHLFzBVrXnPLVh3LtBWh5zNvKqQgy5HXZdluSJY9xAddVskWlHTg74Q33jTg9ixt2hfZDXMPULcO1h2gELrwquYfjyGUcNOxMy/BpkiJ6Gu/TmPSANbfcMV+TpSr1mOkPO/asLthevIALi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918333; c=relaxed/simple;
	bh=cKfIfIJkzsNVyFteg4LLvCqg9OOZy6UEMYzz8LTUoWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0hSvHgh1eT+oyh+rjROBzzsw/KG1Lt0R+gLieyJPGWszDq2INDBt5vngCeyfq7tRdl0q9JLUD1BA33bYpfokjPGWqXj8w+cMyKsr43Isy1xIdyyUvJlckpqkDeideZIbKi0MhmpnrN77seA42wHzxpEd88OmESr/uB7PDszLwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHVhNXLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHVhNXLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4838AC4CECF;
	Mon, 14 Oct 2024 15:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918332;
	bh=cKfIfIJkzsNVyFteg4LLvCqg9OOZy6UEMYzz8LTUoWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHVhNXLcFQx1fCfEAJnFVOFs0gTIijPid4BatiycobpDTKExTcRHM/6nrKKXzbunG
	 k80t3/Xv1OBzJ6L3VK+zOLGxZrMKNMIXAIcKKsefSvInf5/GDdZS8tBm6OoE4d1LAx
	 NIzMmcvK8fJpV+bezKW9ZlRkAFBK0nVBQbwt1Hgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 260/798] Revert "dm: requeue IO if mapping table not yet available"
Date: Mon, 14 Oct 2024 16:13:34 +0200
Message-ID: <20241014141228.149736048@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 80f46e01bca44..6685dc3b8b448 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -493,8 +493,10 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 
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
index ddd44a7f79dbf..f70129bc703b8 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1789,10 +1789,15 @@ static void dm_submit_bio(struct bio *bio)
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



