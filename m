Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F881519B8;
	Mon, 12 May 2025 18:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072895; cv=none; b=RzIPYIU9lq098qnrGjT/e36cmIEKZkgEXoKitJJRTNrSm3mH7erAtWDO4fOWRu4Bl0fflta6jJT/duI2+SK0i92tzQZNGF4KGNzy1h9D/MQqlaJgXuklqn5dI2MdQ+SmPnR4K86g2X5SLsYbYTBTIkhnSzoil++ljPKMHVhEoek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072895; c=relaxed/simple;
	bh=D3wapOJyuErR4hnucNOpXVxhyQVoWl0y959qqPDLN7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzfmsE88OA15ZQ2/8wmufgLGw8lBXN0TN4ncTUgCmEl8xj8QsHTn0Mor67Dm6wjv07xhe9yePpGWG2WsTlLeafsr+x8cjI+BMQHOQLcj+IzKu5ckXKFI1dvMPz0WONRTvOqigX6Q1inBMfmIHl1iS3cn5tvXYB8LdVJxBkjiKaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBcMCS2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBcMCS2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783A3C4CEE7;
	Mon, 12 May 2025 18:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072894;
	bh=D3wapOJyuErR4hnucNOpXVxhyQVoWl0y959qqPDLN7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBcMCS2ziwxYcSUKdMq6Ls9QkybLR4KKdHXwRCQ3eDmInk0h3uDVjw92qqHjwZv5i
	 y16M+0EkRVMq2pa+NaPnnJ8BwEKCRENyZPkvqGpHKPqpSb5DufK3T+8eKvEbU9rM0y
	 WDVWP+aXr1vTPzkBKGIRH7+IwB5NwAnPWImivYFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Jagmeet Randhawa <jagmeet.randhawa@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.12 089/184] drm/xe: Add page queue multiplier
Date: Mon, 12 May 2025 19:44:50 +0200
Message-ID: <20250512172045.453224893@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

commit 391008f34e711253c5983b0bf52277cc43723127 upstream.

For an unknown reason the math to determine the PF queue size does is
not correct - compute UMD applications are overflowing the PF queue
which is fatal. A multippier of 8 fixes the problem.

Fixes: 3338e4f90c14 ("drm/xe: Use topology to determine page fault queue size")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Jagmeet Randhawa <jagmeet.randhawa@intel.com>
Link: https://lore.kernel.org/r/20250408155915.78770-1-matthew.brost@intel.com
(cherry picked from commit 29582e0ea75c95668d168b12406e3c56cf5a73c4)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_gt_pagefault.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_gt_pagefault.c
+++ b/drivers/gpu/drm/xe/xe_gt_pagefault.c
@@ -423,9 +423,16 @@ static int xe_alloc_pf_queue(struct xe_g
 	num_eus = bitmap_weight(gt->fuse_topo.eu_mask_per_dss,
 				XE_MAX_EU_FUSE_BITS) * num_dss;
 
-	/* user can issue separate page faults per EU and per CS */
+	/*
+	 * user can issue separate page faults per EU and per CS
+	 *
+	 * XXX: Multiplier required as compute UMD are getting PF queue errors
+	 * without it. Follow on why this multiplier is required.
+	 */
+#define PF_MULTIPLIER	8
 	pf_queue->num_dw =
-		(num_eus + XE_NUM_HW_ENGINES) * PF_MSG_LEN_DW;
+		(num_eus + XE_NUM_HW_ENGINES) * PF_MSG_LEN_DW * PF_MULTIPLIER;
+#undef PF_MULTIPLIER
 
 	pf_queue->gt = gt;
 	pf_queue->data = devm_kcalloc(xe->drm.dev, pf_queue->num_dw,


