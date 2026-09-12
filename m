Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F88F399004;
	Sat, 12 Sep 2026 20:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243235; cv=none; b=o/rPW4yclG9C1SFr+TgAkTDvPj6DGkaE3UlCKYuH3d9x+CIWMc/3uDlyiZ2MWEsdRoNuGY3E6RLIQ1qk144U9xSjWj42RJB1kwEjAQ1VxuP3TBxW555bKlPiwNBjoRdQMnf4GSgk2sKT64yQ0ZyM89dtvv/U0ZaF7kowSbl32xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243235; c=relaxed/simple;
	bh=vyT9rMjOi89XL2r6gZSM2dvbwTJgb0Kr7pwZOxmFw2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cakk+lFSdWGeT+xVU8T4aDTCqkK+N1uahSedu6cl8/qpKDm/oFIfFK/javrnqu5QzTDdArmPt9x6MpiBIqBPpXqbCNzynxY8Z0ub6FnnWnvKNUz5Abk/OvEcAYCtoHa6fFu1vsFPGn2sCg/aSAYUFAwLOyFbajkNl4+ZFT4DSqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVhXl6Iw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVhXl6Iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B9F1F000FF;
	Sat, 12 Sep 2026 20:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243234;
	bh=CPzcqR0LKOuOaBTn2hrOUKOMjI2TCWzTC2KMOWpdar0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OVhXl6Iw0mTXzntC1IWPfvHdEkJTpxDBSiQvQk3RRNrzmYheUjM1HWFCR9/V8ogpi
	 p0DWSYE77wfNAF7jHPP5AklEgTn7qLmuaR990PtCEO3s95aI1NOZmv0XB1qh9itcfZ
	 A+eYf7J6nfXnpAaqg6bk+6e88FZ2/o0fOJjz+Mzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 683/798] ubi: fastmap: Allocate memory with GFP_NOFS in ubi_update_fastmap
Date: Sat, 12 Sep 2026 09:05:11 +0200
Message-ID: <20260912065532.758950227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit a033ab4fec5fd9194d1b6c0306efbdc75f70b142 ]

Function ubi_update_fastmap could be called in IO context, for example:
 ubifs_writepage
  do_writepage
   ubifs_jnl_write_data
    write_head
     ubifs_wbuf_write_nolock
      ubifs_leb_write
       ubi_leb_write
        ubi_eba_write_leb
	 try_write_vid_and_data
	  ubi_wl_get_peb
	   ubi_update_fastmap
	    erase_block

So it's better to allocate memory with GFP_NOFS mode, in case waiting
page writeback(dead loop).

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Stable-dep-of: 420477a84f1e ("UBI: Preserve torture flag when rescheduling failed erasures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/fastmap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index f579493b24b80..d7a4fbe8512bf 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -20,7 +20,7 @@ static inline unsigned long *init_seen(struct ubi_device *ubi)
 	if (!ubi_dbg_chk_fastmap(ubi))
 		return NULL;
 
-	ret = bitmap_zalloc(ubi->peb_count, GFP_KERNEL);
+	ret = bitmap_zalloc(ubi->peb_count, GFP_NOFS);
 	if (!ret)
 		return ERR_PTR(-ENOMEM);
 
@@ -106,7 +106,7 @@ static struct ubi_vid_io_buf *new_fm_vbuf(struct ubi_device *ubi, int vol_id)
 	struct ubi_vid_io_buf *new;
 	struct ubi_vid_hdr *vh;
 
-	new = ubi_alloc_vid_buf(ubi, GFP_KERNEL);
+	new = ubi_alloc_vid_buf(ubi, GFP_NOFS);
 	if (!new)
 		goto out;
 
@@ -1404,7 +1404,7 @@ static int erase_block(struct ubi_device *ubi, struct ubi_wl_entry *e)
 	struct ubi_ec_hdr *ec_hdr;
 	long long ec = e->ec;
 
-	ec_hdr = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
+	ec_hdr = kzalloc(ubi->ec_hdr_alsize, GFP_NOFS);
 	if (!ec_hdr)
 		return -ENOMEM;
 
@@ -1460,7 +1460,7 @@ static int invalidate_fastmap(struct ubi_device *ubi)
 	ubi->fm = NULL;
 
 	ret = -ENOMEM;
-	fm = kzalloc(sizeof(*fm), GFP_KERNEL);
+	fm = kzalloc(sizeof(*fm), GFP_NOFS);
 	if (!fm)
 		goto out;
 
@@ -1549,7 +1549,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 		return 0;
 	}
 
-	new_fm = kzalloc(sizeof(*new_fm), GFP_KERNEL);
+	new_fm = kzalloc(sizeof(*new_fm), GFP_NOFS);
 	if (!new_fm) {
 		up_write(&ubi->fm_eba_sem);
 		up_write(&ubi->work_sem);
-- 
2.53.0



