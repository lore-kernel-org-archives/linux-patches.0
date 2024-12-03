Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330F71F76AC;
	Tue,  3 Dec 2024 15:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241572; cv=none; b=r/KpoTBRG7xKWsmklZDHx4rZYkOnrdzPtHKbVLxatwOgctguEJm2zL4cyhNahLMb0MA6FGEPeL060KtC2/UCnCLrt2Z67b8Q+EEehEsOAgnfkgh5WE/r9E+GbdPHzNsb1WEY8juPktkYX8BfpUtjReQziUTgnx9HqqE8Z7dg2gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241572; c=relaxed/simple;
	bh=E/KODC6UUTbsEb7XlyyMp9ItEy6++eekQ58uWYWcDCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gig5u2S9AqEXAUP3g7KxEXszyzqUqNwfZxqyly04A8lf3M/nmH24Kvh2ZAvAdjZJIEdXaiUcWnHlI2ytHfVYypBsdmlz1eR/eCdZxP+OXEGT3Zc1nh614blQUQ4onKNONwoXwmEN5p7p/S1TjNPXax7gkhiPW/G4xw99/MYuSAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UicNByDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UicNByDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95428C4CECF;
	Tue,  3 Dec 2024 15:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241572;
	bh=E/KODC6UUTbsEb7XlyyMp9ItEy6++eekQ58uWYWcDCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UicNByDixBrHE478dSTNuNW7dNZA1oLDGWkooYzovUQ9nN9/QDHML8qextHpVmLFI
	 w1rh8YEof/GgLJUd0eOe9YUaPao+J7WtADTZ++sQ4rvljaT8iUflwd9R8eCEQiR8vL
	 WmFVOXXTK/YCOAmN3xXvy6OsDlqsFfEJkf6eFCK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 456/826] zram: permit only one post-processing operation at a time
Date: Tue,  3 Dec 2024 15:43:03 +0100
Message-ID: <20241203144801.545319356@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 58652f2b6d21f2874c9f060165ec7e03e8b1fc71 ]

Both recompress and writeback soon will unlock slots during processing,
which makes things too complex wrt possible race-conditions.  We still
want to clear PP_SLOT in slot_free, because this is how we figure out that
slot that was selected for post-processing has been released under us and
when we start post-processing we check if slot still has PP_SLOT set.  At
the same time, theoretically, we can have something like this:

CPU0			    CPU1

recompress
scan slots
set PP_SLOT
unlock slot
			slot_free
			clear PP_SLOT

			allocate PP_SLOT
			writeback
			scan slots
			set PP_SLOT
			unlock slot
select PP-slot
test PP_SLOT

So recompress will not detect that slot has been re-used and re-selected
for concurrent writeback post-processing.

Make sure that we only permit on post-processing operation at a time.  So
now recompress and writeback post-processing don't race against each
other, we only need to handle slot re-use (slot_free and write), which is
handled individually by each pp operation.

Having recompress and writeback competing for the same slots is not
exactly good anyway (can't imagine anyone doing that).

Link: https://lkml.kernel.org/r/20240917021020.883356-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: f364cdeb3893 ("zram: fix NULL pointer in comp_algorithm_show()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/blockdev/zram.rst |  2 ++
 drivers/block/zram/zram_drv.c               | 16 ++++++++++++++++
 drivers/block/zram/zram_drv.h               |  1 +
 3 files changed, 19 insertions(+)

diff --git a/Documentation/admin-guide/blockdev/zram.rst b/Documentation/admin-guide/blockdev/zram.rst
index 678d70d6e1c3a..714a5171bfc0b 100644
--- a/Documentation/admin-guide/blockdev/zram.rst
+++ b/Documentation/admin-guide/blockdev/zram.rst
@@ -47,6 +47,8 @@ The list of possible return codes:
 -ENOMEM	  zram was not able to allocate enough memory to fulfil your
 	  needs.
 -EINVAL	  invalid input has been provided.
+-EAGAIN	  re-try operation later (e.g. when attempting to run recompress
+	  and writeback simultaneously).
 ========  =============================================================
 
 If you use 'echo', the returned value is set by the 'echo' utility,
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ad9c9bc3ccfc5..b742dc246b0c1 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -626,6 +626,12 @@ static ssize_t writeback_store(struct device *dev,
 		goto release_init_lock;
 	}
 
+	/* Do not permit concurrent post-processing actions. */
+	if (atomic_xchg(&zram->pp_in_progress, 1)) {
+		up_read(&zram->init_lock);
+		return -EAGAIN;
+	}
+
 	if (!zram->backing_dev) {
 		ret = -ENODEV;
 		goto release_init_lock;
@@ -752,6 +758,7 @@ static ssize_t writeback_store(struct device *dev,
 		free_block_bdev(zram, blk_idx);
 	__free_page(page);
 release_init_lock:
+	atomic_set(&zram->pp_in_progress, 0);
 	up_read(&zram->init_lock);
 
 	return ret;
@@ -1881,6 +1888,12 @@ static ssize_t recompress_store(struct device *dev,
 		goto release_init_lock;
 	}
 
+	/* Do not permit concurrent post-processing actions. */
+	if (atomic_xchg(&zram->pp_in_progress, 1)) {
+		up_read(&zram->init_lock);
+		return -EAGAIN;
+	}
+
 	if (algo) {
 		bool found = false;
 
@@ -1948,6 +1961,7 @@ static ssize_t recompress_store(struct device *dev,
 	__free_page(page);
 
 release_init_lock:
+	atomic_set(&zram->pp_in_progress, 0);
 	up_read(&zram->init_lock);
 	return ret;
 }
@@ -2144,6 +2158,7 @@ static void zram_reset_device(struct zram *zram)
 	zram->disksize = 0;
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
+	atomic_set(&zram->pp_in_progress, 0);
 	reset_bdev(zram);
 
 	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
@@ -2381,6 +2396,7 @@ static int zram_add(void)
 	zram->disk->fops = &zram_devops;
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
+	atomic_set(&zram->pp_in_progress, 0);
 
 	/* Actual capacity set using sysfs (/sys/block/zram<id>/disksize */
 	set_capacity(zram->disk, 0);
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index cfc8c059db636..8acf9d2ee42b8 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -139,5 +139,6 @@ struct zram {
 #ifdef CONFIG_ZRAM_MEMORY_TRACKING
 	struct dentry *debugfs_dir;
 #endif
+	atomic_t pp_in_progress;
 };
 #endif
-- 
2.43.0



