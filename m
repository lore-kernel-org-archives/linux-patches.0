Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669C01DED55;
	Tue,  8 Oct 2024 12:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390375; cv=none; b=Y7SPYL+D19tVgoNMSrBZgl+If8+3GPNZkOZogpO+fef+7aGV8uTQbgyKS8y6D33nKpSF0O1G4yQ3q8xs6pgiE2pHryfGLyZsI/iL0S/bwD69SbUbzdNSyqK9yvDWLWSTKNpDIYEhiyfRKzsm74iMGLPwxV3rGp8VXuCoi5ulw1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390375; c=relaxed/simple;
	bh=PM0m8xyBO3kV7qxtIGAkLaURMkGFU6xWyNWcL37+/Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7Uh1a8JfQ4tyiJpZA34kIGj0jldb3w7d8/XtK3QNkVs5j9FEzY7A0DQwu5EbkVkNYRvqm8b9J6Cuvj5UeGK7718+AqyqfVHvyglCKbMX3nrfrZcpOWDAxbyZnNcooRepi6OesS/OMNuUbdCj5Ia1EuRp+Zy/nI4AgHZrg41EGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzdOsDMp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzdOsDMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98029C4CEC7;
	Tue,  8 Oct 2024 12:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390375;
	bh=PM0m8xyBO3kV7qxtIGAkLaURMkGFU6xWyNWcL37+/Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzdOsDMpb3Ymlq0oU+H0hiwYFusbxfhVd7/RqG2vjZJNROdCv38TA0UapN/lUs2w9
	 qKS5IV8lO8lNbQxWIdxzmp5bHAUEGr+arSoOCEyEyDXmgvh0HPrnKZHgpmpgkBp4/G
	 EGzqHE8+bvGh7ZjLQTNsWw/tNtKqnVSZ1EdcQ9k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 271/482] drm/xe: fixup xe_alloc_pf_queue
Date: Tue,  8 Oct 2024 14:05:34 +0200
Message-ID: <20241008115658.945890800@linuxfoundation.org>
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

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 321d6b4b9cbe3dd0bc99937d5e5b4d730b5b5798 ]

kzalloc expects number of bytes, therefore we should convert the number
of dw into bytes, otherwise we are likely just accessing beyond the
array causing all kinds of carnage. Also fixup the error handling while
we are here.

v2:
 - Prefer kcalloc (dim)

Fixes: 3338e4f90c14 ("drm/xe: Use topology to determine page fault queue size")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Stuart Summers <stuart.summers@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240821171917.417386-2-matthew.auld@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_pagefault.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_pagefault.c b/drivers/gpu/drm/xe/xe_gt_pagefault.c
index ee78b4e47dfcb..28cf90e8989c6 100644
--- a/drivers/gpu/drm/xe/xe_gt_pagefault.c
+++ b/drivers/gpu/drm/xe/xe_gt_pagefault.c
@@ -437,7 +437,10 @@ static int xe_alloc_pf_queue(struct xe_gt *gt, struct pf_queue *pf_queue)
 		(num_eus + XE_NUM_HW_ENGINES) * PF_MSG_LEN_DW;
 
 	pf_queue->gt = gt;
-	pf_queue->data = kzalloc(pf_queue->num_dw, GFP_KERNEL);
+	pf_queue->data = kcalloc(pf_queue->num_dw, sizeof(u32), GFP_KERNEL);
+	if (!pf_queue->data)
+		return -ENOMEM;
+
 	spin_lock_init(&pf_queue->lock);
 	INIT_WORK(&pf_queue->worker, pf_queue_work_func);
 
-- 
2.43.0



