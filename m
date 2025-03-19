Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87D01DDC2B;
	Wed, 19 Mar 2025 14:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394958; cv=none; b=juYPvJCXXqKpYehyD8TqxeD4DeS/E8FX/CHuRgR3oIzxXhALyXcir0FMEu2QuLERkjGPwqkWxHswV3T9TVKzvFrtu2OogdSumo5VtMeLwUgxAJM+PAwwIz9TaxaX+c0751FNcqc8M2Uq/8xkJf4WhzVvwP1dXongMzevfm2Rdhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394958; c=relaxed/simple;
	bh=Guaxbmu5t03lw85qw2N0xHhzReyNXv0p3iBhmqluzhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWcCcGEL+TTf/3UyfUHtTpPobcwUHMDH6e4LoXKFisebayfZF723akugQm3/A5jAfG3e/pRGRv/T0n+vRsmbED+yCkXMxEM3cbqbHntibdBOeda3NZ+cYpWzGzQyfE8tNLhBYXe8fPOUXQKMibfa/MfBUcoC9IfZR0ScI+w6BVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPmQJul8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPmQJul8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E25BC4CEE4;
	Wed, 19 Mar 2025 14:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394957;
	bh=Guaxbmu5t03lw85qw2N0xHhzReyNXv0p3iBhmqluzhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPmQJul87HkkbJ6f6a7EJEGN7k6drx3NIE9Zmf4VsItDPGCyTPfH5kVW6z9jB+LEL
	 DM9+Ba0P2fYrkhq850WQpnTZoGpxTxc754w0hdqbfPTRuoUqYjThW/PVsb3kXuC5YI
	 hQQx0r4jBQDIYwTcs8e6aijUI8ZHsi4bxQCqSqWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <Wayne.Lin@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 184/241] drm/amd/display: fix default brightness
Date: Wed, 19 Mar 2025 07:30:54 -0700
Message-ID: <20250319143032.277023829@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit b5a981e1b34e44f94a5967f730fff4166f2101e8 upstream.

[Why]
To avoid flickering during boot default brightness level set by BIOS
should be maintained for as much of the boot as feasible.
commit 2fe87f54abdc ("drm/amd/display: Set default brightness according
to ACPI") attempted to set the right levels for AC vs DC, but brightness
still got reset to maximum level in initialization code for
setup_backlight_device().

[How]
Remove the hardcoded initialization in setup_backlight_device() and
instead program brightness value to match BIOS (AC or DC).  This avoids a
brightness flicker from kernel changing the value.  Userspace may however
still change it during boot.

Fixes: 2fe87f54abdc ("drm/amd/display: Set default brightness according to ACPI")
Acked-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0747acf3311229e22009bec4a9e7fc30c879e842)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4848,6 +4848,7 @@ amdgpu_dm_register_backlight_device(stru
 	dm->backlight_dev[aconnector->bl_idx] =
 		backlight_device_register(bl_name, aconnector->base.kdev, dm,
 					  &amdgpu_dm_backlight_ops, &props);
+	dm->brightness[aconnector->bl_idx] = props.brightness;
 
 	if (IS_ERR(dm->backlight_dev[aconnector->bl_idx])) {
 		DRM_ERROR("DM: Backlight registration failed!\n");
@@ -4915,7 +4916,6 @@ static void setup_backlight_device(struc
 	aconnector->bl_idx = bl_idx;
 
 	amdgpu_dm_update_backlight_caps(dm, bl_idx);
-	dm->brightness[bl_idx] = AMDGPU_MAX_BL_LEVEL;
 	dm->backlight_link[bl_idx] = link;
 	dm->num_of_edps++;
 


