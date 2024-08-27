Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EBD1BD514;
	Tue, 27 Aug 2024 15:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771515; cv=none; b=HIevUwMDrDqbPRpUOC0PKQd0dWAE5doRpUdyCK2JsSXExO71wMdaW7le+qyXh/aeyhdlAD/ndIquFcrty5xeN5Mi/GL5nvOLgc7FrCyTSvLitOkwLj3CCfHoVQhLySqkCtMgYNmHUmdzS3/cajGVLq/I0GZcP6QuMikICL65988=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771515; c=relaxed/simple;
	bh=F7YYLDvnQID+YXI1/Fu7UpZddiw1P4rp006fV4PzMQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8B49/QSoR5AHOL+U1kpu+fzViDSRLYVXZ+ZIxcBckpdpifogj1D5p+4+7dkJnk2XCtkT0cqsFC76Va6DsysVjac5x69Y3a/7zDUiWmkNUz7fefRuKGemtXa2cLKz6llwuvs9AmFAehLxP81cHITxU/e8gRdfWJGz21UwsqAi+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0erS8vJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0erS8vJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C95C4DDEE;
	Tue, 27 Aug 2024 15:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771515;
	bh=F7YYLDvnQID+YXI1/Fu7UpZddiw1P4rp006fV4PzMQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0erS8vJk8qq8+IfvMcGPnQlv/+nz2nfldYehJVUI5GsG6GE3svbSfjOO0+vHWwntu
	 JwEdVFtjRBrJN8QfdgdkMG/UtN0+0cMvj8bcaWh/NJz0X5ZLSBad8s9Tz5iQeQY3Kw
	 qHBGUv1TX4PO66chxRUYzGwSzhO/EwfXAP1bxdsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Summers <stuart.summers@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 212/273] drm/xe: Fix missing workqueue destroy in xe_gt_pagefault
Date: Tue, 27 Aug 2024 16:38:56 +0200
Message-ID: <20240827143841.476802526@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Stuart Summers <stuart.summers@intel.com>

[ Upstream commit a6f78359ac75f24cac3c1bdd753c49c1877bcd82 ]

On driver reload we never free up the memory for the pagefault and
access counter workqueues. Add those destroy calls here.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Stuart Summers <stuart.summers@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/c9a951505271dc3a7aee76de7656679f69c11518.1723862633.git.stuart.summers@intel.com
(cherry picked from commit 7586fc52b14e0b8edd0d1f8a434e0de2078b7b2b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_pagefault.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_pagefault.c b/drivers/gpu/drm/xe/xe_gt_pagefault.c
index fa9e9853c53ba..67e8efcaa93f1 100644
--- a/drivers/gpu/drm/xe/xe_gt_pagefault.c
+++ b/drivers/gpu/drm/xe/xe_gt_pagefault.c
@@ -402,6 +402,18 @@ static void pf_queue_work_func(struct work_struct *w)
 
 static void acc_queue_work_func(struct work_struct *w);
 
+static void pagefault_fini(void *arg)
+{
+	struct xe_gt *gt = arg;
+	struct xe_device *xe = gt_to_xe(gt);
+
+	if (!xe->info.has_usm)
+		return;
+
+	destroy_workqueue(gt->usm.acc_wq);
+	destroy_workqueue(gt->usm.pf_wq);
+}
+
 int xe_gt_pagefault_init(struct xe_gt *gt)
 {
 	struct xe_device *xe = gt_to_xe(gt);
@@ -429,10 +441,12 @@ int xe_gt_pagefault_init(struct xe_gt *gt)
 	gt->usm.acc_wq = alloc_workqueue("xe_gt_access_counter_work_queue",
 					 WQ_UNBOUND | WQ_HIGHPRI,
 					 NUM_ACC_QUEUE);
-	if (!gt->usm.acc_wq)
+	if (!gt->usm.acc_wq) {
+		destroy_workqueue(gt->usm.pf_wq);
 		return -ENOMEM;
+	}
 
-	return 0;
+	return devm_add_action_or_reset(xe->drm.dev, pagefault_fini, gt);
 }
 
 void xe_gt_pagefault_reset(struct xe_gt *gt)
-- 
2.43.0



