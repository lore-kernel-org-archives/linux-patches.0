Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E16D3A9636;
	Sat, 12 Sep 2026 19:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240063; cv=none; b=fZKbMLbJaQk2kjn0tcp8poCyjC4hfuicD7nPppo5tG5ralymO6es71Dd6+0JRa6uJNk7kM3SCdvQTQvcmKUuCBMNgSwiNOwhQ5AAwiJiZ00VznvnXMSTdokQ8RUQf7QNYrljY23xw52UxREafKCk7nb51OqxLWZlvW+NjxfrW6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240063; c=relaxed/simple;
	bh=My0XIy9jjH3dp7SQWZAr8x84Jrars5DzoeHahkTgbd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8hpMg62ASqTdhebTS6AOoUPWAoEQq9V5daHzplZpT42HeXgEFP0JfcLZg1O7hlqhJi6nMEVnf+TMeElY9GZBbYyxCuB2pEdY+SSzD+shwVCClrevxs3QiKHseawBTubmnVuw66cwRIAv/06h1O8bZ/8HlThJvcllYK0tscDw7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ir9w5r2w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ir9w5r2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF641F000FF;
	Sat, 12 Sep 2026 19:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240059;
	bh=NLacl29ZILClRDSG/LOToy7WA7AaXXnBzZwVaPsi9PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ir9w5r2wg9oUlDtqaepGDSJrKgXgnDxgFk7uK7UFu56le9xrJ3Gj426H485x47e/7
	 Xfydk2QZDzQfwg61ZeJRgDrY1S253zebW4SSXtkXywABWYAPdBSz0LPyDfQ2oXtb1L
	 qHIiG8Ih6x0gu1N1s7HdVFtYpz4AYB/9C5wXMtpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 791/935] UBI: Preserve torture flag when rescheduling failed erasures
Date: Sat, 12 Sep 2026 09:03:41 +0200
Message-ID: <20260912065544.973105667@linuxfoundation.org>
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

[ Upstream commit 420477a84f1e52babfe60a43dbdd0988ed956845 ]

In __erase_worker(), when ubi_sync_erase() returns -EINTR, -ENOMEM,
-EAGAIN, or -EBUSY, the physical eraseblock is rescheduled for erasure
via schedule_erase() with the torture flag hardcoded to 0. This
unconditionally drops the torture request.

If the error occurred before torture_peb() completed (e.g., -ENOMEM
from the ec_hdr allocation in ubi_sync_erase(), errors from
self_check_not_bad()/nor_erase_prepare() in ubi_io_sync_erase(), or
torture_peb() failing mid-test because its internal do_sync_erase()/
ubi_io_read()/ubi_io_write() returned one of the above error codes),
the torture test was never finished. Such a PEB may reach the free
pool without being tortured, defeating the purpose of the torture
test for detecting marginally-bad eraseblocks.

If the error occurred after torture_peb() succeeded (the final
do_sync_erase() in ubi_io_sync_erase() or ubi_io_write_ec_hdr() in
ubi_sync_erase() failed), the torture has already been done and need
not be repeated.

Pass the torture flag by pointer to ubi_sync_erase() and
ubi_io_sync_erase(), and clear it to zero once torture_peb() has
completed successfully. __erase_worker() then forwards the updated
wl_wrk->torture to schedule_erase(): torture already done is dropped,
torture not completed is preserved across the reschedule.

