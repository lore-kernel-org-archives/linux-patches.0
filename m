Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E586A354;
	Tue, 23 Jan 2024 02:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975387; cv=none; b=P73kFcmZJpq7aiKFJMOP7LMCvy71oOut6ZWs1HZe9t03sfvPlzfk0h5oKGCGyJo8U5oby3We3lcc1wIKpPNvGc0rQuhJd4neOAj05zc56vhvU/rMKH3pndhOTsQtGd8m9n7wkRcWLLbkzoMxTW0Mp+Ak4ChqHPxS1WdVxh4s9WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975387; c=relaxed/simple;
	bh=T3BmczzOZ1nVWIUezOgwyXmyKNdRuVcUa8Zocu/QQb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nn4kl1ktHPeeo9UwkYxx7UgwwSGM8Pnr9Th0fk/PImvxZL7/E/720lUp2LiiIJryQv96wteEUfdijJZC8iQhVCjuN7+9C87CSLHKQLwGPjwd+FSl23/zG8wUSFKWYBHmNTCrjb06Amkp04LJxGCQFR5TJlsHeGAJj+olBFktXWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTcfpsVp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTcfpsVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1932CC433C7;
	Tue, 23 Jan 2024 02:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975387;
	bh=T3BmczzOZ1nVWIUezOgwyXmyKNdRuVcUa8Zocu/QQb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PTcfpsVp8QFNe7pgkl4B6Bf9auQwpvN7xxYeync1rmlrNj74O1NcWCOvZI2b5dDkn
	 eXNeAOxHDtBbvinrE8ZzZXuSC4ixVsZ5/8Ddd1Hrsyvx9Jb5gddAL4/WW8sgAfJtaU
	 pOYNa57CsDV1PHnUim8Rz2XAKAmyaJyuuG5Kfe+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Sergey Gorenko <sergeygo@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 330/583] IB/iser: Prevent invalidating wrong MR
Date: Mon, 22 Jan 2024 15:56:21 -0800
Message-ID: <20240122235822.147556686@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Sergey Gorenko <sergeygo@nvidia.com>

[ Upstream commit 2f1888281e67205bd80d3e8f54dbd519a9653f26 ]

The iser_reg_resources structure has two pointers to MR but only one
mr_valid field. The implementation assumes that we use only *sig_mr when
pi_enable is true. Otherwise, we use only *mr. However, it is only
sometimes correct. Read commands without protection information occur even
when pi_enble is true. For example, the following SCSI commands have a
Data-In buffer but never have protection information: READ CAPACITY (16),
INQUIRY, MODE SENSE(6), MAINTENANCE IN. So, we use
*sig_mr for some SCSI commands and *mr for the other SCSI commands.

In most cases, it works fine because the remote invalidation is applied.
However, there are two cases when the remote invalidation is not
applicable.
 1. Small write commands when all data is sent as an immediate.
 2. The target does not support the remote invalidation feature.

The lazy invalidation is used if the remote invalidation is impossible.
Since, at the lazy invalidation, we always invalidate the MR we want to
use, the wrong MR may be invalidated.

To fix the issue, we need a field per MR that indicates the MR needs
invalidation. Since the ib_mr structure already has such a field, let's
use ib_mr.need_inval instead of iser_reg_resources.mr_valid.

Fixes: b76a439982f8 ("IB/iser: Use IB_WR_REG_MR_INTEGRITY for PI handover")
Link: https://lore.kernel.org/r/20231219072311.40989-1-sergeygo@nvidia.com
Acked-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Sergey Gorenko <sergeygo@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     | 2 --
 drivers/infiniband/ulp/iser/iser_initiator.c | 5 ++++-
 drivers/infiniband/ulp/iser/iser_memory.c    | 8 ++++----
 drivers/infiniband/ulp/iser/iser_verbs.c     | 1 -
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index dee8c97ff056..d967d5532459 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -317,12 +317,10 @@ struct iser_device {
  *
  * @mr:         memory region
  * @sig_mr:     signature memory region
- * @mr_valid:   is mr valid indicator
  */
 struct iser_reg_resources {
 	struct ib_mr                     *mr;
 	struct ib_mr                     *sig_mr;
-	u8				  mr_valid:1;
 };
 
 /**
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 39ea73f69016..f5f090dc4f1e 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -581,7 +581,10 @@ static inline int iser_inv_desc(struct iser_fr_desc *desc, u32 rkey)
 		return -EINVAL;
 	}
 
-	desc->rsc.mr_valid = 0;
+	if (desc->sig_protected)
+		desc->rsc.sig_mr->need_inval = false;
+	else
+		desc->rsc.mr->need_inval = false;
 
 	return 0;
 }
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 29ae2c6a250a..6efcb79c8efe 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -264,7 +264,7 @@ static int iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 
 	iser_set_prot_checks(iser_task->sc, &sig_attrs->check_mask);
 
-	if (rsc->mr_valid)
+	if (rsc->sig_mr->need_inval)
 		iser_inv_rkey(&tx_desc->inv_wr, mr, cqe, &wr->wr);
 
 	ib_update_fast_reg_key(mr, ib_inc_rkey(mr->rkey));
@@ -288,7 +288,7 @@ static int iser_reg_sig_mr(struct iscsi_iser_task *iser_task,
 	wr->access = IB_ACCESS_LOCAL_WRITE |
 		     IB_ACCESS_REMOTE_READ |
 		     IB_ACCESS_REMOTE_WRITE;
-	rsc->mr_valid = 1;
+	rsc->sig_mr->need_inval = true;
 
 	sig_reg->sge.lkey = mr->lkey;
 	sig_reg->rkey = mr->rkey;
@@ -313,7 +313,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 	struct ib_reg_wr *wr = &tx_desc->reg_wr;
 	int n;
 
-	if (rsc->mr_valid)
+	if (rsc->mr->need_inval)
 		iser_inv_rkey(&tx_desc->inv_wr, mr, cqe, &wr->wr);
 
 	ib_update_fast_reg_key(mr, ib_inc_rkey(mr->rkey));
@@ -336,7 +336,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 		     IB_ACCESS_REMOTE_WRITE |
 		     IB_ACCESS_REMOTE_READ;
 
-	rsc->mr_valid = 1;
+	rsc->mr->need_inval = true;
 
 	reg->sge.lkey = mr->lkey;
 	reg->rkey = mr->rkey;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 95b8eebf7e04..6801b70dc9e0 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -129,7 +129,6 @@ iser_create_fastreg_desc(struct iser_device *device,
 			goto err_alloc_mr_integrity;
 		}
 	}
-	desc->rsc.mr_valid = 0;
 
 	return desc;
 
-- 
2.43.0



