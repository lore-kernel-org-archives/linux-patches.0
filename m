Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0DA356A12;
	Sat, 17 Oct 2026 17:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259370; cv=none; b=ANsrUEyuisfOF2N7ul5RWcci2iMZGFNk+BqFKMgkWntSNReM94F4z3gK52PdGLkiOqKW1raRKXguhmujR7Glpfn1vJyZgocAnkukJTRx/zCMQQzFlWMr36+io5PKKm35qlu5+4+CUi5UcFU4og0tgutPw/SFvKJDUlKo7Wu3hlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259370; c=relaxed/simple;
	bh=m1gdixxPtd7NAVc6OiDQqLvkYopVLn26hnuLvCOnzbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WhR47jLZVdZ9GQ7OK2JnqKDJAw2aghD/ji9zQNh958gB0piKp6ZS4TJYstYu8HRwhDd2rpBuCxxTgELUyP0aOAYzlqRnG712VdYxR1xI4ueaDH2LC2W1f7KXr21ZajDPZMq51fX9tZWAGRp+xIM4m7F6iXfvWqibITlwyAQbsO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+uVJ7ug; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+uVJ7ug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FAF1F000C4;
	Sat, 17 Oct 2026 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259369;
	bh=EgxeKatpJTELd9150kwaZM5uxQv/CfMUAzUGpB//moQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+uVJ7ugCBMbym5ias/eeOY1ggkdP8DfFDLfiEUgfKrr1RyNmdjAYE9fwuffMZuu9
	 Lq3rzk1OFT4a2PWP7O8yl+r/rK2SpeYmHODxkhKjLq8ng5L/UOyTEsoc/RIdXXsjxH
	 pQ4PKqRa8p2zzYKA5Huzn+dhorCvYclcVgevsulw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1150/1674] RDMA/bnxt_re: Avoid repeated requests to allocate WC pages
Date: Sat, 17 Oct 2026 17:57:02 +0200
Message-ID: <20261017160500.666873662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 441baa79043431807115fd030d7d0bb14ed441a0 ]

Applications can request multiple WC pages for the same ucontext.
As of now, only 1 WC page per ucontext is supported. Add a lock to
avoid concurrent access and a check to fail repeated requests.
Also, if the mmap entry insert fails for the WC, free the Doorbell
page index mapped for the WC page.

Fixes: eee6268421a2 ("RDMA/bnxt_re: Move the UAPI methods to a dedicated file")
Fixes: 360da60d6c6e ("RDMA/bnxt_re: Enable low latency push")
Link: https://patch.msgid.link/r/20260615224751.232802-12-selvin.xavier@broadcom.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 34 +++++++++++++++++++-----
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |  1 +
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 9ea0c2b352a68..babcfb153394c 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4154,6 +4154,7 @@ int bnxt_re_alloc_ucontext(struct ib_ucontext *ctx, struct ib_udata *udata)
 		goto fail;
 	}
 	spin_lock_init(&uctx->sh_lock);
+	mutex_init(&uctx->wcdpi_lock);
 
 	resp.comp_mask = BNXT_RE_UCNTX_CMASK_HAVE_CCTX;
 	chip_met_rev_num = rdev->chip_ctx->chip_num;
@@ -4334,14 +4335,23 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_ALLOC_PAGE)(struct uverbs_attr_bundle *
 
 	switch (alloc_type) {
 	case BNXT_RE_ALLOC_WC_PAGE:
-		if (cctx->modes.db_push)  {
+		if (cctx->modes.db_push) {
+			mutex_lock(&uctx->wcdpi_lock);
+			/* already allocated — one WC page per context */
+			if (uctx->wcdpi.dbr) {
+				mutex_unlock(&uctx->wcdpi_lock);
+				return -EEXIST;
+			}
 			if (bnxt_qplib_alloc_dpi(&rdev->qplib_res, &uctx->wcdpi,
-						 uctx, BNXT_QPLIB_DPI_TYPE_WC))
+						 uctx, BNXT_QPLIB_DPI_TYPE_WC)) {
+				mutex_unlock(&uctx->wcdpi_lock);
 				return -ENOMEM;
+			}
 			length = PAGE_SIZE;
 			dpi = uctx->wcdpi.dpi;
 			addr = (u64)uctx->wcdpi.umdbr;
 			mmap_flag = BNXT_RE_MMAP_WC_DB;
+			mutex_unlock(&uctx->wcdpi_lock);
 		} else {
 			return -EINVAL;
 		}
@@ -4364,8 +4374,15 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_ALLOC_PAGE)(struct uverbs_attr_bundle *
 	}
 
 	entry = bnxt_re_mmap_entry_insert(uctx, addr, mmap_flag, &mmap_offset);
-	if (!entry)
+	if (!entry) {
+		if (mmap_flag == BNXT_RE_MMAP_WC_DB) {
+			mutex_lock(&uctx->wcdpi_lock);
+			bnxt_qplib_dealloc_dpi(&rdev->qplib_res, &uctx->wcdpi);
+			uctx->wcdpi.dbr = NULL;
+			mutex_unlock(&uctx->wcdpi_lock);
+		}
 		return -ENOMEM;
+	}
 
 	uobj->object = entry;
 	uverbs_finalize_uobj_create(attrs, BNXT_RE_ALLOC_PAGE_HANDLE);
@@ -4396,11 +4413,16 @@ static int alloc_page_obj_cleanup(struct ib_uobject *uobject,
 
 	switch (entry->mmap_flag) {
 	case BNXT_RE_MMAP_WC_DB:
-		if (uctx && uctx->wcdpi.dbr) {
+		if (uctx) {
 			struct bnxt_re_dev *rdev = uctx->rdev;
 
-			bnxt_qplib_dealloc_dpi(&rdev->qplib_res, &uctx->wcdpi);
-			uctx->wcdpi.dbr = NULL;
+			mutex_lock(&uctx->wcdpi_lock);
+			if (uctx->wcdpi.dbr) {
+				bnxt_qplib_dealloc_dpi(&rdev->qplib_res,
+						       &uctx->wcdpi);
+				uctx->wcdpi.dbr = NULL;
+			}
+			mutex_unlock(&uctx->wcdpi_lock);
 		}
 		break;
 	case BNXT_RE_MMAP_DBR_BAR:
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index ef910e6e2ccb7..99ab392f9e51f 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -137,6 +137,7 @@ struct bnxt_re_ucontext {
 	struct bnxt_re_dev	*rdev;
 	struct bnxt_qplib_dpi	dpi;
 	struct bnxt_qplib_dpi   wcdpi;
+	struct mutex		wcdpi_lock;	/* serialises WC DPI alloc/free */
 	void			*shpg;
 	spinlock_t		sh_lock;	/* protect shpg */
 	struct rdma_user_mmap_entry *shpage_mmap;
-- 
2.53.0



