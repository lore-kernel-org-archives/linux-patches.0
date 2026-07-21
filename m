Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DD946F490;
	Tue, 21 Jul 2026 18:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659683; cv=none; b=kdlCkfXgJ80Q3qCL+tJp/edNg0nkz2DiYMqup9yzk+wXujG5puk8xiAdyYfKPblHodeec6epTxzP2ORJ6WY9UbkPo/gZ4CVrNbhIvIqa5sGvfjE0OM/IGDla/6M+wSUEXP8ilbeXTzqveh8gDZDQWgtxSPZZkAXV0Tact5WirD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659683; c=relaxed/simple;
	bh=31RUCtM+4ILXb3cXSDwFm2K1Kx8MI9j1rSJ23VKh2Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O1aQG/tVmcKU4Sx6pl/5nitIl/+tis6FRp5V99gTDrH8Pe3fwDAUW7zDXMmlSt/kkYR0JNIh+oOtcIaWd/gmgHdP2ozCwGhgWTIWKBQavhpuYLed5Umg0X9nGkMq5BAj3fcIHd1HbuUVRYg06Gle1IdlNheNzIY3H9UYmHXFUQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+2MKHLm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+2MKHLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC3A1F00A3D;
	Tue, 21 Jul 2026 18:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659680;
	bh=D4rD5bjAWZHcMGJr+rZDdCOc8o8UEP27BXxbsX8lpBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+2MKHLmMLte9nYwUdIdNFflqi6IbvO1niDtgjRnY1dvHhVJZZFcXVgOAAnYwYcpN
	 tCrrLPOY8sMvSyOCcEB+Ejbz/erHwz0zvsrWThQRArS2FnfJO9fagtG8o6WcKxz0Li
	 cPWdSC7tWicbLSyaKS63y0SXq4vGXi8dcQ8GWmT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 1611/1611] RDMA/bnxt_re: Avoid repeated requests to allocate WC pages
Date: Tue, 21 Jul 2026 17:28:47 +0200
Message-ID: <20260721152551.712581001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

commit 441baa79043431807115fd030d7d0bb14ed441a0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |    1 
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |    1 
 drivers/infiniband/hw/bnxt_re/uapi.c     |   33 +++++++++++++++++++++++++------
 3 files changed, 29 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4356,6 +4356,7 @@ int bnxt_re_alloc_ucontext(struct ib_uco
 		goto fail;
 	}
 	spin_lock_init(&uctx->sh_lock);
+	mutex_init(&uctx->wcdpi_lock);
 
 	resp.comp_mask = BNXT_RE_UCNTX_CMASK_HAVE_CCTX;
 	chip_met_rev_num = rdev->chip_ctx->chip_num;
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -142,6 +142,7 @@ struct bnxt_re_ucontext {
 	struct bnxt_re_dev	*rdev;
 	struct bnxt_qplib_dpi	dpi;
 	struct bnxt_qplib_dpi   wcdpi;
+	struct mutex		wcdpi_lock;	/* serialises WC DPI alloc/free */
 	void			*shpg;
 	spinlock_t		sh_lock;	/* protect shpg */
 	struct rdma_user_mmap_entry *shpage_mmap;
--- a/drivers/infiniband/hw/bnxt_re/uapi.c
+++ b/drivers/infiniband/hw/bnxt_re/uapi.c
@@ -98,14 +98,23 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD
 
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
@@ -132,8 +141,15 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD
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
@@ -164,11 +180,16 @@ static int alloc_page_obj_cleanup(struct
 
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


