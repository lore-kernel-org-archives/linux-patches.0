Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9C637755D;
	Tue, 17 Feb 2026 20:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360898; cv=none; b=U6hTKjLaXbsvAg2Avx8YHjgPA9GaUA37x7TQrlP9ZV1tj6DAq9twrwHFs58rL911G/NO5D39VsyyekbRc3kvo47J8hLpqmUmUopxmdhyfRA3n7qIQely1k7QAK8aMxEBwv/K71T/fyN/TuIG6da1ZBvQSGD7pAqBbz+1VNuaxtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360898; c=relaxed/simple;
	bh=uo5MBWpdrCxZGr655BaD2iylD+a/uwsIa5UBXDILV7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVbX+1DbQFb319AcB9/zY7ZXzo3OwzXi446YPvfVfcuf4nMTXRBh5CiVVN07laDVgGc7XYZFTRLRlK6gTXcRHhmGT/kduvZSu7gVtUCSiBb2kt8dV1TzrvcmaAY9HwQ+f4bZPd5qDAk+eL8x+EPumtr7J8JpLY8oYMnbx5iLkhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDDpblkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDDpblkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA66AC4CEF7;
	Tue, 17 Feb 2026 20:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360898;
	bh=uo5MBWpdrCxZGr655BaD2iylD+a/uwsIa5UBXDILV7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDDpblkrnV9VhAQ6QQUEMDcBO/wpqN88PIL/6r7r6tvl4s4E+EtFAoTcH6j4pN0vw
	 /srBhkoY8tzSLia6sl1uL9oiAi3nC3iCzWYlm+udzmD//njvI9t5ADGSWBIwSAr+3f
	 OmMDlbCHifj6l74bJCwSLZ+8A51vkN+q+9mNjqtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjie Qi <qwjhust@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Daeho Jeong <daehojeong@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 36/39] f2fs: fix zoned block device information initialization
Date: Tue, 17 Feb 2026 21:30:58 +0100
Message-ID: <20260217200005.595875080@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit 0f9b12142be1af8555cfe53c6fbecb8e60a40dac ]

If the max open zones of zoned devices are less than
the active logs of F2FS, the device may error due to
insufficient zone resources when multiple active logs
are being written at the same time.

Signed-off-by: Wenjie Qi <qwjhust@gmail.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 5c145c03188b ("f2fs: fix to avoid mapping wrong physical block for swapfile")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h  |    1 +
 fs/f2fs/super.c |   27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1567,6 +1567,7 @@ struct f2fs_sb_info {
 
 #ifdef CONFIG_BLK_DEV_ZONED
 	unsigned int blocks_per_blkz;		/* F2FS blocks per zone */
+	unsigned int max_open_zones;		/* max open zone resources of the zoned device */
 #endif
 
 	/* for node-related operations */
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2359,6 +2359,17 @@ static int f2fs_remount(struct super_blo
 	if (err)
 		goto restore_opts;
 
+#ifdef CONFIG_BLK_DEV_ZONED
+	if (f2fs_sb_has_blkzoned(sbi) &&
+		sbi->max_open_zones < F2FS_OPTION(sbi).active_logs) {
+		f2fs_err(sbi,
+			"zoned: max open zones %u is too small, need at least %u open zones",
+				 sbi->max_open_zones, F2FS_OPTION(sbi).active_logs);
+		err = -EINVAL;
+		goto restore_opts;
+	}
+#endif
+
 	/* flush outstanding errors before changing fs state */
 	flush_work(&sbi->s_error_work);
 
@@ -3902,11 +3913,24 @@ static int init_blkz_info(struct f2fs_sb
 	sector_t nr_sectors = bdev_nr_sectors(bdev);
 	struct f2fs_report_zones_args rep_zone_arg;
 	u64 zone_sectors;
+	unsigned int max_open_zones;
 	int ret;
 
 	if (!f2fs_sb_has_blkzoned(sbi))
 		return 0;
 
+	if (bdev_is_zoned(FDEV(devi).bdev)) {
+		max_open_zones = bdev_max_open_zones(bdev);
+		if (max_open_zones && (max_open_zones < sbi->max_open_zones))
+			sbi->max_open_zones = max_open_zones;
+		if (sbi->max_open_zones < F2FS_OPTION(sbi).active_logs) {
+			f2fs_err(sbi,
+				"zoned: max open zones %u is too small, need at least %u open zones",
+				sbi->max_open_zones, F2FS_OPTION(sbi).active_logs);
+			return -EINVAL;
+		}
+	}
+
 	zone_sectors = bdev_zone_sectors(bdev);
 	if (sbi->blocks_per_blkz && sbi->blocks_per_blkz !=
 				SECTOR_TO_BLOCK(zone_sectors))
@@ -4188,6 +4212,9 @@ static int f2fs_scan_devices(struct f2fs
 
 	logical_blksize = bdev_logical_block_size(sbi->sb->s_bdev);
 	sbi->aligned_blksize = true;
+#ifdef CONFIG_BLK_DEV_ZONED
+	sbi->max_open_zones = UINT_MAX;
+#endif
 
 	for (i = 0; i < max_devices; i++) {
 		if (i == 0)


