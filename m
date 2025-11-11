Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE0D1F5F6;
	Tue, 11 Nov 2025 01:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823935; cv=none; b=XLEnE4Eh6n999vjVF196hh7rU1Ax5X0BIX8e/Af8Bmq1tHAp151QT0ZMaQYkOZyn+RhimBWSovPJSH8JEUbMamLJMzQYk8PlQgBSLYcswrA/Z2q829Z3szRFmvLZydJo/3uNKfz51yJgmzBLV2mWa7gMiMCO9ZOHoAvZxOwpMhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823935; c=relaxed/simple;
	bh=EiHoQZucYxvyy3fkFme/AtlH5O5PjudkAJ0lB6zJR/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSzhuQ4FifRpq4iFkVQVps0UzIOW8RPmlBwocBKNSLRnSwlgT0AZNEbXKwEn3RCfzGNSyLksozuXaxEbpB8VwafvICI8ypgxB+Xqigtc4NvyBSdEcdrMxY88ZGwGpCRUE2WKtavT3ce5NmBR7U9OCe2OnjbJ1Feh3y7WYMsIxEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNZkEEgT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNZkEEgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4897C116D0;
	Tue, 11 Nov 2025 01:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823935;
	bh=EiHoQZucYxvyy3fkFme/AtlH5O5PjudkAJ0lB6zJR/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kNZkEEgTIy+UWy7SMrsBxzpbLIf2hSGT4uwD2hqE37w5Ym5Mkkg5QaZr0QagsFYRR
	 uAeDIdvBF2joJyKCSZa63PsNBSohVDYdqtNJ0hm8P7+ktuBVyP7ZNUagLoYNZ/3ka9
	 KFAAy6627/ADgkVsDlINzOiMu9rBnuBNl2IvuNZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Xin Wang <x.wang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 369/849] drm/xe: Ensure GT is in C0 during resumes
Date: Tue, 11 Nov 2025 09:38:59 +0900
Message-ID: <20251111004545.344432931@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Wang <x.wang@intel.com>

[ Upstream commit 95d0883ac8105717f59c2dcdc0d8b9150f13aa12 ]

This patch ensures the gt will be awake for the entire duration
of the resume sequences until GuCRC takes over and GT-C6 gets
re-enabled.

Before suspending GT-C6 is kept enabled, but upon resume, GuCRC
is not yet alive to properly control the exits and some cases of
instability and corruption related to GT-C6 can be observed.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4037

Suggested-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Xin Wang <x.wang@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4037
Link: https://lore.kernel.org/r/20250827000633.1369890-3-x.wang@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index 3e301e42b2f19..9fccc7a855f30 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -18,7 +18,7 @@
 #include "xe_device.h"
 #include "xe_ggtt.h"
 #include "xe_gt.h"
-#include "xe_guc.h"
+#include "xe_gt_idle.h"
 #include "xe_i2c.h"
 #include "xe_irq.h"
 #include "xe_pcode.h"
@@ -177,6 +177,9 @@ int xe_pm_resume(struct xe_device *xe)
 	drm_dbg(&xe->drm, "Resuming device\n");
 	trace_xe_pm_resume(xe, __builtin_return_address(0));
 
+	for_each_gt(gt, xe, id)
+		xe_gt_idle_disable_c6(gt);
+
 	for_each_tile(tile, xe, id)
 		xe_wa_apply_tile_workarounds(tile);
 
@@ -547,6 +550,9 @@ int xe_pm_runtime_resume(struct xe_device *xe)
 
 	xe_rpm_lockmap_acquire(xe);
 
+	for_each_gt(gt, xe, id)
+		xe_gt_idle_disable_c6(gt);
+
 	if (xe->d3cold.allowed) {
 		err = xe_pcode_ready(xe, true);
 		if (err)
-- 
2.51.0



