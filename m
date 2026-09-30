Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582DF515961;
	Wed, 30 Sep 2026 17:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788022; cv=none; b=cEUmHORtzK0zzuuUWecKlHUACqSvaQ+8CtwSyfUFFeBDlGZYxFneuumL4B2nETDi4/9w6vYpWnKtb3I/ftNUqIK6w7bpXH+rsZuc9ZdEf/o1uEv7iyCJJAICTmyXpkVtO2+6DYowFV3YG1uBbYZr8YIapYp1YKhk5c0Psgn9Fts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788022; c=relaxed/simple;
	bh=4ZPrG4luBglJWXUnCDdXIvOZibzO0KvoM5ljjcDge3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ggtGye0NSbqDy8NrcZ/6oIefvHqBMX/weNxwNUCSK5nUkWrrfRlqWRYOIurCI5va7WUoOfQhZMrQz3wedL6OPJvqHrwoIQv4yZSHyifAQhaZa/DX2BaNLYcRn8bBQ9RMJlqbmprfwpkJZZ4GkbRBdUcHf6D+kR52IUavg+OOKvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjCKi1D1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjCKi1D1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19E61F000FF;
	Wed, 30 Sep 2026 17:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788021;
	bh=BAU312ngSzGblKJipC+IJ1RGxgY/oZ4tT7b4nK7hH7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XjCKi1D1GnjpGwrVHzh46bh+bBZVzGeKCg88ZMKSzaadmeHCrZPMyT9DY8t6tXM2V
	 o+nRMt88k8aukbUNXHokTbremrJ3dvHhCLepyCkCFjNf3xplynjijd/lHqqv6Cp4m9
	 lwQlftDGg/9BEtGOtRyieD8VPEUqSyMTS5LDFZdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 7.2 434/457] drm/xe: Add wa_14025941587 to xe2, xe3 and xe3p platforms
Date: Wed, 30 Sep 2026 17:28:59 +0200
Message-ID: <20260930152355.358950827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>

commit cc319238e3f6668f867beb381ce93727c69b7317 upstream.

Avoid programming the IDLEDLY timer to less than 5 microseconds.
Apply wa_14025941587 to Graphics Versions 20.01 to 35.11
and Media Versions 13.01 to 35.03

v2: Use xe_rtp_match_not_sriov_vf, move to local variable
    Remove warn and other knits            - Matt R

v3: Add verbose comment - Tejas

v4: Restore IDLE_DLY register on engine reset.
    Add it to GUC save-restore list. -Vivek

v5: Extend WA to Media Versions 13.01 to 35.03 - Vinay

v6: Avoid clearing inhibit switch - Bala
    Refactor code accordingly by adding idle_reg_val.

v7: Rebased with the divide-by-zero/overflow guards living in
    a separate hardening patch.

v8: Preserve the Wa_16023105232 floor (DIV_ROUND_DOWN_ULL) and the
    maxcnt == 0 guard from the hardening patch. Round up
    (DIV_ROUND_UP_ULL) the Wa_14025941587 minimum conversion instead,
    so the tick-quantized delay cannot round back below 5 us.

v9: Evaluate the Wa_16023105232 xe_gt_WARN_ON() against the value
    read from hardware instead of the Wa_14025941587-bumped value,
    so it no longer fires on the driver's own floor. Re-check the
    rounded-up tick value against maxcnt and floor it if tick
    quantization pushed it back to/above maxcnt, logging via
    xe_gt_dbg since this is the driver's own value, not a hardware
    anomaly.

Assisted-by: GitHub_Copilot:claude-opus-4.8
Signed-off-by: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>
Reviewed-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://patch.msgid.link/20260916100545.779894-3-tilak.tirumalesh.tangudu@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 9453c528fc909076468ff10df1c2e334ca5a9b00)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 drivers/gpu/drm/xe/xe_guc_ads.c    |    2 
 drivers/gpu/drm/xe/xe_hw_engine.c  |   93 ++++++++++++++++++++++++++++++-------
 drivers/gpu/drm/xe/xe_wa_oob.rules |    2 
 3 files changed, 79 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/xe/xe_guc_ads.c
+++ b/drivers/gpu/drm/xe/xe_guc_ads.c
@@ -791,7 +791,7 @@ static unsigned int guc_mmio_regset_writ
 		}
 	}
 
-	if (XE_GT_WA(hwe->gt, 16023105232))
+	if (XE_GT_WA(hwe->gt, 16023105232) || XE_GT_WA(hwe->gt, 14025941587))
 		guc_mmio_regset_write_one(ads, regset_map,
 					  RING_IDLEDLY(hwe->mmio_base),
 					  count++);
--- a/drivers/gpu/drm/xe/xe_hw_engine.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine.c
@@ -577,44 +577,103 @@ static void hw_engine_init_early(struct
 	xe_reg_whitelist_process_engine(hwe);
 }
 
