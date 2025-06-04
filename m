Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A66912B73;
	Wed,  4 Jun 2025 00:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998661; cv=none; b=k9LBI5Cock5CX49mgf4TKiK7GTIIkFiE3o9RdEaTy7kXSV00YrJrUmxCPI5ZXtK8p0uNPhl+u38Y7GkLLnu9OosnV4Z/SL4pJEvYo0waV1mBGH6lD0AZqYPrexSPsWCd7qo6VrNRGLpS4uNhQk2VabQuYsIp8xKe9RSUdV0CnZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998661; c=relaxed/simple;
	bh=mT1Rne6Ygx1Vp1ZmVqMb9hkqHaEkBQfjE281f6VFCFw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a7tw9t0jM0RKoTzH6L+ZqRjU8MCvVCsNI3QEQjs/m5J0xznli5BRhL6VT2Ld8E/NdTfnCR6RWnX4LYyoco+mtLylVvRG4bS1aLewaPXXk1y9wt/ERc5KuKSfsxS3jyySM5BDJ5dgsll7ZJQF+ZXUIoTVops2avIZ9sQoH5hwTGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mEG/k+U5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mEG/k+U5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BEFC4CEED;
	Wed,  4 Jun 2025 00:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998660;
	bh=mT1Rne6Ygx1Vp1ZmVqMb9hkqHaEkBQfjE281f6VFCFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEG/k+U5w+R8+kapNgHO1B1nEuPZdAiJlqYRnLHnLQpd/avlHpz5NSfTKoKdsiypo
	 LZuQRW4GLcrGPJoxwxMYPG/kDkN3o7VgH888Et9q6CpS8aDqJl/+s1+42KcVwlN/ZE
	 LcFO2NSzoAYwfkQ0d/7dh6xPiNWqO0SPPGHgnGKSoNvBPiQGoMO1Sq4Au6kJNtafiX
	 1m18c0eIyAv9J39c/W6DwhmcPG34mutEaik8L7k/aAzh8se/wczinykfD27m5B5qmN
	 BrAkNZtqVzTl5DjW9qgWtjhU/5WeK/ebwYsfIBif9SI+2MUyBnlYDJC+xADE/3Wzia
	 34x5TCWGX+vhQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.14 062/108] f2fs: fix to bail out in get_new_segment()
Date: Tue,  3 Jun 2025 20:54:45 -0400
Message-Id: <20250604005531.4178547-62-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit bb5eb8a5b222fa5092f60d5555867a05ebc3bdf2 ]

------------[ cut here ]------------
WARNING: CPU: 3 PID: 579 at fs/f2fs/segment.c:2832 new_curseg+0x5e8/0x6dc
pc : new_curseg+0x5e8/0x6dc
Call trace:
 new_curseg+0x5e8/0x6dc
 f2fs_allocate_data_block+0xa54/0xe28
 do_write_page+0x6c/0x194
 f2fs_do_write_node_page+0x38/0x78
 __write_node_page+0x248/0x6d4
 f2fs_sync_node_pages+0x524/0x72c
 f2fs_write_checkpoint+0x4bc/0x9b0
 __checkpoint_and_complete_reqs+0x80/0x244
 issue_checkpoint_thread+0x8c/0xec
 kthread+0x114/0x1bc
 ret_from_fork+0x10/0x20

get_new_segment() detects inconsistent status in between free_segmap
and free_secmap, let's record such error into super block, and bail
out get_new_segment() instead of continue using the segment.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees for the
following reasons: **1. Fixes Important Bug Affecting Users:** The
commit addresses a kernel WARNING that can be triggered during normal
filesystem operations. The call trace shows this occurs during
checkpoint operations (`f2fs_write_checkpoint` → `f2fs_sync_node_pages`
→ `f2fs_do_write_node_page`), which are critical for data consistency.
**2. Small and Contained Fix:** The changes are minimal and surgical: -
In `fs/f2fs/segment.c`: Only 6 lines changed, replacing a
`f2fs_bug_on()` call with proper error handling - In
`include/linux/f2fs_fs.h`: Adding one new enum value for the stop
checkpoint reason **3. Minimal Risk of Regression:** The change only
affects the error path when corruption is detected. Instead of
triggering a kernel bug, it now: - Returns `-EFSCORRUPTED` error code -
Stops checkpoint with specific reason
(`STOP_CP_REASON_CORRUPTED_FREE_BITMAP`) - Maintains filesystem
integrity by preventing use of corrupted segments **4. Follows
Established Pattern:** Similar commits (#2, #4, #5) that replace f2fs
panics with graceful error handling have all been marked for backporting
(Status: YES). This commit follows the exact same pattern of improving
f2fs robustness. **5. Critical Subsystem Impact:** The fix touches f2fs
segment management, which is fundamental to the filesystem's allocation
strategy. Corruption in segment bitmaps could lead to data loss or
filesystem corruption if not handled properly. **6. Clear Error Handling
Improvement:** Rather than crashing the kernel when inconsistent bitmap
state is detected, the fix allows the filesystem to stop checkpoint
operations gracefully and record the corruption reason, which aids in
debugging and recovery. The commit meets all stable tree criteria: it's
an important bugfix, has minimal risk, doesn't introduce new features,
and follows established patterns for similar fixes that have been
successfully backported.

 fs/f2fs/segment.c       | 6 +++++-
 include/linux/f2fs_fs.h | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 384bca002ec9a..3ed55889ad7f7 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2836,7 +2836,11 @@ static int get_new_segment(struct f2fs_sb_info *sbi,
 	}
 got_it:
 	/* set it as dirty segment in free segmap */
-	f2fs_bug_on(sbi, test_bit(segno, free_i->free_segmap));
+	if (test_bit(segno, free_i->free_segmap)) {
+		ret = -EFSCORRUPTED;
+		f2fs_stop_checkpoint(sbi, false, STOP_CP_REASON_CORRUPTED_FREE_BITMAP);
+		goto out_unlock;
+	}
 
 	/* no free section in conventional zone */
 	if (new_sec && pinning &&
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index c24f8bc01045d..5206d63b33860 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -78,6 +78,7 @@ enum stop_cp_reason {
 	STOP_CP_REASON_UPDATE_INODE,
 	STOP_CP_REASON_FLUSH_FAIL,
 	STOP_CP_REASON_NO_SEGMENT,
+	STOP_CP_REASON_CORRUPTED_FREE_BITMAP,
 	STOP_CP_REASON_MAX,
 };
 
-- 
2.39.5

