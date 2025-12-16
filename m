Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F46341AC6;
	Tue, 16 Dec 2025 11:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884773; cv=none; b=SUhcyUEv9n7CXZtcPFygXRPykyvD8Gta0oVx/UgtRb0vgok/Zq1hO/Vbyspupee7TIZrQvoDt55ycYvv8/d9tB86v3XWbkHMWBN/CJFnlpppLre+VX1tIU16+chlnoktc0DNyRZ4b4oUzVFB1lDLtlHaXj8B4EAkzg/IalBwlyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884773; c=relaxed/simple;
	bh=tUGw37o7ngZqs3wv/nOtjtpHwJzSREGzuRgA+PxqXu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+g20CJXL7xB6hf6eivbtL58iVV5qaBj4cVAl7I60l10ly4JyxhrzGTO5sEo01g+nN/EAN1V8NQzY/5A2vORTtDRJ/NyGkwizHMpx2Qgu3oBoJCQpGs3Px2eSg7BGZsT3faN4sVAoSXsyzT4hdEHBHdCfli0ygYbMWCUAto5OYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0aHbHRV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0aHbHRV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9657C4CEF1;
	Tue, 16 Dec 2025 11:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884773;
	bh=tUGw37o7ngZqs3wv/nOtjtpHwJzSREGzuRgA+PxqXu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0aHbHRV9OmEvKDsarqlxd2FjelB/KWBNX9yfagQJO9VYxywQkKfGrLJ2cnkVUxTBc
	 iFU3UD/YMaRYbV3vnp5WP10VAPp+vwXtaYUGUOa55nyzBRnxdBM+TjVQ8vBRUflPPL
	 j8pjwkeA36EJ0YAhJiyyF6fTMlUXHjnl4PHZzl48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/354] f2fs: fix to avoid running out of free segments
Date: Tue, 16 Dec 2025 12:14:22 +0100
Message-ID: <20251216111331.599750767@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit f7f8932ca6bb22494ef6db671633ad3b4d982271 ]

If checkpoint is disabled, GC can not reclaim any segments, we need
to detect such condition and bail out from fallocate() of a pinfile,
rather than letting allocator running out of free segment, which may
cause f2fs to be shutdown.

reproducer:
mkfs.f2fs -f /dev/vda 16777216
mount -o checkpoint=disable:10% /dev/vda /mnt/f2fs
for ((i=0;i<4096;i++)) do { dd if=/dev/zero of=/mnt/f2fs/$i bs=1M count=1; } done
sync
for ((i=0;i<4096;i+=2)) do { rm /mnt/f2fs/$i; } done
sync
touch /mnt/f2fs/pinfile
f2fs_io pinfile set /mnt/f2fs/pinfile
f2fs_io fallocate 0 0 4201644032 /mnt/f2fs/pinfile

cat /sys/kernel/debug/f2fs/status
output:
  - Free: 0 (0)

Fixes: f5a53edcf01e ("f2fs: support aligned pinned file")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: e462fc48ceb8 ("f2fs: maintain one time GC mode is enabled during whole zoned GC cycle")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index b8d24c1c48bd4..be32f672497d6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1838,6 +1838,18 @@ static int f2fs_expand_inode_data(struct inode *inode, loff_t offset,
 next_alloc:
 		f2fs_down_write(&sbi->pin_sem);
 
+		if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED))) {
+			if (has_not_enough_free_secs(sbi, 0, 0)) {
+				f2fs_up_write(&sbi->pin_sem);
+				err = -ENOSPC;
+				f2fs_warn_ratelimited(sbi,
+					"ino:%lu, start:%lu, end:%lu, need to trigger GC to "
+					"reclaim enough free segment when checkpoint is enabled",
+					inode->i_ino, pg_start, pg_end);
+				goto out_err;
+			}
+		}
+
 		if (has_not_enough_free_secs(sbi, 0, f2fs_sb_has_blkzoned(sbi) ?
 			ZONED_PIN_SEC_REQUIRED_COUNT :
 			GET_SEC_FROM_SEG(sbi, overprovision_segments(sbi)))) {
-- 
2.51.0



