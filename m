Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50F8372EEF;
	Tue, 21 Jul 2026 20:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665957; cv=none; b=XVO95ClHG/wfWOUjIlXLeRCPPk0PbxIeuPJ5s64NIXZGKiAGyehH/6zZRsD+52y5OpsowlAps5A8srfHlTEEEDBeBWcGlkqWeVoB/AhNmeqAa45q5Z6Rtn8kMRHYnTgmgTrvR5bD4cnD5pDU3qRnFodlk9OaMAWaBH8+FTHPx2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665957; c=relaxed/simple;
	bh=VZQ/MKs/e1IDYfjB63DxS2wvdc+u7luk36IQj0ZHTVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvCqyFZ8NsoVHPnXVolDC4vEwm/3RAfu0Pl6I3I+1EBp3QEsFFsGmTRhtgbCdWsVdZZEhR57d6lLYWvtYX6M70bebmBd/3be4McFB++9o0Xezj3vl8o+G7NRtuW8RdsfNZkONi8cyZKM8tmJqrjdM3SIKd16mgDMtOS4T3jKSM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aovyLX90; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aovyLX90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F761F000E9;
	Tue, 21 Jul 2026 20:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665955;
	bh=0gn5rRmY2NpV2qban9bCaiY4E4WNmmgy0oYl03jmtWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aovyLX901L1P8h6lT0F8KqgDU/DxOcioCcsk65PFhoJB05XLoNUo4ehjWwJuHBRP/
	 jCE1oOOqusI7jPOm+VxsVBmw6rl8dDyozT2I/E9INHZH3zjl/deaPiv5n5B8ZjDzi5
	 6kmDz8aOho2//UgKc3zh1ats72rRNHhevTGYLFc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0498/1266] RDMA/irdma: Fix OOB read during CQ MR registration
Date: Tue, 21 Jul 2026 17:15:35 +0200
Message-ID: <20260721152452.986640639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 91d5b1b0d6b1b2..6928888b068eaa 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2133,7 +2133,6 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 			}
 			cqmr_shadow = &iwpbl_shadow->cq_mr;
 			info.shadow_area_pa = cqmr_shadow->cq_pbl.addr;
-			cqmr->split = true;
 		} else {
 			info.shadow_area_pa = cqmr->shadow;
 		}
@@ -2509,7 +2508,8 @@ static int irdma_handle_q_mem(struct irdma_device *iwdev,
 	case IRDMA_MEMREG_TYPE_CQ:
 		hmc_p = &cqmr->cq_pbl;
 
-		if (!cqmr->split)
+		if (!(iwdev->rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
+		      IRDMA_FEATURE_CQ_RESIZE))
 			cqmr->shadow = (dma_addr_t)arr[req->cq_pages];
 
 		if (lvl)
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index 97abd45a5cee2e..346c8adebf1cd5 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -62,7 +62,6 @@ struct irdma_hmc_pble {
 struct irdma_cq_mr {
 	struct irdma_hmc_pble cq_pbl;
 	dma_addr_t shadow;
-	bool split;
 };
 
 struct irdma_qp_mr {
-- 
2.53.0



