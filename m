Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A821C3BE0;
	Mon, 12 May 2025 17:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072079; cv=none; b=sVgUh7/M2VW3WOOblEzz/YMeIY2zZf507cZo6tNKY7QjKqHFGxsHGIuF5rELWgxHnaNjobtG/HGdgyxnuM8TZvB6uu23js+hwVI0njIq0kMNfyjrXqfhNJSMYbE1ognW69qpKi33/tej/ENXcooAxqysEk+eb9tZPzkyIQ3REj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072079; c=relaxed/simple;
	bh=9aCA9S36QVFVxyKBBnRwlDHqGK7dbREYuLCCumc06tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMhOjhk9Gp+RAiuhzXR4VfGo7TFYPMrLQUyJo+v22HRoq8HKTziK/ys65Gxz1LW9eepMBP7O7upTdsAKguQ6RqKUqJmAbFn3T3JI95o9dRKHDyF/lzU7aPCykGNq1yazP0qWJiTyY2GT3foaz/q4mSkW2gyu0r1sU2gTsecLh/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpmyUwgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpmyUwgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5699DC4CEE7;
	Mon, 12 May 2025 17:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072079;
	bh=9aCA9S36QVFVxyKBBnRwlDHqGK7dbREYuLCCumc06tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpmyUwgz/Hx1WYSFfzBtPn8dXJHUHFxVijNH4FtimDEeykM8KzGjCnkwTPvfTTEFL
	 h3vGUeLIFwltHfDw3TaShRGLU2caJsTCxsS/qe4nRqNRbbfvcnpPMryWsAaymYJquK
	 EmgM9AQlbLaaag3BkyGQjlfLrdWcLre9t1FjgMws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Jagmeet Randhawa <jagmeet.randhawa@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.14 103/197] drm/xe: Add page queue multiplier
Date: Mon, 12 May 2025 19:39:13 +0200
Message-ID: <20250512172048.577993362@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -422,9 +422,16 @@ static int xe_alloc_pf_queue(struct xe_g
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


