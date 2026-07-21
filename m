Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409C8305E3B;
	Tue, 21 Jul 2026 22:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671599; cv=none; b=POUChvuMeFR93p0fyICT4Y/Z4lpl3Ptbam1xTa5Aka74mETQfkg+GOA3KNJGhLjlyddd8ECoAQR2LI85r/UMtsKhpItAD/m3c0/P+GFD9m/KvFyFnhDemic+dltVf+ERniW1ZhEp31ltJmOkss7AkqTW8J1c9hRPPtkH/9d/mR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671599; c=relaxed/simple;
	bh=DIrEF4exXhWr1H6CJUFc3we1tEBDqZOcuIoPD7bPQZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9kcDft/Fo6W+Pc7Ot5CYDvrgWUQFnawGbXnqoJ/Dy+ex5oBmFuiFGgrQYRPcCO4JQrsQ042Y0yCzzSpk2NOaB7w63b5shAw+PgK+6fho3K3zzWDTU+A5YkuBecv/TKOuDYqRAgrN1rsiRJhIfaJZQ2C4WZXkptcelOFZsVizB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDYnD+s9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDYnD+s9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E7D1F000E9;
	Tue, 21 Jul 2026 22:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671598;
	bh=P3G6UCWtqLSd1KkSfrNkR+PUr++75yseOKNaaGM6hBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lDYnD+s9+vWphTukZt3Rn2BMXpn1NoQjfCyAwhOQh87OW92uB6rud05uzRTlRLEqr
	 sKMM3iXBcY7maTLWJ2g3mplsDBai1Khq4ZqMmUSSap2yRtYkZbSQQTQ/FYjIyPqMMH
	 O6fSivZpO9gXjfwlPt/8ONcocwhvxgvTbCwIa7XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 305/843] RDMA/irdma: Fix OOB read during CQ MR registration
Date: Tue, 21 Jul 2026 17:19:00 +0200
Message-ID: <20260721152412.888976356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 4385ddd654d90245eeb83b3cb539670ab5c85ba4 ]

Sashiko pointed out an unrelated bug during a previous patch:
https://sashiko.dev/#/patchset/20260512183852.614045-1-jmoroni%40google.com

This change fixes the bug by eliminating the cqmr->split field which
was not being set properly and instead just checks the CQ resize
feature flag directly.

The cqmr->split field essentially tracks whether IRDMA_FEATURE_CQ_RESIZE
is set, but it was not being set until CQ creation time, which is _after_
CQ memory registration (the only other place where it is referenced).

As a result, it would always be false during MR registration and would
therefore cause irdma_handle_q_mem to populate cqmr->shadow even for GEN_2
HW and beyond:

    cqmr->shadow = (dma_addr_t)arr[req->cq_pages];

The issue is that for GEN_2 and beyond, req->cq_pages may be exactly equal
to iwmr->page_cnt and therefore equal to the size of arr, which would cause
an OOB read by one.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Link: https://patch.msgid.link/r/20260602214423.1315105-2-jmoroni@google.com
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 4 ++--
 drivers/infiniband/hw/irdma/verbs.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index f6409fa1d33b82..e6cf2734c684a8 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2024,7 +2024,6 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 			}
 			cqmr_shadow = &iwpbl_shadow->cq_mr;
 			info.shadow_area_pa = cqmr_shadow->cq_pbl.addr;
-			cqmr->split = true;
 		} else {
 			info.shadow_area_pa = cqmr->shadow;
 		}
@@ -2400,7 +2399,8 @@ static int irdma_handle_q_mem(struct irdma_device *iwdev,
 	case IRDMA_MEMREG_TYPE_CQ:
 		hmc_p = &cqmr->cq_pbl;
 
-		if (!cqmr->split)
+		if (!(iwdev->rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
+		      IRDMA_FEATURE_CQ_RESIZE))
 			cqmr->shadow = (dma_addr_t)arr[req->cq_pages];
 
 		if (use_pbles)
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index 13c66908411f75..9604d9dc2784c0 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -56,7 +56,6 @@ struct irdma_hmc_pble {
 struct irdma_cq_mr {
 	struct irdma_hmc_pble cq_pbl;
 	dma_addr_t shadow;
-	bool split;
 };
 
 struct irdma_qp_mr {
-- 
2.53.0



