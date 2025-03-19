Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849C821B9C0;
	Wed, 19 Mar 2025 14:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395118; cv=none; b=PGU4qOlUWlAb6LVt4kuQPzS3HvJsxMtBQ7xAcHh6/XYo5wLgK/e9xwOYQ7dY8h6rsM3/qYzlK9Jyn42tWW7iP7PFY/FPcA+8RgTyOZ4mNzbfbjBWzBDg9nc3y5nNBPEM/VwGkJF9PxSnpINrik5ixrKKmB+Is3V292CED6NNojY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395118; c=relaxed/simple;
	bh=E/YjpBNM8ezPnqLCQEMZe4umP1eJ/kT6pP1Kqms2Q9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPvzzrLMxd8VvwxuN6yFQ93jx6sLSVAH002due6H5Uf3sXmRWC1QU0YIhKH8yr2WKVjTo6XLMpOlHJ0G8RIOY4xh1cqpKIgM4JemhxwjOVebyeYerGA+8/fFMqAuo6idRfba9JoNcOkFSW4gat87mZ3ahQriNI6kEm3vtPu4Ci8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNujpLVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNujpLVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52050C4CEE4;
	Wed, 19 Mar 2025 14:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395118;
	bh=E/YjpBNM8ezPnqLCQEMZe4umP1eJ/kT6pP1Kqms2Q9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNujpLVk0xcM0FjU0k8TSFo+G5HzwvVhulX2DbjolrJimtA4lnWMfs5+o6NBUCmb4
	 lFo19IGgggXDaXQyRn0uILsjFSDXaYLCohJ5r3oNuJ+pWUtOT7P19T1BAgD1qBlba2
	 ide6t4k4Dq3C10SeGMJ+WeZ2OQVL0Npqi9AB54p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <Wayne.Lin@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 178/231] drm/amd/display: fix default brightness
Date: Wed, 19 Mar 2025 07:31:11 -0700
Message-ID: <20250319143031.235605244@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4822,6 +4822,7 @@ amdgpu_dm_register_backlight_device(stru
 	dm->backlight_dev[aconnector->bl_idx] =
 		backlight_device_register(bl_name, aconnector->base.kdev, dm,
 					  &amdgpu_dm_backlight_ops, &props);
+	dm->brightness[aconnector->bl_idx] = props.brightness;
 
 	if (IS_ERR(dm->backlight_dev[aconnector->bl_idx])) {
 		DRM_ERROR("DM: Backlight registration failed!\n");
@@ -4889,7 +4890,6 @@ static void setup_backlight_device(struc
 	aconnector->bl_idx = bl_idx;
 
 	amdgpu_dm_update_backlight_caps(dm, bl_idx);
-	dm->brightness[bl_idx] = AMDGPU_MAX_BL_LEVEL;
 	dm->backlight_link[bl_idx] = link;
 	dm->num_of_edps++;
 


