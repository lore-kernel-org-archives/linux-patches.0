Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E9479DDB;
	Mon, 15 Apr 2024 14:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191664; cv=none; b=nlj5ZcUqD0r3PXXhRzOOKFicqhc/6oZayTQAAa3r9fBLfP+QHAH6ZEp9Ied+kN9xFIuODbyO55124j/TW8zCPXt3FDWA+JGdBN60lJiAdDQU+rfeqOuzvkMfDgVkzVIqISKRR375OeNijZtzjJ6BpcuytJ0ZDiLvwJS1AN+0grY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191664; c=relaxed/simple;
	bh=7eJDZDXFVzVyq2gPO3cGBdkm0B+9nwelg6LUaDNRYck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REA4aousmEgKIoC9dgudL92+e8fMi58J2Jbct8o9JmpUfI2wltJkKqZm/xUly2Q5H28czei6O6vYlKxstYcCxa5FL5tGZmyY4ZFjg4ACtCdl5nuZVkQoW478i8034cWp3pSHN2yjSHmn/chVTiGZrZkEjtpq0wOCLFNXj9sulDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdXCa8DY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdXCa8DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35A3C113CC;
	Mon, 15 Apr 2024 14:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191664;
	bh=7eJDZDXFVzVyq2gPO3cGBdkm0B+9nwelg6LUaDNRYck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdXCa8DYEmdnnQlLh3WtSZ2TLRbBJl2gidt62S9sS4aidgxeH0ithZPX69Sbws3KP
	 3ooy/N5FD6Cwci2Quxsr0SLOJqQvpuLJosRbbYIoLrJd4bLQ7X1FMb5Ep7Wh5pKx6m
	 Zq5f0w3yH/QdwZeQlWSdoAw9a7xY1h3acPUigs4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coly Li <colyli@suse.de>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.6 007/122] raid1: fix use-after-free for original bio in raid1_write_request()
Date: Mon, 15 Apr 2024 16:19:32 +0200
Message-ID: <20240415141953.596019201@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

commit fcf3f7e2fc8a53a6140beee46ec782a4c88e4744 upstream.

r1_bio->bios[] is used to record new bios that will be issued to
underlying disks, however, in raid1_write_request(), r1_bio->bios[]
will set to the original bio temporarily. Meanwhile, if blocked rdev
is set, free_r1bio() will be called causing that all r1_bio->bios[]
to be freed:

raid1_write_request()
 r1_bio = alloc_r1bio(mddev, bio); -> r1_bio->bios[] is NULL
 for (i = 0;  i < disks; i++) -> for each rdev in conf
  // first rdev is normal
  r1_bio->bios[0] = bio; -> set to original bio
  // second rdev is blocked
  if (test_bit(Blocked, &rdev->flags))
   break

 if (blocked_rdev)
  free_r1bio()
   put_all_bios()
    bio_put(r1_bio->bios[0]) -> original bio is freed

Test scripts:

mdadm -CR /dev/md0 -l1 -n4 /dev/sd[abcd] --assume-clean
fio -filename=/dev/md0 -ioengine=libaio -rw=write -bs=4k -numjobs=1 \
    -iodepth=128 -name=test -direct=1
echo blocked > /sys/block/md0/md/rd2/state

Test result:

BUG bio-264 (Not tainted): Object already free
-----------------------------------------------------------------------------

Allocated in mempool_alloc_slab+0x24/0x50 age=1 cpu=1 pid=869
 kmem_cache_alloc+0x324/0x480
 mempool_alloc_slab+0x24/0x50
 mempool_alloc+0x6e/0x220
 bio_alloc_bioset+0x1af/0x4d0
 blkdev_direct_IO+0x164/0x8a0
 blkdev_write_iter+0x309/0x440
 aio_write+0x139/0x2f0
 io_submit_one+0x5ca/0xb70
 __do_sys_io_submit+0x86/0x270
 __x64_sys_io_submit+0x22/0x30
 do_syscall_64+0xb1/0x210
 entry_SYSCALL_64_after_hwframe+0x6c/0x74
Freed in mempool_free_slab+0x1f/0x30 age=1 cpu=1 pid=869
 kmem_cache_free+0x28c/0x550
 mempool_free_slab+0x1f/0x30
 mempool_free+0x40/0x100
 bio_free+0x59/0x80
 bio_put+0xf0/0x220
 free_r1bio+0x74/0xb0
 raid1_make_request+0xadf/0x1150
 md_handle_request+0xc7/0x3b0
 md_submit_bio+0x76/0x130
 __submit_bio+0xd8/0x1d0
 submit_bio_noacct_nocheck+0x1eb/0x5c0
 submit_bio_noacct+0x169/0xd40
 submit_bio+0xee/0x1d0
 blkdev_direct_IO+0x322/0x8a0
 blkdev_write_iter+0x309/0x440
 aio_write+0x139/0x2f0

Since that bios for underlying disks are not allocated yet, fix this
problem by using mempool_free() directly to free the r1_bio.

Fixes: 992db13a4aee ("md/raid1: free the r1bio before waiting for blocked rdev")
Cc: stable@vger.kernel.org # v6.6+
Reported-by: Coly Li <colyli@suse.de>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Tested-by: Coly Li <colyli@suse.de>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240308093726.1047420-1-yukuai1@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1473,7 +1473,7 @@ static void raid1_write_request(struct m
 		for (j = 0; j < i; j++)
 			if (r1_bio->bios[j])
 				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
-		free_r1bio(r1_bio);
+		mempool_free(r1_bio, &conf->r1bio_pool);
 		allow_barrier(conf, bio->bi_iter.bi_sector);
 
 		if (bio->bi_opf & REQ_NOWAIT) {


