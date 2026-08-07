Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40302F8E8B;
	Fri,  7 Aug 2026 15:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115654; cv=none; b=TEGlycTL2D+W5aJS08+4D+3H3uvKDi2Q+QL7c7H7ANxpo4DZhqy1DMgO0h7OFE1/pjQE8NoIfUHLYjEI0Noy2E2ndtSfJjl8hLaIpjJGFh1lmhF1WKSC2PQN7Ce5ZiI/m+0EU67bLwKlz92+GLTsG/vC8pA3Amrs/EWJgT7H7Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115654; c=relaxed/simple;
	bh=+SNMveejNDWQzFbPBmx9DI5Ma4xAJtUKPg/aZg5Rjj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9vyAG39FtxdxgKXvzRbaNupRe1KxKLt8Xyn811KEJnvYTDblkOLATeK0wWHkTJmmSENxwZ/cmwelH1TcCT9FLKR++83P1TinYnql59o3TVJ6/JZ4hAT5r3V50RQMDIcvDJQfgwCQVMiWlRg6lLXgeuq4n1Yv/WRvi5s2Kt8CS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNlNc7ou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNlNc7ou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57F51F000E9;
	Fri,  7 Aug 2026 15:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115653;
	bh=hYpQHe64bpNXD0trwqskwwqAnyqQVvk8GH4qWk507vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CNlNc7ouoV+9ru5C1fErHVyOeZDBldc7HTDChX4pQPgYfSfPvY7R/AjUuvYrEZPq4
	 OU26MXKuNBrKy7qiD2sHhL6ohd1oQ9+mPFjQgSjCUmEbJENFl9LfOKyEYTHrjdVY+T
	 EN+N/fuY8co0YOounaFw4wqmvr3BJuj8tjd62kP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 352/396] drm/xe/rtp: Ensure locking/ref counting for OA whitelists
Date: Fri,  7 Aug 2026 16:38:32 +0200
Message-ID: <20260807143431.878405823@linuxfoundation.org>
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

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit ef78e2a22f72c892fd6663f0760abd208d49a3e2 ]

Since multiple OA streams might be open in parallel on a gt, ensure that
proper locking is in place. Also ensure that OA registers are whitelisted
when the first OA stream is open and de-whitelisted after the last OA
stream is closed.

Fixes: 828a8eaf37c3 ("drm/xe/oa: Add MMIO trigger support")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patch.msgid.link/20260615224227.34880-10-ashutosh.dixit@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa_types.h      |  3 +++
 drivers/gpu/drm/xe/xe_reg_whitelist.c | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_oa_types.h b/drivers/gpu/drm/xe/xe_oa_types.h
index daf701b5d48b9..48f9520f560c2 100644
--- a/drivers/gpu/drm/xe/xe_oa_types.h
+++ b/drivers/gpu/drm/xe/xe_oa_types.h
@@ -125,6 +125,9 @@ struct xe_oa_gt {
 
 	/** @oa_unit: array of oa_units */
 	struct xe_oa_unit *oa_unit;
+
+	/** @whitelist_count: number of open streams for which oa registers are whitelisted */
+	u32 whitelist_count;
 };
 
 /**
diff --git a/drivers/gpu/drm/xe/xe_reg_whitelist.c b/drivers/gpu/drm/xe/xe_reg_whitelist.c
index e77f50da4a268..eb1d6f52f75fb 100644
--- a/drivers/gpu/drm/xe/xe_reg_whitelist.c
+++ b/drivers/gpu/drm/xe/xe_reg_whitelist.c
@@ -9,6 +9,7 @@
 #include "regs/xe_gt_regs.h"
 #include "regs/xe_oa_regs.h"
 #include "regs/xe_regs.h"
+#include "xe_assert.h"
 #include "xe_gt.h"
 #include "xe_gt_printk.h"
 #include "xe_platform_types.h"
@@ -187,6 +188,10 @@ void xe_reg_whitelist_oa_regs(struct xe_gt *gt)
 	struct xe_hw_engine *hwe;
 	enum xe_hw_engine_id id;
 
+	lockdep_assert_held(&gt->oa.gt_lock);
+	if (gt->oa.whitelist_count++)
+		return;
+
 	for_each_hw_engine(hwe, gt, id)
 		__whitelist_oa_regs(hwe, true);
 }
@@ -202,6 +207,11 @@ void xe_reg_dewhitelist_oa_regs(struct xe_gt *gt)
 	struct xe_hw_engine *hwe;
 	enum xe_hw_engine_id id;
 
+	lockdep_assert_held(&gt->oa.gt_lock);
+	xe_assert(gt_to_xe(gt), gt->oa.whitelist_count);
+	if (--gt->oa.whitelist_count)
+		return;
+
 	for_each_hw_engine(hwe, gt, id)
 		__whitelist_oa_regs(hwe, false);
 }
-- 
2.53.0



