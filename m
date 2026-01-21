Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322923A9D92;
	Wed, 21 Jan 2026 18:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020410; cv=none; b=MMXdUnE9GJZ7dUJObPZMH6HRePuZa5juXR7SMMEhyezpvG7tBYj7LG5WaUOWEswZUXba4w5I/f4RuxbFI/pFSA/o8gnFh6PagFGkmD9it1yDSioflF7An6ZiN/TcjUlkJh7xXYFAH6axVWj9PKrB9pVOFTOf+ySsWv4b1Lza+2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020410; c=relaxed/simple;
	bh=e/k1kMfRKP9+TZGmllYCbWX61r+oL5XnwIGFDu3/3pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXfXDrdD5xm86uSlSNc8mfFJarEq6oYYzCFg18VgmydA/x9y/yJy2XuCsFYGTlg0F31QBnuUn3NHxjXEYdHN4GFOV3lf5rdPr5LPrxQgYVYElr6OXoeWdQy0sr/ZDBPRv5jrNBzGRgVQzAG6RsYvzN73N29FnJQi4xWBPt3ebb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3lk9FaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3lk9FaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80515C4CEF1;
	Wed, 21 Jan 2026 18:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020409;
	bh=e/k1kMfRKP9+TZGmllYCbWX61r+oL5XnwIGFDu3/3pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3lk9FaOWyU3nnMQmsvLZztz36XYZnkh4CKIpD1eLaf0p6NJVL7+HNa9TuKICI+0W
	 Vmbix5IVUzjYjBmMvrdTVXefbgwD5yPayDVxR7Iz0D45LEXqMnhat6PoMdXxN6Ul7x
	 eceY4fKNDqWLknW5cc7z0IRO7F780bfop3Zymcok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Das Mohapatra <vivek@collabora.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 150/198] drm/amd/display: Initialise backlight level values from hw
Date: Wed, 21 Jan 2026 19:16:18 +0100
Message-ID: <20260121181423.955325773@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Vivek Das Mohapatra <vivek@collabora.com>

commit 52d3d115e9cc975b90b1fc49abf6d36ad5e8847a upstream.

Internal backlight levels are initialised from ACPI but the values
are sometimes out of sync with the levels in effect until there has
been a read from hardware (eg triggered by reading from sysfs).

This means that the first drm_commit can cause the levels to be set
to a different value than the actual starting one, which results in
a sudden change in brightness.

This path shows the problem (when the values are out of sync):

   amdgpu_dm_atomic_commit_tail()
   -> amdgpu_dm_commit_streams()
   -> amdgpu_dm_backlight_set_level(..., dm->brightness[n])

This patch calls the backlight ops get_brightness explicitly
at the end of backlight registration to make sure dm->brightness[n]
is in sync with the actual hardware levels.

Fixes: 2fe87f54abdc ("drm/amd/display: Set default brightness according to ACPI")
Signed-off-by: Vivek Das Mohapatra <vivek@collabora.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 318b1c36d82a0cd2b06a4bb43272fa6f1bc8adc1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5193,6 +5193,8 @@ amdgpu_dm_register_backlight_device(stru
 	struct amdgpu_dm_backlight_caps *caps;
 	char bl_name[16];
 	int min, max;
+	int real_brightness;
+	int init_brightness;
 
 	if (aconnector->bl_idx == -1)
 		return;
@@ -5217,6 +5219,8 @@ amdgpu_dm_register_backlight_device(stru
 	} else
 		props.brightness = props.max_brightness = MAX_BACKLIGHT_LEVEL;
 
+	init_brightness = props.brightness;
+
 	if (caps->data_points && !(amdgpu_dc_debug_mask & DC_DISABLE_CUSTOM_BRIGHTNESS_CURVE)) {
 		drm_info(drm, "Using custom brightness curve\n");
 		props.scale = BACKLIGHT_SCALE_NON_LINEAR;
@@ -5235,8 +5239,20 @@ amdgpu_dm_register_backlight_device(stru
 	if (IS_ERR(dm->backlight_dev[aconnector->bl_idx])) {
 		drm_err(drm, "DM: Backlight registration failed!\n");
 		dm->backlight_dev[aconnector->bl_idx] = NULL;
-	} else
+	} else {
+		/*
+		 * dm->brightness[x] can be inconsistent just after startup until
+		 * ops.get_brightness is called.
+		 */
+		real_brightness =
+			amdgpu_dm_backlight_ops.get_brightness(dm->backlight_dev[aconnector->bl_idx]);
+
+		if (real_brightness != init_brightness) {
+			dm->actual_brightness[aconnector->bl_idx] = real_brightness;
+			dm->brightness[aconnector->bl_idx] = real_brightness;
+		}
 		drm_dbg_driver(drm, "DM: Registered Backlight device: %s\n", bl_name);
+	}
 }
 
 static int initialize_plane(struct amdgpu_display_manager *dm,


