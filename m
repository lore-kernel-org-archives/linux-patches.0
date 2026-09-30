Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA552D594F;
	Wed, 30 Sep 2026 18:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793442; cv=none; b=tV+DvI4pnVlrMbCV1UnliuipWsbLN5Q68LmBgDzuuC/HELqTgUkdXYz/rfv/I+8HpqBKe6B536wqFOJgA9jRLKuwV2GG+cOOFaSLugxW+a9jqdkXbo4fJlNHSsKCl2IMb/3Q1oWnsDjKJBMKNxC2LgVSuuDAKfWbgkNVNoyv7Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793442; c=relaxed/simple;
	bh=c5nRsJUtWywxNBsQ5DYifsbvn+vqoTeeTi41N7HMliU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuXdNYPm255es0HvSxKJcJpkEbPOWCh2hIzutie7ueIWiDfEjIaqNRhDurjtcGcC3paf5+sAHVwpFDLa99W00Rktn63c4KQ32smxo/rMrZgYAXis4tFY/pQF63MsS1V78WRZ9nbJnwEOBf71vRxEhnxhQETqIDXA/HQBMYP+lLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oCwigkdD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCwigkdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D03C1F000FF;
	Wed, 30 Sep 2026 18:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793441;
	bh=UgNvR23kX54ROiHWZsfTbYOv0Ckxgr7jTPB0oalWHB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oCwigkdDTSWgaOUIY66I0QhtLYo3TT5F20eN1iesofGP7oIkCo9rgsciFmTSEVEAP
	 b9eNLHsSxumWUX25n954BR0O2B4FQv2mJP0ju93sNlPw52i9OzDfqiuYOqLkU1ICfZ
	 6VdPwez8RY0SQ16czv7U0tV9y4Ol8q/fvfWpBBwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.18 255/395] drm/xe: harden adjust_idledly() against divide-by-zero and overflow
Date: Wed, 30 Sep 2026 17:28:37 +0200
Message-ID: <20260930152346.185016346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>

commit 90f467577ebc28c5bc4ba2f0f1b83a4419fb0740 upstream.

adjust_idledly() has several corner-case issues flagged during review:

  1. If xe_gt_clock_init() failed to recognise the crystal clock,
     gt->info.timestamp_base is 0, which makes idledly_units_ps also 0.
     The subsequent DIV_ROUND_CLOSEST(..., idledly_units_ps) is then a
     divide-by-zero and panics the kernel.

  2. The tick-to-ns conversions are done in u32:
        idledly * idledly_units_ps, (maxcnt - 1) * 1000
     Both overflow u32 before DIV_ROUND_CLOSEST() sees them.

  3. If IDLE_WAIT_TIME reads back as 0, maxcnt evaluates to 0 and
     the maxcnt - 1 clamp wraps to 0xFFFFFFFF in u32.

  4. The register only stores whole ticks, so the clamped ns value has
     to be converted to ticks and back. DIV_ROUND_CLOSEST() can round
     that conversion up past maxcnt:

       maxcnt = 640 ns, one tick = 666664 ps

       clamp:        maxcnt - 1        = 639 ns
       ns -> ticks:  639000 / 666664   = 0.958 -> rounds to 1 tick
       tick -> ns:    1 * 666664 / 1000 = 667 ns

     667 ns is programmed into RING_IDLEDLY, but 667 >= maxcnt (640),
     so xe_gt_WARN_ON() fires again on every subsequent init.

Return early if timestamp_base is 0 (the unknown-crystal path).
Do the conversions in u64 via the *_ULL() helpers so they cannot wrap.
Clamp with a floor (DIV_ROUND_DOWN_ULL) so the programmed delay stays
strictly below maxcnt, and guard the maxcnt == 0 case with a zero delay
while still writing RING_IDLEDLY so INHIBIT_SWITCH_UNTIL_PREEMPTED is
cleared.

