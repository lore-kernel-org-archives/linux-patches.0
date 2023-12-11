Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64013C2D0;
	Mon, 11 Dec 2023 18:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekVBwiCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5D9C433C8;
	Mon, 11 Dec 2023 18:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319527;
	bh=lw1V1/vWuRAm4EvJy5In3JbO1E7fK08BviUAbXv9DqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekVBwiCaRQ34rnfG28ugVqUxTwNirZe/E7zXQLaTUficbhFIukH4xb/9vMAU+rr6v
	 K11rByVpUhW7tQxi7c7O/QumO8xcnK4LTvZ63f389mDzdKnTvaCfHstx15bYem9yc/
	 zh8plNHxOW1uBaCgWXEOWeDN8bdGQ0OA6+3tJvYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/244] RDMA/irdma: Ensure iWarp QP queue memory is OS paged aligned
Date: Mon, 11 Dec 2023 19:20:02 +0100
Message-ID: <20231211182050.666329980@linuxfoundation.org>
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

[ Upstream commit 0a5ec366de7e94192669ba08de6ed336607fd282 ]

The SQ is shared for between kernel and used by storing the kernel page
pointer and passing that to a kmap_atomic().

This then requires that the alignment is PAGE_SIZE aligned.

Fix by adding an iWarp specific alignment check.

Fixes: e965ef0e7b2c ("RDMA/irdma: Split QP handler into irdma_reg_user_mr_type_qp")
Link: https://lore.kernel.org/r/20231129202143.1434-3-shiraz.saleem@intel.com
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 4fef576e9994a..c7cb328b90f9d 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2935,6 +2935,11 @@ static int irdma_reg_user_mr_type_qp(struct irdma_mem_reg_req req,
 	int err;
 	u8 lvl;
 
+	/* iWarp: Catch page not starting on OS page boundary */
+	if (!rdma_protocol_roce(&iwdev->ibdev, 1) &&
+	    ib_umem_offset(iwmr->region))
+		return -EINVAL;
+
 	total = req.sq_pages + req.rq_pages + 1;
 	if (total > iwmr->page_cnt)
 		return -EINVAL;
-- 
2.42.0



