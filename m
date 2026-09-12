Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004D6F4F1;
	Sat, 12 Sep 2026 19:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240041; cv=none; b=F3HvsdMQXWoj5MQp8SrtgXSlWbMyjOsSDkZoyRXFv7rVLTyUgTyzXqmiQHd7IiXJKsFCO7lMcyNyl4AgK9oRmj/lRzHzOk/JnDnXxGSEfTLxtxJycC1nAGXDYILd+ds2+cdHQljYn/SSLt0Rymh+P8rtnuQIV7Ds8LN+Yw0cNf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240041; c=relaxed/simple;
	bh=vKdTTtUark5tJMNYWN9cYDUPP3gCafR2H70TE/WNb3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UokX9C7fnsqwk2bEfYIdupFVU/sSxeWH5hk7LrIQ1Ixe/1eDDV1YngiBZoNZsws5hDkpiP2JkI4izoJ1+xAckeuFTJUydUX9DUSEOrWhM9EE3UEwpoC1T/JhRK07x4tZFXrfbFolWkHAq7GKps5FWzxeawnzxy1lTlZcmxgMshc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWtKeYAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWtKeYAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059C51F000FF;
	Sat, 12 Sep 2026 19:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240039;
	bh=yalNRiBTd0IGpobM5ULn1DJY5baOFhgA/cN7QLK+kBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWtKeYAJph140EvPjjZ98EA8ElCWiOdH365CEngWK2BDB+hGUsO71w9Vpd6e48ER2
	 VXfzpwzglAp282BjpKExf2vYLsRmNyj0tNvGOgVrlEmcJzJI60kkMzInzNLeIMVqjV
	 Asc7PZIWLPhHoq9tGANzrgqJNHWKyNEaV9mLHd0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 787/935] ubi: fastmap: Fix missed ec updating after erasing old fastmap data block
Date: Sat, 12 Sep 2026 09:03:37 +0200
Message-ID: <20260912065544.879382161@linuxfoundation.org>
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



