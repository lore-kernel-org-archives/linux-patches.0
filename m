Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9242D3AC17;
	Sat, 12 Sep 2026 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225390; cv=none; b=AgEyh78mNEKsG/j6IgO4FynAlfH/IUYKiyAxuMWIDdjoeXbH/CIArsxLr/RcEvSwpk+pUoxhDiHcxdYW+0t/42jEn/nGUDw3LfiP1NU3U2grG94scxceVdd/rYtOOBoA+QD7mYKwG63CIVR/kwf5jyySfxXoIlJNtTHlkIodpL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225390; c=relaxed/simple;
	bh=kcdy4fsSTBaeFU2H8LhMrKaS5KZQcPz0f3IXtxByPTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeOSxOaOirnoatiRdAqXLwZC6q4DA/h05SQJmomzWSg7bNOFKIdoczfgRK3hWlZo6otQFn/DeyydRIXdvtzoK7C8X7gkZ9cF73+XyWVQnNxgaW4Mlgh0waQ+G3uxPORwJh8yodQKlFfUzWvR1wE+aaoCsO+EOpd3BMymm0A9wQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJayixFE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJayixFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405101F000FF;
	Sat, 12 Sep 2026 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225389;
	bh=u5h9DWyRetIt0f0PQprSwNuKflpNi4hd17Sw38P8czM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJayixFEgxVv12bcqnWLM5+Z78NAsGlgfSA3Qnen8phEs+/DtTB1zKxDltbfQb1FE
	 GhgUy0cOMWJl+o1j+A6lOMBEihdyLWdrGTQUWLBA4Sv/aNtNDEaRNPIue21t5SE7dP
	 gxx9Sx+rQtPgUdHhjgsYs3D+kPTieNjbVxSKFFmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1181/1424] ubi: fastmap: Allocate memory with GFP_NOFS in ubi_update_fastmap
Date: Sat, 12 Sep 2026 09:00:13 +0200
Message-ID: <20260912065633.739904271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cbc1872588688..6856d9221e26b 100644
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



