Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457151E487;
	Mon, 23 Jun 2025 13:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686089; cv=none; b=sSL9xND11szpJVrQ3wQ+As/xS9q/IRZSeHVXQ6i8RnegjZ4XmHtPt0igB5xWwOd5RnGPZHhBKanz+lE/trE2c6VGWPwqJwGHkudCp9GkMiGUt+d/Z7aQoTPc7LfJLSj6JzOtXfWovj6m1AfuRT0TcnEZSYgvkzevJgD4wZOAZoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686089; c=relaxed/simple;
	bh=PU9ByO6dO/doDZKDkKU5lNMnZ5JWaBXXMhzn3cnxuOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbcG09bPV2aDex5T41wv+kptyF4cE0PTUPgx8CiDkN6nTu8t6g3aYfNO2mYsVFDuNxwzqtPOiQwsGJRuE/RCZqDd8uX/91/yYa34AXKjgRSdWdkiNlX9AnIn2zw1FMUP6n8yfy3pAbLi5UqVUPYZDD6FKvqLrhWK8p03E7IDly4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OvlOEztp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OvlOEztp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD98BC4CEEA;
	Mon, 23 Jun 2025 13:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686089;
	bh=PU9ByO6dO/doDZKDkKU5lNMnZ5JWaBXXMhzn3cnxuOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OvlOEztpcW7HG3Qu500NG120AdnhhkSNTm9E+S5ZwoTPBkJjRDuYyofWiYuIxWUBe
	 zIINYb/xqnSALD7lkC+cgWGv08emoNzNnOJ8OK+EUajE4+/9igtAi9FoTCZSR2thzV
	 H2ldN6XncURgJ+HiOa6JDgH01s9k6BmulyOcQ9YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Lukasz Laguna <lukasz.laguna@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 280/592] drm/xe/vf: Fix guc_info debugfs for VFs
Date: Mon, 23 Jun 2025 15:03:58 +0200
Message-ID: <20250623130707.002905832@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit dba7d17d50b4488c697e991d18a0e55669d9fa59 ]

The guc_info debugfs attempts to read a bunch of registers that the VFs
doesn't have access to, so fix it by skipping the reads.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4775
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Lukasz Laguna <lukasz.laguna@intel.com>
Reviewed-by: Lukasz Laguna <lukasz.laguna@intel.com>
Link: https://lore.kernel.org/r/20250423173908.1571412-1-daniele.ceraolospurio@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc.c | 44 +++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index bc5714a5b36b2..f082be4af4cff 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -1508,30 +1508,32 @@ void xe_guc_print_info(struct xe_guc *guc, struct drm_printer *p)
 
 	xe_uc_fw_print(&guc->fw, p);
 
-	fw_ref = xe_force_wake_get(gt_to_fw(gt), XE_FW_GT);
-	if (!fw_ref)
-		return;
+	if (!IS_SRIOV_VF(gt_to_xe(gt))) {
+		fw_ref = xe_force_wake_get(gt_to_fw(gt), XE_FW_GT);
+		if (!fw_ref)
+			return;
+
+		status = xe_mmio_read32(&gt->mmio, GUC_STATUS);
+
+		drm_printf(p, "\nGuC status 0x%08x:\n", status);
+		drm_printf(p, "\tBootrom status = 0x%x\n",
+			   REG_FIELD_GET(GS_BOOTROM_MASK, status));
+		drm_printf(p, "\tuKernel status = 0x%x\n",
+			   REG_FIELD_GET(GS_UKERNEL_MASK, status));
+		drm_printf(p, "\tMIA Core status = 0x%x\n",
+			   REG_FIELD_GET(GS_MIA_MASK, status));
+		drm_printf(p, "\tLog level = %d\n",
+			   xe_guc_log_get_level(&guc->log));
+
+		drm_puts(p, "\nScratch registers:\n");
+		for (i = 0; i < SOFT_SCRATCH_COUNT; i++) {
+			drm_printf(p, "\t%2d: \t0x%x\n",
+				   i, xe_mmio_read32(&gt->mmio, SOFT_SCRATCH(i)));
+		}
 
-	status = xe_mmio_read32(&gt->mmio, GUC_STATUS);
-
-	drm_printf(p, "\nGuC status 0x%08x:\n", status);
-	drm_printf(p, "\tBootrom status = 0x%x\n",
-		   REG_FIELD_GET(GS_BOOTROM_MASK, status));
-	drm_printf(p, "\tuKernel status = 0x%x\n",
-		   REG_FIELD_GET(GS_UKERNEL_MASK, status));
-	drm_printf(p, "\tMIA Core status = 0x%x\n",
-		   REG_FIELD_GET(GS_MIA_MASK, status));
-	drm_printf(p, "\tLog level = %d\n",
-		   xe_guc_log_get_level(&guc->log));
-
-	drm_puts(p, "\nScratch registers:\n");
-	for (i = 0; i < SOFT_SCRATCH_COUNT; i++) {
-		drm_printf(p, "\t%2d: \t0x%x\n",
-			   i, xe_mmio_read32(&gt->mmio, SOFT_SCRATCH(i)));
+		xe_force_wake_put(gt_to_fw(gt), fw_ref);
 	}
 
-	xe_force_wake_put(gt_to_fw(gt), fw_ref);
-
 	drm_puts(p, "\n");
 	xe_guc_ct_print(&guc->ct, p, false);
 
-- 
2.39.5



