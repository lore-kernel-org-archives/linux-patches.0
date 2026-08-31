Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04B551E44A;
	Mon, 31 Aug 2026 13:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183830; cv=none; b=LBLGXf+m60JoosGAaLQAIbSOSo35PbqG32qfLZ0unnEwEhPDHAxdmdaoSbzJh4cKJDPikWnZHOz+ifadd+JFl4Y5lvPdWPO3sVlXJjZIGsUcrlIA/rw3ur2DYiq/rMjb9OrljdmwI1hY3U6vMxKQK7JH506MzBKO901usNSMjPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183830; c=relaxed/simple;
	bh=tWcYTEq+Nl25O6YTOwT+jZHdQ3ULqDzJsPxPZiVqLYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YRAPlJz/Nxz88NcDs+J56FojJXe9OSq4mc8UsOY7/enG4IAtcEb9joOfZ6Imb0NMX/Lw6z1ldKTmCfcplO+rMs4AedLx/0yeevv3gY8PHRzfgsMMVVlJOYJqZ82zDcDzV8U0O6n5NeB/VX31+I0Dlp9q1gtygIK4qy83fth6n64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hMjBNYCQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMjBNYCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624371F00ACF;
	Mon, 31 Aug 2026 13:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183828;
	bh=FrC4tyM01XfC74y3iCYXDeh4k761i06gexhwjbMakV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMjBNYCQ+/X9I2qHIroHfyPBdwTvKul9ae7+zZP4u/NqxFW9r3SoXY2c9OTMMVJdE
	 X0fgBDtQa38fBXAXJ3Rsloi/U9yYPSy1neGNeUOGT2nULDH/xrdvJodcM9q6/o40oi
	 sEY1WacIi8zFC3cWOHfNBJz7tDPdU32yG0BY9T2ZLi+tkxp3vrGmOSTQIzMiWRDU1Y
	 s8bERlvjqN411bHzMgF9R1SG40mWUVxbbB7mPRG6EICTJVicusIhkHKOz4uyljOVaJ
	 +qlNNMP3GREx6oyH7FUYnME4Z/rEc1JGgDTyGC5Dii9I1JLqTMFRddVlKKzgaAxtGu
	 pHi7OsnuZAP0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daeho Jeong <daehojeong@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	chao@kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] f2fs: optimize representative type determination in GC
Date: Mon, 31 Aug 2026 09:25:57 -0400
Message-ID: <20260831133314.4125787-329-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 5dfb768326b95c6dd6554f34dec71b44a01a0bc8 ]

In large section mode, do_garbage_collect() previously determined the
section's representative type by looking only at the first segment of
the section. However, if data was fsynced into an area previously used
as a node section, and this area is recovered during roll-forward
recovery after sudden power off (SPO), GC would incorrectly assume the
section's type based on an empty or obsolete first segment. This caused
the recovered data segment to be misunderstood as being stuck inside a
node section, triggering false inconsistency panics (Inconsistent
segment type in SSA and SIT) and subsequent mount failures.

This patch optimizes do_garbage_collect() to determine the section's
representative type by identifying the first segment that actually
contains valid blocks (valid_blocks > 0) during the main GC loop. This
eliminates false alarms from empty/obsolete leading segments while
maintaining strict section-level type consistency checks for genuine
corruption.

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background git searches finished and line up with the earlier
analysis:

- **`origin/master`** has the fix as `5dfb768326b95` ("f2fs: optimize
  representative type determination in GC"), merged via the f2fs-
  for-7.1-rc1 tag.
- **Current HEAD (v6.18.44)** does not contain it — subject grep on HEAD
  returned nothing, and recent `fs/f2fs/gc.c` history shows no sign of
  this patch.

That supports the **YES** backport recommendation for this 6.18.y tree:
the bug is still present here, the fix is on mainline, and it applies
cleanly.

 fs/f2fs/gc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 3d41c6348b3c1..e56c7ccecaff5 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1769,9 +1769,8 @@ static int do_garbage_collect(struct f2fs_sb_info *sbi,
 	unsigned int end_segno = start_segno + SEGS_PER_SEC(sbi);
 	unsigned int sec_end_segno;
 	int seg_freed = 0, migrated = 0;
-	unsigned char type = IS_DATASEG(get_seg_entry(sbi, segno)->type) ?
-						SUM_TYPE_DATA : SUM_TYPE_NODE;
-	unsigned char data_type = (type == SUM_TYPE_DATA) ? DATA : NODE;
+	unsigned char type;
+	unsigned char data_type;
 	int submitted = 0, sum_blk_cnt;
 
 	if (__is_large_section(sbi)) {
@@ -1870,6 +1869,12 @@ static int do_garbage_collect(struct f2fs_sb_info *sbi,
 					migrated >= sbi->migration_granularity)
 				continue;
 
+			if (migrated == 0) {
+				type = IS_DATASEG(get_seg_entry(sbi, cur_segno)->type) ?
+							SUM_TYPE_DATA : SUM_TYPE_NODE;
+				data_type = (type == SUM_TYPE_DATA) ? DATA : NODE;
+			}
+
 			sum = SUM_BLK_PAGE_ADDR(sbi, sum_folio, cur_segno);
 			if (type != GET_SUM_TYPE(sum_footer(sbi, sum))) {
 				f2fs_err(sbi, "Inconsistent segment (%u) type "
-- 
2.53.0

