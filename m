Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F772E7163;
	Tue, 17 Jun 2025 16:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176315; cv=none; b=Nxa5zxj5VsFFK6X6ae2QptTzLtMKvHXgbq2tqBLaahkx4vYPj2gNR44F3D5yIfs6GT66yxMQ3n+q9H0UgJPgNZ3t256WWTHiByl+zt5OopI/KnJXi3XOKwlLLJUswvSXgEvN7ikfa48b3rN+fUI0WzFMQdjvuEwhEE6o12/suAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176315; c=relaxed/simple;
	bh=uoQ0E1RHzY7/StZvEAa+GdIzfZaAy4sSQUrZi1JHtQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXUAbpl33S2GvY4uZvFHSD4NC7ehAmy5MFcGK8mpMyTjxQ61PyAU/10YJ416d3jIpdZK0PAnt1UObUPn+5GzM+sjuzDjKug9FvI5lEYtxHLUObTFDyBk/EZghq44+i8cvJq5MADqRgKcWf0ks9sr2JoPsjzW5W5JpG93euLT1RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFmIPTU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFmIPTU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991AAC4CEE3;
	Tue, 17 Jun 2025 16:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176315;
	bh=uoQ0E1RHzY7/StZvEAa+GdIzfZaAy4sSQUrZi1JHtQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFmIPTU2HdI/1gT9g1oAbBleoKsaM74uGV3TMKW+ufUsWmF53BeGKmorCrVVX/gsk
	 9Q3bstI2pKHgbKHSt+54iC2GwN/fEG0hoMbtDh+Vi9459J/zQPJmTViGz4abGTEutk
	 gDgk70tqcQF9P4MDBLNLfAQ3u1Lk5nDqENFQRNDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 157/780] drm/xe/guc: Dont expose GuC privileged debugfs files if VF
Date: Tue, 17 Jun 2025 17:17:45 +0200
Message-ID: <20250617152457.889407637@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 387444984d7b53dbaee263887cad4ea7c8e57b34 ]

Some of the GuC debugfs files require access to the data that is
not available on the VFs. Don't expose those files on the VF driver.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250403142635.1821-3-michal.wajdeczko@intel.com
Stable-dep-of: e22d7acf9f47 ("drm/xe/guc: Make creation of SLPC debugfs files conditional")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_debugfs.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_debugfs.c b/drivers/gpu/drm/xe/xe_guc_debugfs.c
index 9a1c78b89f457..f33013f8a0f38 100644
--- a/drivers/gpu/drm/xe/xe_guc_debugfs.c
+++ b/drivers/gpu/drm/xe/xe_guc_debugfs.c
@@ -103,11 +103,20 @@ static int guc_pc(struct xe_guc *guc, struct drm_printer *p)
 	return 0;
 }
 
-static const struct drm_info_list debugfs_list[] = {
+/*
+ * only for GuC debugfs files which can be safely used on the VF as well:
+ * - without access to the GuC privileged registers
+ * - without access to the PF specific GuC objects
+ */
+static const struct drm_info_list vf_safe_debugfs_list[] = {
 	{ "guc_info", .show = guc_debugfs_show, .data = xe_guc_print_info },
+	{ "guc_ctb", .show = guc_debugfs_show, .data = guc_ctb },
+};
+
+/* everything else should be added here */
+static const struct drm_info_list pf_only_debugfs_list[] = {
 	{ "guc_log", .show = guc_debugfs_show, .data = guc_log },
 	{ "guc_log_dmesg", .show = guc_debugfs_show, .data = guc_log_dmesg },
-	{ "guc_ctb", .show = guc_debugfs_show, .data = guc_ctb },
 	{ "guc_pc", .show = guc_debugfs_show, .data = guc_pc },
 };
 
@@ -115,7 +124,12 @@ void xe_guc_debugfs_register(struct xe_guc *guc, struct dentry *parent)
 {
 	struct drm_minor *minor = guc_to_xe(guc)->drm.primary;
 
-	drm_debugfs_create_files(debugfs_list,
-				 ARRAY_SIZE(debugfs_list),
+	drm_debugfs_create_files(vf_safe_debugfs_list,
+				 ARRAY_SIZE(vf_safe_debugfs_list),
 				 parent, minor);
+
+	if (!IS_SRIOV_VF(guc_to_xe(guc)))
+		drm_debugfs_create_files(pf_only_debugfs_list,
+					 ARRAY_SIZE(pf_only_debugfs_list),
+					 parent, minor);
 }
-- 
2.39.5



