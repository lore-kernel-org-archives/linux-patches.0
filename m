Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A2A33D4E2;
	Thu, 30 Jul 2026 14:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422515; cv=none; b=l3Tax5WL4xof1XWDjbxjy9xeelLgMpLS0Do6NdquCFsGK4m6/8b1ecJioylVfZpgls+Egyj4JeZLVf7th0SnaFenGpBsMMGU439LiR1Xkr49eUHu+dS1knLivCDsGxnQAar57hAsl+9L711RWKXzBAWQsvR4G9sZvcPMFdcHtmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422515; c=relaxed/simple;
	bh=AwEWqLu1S9tHdzbkVtkUr6BacpvwzyedGHkz5qHMSeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDzmMAxO/KLWMSOAvVk9n2YbTGX6taj64SO9eZb9YT9+e1AZklRgL28kmCBo67JOyjbCCHDJbbSPgv+rKwyh3sdsAGG5saPP4Dj18ZZX6fXxC7AX2VQam18c4Wz0axFPXzQJJa6lLYxkv6xbFjjW1yntiPwhJozdrsjN8pPsiEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsy0FOsp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsy0FOsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F09D1F000E9;
	Thu, 30 Jul 2026 14:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422513;
	bh=r3qai6Wm8YHBu2KVyAPjiWunwdi/ayD2qjnRG660kKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jsy0FOspgR0jR6oF9HYd1IJLprhQDje5u9xTFByjIFh+CikEU38mAYUM78FaRepQi
	 zSD0M2yitRPGPl67tLA3mSCZyS6FuTqmqG1Cy8GVMt6DuWMeFC1/j2mtcwVSxLYim6
	 HgZk9RVLBI6j3qKhFNI/xlXXnx6YHLhxgfa7y5N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 458/744] drm/amd/display: Fix backlight max_brightness to match exported range
Date: Thu, 30 Jul 2026 16:12:11 +0200
Message-ID: <20260730141454.031387781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit f1b5d8f9cc54ae8a2567ac126867ae488e1bf625 upstream.

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

Fixes: 4b61b8a39051 ("drm/amd/display: Add debugging message for brightness caps")
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bd9e2b5b0473c75abc0f4134dfe79ecbfb16610d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5383,11 +5383,11 @@ amdgpu_dm_register_backlight_device(stru
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


