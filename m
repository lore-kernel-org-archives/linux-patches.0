Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8028033E36A;
	Sat, 30 May 2026 17:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161699; cv=none; b=EAmqCKmTD7uPLJeJHaAOONV1LkZRL+VLFEhWyGqYnFdbzPjnSLOlGDfkiTBuPs4cvt4JJgi/6sUDtTTKIJCaEzwBYzuNFCUMLGOuzB7k99+Qt43yBC0ALiJeUv6LNpHk1Y548Cq0xMteTAqeJcvEXfaBhteQ2Ae2TNsT8Q/Rf7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161699; c=relaxed/simple;
	bh=mxwGGpMgJOzCX1F5Npd0brBAw94dg1MyIfT/R7dx6Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FcQFUAJL6ByS/7C6x60J1PMoBWF4ydhPv9ooJe/M5lYbseOqqAaBoQj+9ej0u481VJ5MSQfiITn76f0+xgdcmWdznPe0t2AoSz5KXLy0mMi/Z0zmkZ1FAtj+U49C+WMJKOPIn9EeRlpvQuYs2oy4igtnreSwiM/d1NMlUglb5qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8xsRt7h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8xsRt7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851B61F00893;
	Sat, 30 May 2026 17:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161698;
	bh=Hu99QR85UdArvaCdceElinbBvMaRj9HiZA2hTzdq898=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8xsRt7hvKQb/LXI0zvfm6hTAetXGg0W7/zC/owTlvPTbLd/T4kLhnEfkSLGi6OtL
	 qGYfNNBranReACH+yTCLvQYQTOZX+AtEy7RhPGe6LCRAcpMRltvy60Ew6y1KRhu+Ow
	 krWWP0/98LRXhQr7cdL6Dr2taDV5+n5qy5F/aH0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uma Shankar <uma.shankar@intel.com>,
	Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 671/969] drm/i915: Loop over all active pipes in intel_mbus_dbox_update
Date: Sat, 30 May 2026 18:03:15 +0200
Message-ID: <20260530160319.020832053@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>

[ Upstream commit e8333ab22cd8c750b7c14d3da7c0eef3ba85527f ]

We need to loop through all active pipes, not just the ones, that
are in current state, because disabling and enabling even a particular
pipe affects credits in another one.

Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240402155016.13733-6-ville.syrjala@linux.intel.com
Stable-dep-of: a97c88a176b6 ("drm/i915/wm: Verify the correct plane DDB entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/skl_watermark.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/skl_watermark.c b/drivers/gpu/drm/i915/display/skl_watermark.c
index e553192e12b76..2a60aa3fedf82 100644
--- a/drivers/gpu/drm/i915/display/skl_watermark.c
+++ b/drivers/gpu/drm/i915/display/skl_watermark.c
@@ -3456,10 +3456,8 @@ void intel_mbus_dbox_update(struct intel_atomic_state *state)
 {
 	struct drm_i915_private *i915 = to_i915(state->base.dev);
 	const struct intel_dbuf_state *new_dbuf_state, *old_dbuf_state;
-	const struct intel_crtc_state *new_crtc_state;
 	const struct intel_crtc *crtc;
 	u32 val = 0;
-	int i;
 
 	if (DISPLAY_VER(i915) < 11)
 		return;
@@ -3503,12 +3501,9 @@ void intel_mbus_dbox_update(struct intel_atomic_state *state)
 		val |= MBUS_DBOX_B_CREDIT(8);
 	}
 
-	for_each_new_intel_crtc_in_state(state, crtc, new_crtc_state, i) {
+	for_each_intel_crtc_in_pipe_mask(&i915->drm, crtc, new_dbuf_state->active_pipes) {
 		u32 pipe_val = val;
 
-		if (!new_crtc_state->hw.active)
-			continue;
-
 		if (DISPLAY_VER(i915) >= 14) {
 			if (xelpdp_is_only_pipe_per_dbuf_bank(crtc->pipe,
 							      new_dbuf_state->active_pipes))
-- 
2.53.0



