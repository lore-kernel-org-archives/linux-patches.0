Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B946C2F90C5;
	Sat, 12 Sep 2026 19:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240095; cv=none; b=PJ3QKODALAHChA+m40mcToIxpRt/ORBmFFVFAccJc/0JIi9Dyyxxk9RhZM2Z/8ZXWdrDuXJvP1A1FCYOjBsg9dGFXALUNm8HzHcio5sqZxhZYxTwbSzGoXo8WsGumyo1N+huGlIaezzAy8xZ408LUsI75ESu78FajF2kIPlK908=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240095; c=relaxed/simple;
	bh=n7+hFsy1pQUzq276QN/QYIwX7Xblcw2RAiOZj0hsnqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ema7y8oIm8CwhDb30bR3G3Tharp2MZWFuWp4Yb8KsnmsujwDhC0ao3Pe871u/vcaY1hK2M/LEjZzsymxl8xUS6qrrT5CIqsbxkaGyJamZ8jIeJevWNpqBIyaCAWqX/2bxAV5qnX6FmQOgAzENSTJ8nF/euUjZryedHV4VK2d7b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWHTrRSm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWHTrRSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C2E1F000FF;
	Sat, 12 Sep 2026 19:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240093;
	bh=f7UjN8DOIMqgkYR5n0rECTEZItH98JZzUP0ObcaqA/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWHTrRSmQKHQUgkH34U7l4YCfjmdysGS4NJmH976hxlhyHAK5G2iXRW97FVl71Cow
	 movb1EkTFYbxJV17/r37FN/vbA7czkXOSaA39V5qL6qcssiDoRfAijTsBQ0Iwv7Zex
	 EgFWEXZxgrFwNC6bYmfwRyIXi8j2buFVJ9zNmFhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 797/935] ubi: fastmap: Fix lapsed wear leveling for first 64 PEBs
Date: Sat, 12 Sep 2026 09:03:47 +0200
Message-ID: <20260912065545.118626908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 90e0be56144b064be1a816cbdd184d2a8be7061b ]

The anchor PEB must be picked from first 64 PEBs, these PEBs could have
large erase counter greater than other PEBs especially when free space
is nearly running out.
The ubi_update_fastmap will be called as long as pool/wl_pool is empty,
old anchor PEB is erased when updating fastmap. Given an UBI device with
N PEBs, free PEBs is nearly running out and pool will be filled with 1
PEB every time ubi_update_fastmap invoked. So t=N/POOL_SIZE[1]/64 means
that in worst case the erase counter of first 64 PEBs is t times greater
than other PEBs in theory.
After running fsstress for 24h, the erase counter statistics for two UBI
devices shown as follow(CONFIG_MTD_UBI_WL_THRESHOLD=128):

Device A(1024 PEBs, pool=50, wl_pool=25):
=========================================================
from              to     count      min      avg      max
---------------------------------------------------------
0        ..        9:        0        0        0        0
10       ..       99:        0        0        0        0
100      ..      999:        0        0        0        0
1000     ..     9999:        0        0        0        0
10000    ..    99999:      960    29224    29282    29362
100000   ..      inf:       64   117897   117934   117940
---------------------------------------------------------
Total               :     1024    29224    34822   117940

Device B(8192 PEBs, pool=256, wl_pool=128):
=========================================================
from              to     count      min      avg      max
---------------------------------------------------------
0        ..        9:        0        0        0        0
10       ..       99:        0        0        0        0
100      ..      999:        0        0        0        0
1000     ..     9999:     8128     2253     2321     2387
10000    ..    99999:       64    35387    35387    35388
100000   ..      inf:        0        0        0        0
---------------------------------------------------------
Total               :     8192     2253     2579    35388

The key point is reducing fastmap updating frequency by enlarging
POOL_SIZE, so let UBI reserve ubi->fm_pool.max_size PEBs during
attaching. Then POOL_SIZE will become ubi->fm_pool.max_size/2 even
in free space running out case.
Given an UBI device with 8192 PEBs(16384\8192\4096 is common
large-capacity flash), t=8192/128/64=1. The fastmap updating will
happen in either wl_pool or pool is empty, so setting fm_pool_rsv_cnt
as ubi->fm_pool.max_size can fill wl_pool in full state.

After pool reservation, running fsstress for 24h:

Device A(1024 PEBs, pool=50, wl_pool=25):
=========================================================
from              to     count      min      avg      max
---------------------------------------------------------
0        ..        9:        0        0        0        0
10       ..       99:        0        0        0        0
100      ..      999:        0        0        0        0
1000     ..     9999:        0        0        0        0
10000    ..    99999:     1024    33801    33997    34056
100000   ..      inf:        0        0        0        0
---------------------------------------------------------
Total               :     1024    33801    33997    34056

