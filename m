Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43FB4DDB2B;
	Thu, 17 Sep 2026 15:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659173; cv=none; b=mYOS9fLynLptlz/h36ZT4+AhXt1UQwiEeUNOBofolei0GWKmCOmCo6bWR4Ykn+39et5Ap4nYcAAKxZtyE5iJ1kAqo/FFDxlfWL6G4Jh0m7Zb5r1BSdGqtbN6CtGMlZOfLCPaRYnH/KMGVUC7dl4mlUSM12uFVR2uH2I4kQ2OYeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659173; c=relaxed/simple;
	bh=VCN47LvpJqV9jXHwtxUSQyWEGzQFH33cD3ZslQO+vXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lx+x+FXErad/LgU8gKynvtCTLJkgg2JY3Lu35jfi/Eh8YS9/cY6nGC8fvquQ1TA3hSVEzfDcN3LIGwwXCeEdl3M8He54tKMcX0FSqYKDYKkZkpNrPMt7IRWlUXdSIaz7XxjQuT46slkfpP0iNDerxQ7O/doawZ+g7pfOHdz2NR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbVxiU+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbVxiU+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C2E1F000FF;
	Thu, 17 Sep 2026 15:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659161;
	bh=nJNpZ2bBFSisorP2NFdEtrgGfa09FD/e8yr5cxI7TvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UbVxiU+03BTaBesp2wjZntY4fGh111wKgydE8ovb8Gt34g/CEBt7xHvkc0dK1JN6W
	 6PlJPAs402wvMSG9tuvouN72Plijg5mvbaZXngUMZyKUeqQ2XuDhupsPDNd8BlIM5h
	 8ZpdjLX4jGrwIr1zlu9iuUuMDRaIua7pxWkim4qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Arvind Yadav <arvind.yadav@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 125/733] drm/pagemap: Reset migration page count on eviction retry
Date: Thu, 17 Sep 2026 16:07:13 +0100
Message-ID: <20260917151354.129046558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arvind Yadav <arvind.yadav@intel.com>

[ Upstream commit 8eae39cd0adf28ba81a46090b10484cf402c0ac8 ]

drm_pagemap_evict_to_ram() may retry eviction, but mpages retains
the count from the previous attempt. A retry can therefore continue
to the copy path even when no RAM pages were populated.

Reset mpages at the retry label so it reflects only the current
attempt.

Fixes: 99624bdff867 ("drm/gpusvm: Add support for GPU Shared Virtual Memory")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260728090304.1264759-1-arvind.yadav@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_pagemap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 72ca5a48d4a66..89e1ddff84dd2 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -1313,7 +1313,7 @@ int drm_pagemap_evict_to_ram(struct drm_pagemap_devmem *devmem_allocation)
 {
 	const struct drm_pagemap_devmem_ops *ops = devmem_allocation->ops;
 	struct drm_pagemap_iova_state state = {};
-	unsigned long npages, mpages = 0;
+	unsigned long npages, mpages;
 	struct page **pages;
 	unsigned long *src, *dst;
 	struct drm_pagemap_addr *pagemap_addr;
@@ -1324,6 +1324,7 @@ int drm_pagemap_evict_to_ram(struct drm_pagemap_devmem *devmem_allocation)
 	npages = devmem_allocation->size >> PAGE_SHIFT;
 
 retry:
+	mpages = 0;
 	if (!mmget_not_zero(devmem_allocation->mm))
 		return -EFAULT;
 
-- 
2.53.0



