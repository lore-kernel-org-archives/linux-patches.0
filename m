Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6F3289E2C;
	Tue,  8 Jul 2025 16:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993045; cv=none; b=s9eAaN1qELTDX2CANmMKL4PIlfeyAhzEI7+/oNdyhxC5XvvejhC/JJujkD5gWcA+8CpITEmSOeY7RJ3FIFANW7EBFqrMvljS9j4oQ0VtusFhrYMmFh3lM3ATxP/spKLzxQQkFc+2lbvQ5ieL+nLp4uAf4/jO9ETSi7TIbOlpMjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993045; c=relaxed/simple;
	bh=e5f6HMkk3vdKdBxWRi/GAGbF3F6OtojJMUNcGPZqTU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfkttqODI3/lv7V+0603YIVKCVTw2jrF3rWpZxXltKfzBg2JHeTBGOx9jlM+d2DauvDld8TrIDyyF36TS3DfUuAr6aMmHDcD0tsbtZFgq5iKmRsihMUHF40biX3mLNuZPzFS6U7oPBk/YFOsnTsp3GC4PacYuUW7yERoDY5fVco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aelo45Hw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aelo45Hw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA42C4CEED;
	Tue,  8 Jul 2025 16:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993044;
	bh=e5f6HMkk3vdKdBxWRi/GAGbF3F6OtojJMUNcGPZqTU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aelo45HwLwewWMmjKkInBaEZ7GXQcbu9xYDBDCwp6NlmYsfhDWSAg4rmZadxUfE3d
	 fxW3QkQoJxwpT2vgS8ZoE9PgL9dlzksxUxCnoZ8YrX3Olljzilgtb6dhpTzBl5d0yf
	 eZFH2u8Mtu+wXDCktqF+X9cq/iOOgsf5CnREMS7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/232] f2fs: decrease spare area for pinned files for zoned devices
Date: Tue,  8 Jul 2025 18:22:04 +0200
Message-ID: <20250708162244.791951864@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit fa08972bcb7baaf5f1f4fdf251dc08bdd3ab1cf0 ]

Now we reclaim too much space before allocating pinned space for zoned
devices.

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: dc6d9ef57fcf ("f2fs: zone: fix to calculate first_zoned_segno correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c    | 3 ++-
 fs/f2fs/gc.h      | 1 +
 fs/f2fs/segment.c | 3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 02f438cd6bfaf..d9037e74631c0 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1828,7 +1828,8 @@ static int f2fs_expand_inode_data(struct inode *inode, loff_t offset,
 
 		map.m_len = sec_blks;
 next_alloc:
-		if (has_not_enough_free_secs(sbi, 0,
+		if (has_not_enough_free_secs(sbi, 0, f2fs_sb_has_blkzoned(sbi) ?
+			ZONED_PIN_SEC_REQUIRED_COUNT :
 			GET_SEC_FROM_SEG(sbi, overprovision_segments(sbi)))) {
 			f2fs_down_write(&sbi->gc_lock);
 			stat_inc_gc_call_count(sbi, FOREGROUND);
diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
index 2914b678bf8fb..5c1eaf55e1277 100644
--- a/fs/f2fs/gc.h
+++ b/fs/f2fs/gc.h
@@ -35,6 +35,7 @@
 #define LIMIT_BOOST_ZONED_GC	25 /* percentage over total user space of boosted gc for zoned devices */
 #define DEF_MIGRATION_WINDOW_GRANULARITY_ZONED	3
 #define BOOST_GC_MULTIPLE	5
+#define ZONED_PIN_SEC_REQUIRED_COUNT	1
 
 #define DEF_GC_FAILED_PINNED_FILES	2048
 #define MAX_GC_FAILED_PINNED_FILES	USHRT_MAX
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 449c0acbfabc0..3db89becdbfcd 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3250,7 +3250,8 @@ int f2fs_allocate_pinning_section(struct f2fs_sb_info *sbi)
 
 	if (f2fs_sb_has_blkzoned(sbi) && err == -EAGAIN && gc_required) {
 		f2fs_down_write(&sbi->gc_lock);
-		err = f2fs_gc_range(sbi, 0, GET_SEGNO(sbi, FDEV(0).end_blk), true, 1);
+		err = f2fs_gc_range(sbi, 0, GET_SEGNO(sbi, FDEV(0).end_blk),
+				true, ZONED_PIN_SEC_REQUIRED_COUNT);
 		f2fs_up_write(&sbi->gc_lock);
 
 		gc_required = false;
-- 
2.39.5



