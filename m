Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66C92ED143;
	Thu,  3 Jul 2025 15:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555348; cv=none; b=dBqJP9rlXrqin+7nUdzEuPpcuVqCP9yEhKzwN/Sh3ADvw5gTjSGhmD3e53g39uYOJQ3eTzjMUXgvBOo/WXTTCjoAHqDyHqsNzdai6S8AGwiO8Jkc2e9Zm59XjALH0rhvd8uoOUbPobUzYLhJ05cJlrNsYyfCNBimKo+PWPQBlss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555348; c=relaxed/simple;
	bh=GNjlUlDA480m1+vw4hFYcPzcOTKkp5xDLmF0LpP1mz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVx3Q6xeWGG8LkYD2Jby4a/eoFJ3KYK4FqeMOkCfd23Ma7MivW+usMXoYf+JNwYevf7pPdaviJ0j4McxCxGKO1N9JMAnEN+RQ7KPKLTYidXsyvN95I7VH6DM2Cx0N1oH+4iekVSODNjutCtWLWbWdogEIe92uycMIWz3TcKlF/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjeaMdY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjeaMdY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56440C4CEE3;
	Thu,  3 Jul 2025 15:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555347;
	bh=GNjlUlDA480m1+vw4hFYcPzcOTKkp5xDLmF0LpP1mz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjeaMdY5JumFxZNTIabGw9N7AtX8e7conxwy2bx1W+lgI++btL4nQSgRqrLA104A0
	 l3IYCbk4LOPac+pELbCjEojvPC7CbfxxY07WWq9w3uZRY6FBjwRiiCcnDClkMbPPMN
	 2l6GukDvQ0+fap/T41nG1l3qcn7aZyMjzj0AX6/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 250/263] drm/amd/display: Fix default DC and AC levels
Date: Thu,  3 Jul 2025 16:42:50 +0200
Message-ID: <20250703144014.438570401@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 8b5f3a229a70d242322b78c8e13744ca00212def ]

[Why]
DC and AC levels are advertised in a percentage, not a luminance.

[How]
Scale DC and AC levels to supported values.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4221
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 96118a0e1ffeb..389748c420b02 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4834,6 +4834,7 @@ amdgpu_dm_register_backlight_device(struct amdgpu_dm_connector *aconnector)
 	struct backlight_properties props = { 0 };
 	struct amdgpu_dm_backlight_caps caps = { 0 };
 	char bl_name[16];
+	int min, max;
 
 	if (aconnector->bl_idx == -1)
 		return;
@@ -4846,11 +4847,15 @@ amdgpu_dm_register_backlight_device(struct amdgpu_dm_connector *aconnector)
 	}
 
 	amdgpu_acpi_get_backlight_caps(&caps);
-	if (caps.caps_valid) {
+	if (caps.caps_valid && get_brightness_range(&caps, &min, &max)) {
 		if (power_supply_is_system_supplied() > 0)
-			props.brightness = caps.ac_level;
+			props.brightness = (max - min) * DIV_ROUND_CLOSEST(caps.ac_level, 100);
 		else
-			props.brightness = caps.dc_level;
+			props.brightness = (max - min) * DIV_ROUND_CLOSEST(caps.dc_level, 100);
+		/* min is zero, so max needs to be adjusted */
+		props.max_brightness = max - min;
+		drm_dbg(drm, "Backlight caps: min: %d, max: %d, ac %d, dc %d\n", min, max,
+			caps.ac_level, caps.dc_level);
 	} else
 		props.brightness = AMDGPU_MAX_BL_LEVEL;
 
-- 
2.39.5