Device B(8192 PEBs, pool=256, wl_pool=128):
=========================================================
from              to     count      min      avg      max
---------------------------------------------------------
0        ..        9:        0        0        0        0
10       ..       99:        0        0        0        0
100      ..      999:        0        0        0        0
1000     ..     9999:     8192     2205     2397     2460
10000    ..    99999:        0        0        0        0
100000   ..      inf:        0        0        0        0
---------------------------------------------------------
Total               :     8192     2205     2397     2460

The difference of erase counter between first 64 PEBs and others is
under WL_FREE_MAX_DIFF(2*UBI_WL_THRESHOLD=2*128=256).
  Device A: 34056 - 33801 = 255
  Device B: 2460 - 2205 = 255

Next patch will add a switch to control whether UBI needs to reserve
PEBs for filling pool.

Fixes: dbb7d2a88d2a ("UBI: Add fastmap core")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217787
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Stable-dep-of: 5b0a6b554e12 ("ubi: Fix rollback for explicit UBI device numbers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/build.c      | 1 +
 drivers/mtd/ubi/fastmap-wl.c | 2 +-
 drivers/mtd/ubi/ubi.h        | 2 ++
 drivers/mtd/ubi/wl.h         | 6 ++++--
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 948b4c0184c42..ecf8c5e780f51 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -951,6 +951,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 		UBI_FM_MIN_POOL_SIZE);
 
 	ubi->fm_wl_pool.max_size = ubi->fm_pool.max_size / 2;
+	ubi->fm_pool_rsv_cnt = ubi->fm_pool.max_size;
 	ubi->fm_disabled = (!fm_autoconvert || disable_fm) ? 1 : 0;
 	if (fm_debug)
 		ubi_enable_dbg_chk_fastmap(ubi);
diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index 005ff4ccc3534..c4fa4836c6be7 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -118,7 +118,7 @@ static void wait_free_pebs_for_pool(struct ubi_device *ubi)
 	 * 4. beb_rsvd_pebs: This value should be get under lock ubi->wl_lock
 	 */
 	int reserved = WL_RESERVED_PEBS + EBA_RESERVED_PEBS +
-		       ubi->fm_size / ubi->leb_size - 1;
+		       ubi->fm_size / ubi->leb_size - 1 + ubi->fm_pool_rsv_cnt;
 
 	do {
 		spin_lock(&ubi->wl_lock);
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index a6714a2945d8c..455d2018a5353 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -494,6 +494,7 @@ struct ubi_debug_info {
  * @fast_attach: non-zero if UBI was attached by fastmap
  * @fm_anchor: The next anchor PEB to use for fastmap
  * @fm_do_produce_anchor: If true produce an anchor PEB in wl
+ * @fm_pool_rsv_cnt: Number of reserved PEBs for filling pool/wl_pool
  *
  * @used: RB-tree of used physical eraseblocks
  * @erroneous: RB-tree of erroneous used physical eraseblocks
@@ -604,6 +605,7 @@ struct ubi_device {
 	int fast_attach;
 	struct ubi_wl_entry *fm_anchor;
 	int fm_do_produce_anchor;
+	int fm_pool_rsv_cnt;
 
 	/* Wear-leveling sub-system's stuff */
 	struct rb_root used;
diff --git a/drivers/mtd/ubi/wl.h b/drivers/mtd/ubi/wl.h
index c93a532937863..a480456ba8359 100644
--- a/drivers/mtd/ubi/wl.h
+++ b/drivers/mtd/ubi/wl.h
@@ -8,8 +8,10 @@ static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi);
 static void ubi_fastmap_close(struct ubi_device *ubi);
 static inline void ubi_fastmap_init(struct ubi_device *ubi, int *count)
 {
-	/* Reserve enough LEBs to store two fastmaps. */
-	*count += (ubi->fm_size / ubi->leb_size) * 2;
+	if (ubi->fm_disabled)
+		ubi->fm_pool_rsv_cnt = 0;
+	/* Reserve enough LEBs to store two fastmaps and to fill pools. */
+	*count += (ubi->fm_size / ubi->leb_size) * 2 + ubi->fm_pool_rsv_cnt;
 	INIT_WORK(&ubi->fm_work, update_fastmap_work_fn);
 }
 static struct ubi_wl_entry *may_reserve_for_fm(struct ubi_device *ubi,
-- 
2.53.0



