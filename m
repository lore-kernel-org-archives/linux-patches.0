Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0636A6311D;
	Tue, 14 May 2024 11:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685904; cv=none; b=sPUat6qfqlbgqRYDt7fdsj+EqUBXR4xy7QkM3dyzJz1XeBS6YT6JMTAKsYes+wdNtCE+fUTUyRtdnVMGPcxVfPRG3yoJgSUagspOoP6xaC+zmBuYOj0yRFsbH1iiwa0M0a5HxkEUhYGJi28g6Mr8oMbxlRhIwlO8H+Q7nO7LjfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685904; c=relaxed/simple;
	bh=2mK4isx8QZU6RVowVkcWpfm4IfqbFFjki3Mxt1ZUUTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSU3CtRsoeUQ3yDULeHfXHrsZVvm4THVMHfzN4AVawcSBcc+7w9MbFuMHXdfilrrdygnvFdkmREfQFRNIKbArUL3im6Ox7N21rVQkQ5Dfm0UitttJRO1+OolCEh8uiRlVhM4AxfITAFinHkGgUlVQ1Nb1mF4OJG3dJy8s6YXDD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfnWfmdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfnWfmdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65341C2BD10;
	Tue, 14 May 2024 11:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685903;
	bh=2mK4isx8QZU6RVowVkcWpfm4IfqbFFjki3Mxt1ZUUTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfnWfmdlTT+Iadw1X8WrASdafAkBpOe3ge252XnuKfvcMBjAXJdwfzW+3Nh7Si2BE
	 X0On/zO5SE89yKtb3zTg1OhRCLeurdRynvgy03hHMhX/r5I87+zvfNkXVJW2jtykQO
	 JGv+oRfcFYfqDNZkoFj1dFAqGGEVVebKpRp/Dqzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gnattu OC <gnattuoc@me.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Chris Wilson <chris.p.wilson@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Krzysztof Gibala <krzysztof.gibala@intel.com>
Subject: [PATCH 6.6 273/301] drm/i915/gt: Automate CCS Mode setting during engine resets
Date: Tue, 14 May 2024 12:19:04 +0200
Message-ID: <20240514101042.573933855@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Shyti <andi.shyti@linux.intel.com>

commit 51c1b42a232f17743cd825be6790cb64735ff98f upstream.

We missed setting the CCS mode during resume and engine resets.
Create a workaround to be added in the engine's workaround list.
This workaround sets the XEHP_CCS_MODE value at every reset.

The issue can be reproduced by running:

  $ clpeak --kernel-latency

Without resetting the CCS mode, we encounter a fence timeout:

  Fence expiration time out i915-0000:03:00.0:clpeak[2387]:2!

Fixes: 6db31251bb26 ("drm/i915/gt: Enable only one CCS for compute workload")
Reported-by: Gnattu OC <gnattuoc@me.com>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/10895
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Chris Wilson <chris.p.wilson@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: <stable@vger.kernel.org> # v6.2+
Tested-by: Gnattu OC <gnattuoc@me.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Tested-by: Krzysztof Gibala <krzysztof.gibala@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240426000723.229296-1-andi.shyti@linux.intel.com
(cherry picked from commit 4cfca03f76413db115c3cc18f4370debb1b81b2b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_gt_ccs_mode.c |    6 +++---
 drivers/gpu/drm/i915/gt/intel_gt_ccs_mode.h |    2 +-
 drivers/gpu/drm/i915/gt/intel_workarounds.c |    4 +++-
 3 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_gt_ccs_mode.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_ccs_mode.c
@@ -8,14 +8,14 @@
 #include "intel_gt_ccs_mode.h"
 #include "intel_gt_regs.h"
 
-void intel_gt_apply_ccs_mode(struct intel_gt *gt)
+unsigned int intel_gt_apply_ccs_mode(struct intel_gt *gt)
 {
 	int cslice;
 	u32 mode = 0;
 	int first_ccs = __ffs(CCS_MASK(gt));
 
 	if (!IS_DG2(gt->i915))
-		return;
+		return 0;
 
 	/* Build the value for the fixed CCS load balancing */
 	for (cslice = 0; cslice < I915_MAX_CCS; cslice++) {
@@ -35,5 +35,5 @@ void intel_gt_apply_ccs_mode(struct inte
 						     XEHP_CCS_MODE_CSLICE_MASK);
 	}
 
-	intel_uncore_write(gt->uncore, XEHP_CCS_MODE, mode);
+	return mode;
 }
--- a/drivers/gpu/drm/i915/gt/intel_gt_ccs_mode.h
+++ b/drivers/gpu/drm/i915/gt/intel_gt_ccs_mode.h
@@ -8,6 +8,6 @@
 
 struct intel_gt;
 
-void intel_gt_apply_ccs_mode(struct intel_gt *gt);
+unsigned int intel_gt_apply_ccs_mode(struct intel_gt *gt);
 
 #endif /* __INTEL_GT_CCS_MODE_H__ */
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -2828,6 +2828,7 @@ add_render_compute_tuning_settings(struc
 static void ccs_engine_wa_mode(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 {
 	struct intel_gt *gt = engine->gt;
+	u32 mode;
 
 	if (!IS_DG2(gt->i915))
 		return;
@@ -2844,7 +2845,8 @@ static void ccs_engine_wa_mode(struct in
 	 * After having disabled automatic load balancing we need to
 	 * assign all slices to a single CCS. We will call it CCS mode 1
 	 */
-	intel_gt_apply_ccs_mode(gt);
+	mode = intel_gt_apply_ccs_mode(gt);
+	wa_masked_en(wal, XEHP_CCS_MODE, mode);
 }
 
 /*


