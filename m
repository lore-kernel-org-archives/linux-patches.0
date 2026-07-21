Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E8A46D2A4;
	Tue, 21 Jul 2026 17:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654798; cv=none; b=Q+2QVMjS59xpW8qW7t2TzNoMiGmQWBD9/IEWAcEdwf375rRWHUyXX8jYk2wYo70ybF1NSisrlIg94IITPgK4kxWjdi3b8heD7KEggsxRAcBH64Y/MRuyFbBNlGiJmJEhDE7BGabAyAN4xaWqUYJGSUiJfPSjpsPIhHofkU+I9VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654798; c=relaxed/simple;
	bh=B1iQkkoGGEk7x6bzuc7taeKDZ/ZWpDlWsgD5vvFPRag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSUmIUhHhbpq8AewdVP177uPhuxdEu63aRyjxU3TVMvTyQJTLsYtVl9N+FYmMZE/suESez7MQ41FA4oelW65gKQKe0Bn4n/B4VZF4EWD2OQo3cbHOnVOuM+YriPGiqhqTMOug+y+cS21orkf3Ryv3Lcqb00zzUyFNLNyffCJRQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CqwIUm3C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqwIUm3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FA81F000E9;
	Tue, 21 Jul 2026 17:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654796;
	bh=QQ3cis936DkC98K67yljHJzVZV1AGk4wj+bOjzL4JBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqwIUm3Cs7mdSfFo4RpSjeo8mF9se7nyl4Ig8BSZb/kpba7eKbsPvsDnY+GHbr7om
	 vw0JmlXuYuFXTcHJZ5DnlYAONY6Xu78CaxOt/SKDOrrj21lB40OXk0EltRfBGtgsCQ
	 QtaxJ+7vk+TFfJczQ1vNBfnbUvTPqLQ7+28XuOa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Williamson <connordw@amazon.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 1839/2077] block: remove redundant GD_NEED_PART_SCAN in add_disk_final()
Date: Tue, 21 Jul 2026 17:25:12 +0200
Message-ID: <20260721152636.113115330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Connor Williamson <connordw@amazon.com>

commit 181bb9c9eae4f69fe510a62a42c2932d0314a800 upstream.

add_disk_final() sets GD_NEED_PART_SCAN before calling bdev_add(),
then calls disk_scan_partitions() which sets the flag itself. The
early set is redundant and introduces a race.

Between bdev_add() and disk_scan_partitions(), concurrent openers
(multipathd, blkid, LVM) see the flag in blkdev_get_whole() and
trigger bdev_disk_changed(). When disk_scan_partitions() then runs,
it calls bdev_disk_changed() again, dropping the partitions the
concurrent opener already created before re-adding them, which can
result in transient partition disappearances.

The race is observable by inserting an msleep() between bdev_add()
and disk_scan_partitions() while running concurrent open() calls
during device bind. Without artificial delay, it manifests under
scheduling pressure during boot on systems with aggressive device
scanners (multipathd, systemd-udevd).

Therefore, do not set GD_NEED_PART_SCAN in add_disk_final(). Other
GD_NEED_PART_SCAN consumers (blkdev_get_whole(),
sd_need_revalidate()) should not be affected as the flag
is set internally by disk_scan_partitions().

The retry-on-next-open intention from commit e5cfefa97bcc
("block: fix scan partition for exclusively open device again")
should also not be affected as the early return paths in
disk_scan_partitions() should be unreachable at device registration
time (bd_holder is NULL and open_partitions is zero).

Fixes: e5cfefa97bcc ("block: fix scan partition for exclusively open device again")
Cc: stable@vger.kernel.org
Signed-off-by: Connor Williamson <connordw@amazon.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260615130715.53693-1-connordw@amazon.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/genhd.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -407,10 +407,6 @@ static void add_disk_final(struct gendis
 	struct device *ddev = disk_to_dev(disk);
 
 	if (!(disk->flags & GENHD_FL_HIDDEN)) {
-		/* Make sure the first partition scan will be proceed */
-		if (get_capacity(disk) && disk_has_partscan(disk))
-			set_bit(GD_NEED_PART_SCAN, &disk->state);
-
 		bdev_add(disk->part0, ddev->devt);
 		if (get_capacity(disk))
 			disk_scan_partitions(disk, BLK_OPEN_READ);


