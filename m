Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFA327604E;
	Tue, 12 Aug 2025 19:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025234; cv=none; b=Px7JxLU6S6Gn7V0Gy1I9MvQPqC44z+FRFeOLMInM6arUoCtpf+PGOUByFtqPC5HUZnZUP/pxb6ow25etSj4JBoFdUwyH/788q0K7iDmLW4wk3TciRA+MNluLoAuKnNMqfO6v6nXXX4mjFUzjvrGVZONwXhd/cyyF3vZCYYd8pPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025234; c=relaxed/simple;
	bh=4jusQ+yWuvyLu67N0M1Zv8SClFPTVeHwKQgrDsnIpzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFujbnG/fq1lgdiwaIuWX6OtcdEnBKROBqxVxIRc1k1BQS3eNG0JuNU0/2zn78jQgCwCh5INalbDicihjxPAiGzyi+ITNFxPuFjPpf1k4SYvRX6xWzcHfamvGMbPbneAowiejboErbEye5pZaeWGy3kMXvxHfDV6jEUY8PW2Meo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMXsGcqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMXsGcqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06DEC4CEF0;
	Tue, 12 Aug 2025 19:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025234;
	bh=4jusQ+yWuvyLu67N0M1Zv8SClFPTVeHwKQgrDsnIpzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMXsGcqw1e2jJdeblp7FDMr3i0nlkR1GdclvqGtsYuGHoSClZ1p0PAG4y5afgrO0K
	 MvdQX1bKXcfn49CFy72y9p3uuHXGUYMz6Fg4SuHw9QvyC75lZNOiJlqJwBfv8b7GcZ
	 zA/IF059xQcyNziL4AQeiEbJH/8RT3pSKwnS4YXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.16 609/627] zloop: fix KASAN use-after-free of tag set
Date: Tue, 12 Aug 2025 19:35:04 +0200
Message-ID: <20250812173455.037556612@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit 765761851d89c772f482494d452e266795460278 upstream.

When a zoned loop device, or zloop device, is removed, KASAN enabled
kernel reports "BUG KASAN use-after-free" in blk_mq_free_tag_set(). The
BUG happens because zloop_ctl_remove() calls put_disk(), which invokes
zloop_free_disk(). The zloop_free_disk() frees the memory allocated for
the zlo pointer. However, after the memory is freed, zloop_ctl_remove()
calls blk_mq_free_tag_set(&zlo->tag_set), which accesses the freed zlo.
Hence the KASAN use-after-free.

 zloop_ctl_remove()
  put_disk(zlo->disk)
   put_device()
    kobject_put()
     ...
      zloop_free_disk()
        kvfree(zlo)
  blk_mq_free_tag_set(&zlo->tag_set)

To avoid the BUG, move the call to blk_mq_free_tag_set(&zlo->tag_set)
from zloop_ctl_remove() into zloop_free_disk(). This ensures that
the tag_set is freed before the call to kvfree(zlo).

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
CC: stable@vger.kernel.org
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250731110745.165751-1-shinichiro.kawasaki@wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zloop.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 553b1a713ab9..a423228e201b 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -700,6 +700,8 @@ static void zloop_free_disk(struct gendisk *disk)
 	struct zloop_device *zlo = disk->private_data;
 	unsigned int i;
 
+	blk_mq_free_tag_set(&zlo->tag_set);
+
 	for (i = 0; i < zlo->nr_zones; i++) {
 		struct zloop_zone *zone = &zlo->zones[i];
 
@@ -1080,7 +1082,6 @@ static int zloop_ctl_remove(struct zloop_options *opts)
 
 	del_gendisk(zlo->disk);
 	put_disk(zlo->disk);
-	blk_mq_free_tag_set(&zlo->tag_set);
 
 	pr_info("Removed device %d\n", opts->id);
 
-- 
2.50.1



