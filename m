Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B631EF0AE;
	Tue,  3 Dec 2024 15:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239234; cv=none; b=DoRCdFY/nMNcF27tf1HHxSA/fpDbg0oc/IShAkfXFruYHNWX5bysINYwnH+kOPuKWChrd6yzZIm7fyrYdpzfvFStbn/UDKaOQ6rS5h08Yw/v7z32toltCvcqR89QZUDmCuI6uEzctOspwQbDu1z/rsjl7nOd1m/C1JmPQVMgxMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239234; c=relaxed/simple;
	bh=wcXGiJAyZ+eAtgPLmDBZcZpkRSoWxhdfuclFpl2TTvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTQUf7+z0ki48weAxxxghrdrGNiYeYG/jGeqoDVNJoVBwajO178dZ3U53K6RdakUW7Ckta++9DSG9IVbzppcViRXUaOBJPGgWweZ/PbgGP7TdY2vLWf9SGonDHxchrtWJCRcVMC5E2+JhjAMhfVtMPWeAAKf1LIZncBh9rrs8NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdUpXNDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdUpXNDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B293C4CECF;
	Tue,  3 Dec 2024 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239233;
	bh=wcXGiJAyZ+eAtgPLmDBZcZpkRSoWxhdfuclFpl2TTvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdUpXNDCJ3rEdqx+BlVwk4tegRy7ciJj9Tufh6Ojfh143sM3rgBbmgOUwta91xSYz
	 ihZiScwXAxFqBXxPz3wBCN9SjGrUO/IqnPA+M1jXjE9UJaQe1Jcb7qgxSqpEi0qHeR
	 MvaRQ8aF57RiCAJA8U2EHpPdWp+e4QRPK41wIVVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 512/817] f2fs: fix to avoid use GC_AT when setting gc_mode as GC_URGENT_LOW or GC_URGENT_MID
Date: Tue,  3 Dec 2024 15:41:24 +0100
Message-ID: <20241203144015.867056782@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index d0c1acfcad405..ef2d8fcc6e993 100644
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
index 938249e7819e4..2bc16e3106508 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -251,6 +251,8 @@ static int select_gc_type(struct f2fs_sb_info *sbi, int gc_type)
 
 	switch (sbi->gc_mode) {
 	case GC_IDLE_CB:
+	case GC_URGENT_LOW:
+	case GC_URGENT_MID:
 		gc_mode = GC_CB;
 		break;
 	case GC_IDLE_GREEDY:
-- 
2.43.0



