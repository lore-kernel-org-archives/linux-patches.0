Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691F04746CF;
	Fri,  7 Aug 2026 15:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117761; cv=none; b=gvmvDRklJWOVWuf6ZFkBCa5Dh6bZf8Hxlhy9bG6Mc9VrRJkuKbsHgy0q1bS+JyebkNpolHGENMODlXdI/bWk17u8Eg2zF0n5OabaS6pUbMAZ7b1eqa+voI0X84KDIxeG/KPGVlMwLfCRA8d0HBbtgGWRyXO4R6cW/fR1nIo4jZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117761; c=relaxed/simple;
	bh=RsDImXhrvZe3shosCiHTayHyp6+zKK0UqXQcjwuUhpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OG8+QTbAuwMX1bSde4hol/B9Nz9gt5cQLOUsoIeWyg+aJ4jE++HY/m6fKHk/ngV0VykT7dNwM0yrYKqhE6Hk9YguVDM1E3zF+GHj7Olsz8E8TI4RWFCl3V5dNxPEytZAg56j0mY9qxq29bFXwnHnk8avNKIJfQ7WMoYRa2BRU84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h356cqJG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h356cqJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44961F000E9;
	Fri,  7 Aug 2026 15:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117760;
	bh=CTdDUibJF+Dw8Z6bVwjwe+rMP9884TBQlz/TlfgHxbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h356cqJG2RfHFh7p8iDayh0+L/8LZY0iTPb6/FSaYy1WN8O1uwG6yEQw5XmMIvgXM
	 P4+N+vELokR43U0y1ab5U1855E4TXB/m7WqNGP2JWqNP5MWkKqBs+VpWcieNFJXCHx
	 MJ0+rYwggaAQPVSvt9/CGc2HKbWQWi4NgCXTV+5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Raag Jadav <raag.jadav@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 431/438] drm/xe: Separate early xe_device initialization
Date: Fri,  7 Aug 2026 16:40:27 +0200
Message-ID: <20260807143437.157766459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 2841cea001b983db79dc1fdf160e65318dfda3cd ]

We would like to initialize more of the xe_device struct also from
the kunit code, as it should be safe to use most of the generic drm
or xe components without doing any additional tweaks. Separate early
xe initialization code to a new function, so it can be reused.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patch.msgid.link/20260526195452.20545-6-michal.wajdeczko@intel.com
Stable-dep-of: ba7fd1634228 ("drm/xe: Set TTM device beneficial_order to 9 (2M)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_device.c |   39 ++++++++++++++++++++++++++++-----------
 drivers/gpu/drm/xe/xe_device.h |    1 +
 2 files changed, 29 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -458,27 +458,45 @@ struct xe_device *xe_device_create(struc
 	if (IS_ERR(xe))
 		return xe;
 
+	err = xe_device_init_early(xe);
+	if (err)
+		return ERR_PTR(err);
+
+	return xe;
+}
+ALLOW_ERROR_INJECTION(xe_device_create, ERRNO); /* See xe_pci_probe() */
+
+/**
+ * xe_device_init_early() - Initialize a new &xe_device instance
+ * @xe: the &xe_device to initialize
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_device_init_early(struct xe_device *xe)
+{
+	int err;
+
 	err = ttm_device_init(&xe->ttm, &xe_ttm_funcs, xe->drm.dev,
 			      xe->drm.anon_inode->i_mapping,
 			      xe->drm.vma_offset_manager, 0);
-	if (WARN_ON(err))
-		return ERR_PTR(err);
+	if (err)
+		return err;
 
 	xe_bo_dev_init(&xe->bo_device);
 	err = drmm_add_action_or_reset(&xe->drm, xe_device_destroy, NULL);
 	if (err)
-		return ERR_PTR(err);
+		return err;
 
 	err = xe_shrinker_create(xe);
 	if (err)
-		return ERR_PTR(err);
+		return err;
 
 	xe->atomic_svm_timeslice_ms = 5;
 	xe->min_run_period_lr_ms = 5;
 
 	err = xe_irq_init(xe);
 	if (err)
-		return ERR_PTR(err);
+		return err;
 
 	xe_validation_device_init(&xe->val);
 
@@ -488,7 +506,7 @@ struct xe_device *xe_device_create(struc
 
 	err = xe_pagemap_shrinker_create(xe);
 	if (err)
-		return ERR_PTR(err);
+		return err;
 
 	xa_init_flags(&xe->usm.asid_to_vm, XA_FLAGS_ALLOC);
 
@@ -507,7 +525,7 @@ struct xe_device *xe_device_create(struc
 
 	err = xe_bo_pinned_init(xe);
 	if (err)
-		return ERR_PTR(err);
+		return err;
 
 	xe->preempt_fence_wq = alloc_ordered_workqueue("xe-preempt-fence-wq",
 						       WQ_MEM_RECLAIM);
@@ -521,16 +539,15 @@ struct xe_device *xe_device_create(struc
 		 * drmm_add_action_or_reset register above
 		 */
 		drm_err(&xe->drm, "Failed to allocate xe workqueues\n");
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	}
 
 	err = drmm_mutex_init(&xe->drm, &xe->pmt.lock);
 	if (err)
-		return ERR_PTR(err);
+		return err;
 
-	return xe;
+	return 0;
 }
-ALLOW_ERROR_INJECTION(xe_device_create, ERRNO); /* See xe_pci_probe() */
 
 static bool xe_driver_flr_disabled(struct xe_device *xe)
 {
--- a/drivers/gpu/drm/xe/xe_device.h
+++ b/drivers/gpu/drm/xe/xe_device.h
@@ -44,6 +44,7 @@ static inline struct xe_device *ttm_to_x
 }
 
 struct xe_device *xe_device_create(struct pci_dev *pdev);
+int xe_device_init_early(struct xe_device *xe);
 int xe_device_probe_early(struct xe_device *xe);
 int xe_device_probe(struct xe_device *xe);
 void xe_device_remove(struct xe_device *xe);