v2: Drop the redundant warn on the timestamp_base == 0 path;
    xe_gt_clock_init() already warns on an unrecognised crystal clock.
    Keep the early return to avoid the divide-by-zero. - Vinay

v3: Field-mask the RING_IDLEDLY write with REG_FIELD_PREP(IDLE_DELAY, ...)
    instead of writing the raw tick count, which could clobber
    INHIBIT_SWITCH_UNTIL_PREEMPTED and reserved bits. Split the
    inhibit-switch clear from the maxcnt clamp so a set inhibit bit no
    longer forces a needless delay overwrite when the delay itself is
    already valid. Use gt_to_xe(gt) instead of gt_to_xe(hwe->gt).

Fixes: d2de4410a88f ("drm/xe: Apply Wa_16023105232")
Cc: stable@vger.kernel.org
Assisted-by: GitHub_Copilot:claude-opus-4.8
Signed-off-by: Tangudu Tilak Tirumalesh <tilak.tirumalesh.tangudu@intel.com>
Reviewed-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://patch.msgid.link/20260916100545.779894-2-tilak.tirumalesh.tangudu@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit d864065ea25e9d12897c175de9176ce46677e176)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_hw_engine.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/xe/xe_hw_engine.c
+++ b/drivers/gpu/drm/xe/xe_hw_engine.c
@@ -577,22 +577,37 @@ static void adjust_idledly(struct xe_hw_
 	u32 idledly_units_ps = 8 * gt->info.timestamp_base;
 	u32 maxcnt_units_ns = 640;
 	bool inhibit_switch = 0;
+	bool wa_applied = false;
+
+	if (!IS_SRIOV_VF(gt_to_xe(gt)) && XE_GT_WA(gt, 16023105232)) {
+		/* xe_gt_clock_init() warns and zeroes timestamp_base on unknown crystal clock. */
+		if (!idledly_units_ps)
+			return;
 
-	if (!IS_SRIOV_VF(gt_to_xe(hwe->gt)) && XE_GT_WA(gt, 16023105232)) {
 		idledly = xe_mmio_read32(&gt->mmio, RING_IDLEDLY(hwe->mmio_base));
 		maxcnt = xe_mmio_read32(&gt->mmio, RING_PWRCTX_MAXCNT(hwe->mmio_base));
 
 		inhibit_switch = idledly & INHIBIT_SWITCH_UNTIL_PREEMPTED;
 		idledly = REG_FIELD_GET(IDLE_DELAY, idledly);
-		idledly = DIV_ROUND_CLOSEST(idledly * idledly_units_ps, 1000);
+		idledly = DIV_ROUND_CLOSEST_ULL((u64)idledly * idledly_units_ps, 1000);
 		maxcnt = REG_FIELD_GET(IDLE_WAIT_TIME, maxcnt);
 		maxcnt *= maxcnt_units_ns;
 
-		if (xe_gt_WARN_ON(gt, idledly >= maxcnt || inhibit_switch)) {
-			idledly = DIV_ROUND_CLOSEST(((maxcnt - 1) * 1000),
-						    idledly_units_ps);
-			xe_mmio_write32(&gt->mmio, RING_IDLEDLY(hwe->mmio_base), idledly);
+		/* Clear the inhibit switch without disturbing a valid delay. */
+		if (inhibit_switch)
+			wa_applied = true;
+
+		if (xe_gt_WARN_ON(gt, idledly >= maxcnt)) {
+			/* Floor below maxcnt; write 0 to still clear the inhibit bit. */
+			idledly = maxcnt ?
+				DIV_ROUND_DOWN_ULL((u64)(maxcnt - 1) * 1000,
+						   idledly_units_ps) : 0;
+			wa_applied = true;
 		}
+
+		if (wa_applied)
+			xe_mmio_write32(&gt->mmio, RING_IDLEDLY(hwe->mmio_base),
+					REG_FIELD_PREP(IDLE_DELAY, idledly));
 	}
 }
 


