Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA28D42A15B;
	Fri,  7 Aug 2026 14:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114785; cv=none; b=Ku9yV083wihzqlWO0zwc/yS9pcM3XXgmjVNUs2USeed2A0UuYaIOCPPto9A1cIBkt2zL6e3TFko+z8i/ryP580ZMwRTlbe0IjYKZ7HD+kNHnoUx58K1tUSTX3r1dwx4psvAMDUz4dtXYyLrOe7YP1kE8fG4dcQoyJz8iFJJ2WpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114785; c=relaxed/simple;
	bh=dvr4LU3IQIGfhq2evzlAj5D5d8mJmzsjI7UY+nFcDd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAjhkv2BfNIXn0/5SQK0q3oS9I71M8fg9KnA3Fv3IIbfJo+Ci9oN8heoLONK9mOEUYS/AD/u0wwfjLZF1kt0PgPwFzdOKBn2d7HlnLrbdaHiitOXqDdVqCqVZVBK3gnOqi37Kk9nx7pxHbLhSWC1kwGAGDLUbxFVsuqUTNAw0lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yoonfDim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yoonfDim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529251F00A3D;
	Fri,  7 Aug 2026 14:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114783;
	bh=2Q5WRbeCTosz+6f5fBl86pclkLC8qcbJfMNsmhAfhGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yoonfDim1jqIjyN5kxLw4ngXrbg6iDm6cUK+wb8i07sMjx9lNMlur/ZeJcSVLfbn6
	 BuHqaUcfmzPOgXaVOBhE2BrrIwycpSP57a7AiGHfuTC79x6GTxOgID8XqnGVpl095C
	 B8nNY8l9RcEclmx9itXTVnqGRgx3N4Xq2JJ0LEUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Honglei Huang <honghuan@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 006/396] drm/gpusvm: publish dpagemap early to avoid device mapping leak on error
Date: Fri,  7 Aug 2026 16:32:46 +0200
Message-ID: <20260807143424.411933985@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honglei Huang <honghuan@amd.com>

commit 7f708f51e3955bda0d77a0b67ab9bea6c97fea99 upstream.

drm_gpusvm_get_pages() only stored the local dpagemap into
svm_pages->dpagemap on the success path. If a later page failed (e.g.
-EOPNOTSUPP when ctx->allow_mixed is false) and jumped to err_unmap,
svm_pages->dpagemap was still NULL, so __drm_gpusvm_unmap_pages() skipped
device_unmap() and leaked the device mappings already created.

Assign svm_pages->dpagemap when the first device page is mapped so the
err_unmap path can device_unmap() those mappings.

This issue was found by Sashiko AI review.

Fixes: f70da6f99d4f ("drm/gpusvm: pull out drm_gpusvm_pages substructure")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Honglei Huang <honghuan@amd.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260701062800.409248-4-honghuan@amd.com
[ Adjusted for 6.18.y: drop drm_pagemap_get()/drm_pagemap_put() around the
  svm_pages->dpagemap assignment; that reference counting is not present in
  6.18 where the field is not refcounted (unmap path only clears it). ]
Signed-off-by: Honglei Huang <honghuan@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gpusvm.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index 781cd4e5b704..e5c7befe3108 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -1390,6 +1390,14 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 					err = -EAGAIN;
 					goto err_unmap;
 				}
+
+				/*
+				 * Set the dpagemap as soon as the first
+				 * device page is mapped so the err_unmap path
+				 * can device_unmap() the device mappings that
+				 * have already been created.
+				 */
+				svm_pages->dpagemap = dpagemap;
 			}
 			svm_pages->dma_addr[j] =
 				dpagemap->ops->device_map(dpagemap,
@@ -1432,10 +1440,8 @@ int drm_gpusvm_get_pages(struct drm_gpusvm *gpusvm,
 		flags.has_dma_mapping = true;
 	}
 
-	if (pagemap) {
+	if (pagemap)
 		flags.has_devmem_pages = true;
-		svm_pages->dpagemap = dpagemap;
-	}
 
 	/* WRITE_ONCE pairs with READ_ONCE for opportunistic checks */
 	WRITE_ONCE(svm_pages->flags.__flags, flags.__flags);
-- 
2.53.0



