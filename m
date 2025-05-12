Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931DB1A08CA;
	Mon, 12 May 2025 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072209; cv=none; b=q0/mxMHhb579ActGEqtinJCi9GjGPGUdWp4kfOO60gta9NdOnTMP7eAcdUbf0aSuX9M+w6ssmyCBWd5wpQ8vl1sji2vvCFCWJ5766E6Z7MPwNAnmvZxnsLzCYFINs5AjM3aFXTSxyslTGURFd4+BIARD6h08S+xk964wlv7T0QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072209; c=relaxed/simple;
	bh=TTz5V1sXApHb/9foLHtyo6LGHKU6bK4x21JhmxgLPiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8kA0GTYOMioDeWp5U4pFKScWZKT1Rc+QF0a44+89QQm0NV0j7GWN6Xaxry3aayG1f8+Lk+0n56QTAEUDSLGcQgfjq6XMeu5Z5jwp6I3GKNmbigYQQii8ThoIzL0GsEdXsUjRFfokm8Vzv3cMzBPbf16MVs5dK3VIXyA+ZTHH1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8eP7aPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8eP7aPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD53C4CEE7;
	Mon, 12 May 2025 17:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072209;
	bh=TTz5V1sXApHb/9foLHtyo6LGHKU6bK4x21JhmxgLPiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8eP7aPyQ/mqtOLtzlbCDV49P1P4KGv1dxv+MlR5sDKVdnnTw0RgsojCND5OZ/Er9
	 +uPf4SzE/NmhzWEWOyvUvL7WuZ1nPb//qbPanJasalCowSDnlRFDYQjVtfx6odhLxq
	 tcNvADDE/uFrC7bs9YsEX9phJtTeZmcgLHdGQdkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 169/197] drm/xe: Release force wake first then runtime power
Date: Mon, 12 May 2025 19:40:19 +0200
Message-ID: <20250512172051.266470290@linuxfoundation.org>
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

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 9d271a4f5ba52520e448ab223b1a91c6e35f17c7 ]

xe_force_wake_get() is dependent on xe_pm_runtime_get(), so for
the release path, xe_force_wake_put() should be called first then
xe_pm_runtime_put().
Combine the error path and normal path together with goto.

Fixes: 85d547608ef5 ("drm/xe/xe_gt_debugfs: Update handling of xe_force_wake_get return")
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://lore.kernel.org/r/20250507022302.2187527-1-shuicheng.lin@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 432cd94efdca06296cc5e76d673546f58aa90ee1)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_debugfs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_debugfs.c b/drivers/gpu/drm/xe/xe_gt_debugfs.c
index 2d63a69cbfa38..f7005a3643e62 100644
--- a/drivers/gpu/drm/xe/xe_gt_debugfs.c
+++ b/drivers/gpu/drm/xe/xe_gt_debugfs.c
@@ -92,22 +92,23 @@ static int hw_engines(struct xe_gt *gt, struct drm_printer *p)
 	struct xe_hw_engine *hwe;
 	enum xe_hw_engine_id id;
 	unsigned int fw_ref;
+	int ret = 0;
 
 	xe_pm_runtime_get(xe);
 	fw_ref = xe_force_wake_get(gt_to_fw(gt), XE_FORCEWAKE_ALL);
 	if (!xe_force_wake_ref_has_domain(fw_ref, XE_FORCEWAKE_ALL)) {
-		xe_pm_runtime_put(xe);
-		xe_force_wake_put(gt_to_fw(gt), fw_ref);
-		return -ETIMEDOUT;
+		ret = -ETIMEDOUT;
+		goto fw_put;
 	}
 
 	for_each_hw_engine(hwe, gt, id)
 		xe_hw_engine_print(hwe, p);
 
+fw_put:
 	xe_force_wake_put(gt_to_fw(gt), fw_ref);
 	xe_pm_runtime_put(xe);
 
-	return 0;
+	return ret;
 }
 
 static int powergate_info(struct xe_gt *gt, struct drm_printer *p)
-- 
2.39.5



