Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1909428EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4A5C433EF;
	Mon, 30 Jan 2023 14:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087391;
	bh=93GWhiji0lyZxjJI6UGQKdFH6KAyLaOvKtCojPxaUi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmmqWrpE0etEr6nVXtSdp1BITtQKkkec0NJHePgrg27p7/NMmvqfWvUd20EPH2WDr
	 BjVcnRXljjuRzqRgLN8SGRzkg7owpi8TlJ9+MENGmWXcuM8kFxzKI9/KuhyAZx+xo8
	 bj6rXVJUAMUqsNV88sBKzYUv2BpacHBOrhB7Os1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/313] btrfs: zoned: enable metadata over-commit for non-ZNS setup
Date: Mon, 30 Jan 2023 14:50:27 +0100
Message-Id: <20230130134345.633143606@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 85e79ec7b78f863178ca488fd8cb5b3de6347756 ]

The commit 79417d040f4f ("btrfs: zoned: disable metadata overcommit for
zoned") disabled the metadata over-commit to track active zones properly.

However, it also introduced a heavy overhead by allocating new metadata
block groups and/or flushing dirty buffers to release the space
reservations. Specifically, a workload (write only without any sync
operations) worsen its performance from 343.77 MB/sec (v5.19) to 182.89
MB/sec (v6.0).

The performance is still bad on current misc-next which is 187.95 MB/sec.
And, with this patch applied, it improves back to 326.70 MB/sec (+73.82%).

This patch introduces a new fs_info->flag BTRFS_FS_NO_OVERCOMMIT to
indicate it needs to disable the metadata over-commit. The flag is enabled
when a device with max active zones limit is loaded into a file-system.

Fixes: 79417d040f4f ("btrfs: zoned: disable metadata overcommit for zoned")
CC: stable@vger.kernel.org # 6.0+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h      | 6 ++++++
 fs/btrfs/space-info.c | 3 ++-
 fs/btrfs/zoned.c      | 2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9e6d48ff4597..a3febabacec0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -590,6 +590,12 @@ enum {
 	/* Indicate we have to finish a zone to do next allocation. */
 	BTRFS_FS_NEED_ZONE_FINISH,
 
+	/*
+	 * Indicate metadata over-commit is disabled. This is set when active
+	 * zone tracking is needed.
+	 */
+	BTRFS_FS_NO_OVERCOMMIT,
+
 #if BITS_PER_LONG == 32
 	/* Indicate if we have error/warn message printed on 32bit systems */
 	BTRFS_FS_32BIT_ERROR,
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index f171bf875633..65c010159fb5 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -404,7 +404,8 @@ int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
 		return 0;
 
 	used = btrfs_space_info_used(space_info, true);
-	if (btrfs_is_zoned(fs_info) && (space_info->flags & BTRFS_BLOCK_GROUP_METADATA))
+	if (test_bit(BTRFS_FS_NO_OVERCOMMIT, &fs_info->flags) &&
+	    (space_info->flags & BTRFS_BLOCK_GROUP_METADATA))
 		avail = 0;
 	else
 		avail = calc_available_free_space(fs_info, space_info, flush);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index c9e2b0c85309..056f002263db 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -538,6 +538,8 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
 		}
 		atomic_set(&zone_info->active_zones_left,
 			   max_active_zones - nactive);
+		/* Overcommit does not work well with active zone tacking. */
+		set_bit(BTRFS_FS_NO_OVERCOMMIT, &fs_info->flags);
 	}
 
 	/* Validate superblock log */
-- 
2.39.0



