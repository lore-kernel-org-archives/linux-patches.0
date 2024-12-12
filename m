Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCC022FDED;
	Thu, 12 Dec 2024 16:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020304; cv=none; b=J0H+3db/8joz2B5xWtQvjGXzaFOEc+phnWZVCYOAHfsmCLq2BxbW4qJdWbFBl0EOHHadRsc/6X/+vmEi1XumukHctZQwLW5pDbV13FS4FcJkM+v9Y7enC6d9EB5/4MN4jtrk1ookTsrb/RVkk2dpzs75jRFruDtebsIMWRjxMLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020304; c=relaxed/simple;
	bh=1is3VDtYfzQOu6jpopmvowTlrqpOZE8EKYvvmRVezNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNFzrciDwE7U7lw+ZyjsCigPUXOeeuhdkyU2P7Tl/NRLq1ZUgS6uKWfVYMo2sriJ9RSZ+N6XtUiDN9tk7hzOciacSh28ySIhz0pmDJasGOF/h0jrFgCUQph/xfa9rxeb6U0Iy0TEyPAT+7HpUjccFe73TrBhHJopfGOFEgfX08U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxLq67Fy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxLq67Fy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1809DC4CECE;
	Thu, 12 Dec 2024 16:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020303;
	bh=1is3VDtYfzQOu6jpopmvowTlrqpOZE8EKYvvmRVezNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxLq67FyGV8wY+yA8qjMTA4EkI2K2JhixQ9XlQauVXBlas29I/GRaQU69fZ6dsPas
	 oyIVR6YvOJX+2fG5uzQSXRgSue9dwyNemQRzI4HxbAnP5vx4zRfaiq/J6s6XnXqZuT
	 JN2sd109KwfM0c40psA/FpRoRPDRA6sbVNeBXXr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 433/772] ubi: fastmap: wl: Schedule fm_work if wear-leveling pool is empty
Date: Thu, 12 Dec 2024 15:56:18 +0100
Message-ID: <20241212144407.824409394@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit c4595fe394a289927077e3da561db27811919ee0 ]

Since commit 14072ee33d5a ("ubi: fastmap: Check wl_pool for free peb
before wear leveling"), wear_leveling_worker() won't schedule fm_work
if wear-leveling pool is empty, which could temporarily disable the
wear-leveling until the fastmap is updated(eg. pool becomes empty).
Fix it by scheduling fm_work if wl_pool is empty during wear-leveing.

Fixes: 14072ee33d5a ("ubi: fastmap: Check wl_pool for free peb before wear leveling")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/fastmap-wl.c | 19 ++++++++++++++++---
 drivers/mtd/ubi/wl.c         |  2 +-
 drivers/mtd/ubi/wl.h         |  3 ++-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index 863f571f1adb5..79733163ab7d0 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -282,14 +282,27 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
  * WL sub-system.
  *
  * @ubi: UBI device description object
+ * @need_fill: whether to fill wear-leveling pool when no PEBs are found
  */
-static struct ubi_wl_entry *next_peb_for_wl(struct ubi_device *ubi)
+static struct ubi_wl_entry *next_peb_for_wl(struct ubi_device *ubi,
+					    bool need_fill)
 {
 	struct ubi_fm_pool *pool = &ubi->fm_wl_pool;
 	int pnum;
 
-	if (pool->used == pool->size)
+	if (pool->used == pool->size) {
+		if (need_fill && !ubi->fm_work_scheduled) {
+			/*
+			 * We cannot update the fastmap here because this
+			 * function is called in atomic context.
+			 * Let's fail here and refill/update it as soon as
+			 * possible.
+			 */
+			ubi->fm_work_scheduled = 1;
+			schedule_work(&ubi->fm_work);
+		}
 		return NULL;
+	}
 
 	pnum = pool->pebs[pool->used];
 	return ubi->lookuptbl[pnum];
@@ -311,7 +324,7 @@ static bool need_wear_leveling(struct ubi_device *ubi)
 	if (!ubi->used.rb_node)
 		return false;
 
-	e = next_peb_for_wl(ubi);
+	e = next_peb_for_wl(ubi, false);
 	if (!e) {
 		if (!ubi->free.rb_node)
 			return false;
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 3e37c9981e716..c1d3472cdc9ad 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -671,7 +671,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 	ubi_assert(!ubi->move_to_put);
 
 #ifdef CONFIG_MTD_UBI_FASTMAP
-	if (!next_peb_for_wl(ubi) ||
+	if (!next_peb_for_wl(ubi, true) ||
 #else
 	if (!ubi->free.rb_node ||
 #endif
diff --git a/drivers/mtd/ubi/wl.h b/drivers/mtd/ubi/wl.h
index 5ebe374a08aed..1d83e552533a5 100644
--- a/drivers/mtd/ubi/wl.h
+++ b/drivers/mtd/ubi/wl.h
@@ -5,7 +5,8 @@
 static void update_fastmap_work_fn(struct work_struct *wrk);
 static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root);
 static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi);
-static struct ubi_wl_entry *next_peb_for_wl(struct ubi_device *ubi);
+static struct ubi_wl_entry *next_peb_for_wl(struct ubi_device *ubi,
+					    bool need_fill);
 static bool need_wear_leveling(struct ubi_device *ubi);
 static void ubi_fastmap_close(struct ubi_device *ubi);
 static inline void ubi_fastmap_init(struct ubi_device *ubi, int *count)
-- 
2.43.0



