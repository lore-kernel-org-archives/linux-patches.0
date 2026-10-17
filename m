Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7526D3BED30;
	Sat, 17 Oct 2026 17:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257454; cv=none; b=gi3I/qaKK5PgSozfSQ767/xYt3PeQMDzJfEmKsmTnbWVGZqWVN+T60MED8r/PmpBzUsP0u3FFXDxMxjd8trTFS7+q4xFAs7jyOQvh2l0NV552KJO8I/3CtdUNjJgxgFbUVNhhcojK/h/hzraM9qv58QgMqxRso8TItrwBDx+0DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257454; c=relaxed/simple;
	bh=5PDoWDM3xDJq9xTwf1U7WRopXaoCEQer1jr15FGYdc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hr0MD+VEuOOkgg/8C95P6WgIR5mu41p8hsqY/pKa05Nc7mmO5R9bZwxobmvQ06rWDX5aIxFSDBs/g6JhxHvndrgY7uHwUtlcgdLj6N3d1lNaN5I7rLD9EVM13oope2R/jew+OOq92HtG7XJ+0K/qD1FyXmC/3OS9AAAjND/v1Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elsf3iwN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elsf3iwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED9C1F000C4;
	Sat, 17 Oct 2026 17:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257453;
	bh=lq7o4FDR4Ec10Cqnx2Ch9qFNpdP7ihTjb8ZO2VE3elo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=elsf3iwN4n6ZgmWluWc5DfTj4w+UCZaOa2Yg1wVoEmrU3qoMxuTzGlPa/wQloMVde
	 EoXRWCLTTNrpAGVEcjGeamuxO8/h4Xug0u7x41UhkVkCn3RE1waDx27ohPDaxz3YGI
	 1FNleKDeK8dhqAq85OHgWjFHyfVyoWfG3IgkjgDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Betschart <adrian.betschart@cinemaone.ch>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0562/1674] drm/amd/display: Dont replace a sink mode that shares the native totals
Date: Sat, 17 Oct 2026 17:47:14 +0200
Message-ID: <20261017160445.520437450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Betschart <adrian.betschart@cinemaone.ch>

commit 54c998c55fc9cbc391b350d67b86e0c2a0748f1a upstream.

decide_crtc_timing_for_drm_display_mode() copies the native mode's CRTC
timing into the requested mode when clock, htotal and vtotal match.
That is meant for the modes amdgpu inserts itself:
amdgpu_dm_create_common_mode() duplicates the native mode and changes
only hdisplay and vdisplay, so those are sent with the native timing
and scaled.

A sink can also offer a real mode with the same clock and totals as
its native mode. CTA-861 VIC 102 (4096x2160@60) and VIC 97
(3840x2160@60) both use 594 MHz and 4400x2250. With 3840x2160@60 as
the preferred mode, a 4096x2160@60 request goes out with the 3840x2160
timing and the framebuffer scaled into it (dst 3840x2025 at y=67),
while the AVI InfoFrame still carries VIC 102. A JVC projector then
reports 3840x2160 and shows a corrupted right edge. 4096x2160@24,
whose totals differ, is sent and displayed correctly.

Inserted modes keep the native sync positions; a real mode with its
own active width does not. Compare those too, so only inserted modes
are patched.

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
Signed-off-by: Adrian Betschart <adrian.betschart@cinemaone.ch>
Assisted-by: Claude-Code:claude-opus-5-5
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 22f9a2da101c37f821cd00954f81dc598754f4d5)
Cc: stable@vger.kernel.org
(cherry picked from commit 54c998c55fc9cbc391b350d67b86e0c2a0748f1a)
[ Adrian: this tree keeps the function in amdgpu_dm.c, with the equal-totals
  case as its own else-if; added the sync checks there. Dropped the KUnit
  test, its file does not exist here. ]
Signed-off-by: Adrian Betschart <adrian.betschart@cinemaone.ch>
Assisted-by: Claude-Code:claude-opus-5-5
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 530b85a22222b..b8eed8724502a 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5671,11 +5671,16 @@ decide_crtc_timing_for_drm_display_mode(struct drm_display_mode *drm_mode,
 					const struct drm_display_mode *native_mode,
 					bool scale_enabled)
 {
+	/* Inserted modes copy the native sync; a sink mode with equal totals may not */
 	if (scale_enabled) {
 		copy_crtc_timing_for_drm_display_mode(native_mode, drm_mode);
 	} else if (native_mode->clock == drm_mode->clock &&
 			native_mode->htotal == drm_mode->htotal &&
-			native_mode->vtotal == drm_mode->vtotal) {
+			native_mode->vtotal == drm_mode->vtotal &&
+			native_mode->hsync_start == drm_mode->hsync_start &&
+			native_mode->hsync_end == drm_mode->hsync_end &&
+			native_mode->vsync_start == drm_mode->vsync_start &&
+			native_mode->vsync_end == drm_mode->vsync_end) {
 		copy_crtc_timing_for_drm_display_mode(native_mode, drm_mode);
 	} else {
 		/* no scaling nor amdgpu inserted, no need to patch */
-- 
2.53.0



