Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB6C5FB90;
	Tue, 13 Feb 2024 17:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845171; cv=none; b=WAqz0jIHI5PWKDAtLjUJHWK0r3V213J8oTQ2kVkeBj2lzvwF1MaKicRp7Hj4XZjanqdqO/xn431ySqMv6Gs9Gyip4V3dlMBpkWw7J5SPxf7vGEavZ+k5xW2wKvDuqa0PWyHTauD3g86SXsFLXEVkhbbLRcutbdXWT9XAplwD8p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845171; c=relaxed/simple;
	bh=zZSXT8qLKc7v5j0P3TXPAdEwW0Vcc7YzIFPhwPa6nJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnAIxNkqSfLakwpZF7F1cj6emnsoVEcveqotpxPTHuf5ktHh+wHQ/e2wMv6XlkHt6sGo6dg2WeUI0ZZ0AnGtAAJ4eJTRVtZGBNjAw/tXVoCWdI2Pp3WZMtCJDr5jX84E7SfHYUgTBIufBKkeap+X0XF00618Y23hKLxRaVJ4888=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azq83frp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azq83frp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD10C433C7;
	Tue, 13 Feb 2024 17:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845170;
	bh=zZSXT8qLKc7v5j0P3TXPAdEwW0Vcc7YzIFPhwPa6nJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azq83frpbDIg9P6KbesR0M++bHR289P9eRNfBbE1PHCwqpic+P5XLnz0Pcz1x09DE
	 t7iximG4MlU0yu/pk9gKO323FxE0nRxv/DP7273dCPsBkH/8XWU9dwvVHFLsNvEmJb
	 9KCLxBcXFjtgarNJIcSBeiMxwCC73GiWlNgpUULc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.1 61/64] RDMA/irdma: Fix support for 64k pages
Date: Tue, 13 Feb 2024 18:21:47 +0100
Message-ID: <20240213171846.658731660@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

commit 03769f72d66edab82484449ed594cb6b00ae0223 upstream.

Virtual QP and CQ require a 4K HW page size but the driver passes
PAGE_SIZE to ib_umem_find_best_pgsz() instead.

Fix this by using the appropriate 4k value in the bitmap passed to
ib_umem_find_best_pgsz().

Fixes: 693a5386eff0 ("RDMA/irdma: Split mr alloc and free into new functions")
Link: https://lore.kernel.org/r/20231129202143.1434-4-shiraz.saleem@intel.com
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/irdma/verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2825,7 +2825,7 @@ static struct ib_mr *irdma_reg_user_mr(s
 	iwmr->ibmr.pd = pd;
 	iwmr->ibmr.device = pd->device;
 	iwmr->ibmr.iova = virt;
-	iwmr->page_size = PAGE_SIZE;
+	iwmr->page_size = SZ_4K;
 
 	if (req.reg_type == IRDMA_MEMREG_TYPE_MEM) {
 		iwmr->page_size = ib_umem_find_best_pgsz(region,


