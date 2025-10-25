Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D80307ACB;
	Sat, 25 Oct 2025 16:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409486; cv=none; b=GCFj9fqpw3pl4dVQytG4bEVEyc+i0yaYPdDuUahMpJHO8jn3cji7UjOV0zezaCrabrC3n/jqMoEeSTCzRLHrkBFuqB/ClfjWAEkn6z7ypUGmIjLMO16thXxdlOBBiohtvgBSrJGN1YzOXoGVwPNwel1nbUohnXnvDJAcBp13pno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409486; c=relaxed/simple;
	bh=OG1WIUaN3zRAnMzSfe4HeqCKMVnfY9o001jP/RmG4QM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CCbB5oukFpFCz8A8nCQL3s9O0n0d3y8pNUJ8fQ6R62xvlFlKfsjlxxrsr9cwRoSmDpduiAqqg3rRdswkLGRXvqRn3wwW1D7wj8o53qnJSy/CLPdS5jMLi/XhOvtwzzKAdzj9Ta+YElCDb96MbIBArPQsjna8hkslN9j8HMzWpNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uVKETrnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uVKETrnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D19C4CEF5;
	Sat, 25 Oct 2025 16:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409486;
	bh=OG1WIUaN3zRAnMzSfe4HeqCKMVnfY9o001jP/RmG4QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVKETrnrm2t+cb0BtopA9jEn1ozC83/aE3x5+4J8BlnCGnSDXKHXQNyhHg44/Af3i
	 oHK06F3TbSoPXZiVZiN8Hku2OMpAzF28fxsYRAIyxQ94NB+l4gZIPZ32BnwqESA4Ly
	 xvosJyuy+kJotzrmQFYMEgnR1/KYT1pdammi7nmzyybx/LlIZykC8TbnFiNsxdQhV3
	 aSsKgkmgabOQO36Ag6v+g1laphrxYSxvzW6lvkE/aJPuHCLXzDR2mVlvm4dXi2mqnH
	 L4Xy0BUatx3WaV3nxkxvN72760qhmuPM6NPkvTe8AOMG4+SMqWJWkxoUePw6/XDmb7
	 HoGri/vKV8wHA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.17-6.12] f2fs: fix wrong layout information on 16KB page
Date: Sat, 25 Oct 2025 11:59:37 -0400
Message-ID: <20251025160905.3857885-346-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit a33be64b98d0723748d2fab0832b926613e1fce0 ]

This patch fixes to support different block size.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation
- Fix scope: Corrects user-visible layout info in
  `/proc/fs/f2fs/<sb>/disk_map` for non-4KB page/block sizes.
  Previously, sizes were hardcoded to a 2MB-per-segment assumption,
  producing wrong values on 16KB/64KB systems.
- What changed: In `fs/f2fs/sysfs.c:disk_map_seq_show` the output now
  derives sizes from block size instead of assuming 4KB:
  - Adds block size line: fs/f2fs/sysfs.c:1771
    - `seq_printf(..., " Block size    : %12lu KB\n", F2FS_BLKSIZE >>
      10);`
  - Computes segment size in MB generically: fs/f2fs/sysfs.c:1772
    - `seq_printf(..., " Segment size  : %12d MB\n", (BLKS_PER_SEG(sbi)
      << (F2FS_BLKSIZE_BITS - 10)) >> 10);`
  - Computes section size in MB generically: fs/f2fs/sysfs.c:1776
    - `seq_printf(..., " Section size  : %12d MB\n", (BLKS_PER_SEC(sbi)
      << (F2FS_BLKSIZE_BITS - 10)) >> 10);`
  - Relocates the “# of Sections” line beneath section size for clarity:
    fs/f2fs/sysfs.c:1778
- Why it matters: On 16KB systems (`F2FS_BLKSIZE_BITS=14`), a segment is
  512 blocks × 16KB = 8MB. The old code printed section size using
  `SEGS_PER_SEC << 1` (2MB/segment assumption), underreporting by 4×. On
  64KB pages, segments are 32MB, making the error even larger.
- Correctness of the new math: The expression `(blocks <<
  (F2FS_BLKSIZE_BITS - 10)) >> 10` equals `blocks * (block_size_bytes /
  1MB)` and yields the right MB count for any `PAGE_SHIFT` (e.g.,
  12→4KB, 14→16KB, 16→64KB). Definitions: `F2FS_BLKSIZE = PAGE_SIZE`,
  `F2FS_BLKSIZE_BITS = PAGE_SHIFT` (include/linux/f2fs_fs.h:18–19).
  Block-to-segment/section counts are via `BLKS_PER_SEG(sbi)` and
  `BLKS_PER_SEC(sbi)` (fs/f2fs/f2fs.h:1946–1947).
- User impact: Fixes inaccurate diagnostics that admins and tooling may
  rely on when inspecting F2FS layout. No on-disk format or runtime
  behavior change; purely display.
- Containment and risk: Single function, print-only changes in a procfs
  seq_file. No locking, no state changes, no dependency impact.
  Extremely low regression risk. The proc output format gains two lines
  (“Block size”, “Segment size”) and reorders “# of Sections”; procfs
  output is not a stable ABI, and this is a correctness fix.
- Stable criteria:
  - Fixes a real bug that affects users on non-4KB page systems.
  - Small, localized change; no architectural modifications.
  - Minimal risk of regression; no functional side effects.
  - Touches a filesystem but only its proc reporting path.
  - No “Cc: stable” tag, but the fix is obvious and self-contained.

Conclusion: This is a safe, correctness-only fix improving accuracy of
f2fs diagnostics on 16KB/64KB page systems and should be backported.

 fs/f2fs/sysfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index f736052dea50a..902ffb3faa1ff 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -1723,12 +1723,15 @@ static int __maybe_unused disk_map_seq_show(struct seq_file *seq,
 	seq_printf(seq, " Main          : 0x%010x (%10d)\n",
 			SM_I(sbi)->main_blkaddr,
 			le32_to_cpu(F2FS_RAW_SUPER(sbi)->segment_count_main));
-	seq_printf(seq, " # of Sections : %12d\n",
-			le32_to_cpu(F2FS_RAW_SUPER(sbi)->section_count));
+	seq_printf(seq, " Block size    : %12lu KB\n", F2FS_BLKSIZE >> 10);
+	seq_printf(seq, " Segment size  : %12d MB\n",
+			(BLKS_PER_SEG(sbi) << (F2FS_BLKSIZE_BITS - 10)) >> 10);
 	seq_printf(seq, " Segs/Sections : %12d\n",
 			SEGS_PER_SEC(sbi));
 	seq_printf(seq, " Section size  : %12d MB\n",
-			SEGS_PER_SEC(sbi) << 1);
+			(BLKS_PER_SEC(sbi) << (F2FS_BLKSIZE_BITS - 10)) >> 10);
+	seq_printf(seq, " # of Sections : %12d\n",
+			le32_to_cpu(F2FS_RAW_SUPER(sbi)->section_count));
 
 	if (!f2fs_is_multi_device(sbi))
 		return 0;
-- 
2.51.0

