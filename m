Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9145384233;
	Sat, 12 Sep 2026 08:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203454; cv=none; b=nVOOMCZrRNjS1Xc9qH7wdNp7k+yguIyRbk8Y+vGMX+dCIZw5/84rabjLthP39m9BcqzQ6VRvz949gk0+MNNSQGxQJzOus/VIlEfEh/DbOY6yohqJtO8j0yfnf7xpZ8m68zgCsexoVMQuL/5lQwUVHmOZ4UVkSyb8rx5a8twg1yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203454; c=relaxed/simple;
	bh=C4OZ6rLLY8VkdPlBxM35b/6ACOx9jpoNUJq3GUqNwg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaYzYiunYuua151wljFtvsnnedksmk+dqHJSRPzdqtDonP6g+m2SPcjtcDIYaO114oiMT+nYO2vNhO3AF59gh2SLweMWseNxw/52i0CH5uW0jGLon2E0mBgh8bWHrClQwc0C+a+Lgr9qoCqWR4daw5UYxx9h/Tw6fXxE6sTFO/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hk1eoFfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hk1eoFfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE311F000FF;
	Sat, 12 Sep 2026 08:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203452;
	bh=tobCydwUQdJIoZMXzbWqZ+2fZSXZPjd64ugHL0JwL98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hk1eoFfFVrj8BJMbHEoc6ctjrLwtfBZhi4osH/QUlmW144tEEk+XMeKmk4VL2mZo5
	 AQQiizvviiLIERaOnL7xvE0CWlwiT2WYIMefYHU/Y590N5M3EH3tZ6z92JcgVuJaky
	 4ReG2xuwuGN9LygKZn+/kQEdFwiGdn8RiGm5siPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1374/1815] UBI: Preserve torture flag when rescheduling failed erasures
Date: Sat, 12 Sep 2026 08:52:04 +0200
Message-ID: <20260912065721.284054837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 0fa115cbf3ad4..0ce7ff7400d37 100644
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
index 3bce1b4d84643..98cc698d9c34d 100644
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
 
@@ -1526,7 +1526,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 		if (!tmp_e) {
 			if (old_fm && old_fm->e[i]) {
-				ret = ubi_sync_erase(ubi, old_fm->e[i], 0);
+				ret = ubi_sync_erase(ubi, old_fm->e[i], &torture);
 				if (ret < 0) {
 					ubi_err(ubi, "could not erase old fastmap PEB");
 
@@ -1578,7 +1578,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	if (old_fm) {
 		/* no fresh anchor PEB was found, reuse the old one */
 		if (!tmp_e) {
-			ret = ubi_sync_erase(ubi, old_fm->e[0], 0);
+			ret = ubi_sync_erase(ubi, old_fm->e[0], &torture);
 			if (ret < 0) {
 				ubi_err(ubi, "could not erase old anchor PEB");
 
diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index 915eb64cb0011..d70d1313ad4e8 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -519,8 +519,10 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
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
@@ -532,7 +534,7 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
  * codes in case of other errors. Note, %-EIO means that the physical
  * eraseblock is bad.
  */
-int ubi_io_sync_erase(struct ubi_device *ubi, int pnum, int torture)
+int ubi_io_sync_erase(struct ubi_device *ubi, int pnum, int *torture)
 {
 	int err, ret = 0;
 
@@ -560,10 +562,11 @@ int ubi_io_sync_erase(struct ubi_device *ubi, int pnum, int torture)
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
index af466cd83ae07..80b7628929228 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -901,7 +901,7 @@ int self_check_eba(struct ubi_device *ubi, struct ubi_attach_info *ai_fastmap,
 		   struct ubi_attach_info *ai_scan);
 
 /* wl.c */
-int ubi_sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e, int torture);
+int ubi_sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e, int *torture);
 int ubi_wl_get_peb(struct ubi_device *ubi);
 int ubi_wl_put_peb(struct ubi_device *ubi, int vol_id, int lnum,
 		   int pnum, int torture);
@@ -923,7 +923,7 @@ int ubi_io_read(const struct ubi_device *ubi, void *buf, int pnum, int offset,
 		int len);
 int ubi_io_write(struct ubi_device *ubi, const void *buf, int pnum, int offset,
 		 int len);
-int ubi_io_sync_erase(struct ubi_device *ubi, int pnum, int torture);
+int ubi_io_sync_erase(struct ubi_device *ubi, int pnum, int *torture);
 int ubi_io_is_bad(const struct ubi_device *ubi, int pnum);
 int ubi_io_mark_bad(const struct ubi_device *ubi, int pnum);
 int ubi_io_read_ec_hdr(struct ubi_device *ubi, int pnum,
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index e3705db8e5709..edfab98f7064f 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -443,12 +443,14 @@ static int prot_queue_del(struct ubi_device *ubi, int pnum)
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
@@ -1113,7 +1115,7 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
 	dbg_wl("erase PEB %d EC %d LEB %d:%d",
 	       pnum, e->ec, wl_wrk->vol_id, wl_wrk->lnum);
 
-	err = ubi_sync_erase(ubi, e, wl_wrk->torture);
+	err = ubi_sync_erase(ubi, e, &wl_wrk->torture);
 	if (!err) {
 		spin_lock(&ubi->wl_lock);
 
@@ -1150,7 +1152,8 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
 		int err1;
 
 		/* Re-schedule the LEB for erasure */
-		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, true);
+		err1 = schedule_erase(ubi, e, vol_id, lnum, wl_wrk->torture,
+				      true);
 		if (err1) {
 			spin_lock(&ubi->wl_lock);
 			wl_entry_destroy(ubi, e);
@@ -1757,7 +1760,7 @@ static void shutdown_work(struct ubi_device *ubi)
 static int erase_aeb(struct ubi_device *ubi, struct ubi_ainf_peb *aeb, bool sync)
 {
 	struct ubi_wl_entry *e;
-	int err;
+	int err, torture = 0;
 
 	e = kmem_cache_alloc(ubi_wl_entry_slab, GFP_KERNEL);
 	if (!e)
@@ -1768,7 +1771,7 @@ static int erase_aeb(struct ubi_device *ubi, struct ubi_ainf_peb *aeb, bool sync
 	ubi->lookuptbl[e->pnum] = e;
 
 	if (sync) {
-		err = ubi_sync_erase(ubi, e, false);
+		err = ubi_sync_erase(ubi, e, &torture);
 		if (err)
 			goto out_free;
 
-- 
2.53.0