+static u32 idledly_floor_ticks(u32 idledly_ns, u32 idledly_units_ps)
+{
+	return DIV_ROUND_DOWN_ULL((u64)idledly_ns * 1000, idledly_units_ps);
+}
+
 static void adjust_idledly(struct xe_hw_engine *hwe)
 {
 	struct xe_gt *gt = hwe->gt;
-	u32 idledly, maxcnt;
+	u32 idledly, idledly_hw, idledly_reg_val, maxcnt;
 	u32 idledly_units_ps = 8 * gt->info.timestamp_base;
 	u32 maxcnt_units_ns = 640;
-	bool inhibit_switch = 0;
+	bool inhibit_switch = false;
 	bool wa_applied = false;
+	bool clamped_below_maxcnt = false;
+
+	if ((!IS_SRIOV_VF(gt_to_xe(gt)) && XE_GT_WA(gt, 16023105232)) ||
+	    XE_GT_WA(gt, 14025941587)) {
+		u32 mincnt_idledly_ns = 5000;
 
-	if (!IS_SRIOV_VF(gt_to_xe(gt)) && XE_GT_WA(gt, 16023105232)) {
 		/* xe_gt_clock_init() warns and zeroes timestamp_base on unknown crystal clock. */
 		if (!idledly_units_ps)
 			return;
 
-		idledly = xe_mmio_read32(&gt->mmio, RING_IDLEDLY(hwe->mmio_base));
+		idledly_reg_val = xe_mmio_read32(&gt->mmio, RING_IDLEDLY(hwe->mmio_base));
 		maxcnt = xe_mmio_read32(&gt->mmio, RING_PWRCTX_MAXCNT(hwe->mmio_base));
 
-		inhibit_switch = idledly & INHIBIT_SWITCH_UNTIL_PREEMPTED;
-		idledly = REG_FIELD_GET(IDLE_DELAY, idledly);
+		inhibit_switch = idledly_reg_val & INHIBIT_SWITCH_UNTIL_PREEMPTED;
+		idledly = REG_FIELD_GET(IDLE_DELAY, idledly_reg_val);
 		idledly = DIV_ROUND_CLOSEST_ULL((u64)idledly * idledly_units_ps, 1000);
+		idledly_hw = idledly;
 		maxcnt = REG_FIELD_GET(IDLE_WAIT_TIME, maxcnt);
 		maxcnt *= maxcnt_units_ns;
 
-		/* Clear the inhibit switch without disturbing a valid delay. */
-		if (inhibit_switch)
+		/*
+		 * Wa_14025941587 is applied before Wa_16023105232, which takes
+		 * priority if the two ever conflict (not expected in practice).
+		 */
+		if (XE_GT_WA(gt, 14025941587) &&
+		    idledly < mincnt_idledly_ns) {
+			idledly = mincnt_idledly_ns;
 			wa_applied = true;
+		}
 
-		if (xe_gt_WARN_ON(gt, idledly >= maxcnt)) {
-			/* Floor below maxcnt; write 0 to still clear the inhibit bit. */
-			idledly = maxcnt ?
-				DIV_ROUND_DOWN_ULL((u64)(maxcnt - 1) * 1000,
-						   idledly_units_ps) : 0;
-			wa_applied = true;
+		if (XE_GT_WA(gt, 16023105232)) {
+			/* Clear the inhibit switch without disturbing a valid delay. */
+			if (inhibit_switch) {
+				idledly_reg_val &= ~INHIBIT_SWITCH_UNTIL_PREEMPTED;
+				wa_applied = true;
+			}
+
+			/* Warn only on the value read from hardware. */
+			xe_gt_WARN_ON(gt, idledly_hw >= maxcnt);
+
+			if (idledly >= maxcnt) {
+				/* maxcnt may be 0 if IDLE_WAIT_TIME is unprogrammed. */
+				idledly = maxcnt ? maxcnt - 1 : 0;
+				clamped_below_maxcnt = true;
+				wa_applied = true;
+			}
 		}
 
-		if (wa_applied)
-			xe_mmio_write32(&gt->mmio, RING_IDLEDLY(hwe->mmio_base),
-					REG_FIELD_PREP(IDLE_DELAY, idledly));
+		if (wa_applied) {
+			u32 idledly_ticks;
+
+			/*
+			 * Wa_16023105232 requires idledly < maxcnt, so floor
+			 * that clamp; otherwise round up to guarantee the
+			 * Wa_14025941587 minimum survives tick quantization.
+			 */
+			if (clamped_below_maxcnt)
+				idledly_ticks = idledly_floor_ticks(idledly, idledly_units_ps);
+			else
+				idledly_ticks = DIV_ROUND_UP_ULL((u64)idledly * 1000,
+								 idledly_units_ps);
+
+			/*
+			 * Tick quantization can still push the rounded-up value
+			 * to/above maxcnt; re-floor here so Wa_16023105232 keeps
+			 * priority even in that case.
+			 */
+			if (!clamped_below_maxcnt && XE_GT_WA(gt, 16023105232) &&
+			    (u64)idledly_ticks * idledly_units_ps >= (u64)maxcnt * 1000) {
+				xe_gt_dbg(gt, "idledly %s: %u ticks would exceed maxcnt=%u, so flooring\n",
+					  hwe->name, idledly_ticks, maxcnt);
+				idledly = maxcnt ? maxcnt - 1 : 0;
+				idledly_ticks = idledly_floor_ticks(idledly, idledly_units_ps);
+			}
+
+			idledly_reg_val &= ~IDLE_DELAY;
+			idledly_reg_val |= REG_FIELD_PREP(IDLE_DELAY, idledly_ticks);
+			xe_gt_dbg(gt, "idledly %s: set %u max=%u inh=%u ts=%u\n",
+				  hwe->name, idledly, maxcnt,
+				  !!inhibit_switch, gt->info.timestamp_base);
+			xe_mmio_write32(&gt->mmio,
+					RING_IDLEDLY(hwe->mmio_base),
+					idledly_reg_val);
+		}
 	}
 }
 
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -65,3 +65,5 @@
 
 14025883347	MEDIA_VERSION_RANGE(1301, 3500)
 		GRAPHICS_VERSION_RANGE(2004, 3005)
+14025941587	GRAPHICS_VERSION_RANGE(2001, 3511), FUNC(xe_rtp_match_not_sriov_vf)
+		MEDIA_VERSION_RANGE(1301, 3503), FUNC(xe_rtp_match_not_sriov_vf)


