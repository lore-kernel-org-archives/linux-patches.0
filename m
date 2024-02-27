Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC90113B2B9;
	Tue, 27 Feb 2024 13:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040636; cv=none; b=tpJDCuBo0eZTkusGTrq3EpHrnFxFCD81JTyfsFtMO7SsMGOri6Ze4glx64eBcqIpIqx9Xxz8mzSl0f/NLiC5LI4UgD7rJGUhfjC+ltDt/1TXG+uNpaUdEnt0GyHY2cs4xJTmeOJTW5MGn0xkPk+NHf/l8XpgGX3QT7ASnGQdils=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040636; c=relaxed/simple;
	bh=Kn55WTZ2Xpzpk3JXTIxnXHaXlR9eukk0uJHbFI1Lc5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTESwYzayjyzq8z93z7764MSfY7yhZX3wNyIxa0CUB2WmiLhn4c0GvgKCMHEEmZxEa/MGtSdkITMmTTIT6PVh1jDHfgbkvVAM3F6Dk5aa5OMRqbj4/SaFn6h/lTO0jwPokEJyDV4duVwA1FtXEkwUMnVR1r7nYfLK9JD19Byg+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBMWB2aN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBMWB2aN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADF8C433C7;
	Tue, 27 Feb 2024 13:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040636;
	bh=Kn55WTZ2Xpzpk3JXTIxnXHaXlR9eukk0uJHbFI1Lc5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBMWB2aNDx/G6EtW9wnICmdRgnyxTFlo/d74VCl/m5LK/ia59mCyUwNodVBV6V+Ro
	 ihJoM7xDczki6ob5T34k8GWMgqa+djK2TpZz15z1zuUmHdi50HJ0dUgGksML74Teu9
	 0OD8ZPm6bWzYXQaa9935xJZtCRAoLdSQ94qkwUKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maksim Kiselev <bigunclemax@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 027/334] aoe: avoid potential deadlock at set_capacity
Date: Tue, 27 Feb 2024 14:18:05 +0100
Message-ID: <20240227131631.475412674@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

From: Maksim Kiselev <bigunclemax@gmail.com>

[ Upstream commit e169bd4fb2b36c4b2bee63c35c740c85daeb2e86 ]

Move set_capacity() outside of the section procected by (&d->lock).
To avoid possible interrupt unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
[1] lock(&bdev->bd_size_lock);
                                local_irq_disable();
                            [2] lock(&d->lock);
                            [3] lock(&bdev->bd_size_lock);
   <Interrupt>
[4]  lock(&d->lock);

  *** DEADLOCK ***

Where [1](&bdev->bd_size_lock) hold by zram_add()->set_capacity().
[2]lock(&d->lock) hold by aoeblk_gdalloc(). And aoeblk_gdalloc()
is trying to acquire [3](&bdev->bd_size_lock) at set_capacity() call.
In this situation an attempt to acquire [4]lock(&d->lock) from
aoecmd_cfg_rsp() will lead to deadlock.

So the simplest solution is breaking lock dependency
[2](&d->lock) -> [3](&bdev->bd_size_lock) by moving set_capacity()
outside.

Signed-off-by: Maksim Kiselev <bigunclemax@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20240124072436.3745720-2-bigunclemax@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/aoe/aoeblk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index cf6883756155a..37eff1c974515 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -333,6 +333,7 @@ aoeblk_gdalloc(void *vp)
 	struct gendisk *gd;
 	mempool_t *mp;
 	struct blk_mq_tag_set *set;
+	sector_t ssize;
 	ulong flags;
 	int late = 0;
 	int err;
@@ -395,7 +396,7 @@ aoeblk_gdalloc(void *vp)
 	gd->minors = AOE_PARTITIONS;
 	gd->fops = &aoe_bdops;
 	gd->private_data = d;
-	set_capacity(gd, d->ssize);
+	ssize = d->ssize;
 	snprintf(gd->disk_name, sizeof gd->disk_name, "etherd/e%ld.%d",
 		d->aoemajor, d->aoeminor);
 
@@ -404,6 +405,8 @@ aoeblk_gdalloc(void *vp)
 
 	spin_unlock_irqrestore(&d->lock, flags);
 
+	set_capacity(gd, ssize);
+
 	err = device_add_disk(NULL, gd, aoe_attr_groups);
 	if (err)
 		goto out_disk_cleanup;
-- 
2.43.0



