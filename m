Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333F92A1D1;
	Thu, 13 Feb 2025 15:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458947; cv=none; b=UftWRjR5VddWbnD9aVg78Sz6sEZ/5pGXZPJnm6LUeGkDoFBO18gTV8h/e6uyxs/bXbBocNqLuR/DwbZBkmzEGnFGHSRWCpqNBPSIxYpRVqR1GfzSp7Okc2iUR+7fLaVFE8zrNmt4qKOtWkrHqMz97E6EGzDuQfC+CC/32ch+Jgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458947; c=relaxed/simple;
	bh=Br8sNPt2pjEb3l7aV6KRmWgaFdEUxAyKenRHTDIJfzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IB5L1R1oVa+cFw5XhAMWpGXcrOYoVRBfkOgnh8jvkwAFrBdQOMcRmB0Pghw19vuhT+3S6t/DriyH4v8bSxuAylX4dNjPyvqyFY62aU3F5vPVrdDr433h33HadrsKxqQQBQiE1MD0LCQUXHm3je+vXgNtbdxnS5X2rBs/dWG9+DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhVM35YP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhVM35YP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9620BC4CEE4;
	Thu, 13 Feb 2025 15:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458947;
	bh=Br8sNPt2pjEb3l7aV6KRmWgaFdEUxAyKenRHTDIJfzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhVM35YPC6Rv0AuL/5TGSxKvFkHQ0uLNkS77+zrLXjC1FEIsXZ6O9ARfzy/7NFHi6
	 CeHDjlvQdqFqrJNjjG9j9PXVdzmbEgq3CPaY+kL/Mp3//+ck9b6Bq6JoahXtMEV24d
	 QrmwV80Wfj5aRUOpnWP7JDK3pvY/b2wcKZTNeMpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 123/443] drm/xe/pf: Fix migration initialization
Date: Thu, 13 Feb 2025 15:24:48 +0100
Message-ID: <20250213142445.358104170@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 9f706fd8024208b0686bb8ec68589d758f765672 ]

The migration support only needs to be initialized once, but it
was incorrectly called from the xe_gt_sriov_pf_init_hw(), which
is part of the reset flow and may be called multiple times.

Fixes: d86e3737c7ab ("drm/xe/pf: Add functions to save and restore VF GuC state")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250120232443.544-1-michal.wajdeczko@intel.com
(cherry picked from commit 9ebb5846e1a3b1705f8a7cbc528888a1aa0b163e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt.c          |  4 +++-
 drivers/gpu/drm/xe/xe_gt_sriov_pf.c | 14 +++++++++++++-
 drivers/gpu/drm/xe/xe_gt_sriov_pf.h |  6 ++++++
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index 94d468d01253d..77d818beb26d3 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -532,8 +532,10 @@ static int all_fw_domain_init(struct xe_gt *gt)
 	if (IS_SRIOV_PF(gt_to_xe(gt)) && !xe_gt_is_media_type(gt))
 		xe_lmtt_init_hw(&gt_to_tile(gt)->sriov.pf.lmtt);
 
-	if (IS_SRIOV_PF(gt_to_xe(gt)))
+	if (IS_SRIOV_PF(gt_to_xe(gt))) {
+		xe_gt_sriov_pf_init(gt);
 		xe_gt_sriov_pf_init_hw(gt);
+	}
 
 	xe_force_wake_put(gt_to_fw(gt), fw_ref);
 
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
index e71fc3d2bda22..6f906c8e8108b 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
@@ -68,6 +68,19 @@ int xe_gt_sriov_pf_init_early(struct xe_gt *gt)
 	return 0;
 }
 
+/**
+ * xe_gt_sriov_pf_init - Prepare SR-IOV PF data structures on PF.
+ * @gt: the &xe_gt to initialize
+ *
+ * Late one-time initialization of the PF data.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_gt_sriov_pf_init(struct xe_gt *gt)
+{
+	return xe_gt_sriov_pf_migration_init(gt);
+}
+
 static bool pf_needs_enable_ggtt_guest_update(struct xe_device *xe)
 {
 	return GRAPHICS_VERx100(xe) == 1200;
@@ -90,7 +103,6 @@ void xe_gt_sriov_pf_init_hw(struct xe_gt *gt)
 		pf_enable_ggtt_guest_update(gt);
 
 	xe_gt_sriov_pf_service_update(gt);
-	xe_gt_sriov_pf_migration_init(gt);
 }
 
 static u32 pf_get_vf_regs_stride(struct xe_device *xe)
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf.h
index 96fab779a906f..f474509411c0c 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf.h
@@ -10,6 +10,7 @@ struct xe_gt;
 
 #ifdef CONFIG_PCI_IOV
 int xe_gt_sriov_pf_init_early(struct xe_gt *gt);
+int xe_gt_sriov_pf_init(struct xe_gt *gt);
 void xe_gt_sriov_pf_init_hw(struct xe_gt *gt);
 void xe_gt_sriov_pf_sanitize_hw(struct xe_gt *gt, unsigned int vfid);
 void xe_gt_sriov_pf_restart(struct xe_gt *gt);
@@ -19,6 +20,11 @@ static inline int xe_gt_sriov_pf_init_early(struct xe_gt *gt)
 	return 0;
 }
 
+static inline int xe_gt_sriov_pf_init(struct xe_gt *gt)
+{
+	return 0;
+}
+
 static inline void xe_gt_sriov_pf_init_hw(struct xe_gt *gt)
 {
 }
-- 
2.39.5



