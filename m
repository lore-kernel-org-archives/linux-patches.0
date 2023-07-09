Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC09522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0400FC433C8;
	Sun,  9 Jul 2023 11:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902106;
	bh=tDEY2Jg+E3JWJHtY7yGVeW6buAETziqXevjbXQJTiX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyxu/Kq3wBtV9p1YSbBjxNwFpzgSRXZxrICSZDP2mNpoqKQgm0YkFELL4TS2UjRz2
	 rj7W4WafhJjha6KZ65IDIBjIPLwZVgSymxgD1DE9V/vnKqSuU8xq9fMs/I3bKZRdku
	 OuQuUMyMp24jl/k7KqeAVMsF0FU/wPduMqTvWrhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 258/431] RDMA/irdma: avoid fortify-string warning in irdma_clr_wqes
Date: Sun,  9 Jul 2023 13:13:26 +0200
Message-ID: <20230709111457.200810186@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b002760f877c0d91ecd3c78565b52f4bbac379dd ]

Commit df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3") triggers a
warning for fortified memset():

In function 'fortify_memset_chk',
    inlined from 'irdma_clr_wqes' at drivers/infiniband/hw/irdma/uk.c:103:4:
include/linux/fortify-string.h:493:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  493 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The problem here isthat the inner array only has four 8-byte elements, so
clearing 4096 bytes overflows that. As this structure is part of an outer
array, change the code to pass a pointer to the irdma_qp_quanta instead,
and change the size argument for readability, matching the comment above
it.

Fixes: 551c46edc769 ("RDMA/irdma: Add user/kernel shared libraries")
Link: https://lore.kernel.org/r/20230523111859.2197825-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/uk.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/irdma/uk.c
index 16183e894da77..dd428d915c175 100644
--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -93,16 +93,18 @@ static int irdma_nop_1(struct irdma_qp_uk *qp)
  */
 void irdma_clr_wqes(struct irdma_qp_uk *qp, u32 qp_wqe_idx)
 {
-	__le64 *wqe;
+	struct irdma_qp_quanta *sq;
 	u32 wqe_idx;
 
 	if (!(qp_wqe_idx & 0x7F)) {
 		wqe_idx = (qp_wqe_idx + 128) % qp->sq_ring.size;
-		wqe = qp->sq_base[wqe_idx].elem;
+		sq = qp->sq_base + wqe_idx;
 		if (wqe_idx)
-			memset(wqe, qp->swqe_polarity ? 0 : 0xFF, 0x1000);
+			memset(sq, qp->swqe_polarity ? 0 : 0xFF,
+			       128 * sizeof(*sq));
 		else
-			memset(wqe, qp->swqe_polarity ? 0xFF : 0, 0x1000);
+			memset(sq, qp->swqe_polarity ? 0xFF : 0,
+			       128 * sizeof(*sq));
 	}
 }
 
-- 
2.39.2



