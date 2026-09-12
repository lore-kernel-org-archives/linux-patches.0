Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC3141169F;
	Sat, 12 Sep 2026 16:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231524; cv=none; b=gbjpvU/A6K8najNp6vzJQPIm3hxGRep+pW9Qv+7B2mu1jO4UdASJ3BVtPpk/X8wA4FPFC177QEnjXK4OWp19AogVGjVmWqw2mO7RwT/Ud5Z2WCigfFxbI0wC0vSVvWxb2wosMIaQZm9PLsb48b9CitOmyf7zPEa7fEsSWmyyJ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231524; c=relaxed/simple;
	bh=RrOwsf0uAAhEngO5qhdZ6MK6ZHCrrpb/6RQgJqiUwpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwI07Ey7WMmb1/c0SLOoUjqWQehGc9p+n0AaiYWkCrXahvrjiKbIwaNK6F3l+Q18i9e80BSYBtp7YWxcBPL7of8g0wcllPH3wmgiJqrReONxIErkln2FGLBDaZZN+t7ZqDpQKRhx0rGPKwbK0rL+31t4Bhf6piIcw6XOEHFOm6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cit8LPHA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cit8LPHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8733C1F000FF;
	Sat, 12 Sep 2026 16:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231522;
	bh=sigPyrEUsOGszSZ5RvNYn3T2LD985rsH/hPm5e8abcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cit8LPHA+M+SjKH62Wm9IHTZQydzqV73NeehZ5hdzk2miVB/I8C4OB6qd4HBALRec
	 Fe5VTldn3Faig8Trej8/Orqr3te0S+uebvTzY3S/db0N5XG+liY1nEJbcU7SxzTR9X
	 oVnJCiFsV9lss1UM0ZWh9yH7l9+CrGSXBH8ZfENc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0973/1191] ubi: fastmap: Fix missed ec updating after erasing old fastmap data block
Date: Sat, 12 Sep 2026 09:01:41 +0200
Message-ID: <20260912065610.067394306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 4d18b5a57b16c21cf868369ca555068722c32b2d ]

After running fsstress on ubifs for a long time, UBI(16384 blocks,
fastmap takes 2 blocks) has an erase block with different erase
counters displayed from two views:

>From ubiscan view: PEB 8031 has erase counter 31581
=========================================================
from              to     count      min      avg      max
---------------------------------------------------------
0        ..        9:        0        0        0        0
10       ..       99:        0        0        0        0
100      ..      999:    16383      290      315      781
1000     ..     9999:        0        0        0        0
10000    ..    99999:        1    31581    31581    31581
100000   ..      inf:        0        0        0        0
---------------------------------------------------------
Total               :    16384      290      317    31581

>From detailed_erase_block_info view: PEB 8031 has erase counter 7
physical_block_number   erase_count
8030                    421
8031                    7   # mem info is different from disk info
8032                    434
8033                    425
8034                    431

Following process missed updating erase counter in wl_entry(in memory):
ubi_update_fastmap
 for (i = 1; i < new_fm->used_blocks; i++) // update fastmap data
  if (!tmp_e)
   if (old_fm && old_fm->e[i])
    erase_block(ubi, old_fm->e[i]->pnum)
     ret = ubi_io_sync_erase(ubi, pnum, 0)
     ec = be64_to_cpu(ec_hdr->ec)
     ec += ret
     ec_hdr->ec = cpu_to_be64(ec)
     ubi_io_write_ec_hdr(ubi, pnum, ec_hdr)  // ec is updated on flash
   // ec is not updated in old_fm->e[i] (in memory)

Fix it by passing wl_enter into erase_block() and updating erase
counter in erase_block().

Fixes: dbb7d2a88d2a ("UBI: Add fastmap core")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Stable-dep-of: 420477a84f1e ("UBI: Preserve torture flag when rescheduling failed erasures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/fastmap.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 1060e19205d2a..5dbab1237fee9 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1393,11 +1393,12 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 /**
  * erase_block - Manually erase a PEB.
  * @ubi: UBI device object
- * @pnum: PEB to be erased
+ * @e: the physical eraseblock to erase
  *
- * Returns the new EC value on success, < 0 indicates an internal error.
+ * This function returns zero in case of success and a negative error code in
+ * case of failure.
  */
-static int erase_block(struct ubi_device *ubi, int pnum)
+static int erase_block(struct ubi_device *ubi, struct ubi_wl_entry *e)
 {
 	int ret;
 	struct ubi_ec_hdr *ec_hdr;
@@ -1407,7 +1408,7 @@ static int erase_block(struct ubi_device *ubi, int pnum)
 	if (!ec_hdr)
 		return -ENOMEM;
 
-	ret = ubi_io_read_ec_hdr(ubi, pnum, ec_hdr, 0);
+	ret = ubi_io_read_ec_hdr(ubi, e->pnum, ec_hdr, 0);
 	if (ret < 0)
 		goto out;
 	else if (ret && ret != UBI_IO_BITFLIPS) {
@@ -1415,7 +1416,7 @@ static int erase_block(struct ubi_device *ubi, int pnum)
 		goto out;
 	}
 
-	ret = ubi_io_sync_erase(ubi, pnum, 0);
+	ret = ubi_io_sync_erase(ubi, e->pnum, 0);
 	if (ret < 0)
 		goto out;
 
@@ -1427,11 +1428,16 @@ static int erase_block(struct ubi_device *ubi, int pnum)
 	}
 
 	ec_hdr->ec = cpu_to_be64(ec);
-	ret = ubi_io_write_ec_hdr(ubi, pnum, ec_hdr);
+	ret = ubi_io_write_ec_hdr(ubi, e->pnum, ec_hdr);
 	if (ret < 0)
 		goto out;
 
-	ret = ec;
+	e->ec = ec;
+	spin_lock(&ubi->wl_lock);
+	if (e->ec > ubi->max_ec)
+		ubi->max_ec = e->ec;
+	spin_unlock(&ubi->wl_lock);
+
 out:
 	kfree(ec_hdr);
 	return ret;
@@ -1577,7 +1583,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 		if (!tmp_e) {
 			if (old_fm && old_fm->e[i]) {
-				ret = erase_block(ubi, old_fm->e[i]->pnum);
+				ret = erase_block(ubi, old_fm->e[i]);
 				if (ret < 0) {
 					ubi_err(ubi, "could not erase old fastmap PEB");
 
@@ -1629,7 +1635,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	if (old_fm) {
 		/* no fresh anchor PEB was found, reuse the old one */
 		if (!tmp_e) {
-			ret = erase_block(ubi, old_fm->e[0]->pnum);
+			ret = erase_block(ubi, old_fm->e[0]);
 			if (ret < 0) {
 				ubi_err(ubi, "could not erase old anchor PEB");
 
@@ -1641,7 +1647,6 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 				goto err;
 			}
 			new_fm->e[0] = old_fm->e[0];
-			new_fm->e[0]->ec = ret;
 			old_fm->e[0] = NULL;
 		} else {
 			/* we've got a new anchor PEB, return the old one */
-- 
2.53.0



