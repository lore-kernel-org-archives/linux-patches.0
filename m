Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A211DEFE5;
	Tue,  8 Oct 2024 12:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390378; cv=none; b=cg0ERtSjH8Clx2PDLPPHcwAJQEvA55/Gs5by7y/Na74c5ZRVAtRyDiksW5DZ/1XiQLpbVf7vGZf/aFV0+wzHUmu/bb7LW9FdC54Nv2Z2Ty3FdyxF7HnSQVz28QiTz9czVrgUglctcDCASHp3nfoI3Js7y6P0NhQPXUefzsKhUKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390378; c=relaxed/simple;
	bh=AiBxuKCbXVWr1OcXYJVtHUUrwQ2Hm0/yWQsKXpLjqNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2LlxkE927C6horVpnZFR0IKTSL0KYmVTdN282Cygbm9yC5fGiU8zVh157qeFIVGgzoEmItYhXQsNKVAnQtxQ3/jPgihqmwI9eG/ijayRh/W6agu4B1U9lChnTFNRkedP7at/P90B4UYHOswQeAAaDQHw8xupJ8PnDnRVajH1zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvtAuXCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvtAuXCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B06C4CEC7;
	Tue,  8 Oct 2024 12:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390378;
	bh=AiBxuKCbXVWr1OcXYJVtHUUrwQ2Hm0/yWQsKXpLjqNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvtAuXCOKiXfYKQs+USvrBp/DYuCt1ZOD+N95ZchYTklwY6H6mZPp0W6kdjfblIx9
	 lGMWaHSU1XG84Tzp1obSr1QX/s03USFEY8+YNhOo0Dz9kJ0a42JxeTwSzoEo5sNMPJ
	 267p5zfjK+PCBtwfansb/OXUGFquBXvNXjCMzr/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 272/482] drm/xe: Fix memory leak on xe_alloc_pf_queue failure
Date: Tue,  8 Oct 2024 14:05:35 +0200
Message-ID: <20241008115658.984178263@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit c5f728de696caa35481fd84202dfbc9fecc18e0b ]

Simplify memory unwinding on error also fixing current memory
leak that can happen on error.

v2: use devm_kcalloc(Matt A)

Fixes: 3338e4f90c14 ("drm/xe: Use topology to determine page fault queue size")
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Stuart Summers <stuart.summers@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240826162035.20462-1-nirmoy.das@intel.com
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_pagefault.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_pagefault.c b/drivers/gpu/drm/xe/xe_gt_pagefault.c
index 28cf90e8989c6..d924fdd8f6f97 100644
--- a/drivers/gpu/drm/xe/xe_gt_pagefault.c
+++ b/drivers/gpu/drm/xe/xe_gt_pagefault.c
@@ -408,20 +408,17 @@ static void pagefault_fini(void *arg)
 {
 	struct xe_gt *gt = arg;
 	struct xe_device *xe = gt_to_xe(gt);
-	int i;
 
 	if (!xe->info.has_usm)
 		return;
 
 	destroy_workqueue(gt->usm.acc_wq);
 	destroy_workqueue(gt->usm.pf_wq);
-
-	for (i = 0; i < NUM_PF_QUEUE; ++i)
-		kfree(gt->usm.pf_queue[i].data);
 }
 
 static int xe_alloc_pf_queue(struct xe_gt *gt, struct pf_queue *pf_queue)
 {
+	struct xe_device *xe = gt_to_xe(gt);
 	xe_dss_mask_t all_dss;
 	int num_dss, num_eus;
 
@@ -437,7 +434,8 @@ static int xe_alloc_pf_queue(struct xe_gt *gt, struct pf_queue *pf_queue)
 		(num_eus + XE_NUM_HW_ENGINES) * PF_MSG_LEN_DW;
 
 	pf_queue->gt = gt;
-	pf_queue->data = kcalloc(pf_queue->num_dw, sizeof(u32), GFP_KERNEL);
+	pf_queue->data = devm_kcalloc(xe->drm.dev, pf_queue->num_dw,
+				      sizeof(u32), GFP_KERNEL);
 	if (!pf_queue->data)
 		return -ENOMEM;
 
-- 
2.43.0



