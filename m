Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C4D34167A;
	Tue, 16 Dec 2025 11:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884776; cv=none; b=OAnR5hLP2HU9TWAomWEOzpmhvfKDmDGF2Oqkw0gjhMy7qXo17A3kbUlb7SHsE0MyETFG1mCM3s9+9S14mcmd7U6Yb7fJD4p9xkJLfmFJBxWNXs66ELo2pNuWz2HJ3XDcm2W1NfQrSMf0GBcfz2Mo0RzGGccYr7ObCDQvIwhSKvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884776; c=relaxed/simple;
	bh=y3FIiBMbQmxa1DO7ScvzZ7VhCUFcSfGijobdIcI5YwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoWxgU0m+C/tjxiR5nBDFFrhXwpvDO99J4Esoewf50oJvs2pOYEjXyPCaHbPxE3DxdEIpbbu9JWysBfnRlbPwbBLLc+4ktOI3SJbyQcHDhDrk/9iIrYJLKd+5nzlvtLGr4aBecJ6WiVXyAAUqh0uYuQalcQiw1/oJgHrpeLzZI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rg9x3lpN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rg9x3lpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B114C4CEF1;
	Tue, 16 Dec 2025 11:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884776;
	bh=y3FIiBMbQmxa1DO7ScvzZ7VhCUFcSfGijobdIcI5YwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rg9x3lpN9z0YptaxvAcCEjuDTZEh5rPltBRHP5cHAqdLa02gZCNRnhTK4EnXptbfc
	 aMM8aUzhQ4Zkwg9mJOIZU58Wa7vTo9Wqbn5CdCX3Y6/I8x1Njia6BotHnf0LWonpLa
	 W17XpH4ycHRIZ3ADKbI/9ewwFT+jizLqNQOUUa0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 296/354] f2fs: add carve_out sysfs node
Date: Tue, 16 Dec 2025 12:14:23 +0100
Message-ID: <20251216111331.635684902@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit d7b549def0eb42a950eebd3bd5343f5c8088c305 ]

For several zoned storage devices, vendors will provide extra space
which was used for device level GC than specs and F2FS can use this
space for filesystem level GC. To do that, we can reserve the space
using reserved_blocks. However, it is not enough, since this extra
space should not be shown to users. So, with this new sysfs node,
we can hide the space by substracting reserved_blocks from total
bytes.

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: e462fc48ceb8 ("f2fs: maintain one time GC mode is enabled during whole zoned GC cycle")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-f2fs | 10 ++++++++++
 fs/f2fs/f2fs.h                          |  3 +++
 fs/f2fs/super.c                         |  3 ++-
 fs/f2fs/sysfs.c                         |  2 ++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index 81deae2af84d2..c7ebda8c677e5 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -835,3 +835,13 @@ Contact:	"Jaegeuk Kim" <jaegeuk@kernel.org>
 Description:	It reclaims the given KBs of file-backed pages registered by
 		ioctl(F2FS_IOC_DONATE_RANGE).
 		For example, writing N tries to drop N KBs spaces in LRU.
+
+What:		/sys/fs/f2fs/<disk>/carve_out
+Date:		March 2025
+Contact:	"Daeho Jeong" <daehojeong@google.com>
+Description:	For several zoned storage devices, vendors will provide extra space which
+		was used for device level GC than specs and F2FS can use this space for
+		filesystem level GC. To do that, we can reserve the space using
+		reserved_blocks. However, it is not enough, since this extra space should
+		not be shown to users. So, with this new sysfs node, we can hide the space
+		by substracting reserved_blocks from total bytes.
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index f2f3e02b6fd4c..08bab3de5c50d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1813,6 +1813,9 @@ struct f2fs_sb_info {
 	u64 committed_atomic_block;
 	u64 revoked_atomic_block;
 
+	/* carve out reserved_blocks from total blocks */
+	bool carve_out;
+
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 	struct kmem_cache *page_array_slab;	/* page array entry */
 	unsigned int page_array_slab_size;	/* default page array slab size */
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 3be4e8bcbd138..ee8352246ce47 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1839,7 +1839,8 @@ static int f2fs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_blocks = total_count - start_count;
 
 	spin_lock(&sbi->stat_lock);
-
+	if (sbi->carve_out)
+		buf->f_blocks -= sbi->current_reserved_blocks;
 	user_block_count = sbi->user_block_count;
 	total_valid_node_count = valid_node_count(sbi);
 	avail_node_count = sbi->total_node_count - F2FS_RESERVED_NODE_NUM;
diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 5c4fd0f3acab7..9b4768b1efac5 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -1145,6 +1145,7 @@ F2FS_SBI_GENERAL_RW_ATTR(max_read_extent_count);
 F2FS_SBI_GENERAL_RO_ATTR(unusable_blocks_per_sec);
 F2FS_SBI_GENERAL_RW_ATTR(blkzone_alloc_policy);
 #endif
+F2FS_SBI_GENERAL_RW_ATTR(carve_out);
 
 /* STAT_INFO ATTR */
 #ifdef CONFIG_F2FS_STAT_FS
@@ -1332,6 +1333,7 @@ static struct attribute *f2fs_attrs[] = {
 	ATTR_LIST(warm_data_age_threshold),
 	ATTR_LIST(last_age_weight),
 	ATTR_LIST(max_read_extent_count),
+	ATTR_LIST(carve_out),
 	NULL,
 };
 ATTRIBUTE_GROUPS(f2fs);
-- 
2.51.0



