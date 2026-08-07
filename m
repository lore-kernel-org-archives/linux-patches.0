Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A98378D76;
	Fri,  7 Aug 2026 14:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114467; cv=none; b=Ne4GK5gKt+7NSLgjEhBSPUI1xzCgQRC4UHXrHyL982aTXH00OyzgRv2c16OdeY2oV7dBQZOo7DeE/XppFQD5o/J+AZg+nwUKzL6Eyj1yis44f/zpWlyqFB4rjMOEHwvqHi2k640BvgwGb8qaTw+Z5EhH68nySB/jltPZP4Bw+tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114467; c=relaxed/simple;
	bh=QgVeFfy37r2qgGOL/zCx6pq35lW5jGlbtBXezKhfO38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEDHTjcHoSFSXo7oPPqbT/3oNSKRYBEaFJfjhkEO5AHH/d6lNDoQgxAw6djEQkbKL7GRBamO8vjrQZ4+tXm/Y3UtoLWmpzEhWvIrzZ44BNKLAXbWK8oU03pNGTKxVSjRHJ3KtPeM9q1BqrTE8hG2qyLCRHhDrchb+8wycnHxXtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXdtpXmD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXdtpXmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA701F000E9;
	Fri,  7 Aug 2026 14:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114464;
	bh=Ddg3g9gRxoxOSzqhHQZklCi1tI2rE7nK80Z4ItrWZXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXdtpXmDd5302tIGM5xLJOR2yrT7+OGIKku9scZ9pddVL1cXt2hQWWZgOkfsuV3RC
	 BCxgQY5vMj6BrvHorRRKwUAUp2v5C66+NcJBLYskuF46Q9cUT6drf3EQ5GB/JK/jeI
	 Z22BiqP4BrCfoXueh0Wd0DHdE8z3a0yW3N/nGv44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 274/337] drm/xe: Introduce xe_gt_dbg_printer()
Date: Fri,  7 Aug 2026 16:37:57 +0200
Message-ID: <20260807143424.477388155@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 26582fc61a923e81832df8d5a169bbdab095d15e ]

We didn't have GT-oriented debug level printer as it was hard to
correctly show actual callsite annotation. But this is now doable
from commit c2ef66e9ad88 ("drm/print: Improve drm_dbg_printer").

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241209232739.147417-3-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_printk.h | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt_printk.h b/drivers/gpu/drm/xe/xe_gt_printk.h
index 5dc71394372d6..11da0228cea71 100644
--- a/drivers/gpu/drm/xe/xe_gt_printk.h
+++ b/drivers/gpu/drm/xe/xe_gt_printk.h
@@ -60,6 +60,21 @@ static inline void __xe_gt_printfn_info(struct drm_printer *p, struct va_format
 	xe_gt_info(gt, "%pV", vaf);
 }
 
+static inline void __xe_gt_printfn_dbg(struct drm_printer *p, struct va_format *vaf)
+{
+	struct xe_gt *gt = p->arg;
+	struct drm_printer dbg;
+
+	/*
+	 * The original xe_gt_dbg() callsite annotations are useless here,
+	 * redirect to the tweaked drm_dbg_printer() instead.
+	 */
+	dbg = drm_dbg_printer(&gt_to_xe(gt)->drm, DRM_UT_DRIVER, NULL);
+	dbg.origin = p->origin;
+
+	drm_printf(&dbg, "GT%u: %pV", gt->info.id, vaf);
+}
+
 /**
  * xe_gt_err_printer - Construct a &drm_printer that outputs to xe_gt_err()
  * @gt: the &xe_gt pointer to use in xe_gt_err()
@@ -90,4 +105,20 @@ static inline struct drm_printer xe_gt_info_printer(struct xe_gt *gt)
 	return p;
 }
 
+/**
+ * xe_gt_dbg_printer - Construct a &drm_printer that outputs like xe_gt_dbg()
+ * @gt: the &xe_gt pointer to use in xe_gt_dbg()
+ *
+ * Return: The &drm_printer object.
+ */
+static inline struct drm_printer xe_gt_dbg_printer(struct xe_gt *gt)
+{
+	struct drm_printer p = {
+		.printfn = __xe_gt_printfn_dbg,
+		.arg = gt,
+		.origin = (const void *)_THIS_IP_,
+	};
+	return p;
+}
+
 #endif
-- 
2.53.0