Fixes: 784c145444e7 ("UBI: fix error handling in erase worker")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/attach.c  |  4 ++--
 drivers/mtd/ubi/fastmap.c |  6 +++---
 drivers/mtd/ubi/io.c      | 11 +++++++----
 drivers/mtd/ubi/ubi.h     |  4 ++--
 drivers/mtd/ubi/wl.c      | 15 +++++++++------
 5 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index adc47b87b38a5..3946b4aab3166 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -771,7 +771,7 @@ void ubi_remove_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av)
 static int early_erase_peb(struct ubi_device *ubi,
 			   const struct ubi_attach_info *ai, int pnum, int ec)
 {
-	int err;
+	int err, torture = 0;
 	struct ubi_ec_hdr *ec_hdr;
 
 	if ((long long)ec >= UBI_MAX_ERASECOUNTER) {
@@ -790,7 +790,7 @@ static int early_erase_peb(struct ubi_device *ubi,
 
 	ec_hdr->ec = cpu_to_be64(ec);
 
-	err = ubi_io_sync_erase(ubi, pnum, 0);
+	err = ubi_io_sync_erase(ubi, pnum, &torture);
 	if (err < 0)
 		goto out_free;
 
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index e448dbb7d2582..94af66c8a9417 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1488,7 +1488,7 @@ static void return_fm_pebs(struct ubi_device *ubi,
  */
 int ubi_update_fastmap(struct ubi_device *ubi)
 {
-	int ret, i, j;
+	int ret, i, j, torture = 0;
 	struct ubi_fastmap_layout *new_fm, *old_fm;
 	struct ubi_wl_entry *tmp_e;
 
@@ -1530,7 +1530,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 		if (!tmp_e) {
 			if (old_fm && old_fm->e[i]) {
-				ret = ubi_sync_erase(ubi, old_fm->e[i], 0);
+				ret = ubi_sync_erase(ubi, old_fm->e[i], &torture);
 				if (ret < 0) {
 					ubi_err(ubi, "could not erase old fastmap PEB");
 
@@ -1582,7 +1582,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	if (old_fm) {
 		/* no fresh anchor PEB was found, reuse the old one */
 		if (!tmp_e) {
-			ret = ubi_sync_erase(ubi, old_fm->e[0], 0);
+			ret = ubi_sync_erase(ubi, old_fm->e[0], &torture);
 			if (ret < 0) {
 				ubi_err(ubi, "could not erase old anchor PEB");
 
diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index 01b6448612533..2af724bd67264 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -507,8 +507,10 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
 /**
  * ubi_io_sync_erase - synchronously erase a physical eraseblock.
  * @ubi: UBI device description object
- * @pnum: physical eraseblock number to erase
- * @torture: if this physical eraseblock has to be tortured
+ * @pnum: the physical eraseblock number to erase
+ * @torture: if this physical eraseblock has to be tortured; cleared to zero
+ *           once the torture test has completed successfully so that a retry
+ *           of the erase does not torture the physical eraseblock again
  *
  * This function synchronously erases physical eraseblock @pnum. If @torture
  * flag is not zero, the physical eraseblock is checked by means of writing
@@ -520,7 +522,7 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
  * codes in case of other errors. Note, %-EIO means that the physical
  * eraseblock is bad.
  */
-int ubi_io_sync_erase(struct ubi_device *ubi, int pnum, int torture)
+int ubi_io_sync_erase(struct ubi_device *ubi, int pnum, int *torture)
 {
 	int err, ret = 0;
 
@@ -548,10 +550,11 @@ int ubi_io_sync_erase(struct ubi_device *ubi, int pnum, int torture)
 			return err;
 	}
 
-	if (torture) {
+	if (*torture) {
 		ret = torture_peb(ubi, pnum);
 		if (ret < 0)
 			return ret;
+		*torture = 0;
 	}
 
 	err = do_sync_erase(ubi, pnum);
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index de475bd583256..589221981524a 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -902,7 +902,7 @@ int self_check_eba(struct ubi_device *ubi, struct ubi_attach_info *ai_fastmap,
 		   struct ubi_attach_info *ai_scan);
 
 /* wl.c */
-int ubi_sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e, int torture);
+int ubi_sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e, int *torture);
 int ubi_wl_get_peb(struct ubi_device *ubi);
 int ubi_wl_put_peb(struct ubi_device *ubi, int vol_id, int lnum,
 		   int pnum, int torture);
@@ -924,7 +924,7 @@ int ubi_io_read(const struct ubi_device *ubi, void *buf, int pnum, int offset,
 		int len);
 int ubi_io_write(struct ubi_device *ubi, const void *buf, int pnum, int offset,
 		 int len);
-int ubi_io_sync_erase(struct ubi_device *ubi, int pnum, int torture);
+int ubi_io_sync_erase(struct ubi_device *ubi, int pnum, int *torture);
 int ubi_io_is_bad(const struct ubi_device *ubi, int pnum);
 int ubi_io_mark_bad(const struct ubi_device *ubi, int pnum);
 int ubi_io_read_ec_hdr(struct ubi_device *ubi, int pnum,
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index d72c1b13c9e39..0e45f14a12f98 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -430,12 +430,14 @@ static int prot_queue_del(struct ubi_device *ubi, int pnum)
  * ubi_sync_erase - synchronously erase a physical eraseblock.
  * @ubi: UBI device description object
  * @e: the physical eraseblock to erase
- * @torture: if the physical eraseblock has to be tortured
+ * @torture: if the physical eraseblock has to be tortured; cleared to zero
+ *           once the torture test has completed successfully so that a retry
+ *           of the erase does not torture the physical eraseblock again
  *
  * This function returns zero in case of success and a negative error code in
  * case of failure.
  */
-int ubi_sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e, int torture)
+int ubi_sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e, int *torture)
 {
 	int err;
 	struct ubi_ec_hdr *ec_hdr;
@@ -1090,7 +1092,7 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
 	dbg_wl("erase PEB %d EC %d LEB %d:%d",
 	       pnum, e->ec, wl_wrk->vol_id, wl_wrk->lnum);
 
-	err = ubi_sync_erase(ubi, e, wl_wrk->torture);
+	err = ubi_sync_erase(ubi, e, &wl_wrk->torture);
 	if (!err) {
 		spin_lock(&ubi->wl_lock);
 
@@ -1127,7 +1129,8 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
 		int err1;
 
 		/* Re-schedule the LEB for erasure */
-		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, true);
+		err1 = schedule_erase(ubi, e, vol_id, lnum, wl_wrk->torture,
+				      true);
 		if (err1) {
 			spin_lock(&ubi->wl_lock);
 			wl_entry_destroy(ubi, e);
@@ -1734,7 +1737,7 @@ static void shutdown_work(struct ubi_device *ubi)
 static int erase_aeb(struct ubi_device *ubi, struct ubi_ainf_peb *aeb, bool sync)
 {
 	struct ubi_wl_entry *e;
-	int err;
+	int err, torture = 0;
 
 	e = kmem_cache_alloc(ubi_wl_entry_slab, GFP_KERNEL);
 	if (!e)
@@ -1745,7 +1748,7 @@ static int erase_aeb(struct ubi_device *ubi, struct ubi_ainf_peb *aeb, bool sync
 	ubi->lookuptbl[e->pnum] = e;
 
 	if (sync) {
-		err = ubi_sync_erase(ubi, e, false);
+		err = ubi_sync_erase(ubi, e, &torture);
 		if (err)
 			goto out_free;
 
-- 
2.53.0



