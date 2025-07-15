Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5250D2E49BF;
	Tue, 15 Jul 2025 13:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586118; cv=none; b=Kh670J87lwMvOfqxvLRgV/uEvMNvdwj3pyemCjFAahKFq2bTPgHfi+xBHe1t12efQCjjQg0UzfHhGo846wiSinhsvA4b8NDyeVPJkvIqKIojgopBiE+IHdqyBOErwCSRB5aTeb7j5mx595wQXFLfx6LDAHYhxluNJePFVRhlL3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586118; c=relaxed/simple;
	bh=ZlpCF0i1nrTRHP/q5MFRtHkaWJ50lV+NSB+wSglEuCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdZkIyFhJD1FA63foAAjftvi+mA2hMxBRSKU2zQmcqDdbTKOoTNiqdZxQANdKR0XvsznAGvx6H1B4IOR5WvHfZYDZ1rulhSdbdipN4qay84Vr6GPhVNcCtyKjojnmQlIfk51DeqCZhYUVZq60L23IEXer4xtwkx+ibR/Pipb+no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bj/WK/nv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bj/WK/nv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0C0C4CEF1;
	Tue, 15 Jul 2025 13:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586118;
	bh=ZlpCF0i1nrTRHP/q5MFRtHkaWJ50lV+NSB+wSglEuCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bj/WK/nvCtp7/iLqBP0o0w6q7QgcCo0Gx3ta5O4COXrnFCMnufjdmDa4oZrFLc76W
	 Ti0GYKO5TtdBg2V5WFewqF+je4mivbyGi/zD2OHnpnvitola1iOyNyixN/2dgX/a5B
	 LteQPtFPM7rGscY9FQ+3X1WnJKy/TAD9A1ogmOew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maksim Kiselev <bigunclemax@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Larry Bassel <larry.bassel@oracle.com>
Subject: [PATCH 5.15 22/77] aoe: avoid potential deadlock at set_capacity
Date: Tue, 15 Jul 2025 15:13:21 +0200
Message-ID: <20250715130752.590330527@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maksim Kiselev <bigunclemax@gmail.com>

commit e169bd4fb2b36c4b2bee63c35c740c85daeb2e86 upstream.

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
[ Larry: backport to 5.15.y. Minor conflict resolved due to missing commit d9c2bd252a457
  aoe: add error handling support for add_disk() ]
Signed-off-by: Larry Bassel <larry.bassel@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/aoe/aoeblk.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -346,6 +346,7 @@ aoeblk_gdalloc(void *vp)
 	struct gendisk *gd;
 	mempool_t *mp;
 	struct blk_mq_tag_set *set;
+	sector_t ssize;
 	ulong flags;
 	int late = 0;
 	int err;
@@ -408,7 +409,7 @@ aoeblk_gdalloc(void *vp)
 	gd->minors = AOE_PARTITIONS;
 	gd->fops = &aoe_bdops;
 	gd->private_data = d;
-	set_capacity(gd, d->ssize);
+	ssize = d->ssize;
 	snprintf(gd->disk_name, sizeof gd->disk_name, "etherd/e%ld.%d",
 		d->aoemajor, d->aoeminor);
 
@@ -417,6 +418,8 @@ aoeblk_gdalloc(void *vp)
 
 	spin_unlock_irqrestore(&d->lock, flags);
 
+	set_capacity(gd, ssize);
+
 	device_add_disk(NULL, gd, aoe_attr_groups);
 	aoedisk_add_debugfs(d);
 


