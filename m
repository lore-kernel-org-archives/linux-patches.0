Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A34C2D0;
	Mon, 11 Dec 2023 18:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcmliQ6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0061C433C7;
	Mon, 11 Dec 2023 18:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319530;
	bh=oGhPEqe4rHZZ6jzmPe1kPB3Pv2L2gXq4KjVMcorGP70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcmliQ6fCLxT9f/Et8AGpYX316FXKeLwdzyRx27koNkdFhaKaT8Y7shuI0jdektBn
	 xvG2tmJ4UGg4846jr8k2+eJPN8nuhHupZZ7MPIK8hegHg5kI9beQA7aUGGEmIWicB1
	 Si3yxbLUabQYRna5X/iNXBK0+bXxduitiTvAxIZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/244] RDMA/irdma: Fix support for 64k pages
Date: Mon, 11 Dec 2023 19:20:03 +0100
Message-ID: <20231211182050.716233930@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

[ Upstream commit 03769f72d66edab82484449ed594cb6b00ae0223 ]

Virtual QP and CQ require a 4K HW page size but the driver passes
PAGE_SIZE to ib_umem_find_best_pgsz() instead.

Fix this by using the appropriate 4k value in the bitmap passed to
ib_umem_find_best_pgsz().

Fixes: 693a5386eff0 ("RDMA/irdma: Split mr alloc and free into new functions")
Link: https://lore.kernel.org/r/20231129202143.1434-4-shiraz.saleem@intel.com
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index c7cb328b90f9d..2f1bedd3a5201 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2903,7 +2903,7 @@ static struct irdma_mr *irdma_alloc_iwmr(struct ib_umem *region,
 	iwmr->type = reg_type;
 
 	pgsz_bitmap = (reg_type == IRDMA_MEMREG_TYPE_MEM) ?
-		iwdev->rf->sc_dev.hw_attrs.page_size_cap : PAGE_SIZE;
+		iwdev->rf->sc_dev.hw_attrs.page_size_cap : SZ_4K;
 
 	iwmr->page_size = ib_umem_find_best_pgsz(region, pgsz_bitmap, virt);
 	if (unlikely(!iwmr->page_size)) {
-- 
2.42.0



