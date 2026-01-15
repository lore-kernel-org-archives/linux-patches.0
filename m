Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA123BC4DA;
	Thu, 15 Jan 2026 17:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496506; cv=none; b=XiClCJTkM1J7Nqj3/jP0N9Tp2HJYHmbpIxG6lDI0Z3HyoWBsEfK/kFWj7ZUeQ2uDNWDAgT+tN/nfo7bkWdAviyUgsPTB7QyP5N5TNNUYz4tlrOMw4Jx4GQpq0e4ckgsKCt9fppfjdJoUtmcEIy3Zyoy8t6RqfogWT/40Tcau0u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496506; c=relaxed/simple;
	bh=skkte8LD5koAr5YkBOz2UyYgnRv5lv6VaBzpcfnYLVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOFK48bR8dGHHbbVSZu/nCkvnRy0SyruvsY4cx53dMBf6rEmencu735qeFaaKIL/O0E3DSSjy5pk14shsUcDq2lTTMYqTVsA2CB5oBOWlWcSk5cfOLcxw3cTMNgFf1oFpyNiS5X9b9ajwXcqtVJrsrohUJW7fy6VXiRMTxnE8b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1qVVXGm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1qVVXGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AACC116D0;
	Thu, 15 Jan 2026 17:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496506;
	bh=skkte8LD5koAr5YkBOz2UyYgnRv5lv6VaBzpcfnYLVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1qVVXGmTxezTXGxR9ZzDuLY18z4P7VmGW2ZlfFZqxfMhoFt4Qq11WAXb1A4+BCrs
	 LV7NudwpsDA8I92hHrJ9UN5N0Zym4SQuXhMf180iowf9zuXWHaWOBaC9i5dtOmymOM
	 HYNRYOAz4tRfzLZqdflkm9q0U6ZAuRLcZzJFE74E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Xin Wang <x.wang@intel.com>
Subject: [PATCH 6.12 029/119] drm/xe: make xe_gt_idle_disable_c6() handle the forcewake internally
Date: Thu, 15 Jan 2026 17:47:24 +0100
Message-ID: <20260115164153.013741232@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Wang <x.wang@intel.com>

commit 1313351e71181a4818afeb8dfe202e4162091ef6 upstream.

Move forcewake_get() into xe_gt_idle_enable_c6() to streamline the
code and make it easier to use.

Suggested-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Xin Wang <x.wang@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://lore.kernel.org/r/20250827000633.1369890-2-x.wang@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_gt_idle.c |   20 +++++++++++++-------
 drivers/gpu/drm/xe/xe_gt_idle.h |    2 +-
 drivers/gpu/drm/xe/xe_guc_pc.c  |   10 +---------
 3 files changed, 15 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/xe/xe_gt_idle.c
+++ b/drivers/gpu/drm/xe/xe_gt_idle.c
@@ -204,11 +204,8 @@ static void gt_idle_fini(void *arg)
 
 	xe_gt_idle_disable_pg(gt);
 
-	if (gt_to_xe(gt)->info.skip_guc_pc) {
-		XE_WARN_ON(xe_force_wake_get(gt_to_fw(gt), XE_FW_GT));
+	if (gt_to_xe(gt)->info.skip_guc_pc)
 		xe_gt_idle_disable_c6(gt);
-		xe_force_wake_put(gt_to_fw(gt), XE_FW_GT);
-	}
 
 	sysfs_remove_files(kobj, gt_idle_attrs);
 	kobject_put(kobj);
@@ -266,14 +263,23 @@ void xe_gt_idle_enable_c6(struct xe_gt *
 			RC_CTL_HW_ENABLE | RC_CTL_TO_MODE | RC_CTL_RC6_ENABLE);
 }
 
-void xe_gt_idle_disable_c6(struct xe_gt *gt)
+int xe_gt_idle_disable_c6(struct xe_gt *gt)
 {
+	unsigned int fw_ref;
+
 	xe_device_assert_mem_access(gt_to_xe(gt));
-	xe_force_wake_assert_held(gt_to_fw(gt), XE_FW_GT);
 
 	if (IS_SRIOV_VF(gt_to_xe(gt)))
-		return;
+		return 0;
+
+	fw_ref = xe_force_wake_get(gt_to_fw(gt), XE_FW_GT);
+	if (!fw_ref)
+		return -ETIMEDOUT;
 
 	xe_mmio_write32(gt, RC_CONTROL, 0);
 	xe_mmio_write32(gt, RC_STATE, 0);
+
+	xe_force_wake_put(gt_to_fw(gt), fw_ref);
+
+	return 0;
 }
--- a/drivers/gpu/drm/xe/xe_gt_idle.h
+++ b/drivers/gpu/drm/xe/xe_gt_idle.h
@@ -12,7 +12,7 @@ struct xe_gt;
 
 int xe_gt_idle_init(struct xe_gt_idle *gtidle);
 void xe_gt_idle_enable_c6(struct xe_gt *gt);
-void xe_gt_idle_disable_c6(struct xe_gt *gt);
+int xe_gt_idle_disable_c6(struct xe_gt *gt);
 void xe_gt_idle_enable_pg(struct xe_gt *gt);
 void xe_gt_idle_disable_pg(struct xe_gt *gt);
 
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -1008,15 +1008,7 @@ int xe_guc_pc_gucrc_disable(struct xe_gu
 	if (ret)
 		return ret;
 
-	ret = xe_force_wake_get(gt_to_fw(gt), XE_FORCEWAKE_ALL);
-	if (ret)
-		return ret;
-
-	xe_gt_idle_disable_c6(gt);
-
-	XE_WARN_ON(xe_force_wake_put(gt_to_fw(gt), XE_FORCEWAKE_ALL));
-
-	return 0;
+	return xe_gt_idle_disable_c6(gt);
 }
 
 /**


