Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A3B1F76A4;
	Tue,  3 Dec 2024 16:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241738; cv=none; b=cRAPMxClBCsVutUpEmFKWSOIE0EriLtld0rEeZNb59Y0kFWBsZeMpFz4nKgbQZ2sBgoYE3lkLQf0NHciOw7T9z/5zxe0mhItAj7vSQ/zMKBeDYLvx1RTuT+Q8rLa5u+PJCk9Wo5yTXK03YWXqoDZ277hnQoUp3fNHlZO1vemakY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241738; c=relaxed/simple;
	bh=IG433edcuEtlHaqbUXwUEf46RKYOLHCPKKdQjP/eohw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7VgJvNgwfczKHIIJnKjBktc1UcrKepxlG1/jtaYZRPI+4+Oy8GJrKh2zvpqXjpQaxc4Q0vFqLBjEH2yBTIvvbpoPdjK9Qg72d3IGWfhtM7fz6vDZmN+1mTVEJHOOM0BdLFiLiCN43ra+FxRVxlkDznKVEYbW6t4amqJARB6H/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTyjpEH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTyjpEH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9362AC4CECF;
	Tue,  3 Dec 2024 16:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241738;
	bh=IG433edcuEtlHaqbUXwUEf46RKYOLHCPKKdQjP/eohw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTyjpEH0LY3NI839V/ED5/3nSVdX/gcNPXKoHvPijQedsDUlPeo9S2MLsV+5xVPf6
	 RGmu2M0FDCW+3p5Y/nmMGaJ2nSTHhukMC7Q2YWp1vKhX5h1PtOv/VKCuL1Qk4OXfLm
	 7KWN2BC5gv+CVGtvqwBNAxnySxzK5RvE1Cz6AsPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 501/826] f2fs: fix to avoid use GC_AT when setting gc_mode as GC_URGENT_LOW or GC_URGENT_MID
Date: Tue,  3 Dec 2024 15:43:48 +0100
Message-ID: <20241203144803.299351845@linuxfoundation.org>
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

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 296b8cb34e65fa93382cf919be5a056f719c9a26 ]

If gc_mode is set to GC_URGENT_LOW or GC_URGENT_MID, cost benefit GC
approach should be used, but if ATGC is enabled at the same time,
Age-threshold approach will be selected, which can only do amount of
GC and it is much less than the numbers of CB approach.

some traces:
  f2fs_gc-254:48-396     [007] ..... 2311600.684028: f2fs_gc_begin: dev = (254,48), gc_type = Background GC, no_background_GC = 0, nr_free_secs = 0, nodes = 1053, dents = 2, imeta = 18, free_sec:44898, free_seg:44898, rsv_seg:239, prefree_seg:0
  f2fs_gc-254:48-396     [007] ..... 2311600.684527: f2fs_get_victim: dev = (254,48), type = No TYPE, policy = (Background GC, LFS-mode, Age-threshold), victim = 10, cost = 4294364975, ofs_unit = 1, pre_victim_secno = -1, prefree = 0, free = 44898
  f2fs_gc-254:48-396     [007] ..... 2311600.714835: f2fs_gc_end: dev = (254,48), ret = 0, seg_freed = 0, sec_freed = 0, nodes = 1562, dents = 2, imeta = 18, free_sec:44898, free_seg:44898, rsv_seg:239, prefree_seg:0
  f2fs_gc-254:48-396     [007] ..... 2311600.714843: f2fs_background_gc: dev = (254,48), wait_ms = 50, prefree = 0, free = 44898
  f2fs_gc-254:48-396     [007] ..... 2311600.771785: f2fs_gc_begin: dev = (254,48), gc_type = Background GC, no_background_GC = 0, nr_free_secs = 0, nodes = 1562, dents = 2, imeta = 18, free_sec:44898, free_seg:44898, rsv_seg:239, prefree_seg:
  f2fs_gc-254:48-396     [007] ..... 2311600.772275: f2fs_gc_end: dev = (254,48), ret = -61, seg_freed = 0, sec_freed = 0, nodes = 1562, dents = 2, imeta = 18, free_sec:44898, free_seg:44898, rsv_seg:239, prefree_seg:0

Fixes: 0e5e81114de1 ("f2fs: add GC_URGENT_LOW mode in gc_urgent")
Fixes: d98af5f45520 ("f2fs: introduce gc_urgent_mid mode")
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-f2fs | 7 +++++--
 fs/f2fs/gc.c                            | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index fdedf1ea944ba..513296bb6f297 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -311,10 +311,13 @@ Description:	Do background GC aggressively when set. Set to 0 by default.
 		GC approach and turns SSR mode on.
 		gc urgent low(2): lowers the bar of checking I/O idling in
 		order to process outstanding discard commands and GC a
-		little bit aggressively. uses cost benefit GC approach.
+		little bit aggressively. always uses cost benefit GC approach,
+		and will override age-threshold GC approach if ATGC is enabled
+		at the same time.
 		gc urgent mid(3): does GC forcibly in a period of given
 		gc_urgent_sleep_time and executes a mid level of I/O idling check.
-		uses cost benefit GC approach.
+		always uses cost benefit GC approach, and will override
+		age-threshold GC approach if ATGC is enabled at the same time.
 
 What:		/sys/fs/f2fs/<disk>/gc_urgent_sleep_time
 Date:		August 2017
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 9322a7200e310..e0469316c7cd4 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -257,6 +257,8 @@ static int select_gc_type(struct f2fs_sb_info *sbi, int gc_type)
 
 	switch (sbi->gc_mode) {
 	case GC_IDLE_CB:
+	case GC_URGENT_LOW:
+	case GC_URGENT_MID:
 		gc_mode = GC_CB;
 		break;
 	case GC_IDLE_GREEDY:
-- 
2.43.0



