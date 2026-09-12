Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F9A3B27FB;
	Sat, 12 Sep 2026 19:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240057; cv=none; b=lf3gIR3S2Ilb9nwrvfB0ByqdWTJXSwm2sZmItPlU/vGLKpRrI+u3MR2I/jTYyDbVMossQhVHz446Oet4mQOzSbnNw2I68NPiOwuCHN1PzV/IUi/1jtGisvj3an95Bd1T/Hvt5ROTtTITFLEcRkDEQC3qP6cPJ4YDsHhshccngR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240057; c=relaxed/simple;
	bh=/fDjL7OL0A9NxSOBzWsv5+rk8fu2dlRAV3U/8ejHGBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvfMf60yirju2bIRnr9bfDtY+uDn5ePCf3mmJMAjr45IDTBGdXsPGbc9LNo9O3vNCpG/toBIDf9OQW+TEXrQbyPemLU9I26m0q1nFfRSYH082xjmF8D7xeqB2AUNuiI/duGIcVPnbsoZgIEuAfC8Q/uOxQw9+zagYAHjqPdOnn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZet2lg+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZet2lg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A621F000FF;
	Sat, 12 Sep 2026 19:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240054;
	bh=4sGWDFU3qsUQRmGs6slTqqwL7+o6KjUb3Pw+R2Fdh1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZet2lg+61MTk2batsoWyj7wapJJ8yNKeYyPUksECb4qXkg8ShLKnuDEwBZkXtF1n
	 eHVXJWinyvH0CkjZGEvQRfW/PzPeJTwaKhOrQ9oM4xwCkj98av28uM2snJzAfsh8zV
	 lmPXRp2PvM4HikmifR4D3Rmd5kPaS7WxsquU7mqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 790/935] ubi: Replace erase_block() with sync_erase()
Date: Sat, 12 Sep 2026 09:03:40 +0200
Message-ID: <20260912065544.948432163@linuxfoundation.org>
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

[ Upstream commit c19286d70aaa361cdb073a68a1f66232c359e2fd ]

Since erase_block() has same logic with sync_erase(), just replace it
with sync_erase(), also rename 'sync_erase()' to 'ubi_sync_erase()'.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Stable-dep-of: 420477a84f1e ("UBI: Preserve torture flag when rescheduling failed erasures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/fastmap.c | 48 ++-------------------------------------
 drivers/mtd/ubi/ubi.h     |  1 +
 drivers/mtd/ubi/wl.c      |  9 ++++----
 3 files changed, 7 insertions(+), 51 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index d7a4fbe8512bf..e448dbb7d2582 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1390,50 +1390,6 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	return ret;
 }
 
-/**
- * erase_block - Manually erase a PEB.
- * @ubi: UBI device object
- * @e: the physical eraseblock to erase
- *
- * This function returns zero in case of success and a negative error code in
- * case of failure.
- */
-static int erase_block(struct ubi_device *ubi, struct ubi_wl_entry *e)
-{
-	int err;
-	struct ubi_ec_hdr *ec_hdr;
-	long long ec = e->ec;
-
-	ec_hdr = kzalloc(ubi->ec_hdr_alsize, GFP_NOFS);
-	if (!ec_hdr)
-		return -ENOMEM;
-
-	err = ubi_io_sync_erase(ubi, e->pnum, 0);
-	if (err < 0)
-		goto out;
-
-	ec += err;
-	if (ec > UBI_MAX_ERASECOUNTER) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	ec_hdr->ec = cpu_to_be64(ec);
-	err = ubi_io_write_ec_hdr(ubi, e->pnum, ec_hdr);
-	if (err < 0)
-		goto out;
-
-	e->ec = ec;
-	spin_lock(&ubi->wl_lock);
-	if (e->ec > ubi->max_ec)
-		ubi->max_ec = e->ec;
-	spin_unlock(&ubi->wl_lock);
-
-out:
-	kfree(ec_hdr);
-	return err;
-}
-
 /**
  * invalidate_fastmap - destroys a fastmap.
  * @ubi: UBI device object
@@ -1574,7 +1530,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 		if (!tmp_e) {
 			if (old_fm && old_fm->e[i]) {
-				ret = erase_block(ubi, old_fm->e[i]);
+				ret = ubi_sync_erase(ubi, old_fm->e[i], 0);
 				if (ret < 0) {
 					ubi_err(ubi, "could not erase old fastmap PEB");
 
@@ -1626,7 +1582,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	if (old_fm) {
 		/* no fresh anchor PEB was found, reuse the old one */
 		if (!tmp_e) {
-			ret = erase_block(ubi, old_fm->e[0]);
+			ret = ubi_sync_erase(ubi, old_fm->e[0], 0);
 			if (ret < 0) {
 				ubi_err(ubi, "could not erase old anchor PEB");
 
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 0110eb3d4db6e..de475bd583256 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -902,6 +902,7 @@ int self_check_eba(struct ubi_device *ubi, struct ubi_attach_info *ai_fastmap,
 		   struct ubi_attach_info *ai_scan);
 
 /* wl.c */
+int ubi_sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e, int torture);
 int ubi_wl_get_peb(struct ubi_device *ubi);
 int ubi_wl_put_peb(struct ubi_device *ubi, int vol_id, int lnum,
 		   int pnum, int torture);
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 2f185e52de13a..d72c1b13c9e39 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -427,7 +427,7 @@ static int prot_queue_del(struct ubi_device *ubi, int pnum)
 }
 
 /**
- * sync_erase - synchronously erase a physical eraseblock.
+ * ubi_sync_erase - synchronously erase a physical eraseblock.
  * @ubi: UBI device description object
  * @e: the physical eraseblock to erase
  * @torture: if the physical eraseblock has to be tortured
@@ -435,8 +435,7 @@ static int prot_queue_del(struct ubi_device *ubi, int pnum)
  * This function returns zero in case of success and a negative error code in
  * case of failure.
  */
-static int sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
-		      int torture)
+int ubi_sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e, int torture)
 {
 	int err;
 	struct ubi_ec_hdr *ec_hdr;
@@ -1091,7 +1090,7 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
 	dbg_wl("erase PEB %d EC %d LEB %d:%d",
 	       pnum, e->ec, wl_wrk->vol_id, wl_wrk->lnum);
 
-	err = sync_erase(ubi, e, wl_wrk->torture);
+	err = ubi_sync_erase(ubi, e, wl_wrk->torture);
 	if (!err) {
 		spin_lock(&ubi->wl_lock);
 
@@ -1746,7 +1745,7 @@ static int erase_aeb(struct ubi_device *ubi, struct ubi_ainf_peb *aeb, bool sync
 	ubi->lookuptbl[e->pnum] = e;
 
 	if (sync) {
-		err = sync_erase(ubi, e, false);
+		err = ubi_sync_erase(ubi, e, false);
 		if (err)
 			goto out_free;
 
-- 
2.53.0



