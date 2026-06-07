Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F61D1DE8AE;
	Sun,  7 Jun 2026 10:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826877; cv=none; b=PV8X7lW0HKOfIUSoilpzRtSKbp20siY92TMO0VPX2t0/HvFX7eFtEFqkYx139YWXEUi9C/IOZlK9JiwhpTPVhIoffNoA+SZWvVukh0YzYR1YyAqgQ3fuinmVCdarCRTtRWpNVhi7QkBbP44F/6hEw8X5QkTiYCYJRi1YhNcnkRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826877; c=relaxed/simple;
	bh=CEfQIfB4iyFNVofTlm3HxkxrXBgI/AVyftcKEDNlVJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FBpMiz2BcENv3TMbzQ0ZRiuSISEWcfyNDGe1ONsmxYWroU8tL6a+EcgJlaRBj9r91Kuo70/E0xn//ZkUIqQmljB0oTiCSfy7WUcRQrC8hccN481nZNCnIpGokPkf157K6LXEN9PNQ+9phpuMPmXWOpIt+FRvVE29yAMy2XXxZgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fnyAprKj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnyAprKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD93C1F00893;
	Sun,  7 Jun 2026 10:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826876;
	bh=GMsTytIjE82+TTChcMTiWnwgLQKDGKoEIJI+eox1Vzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fnyAprKjZOHhtDUnX6YqD3fMXzHI7SWg3DoEoRD5eGgqCk2UCGWuba6bL4IuGw2ij
	 hwoG7Bx5a4lfHTvkZIurRVj7GQ2EPGkg4ZGVcYllZy3Kg89kVdzatdVChh1WuQt6YO
	 lyFvXDwpoArtq2qYBC1X3rmvoQUoW7H1DE2ygJDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Micha=C5=82=20Grzelak?= <michal.grzelak@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 039/332] drm/i915/aux: use polling when irqs are unavailable
Date: Sun,  7 Jun 2026 11:56:48 +0200
Message-ID: <20260607095729.548600140@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Grzelak <michal.grzelak@intel.com>

[ Upstream commit 202e77cf2e839e1adc804433322dc5c9ee511c9f ]

PTL with physically disconnected display was observed to have 40s longer
execution time when testing xe_fault_injection@xe_guc_mmio_send_recv.
The issue has not been seen when reverting commit 40a9f77a28fa ("Revert
"drm/i915/dp: change aux_ctl reg read to polling read"").

Apparently the configuration suffers from not having AUX enabled when
using interrupts. One probable cause can be xe enabling interrupts too
late: interrupts need memory allocations which currently can't be done
before the display FB takeover is done.

As for now, use polling for AUX in case interrupts are unavailable.

Fixes: 40a9f77a28fa ("Revert "drm/i915/dp: change aux_ctl reg read to polling read"")
Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Michał Grzelak <michal.grzelak@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260416163744.288107-1-michal.grzelak@intel.com
(cherry picked from commit 05e0550b65cd1604bd515fbc65f522bce4c10a87)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp_aux.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux.c b/drivers/gpu/drm/i915/display/intel_dp_aux.c
index b20ec3e589fadc..9c9b6410366d5c 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
@@ -12,6 +12,7 @@
 #include "intel_dp.h"
 #include "intel_dp_aux.h"
 #include "intel_dp_aux_regs.h"
+#include "intel_parent.h"
 #include "intel_pps.h"
 #include "intel_quirks.h"
 #include "intel_tc.h"
@@ -60,18 +61,29 @@ intel_dp_aux_wait_done(struct intel_dp *intel_dp)
 	struct intel_display *display = to_intel_display(intel_dp);
 	i915_reg_t ch_ctl = intel_dp->aux_ch_ctl_reg(intel_dp);
 	const unsigned int timeout_ms = 10;
+	bool done = true;
 	u32 status;
-	bool done;
+	int ret;
 
+	if (intel_parent_irq_enabled(display)) {
 #define C (((status = intel_de_read_notrace(display, ch_ctl)) & DP_AUX_CH_CTL_SEND_BUSY) == 0)
-	done = wait_event_timeout(display->gmbus.wait_queue, C,
-				  msecs_to_jiffies_timeout(timeout_ms));
+		done = wait_event_timeout(display->gmbus.wait_queue, C,
+					  msecs_to_jiffies_timeout(timeout_ms));
+
+#undef C
+	} else {
+		ret = intel_de_wait_ms(display, ch_ctl,
+				       DP_AUX_CH_CTL_SEND_BUSY, 0,
+				       timeout_ms, &status);
+
+		if (ret == -ETIMEDOUT)
+			done = false;
+	}
 
 	if (!done)
 		drm_err(display->drm,
 			"%s: did not complete or timeout within %ums (status 0x%08x)\n",
 			intel_dp->aux.name, timeout_ms, status);
-#undef C
 
 	return status;
 }
-- 
2.53.0



