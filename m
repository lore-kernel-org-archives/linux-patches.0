Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFA839768F;
	Sat, 12 Sep 2026 09:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205523; cv=none; b=uM2i76tbUCTNz3GnPeGQpq56tW7bzm9feYwfIFw0XSRqTtF/7Ow7ohoPoE0zrpqIaKA+ofnbwk1/ZELGE4KGbNwCQJr8g5CDjFdl/Z0rN8MFY+SD7+JwMYeGt91loQ/djkwtXQVz9DSbgUKDP+K+MsqO+9uqC5RZg6xm4lOXq+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205523; c=relaxed/simple;
	bh=mQgqH0C8g2RnYCB3GCVYO45p6/svXJHWd3oSJbyDfdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXEd4Lqpmz3O9cATiEtdUS1zI7Zhe6Y7QkxjbktUH5UNms0Jha3D78IKK47ix6bVtA5kwVn2XvIAvqwNxhQbIY/Xyw3R/rzG/Ubr1qTnIGgCWxYflXrUVUHlntQmi+RQMtPeV+CS+noBm4yE8pWfxBVWVnJxW7bm7tvSOKMsavw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5Nzc1gm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5Nzc1gm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F301F000FF;
	Sat, 12 Sep 2026 09:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205521;
	bh=mKgD9jUmigow4z4SemfD8cONRn6dU/jSYFyQNJGa9B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5Nzc1gmRPnWS/8wbONZYpeASmhgvTrauJ7nE1s+nj8IRMMU8Jv4r2drvSzADIebz
	 2LhpV9gjnCEh3Qzv8f78yJVjZAEql9yyfSrBAPtMxHhJ0a9jIvnH5xenVTzfcqZuIg
	 ypdGI+AL8x7J7QuDOzqDtNv99kCJPxQP2NJszLvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Akhmed Zhitaev <zhitaevakh@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0002/1518] drm/amd/display: Fix backlight max_brightness to match exported range
Date: Sat, 12 Sep 2026 08:36:11 +0200
Message-ID: <20260912065623.461223078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit bd9e2b5b0473c75abc0f4134dfe79ecbfb16610d ]

[Why]
FWTS autobrightness fails on eDP panels because actual_brightness can
read higher than the advertised max_brightness (e.g. 63576 vs 62451).

The conversion helpers expose the firmware PWM range to userspace as
[0..max].  But max_brightness is advertised as (max - min), which is
smaller.  So reading the level can return a value above max_brightness.

This regressed in commit 4b61b8a39051 ("drm/amd/display: Add debugging
message for brightness caps"), which changed max_brightness to
(max - min) and undid commit 8dbd72cb7900 ("drm/amd/display: Export full
brightness range to userspace").

[How]
Advertise max_brightness as max, and scale the initial AC/DC brightness
against max too.  Update the KUnit expectations to match.

[ Backport note: In 6.18.y the backlight property setup still lives in
  amdgpu_dm.c, so apply the same property changes there.  The upstream
  KUnit file was introduced by a later refactoring and is not present. ]

Fixes: 4b61b8a39051 ("drm/amd/display: Add debugging message for brightness caps")
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Akhmed Zhitaev <zhitaevakh@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 6eb2514c7c305..c71d34186dfed 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5228,11 +5228,11 @@ amdgpu_dm_register_backlight_device(struct amdgpu_dm_connector *aconnector)
 	caps = &dm->backlight_caps[aconnector->bl_idx];
 	if (get_brightness_range(caps, &min, &max)) {
 		if (power_supply_is_system_supplied() > 0)
-			props.brightness = DIV_ROUND_CLOSEST((max - min) * caps->ac_level, 100);
+			props.brightness = DIV_ROUND_CLOSEST(max * caps->ac_level, 100);
 		else
-			props.brightness = DIV_ROUND_CLOSEST((max - min) * caps->dc_level, 100);
+			props.brightness = DIV_ROUND_CLOSEST(max * caps->dc_level, 100);
 		/* min is zero, so max needs to be adjusted */
-		props.max_brightness = max - min;
+		props.max_brightness = max;
 		drm_dbg(drm, "Backlight caps: min: %d, max: %d, ac %d, dc %d\n", min, max,
 			caps->ac_level, caps->dc_level);
 	} else
-- 
2.53.0



