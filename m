Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965FD33EAEF;
	Wed,  3 Dec 2025 15:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777266; cv=none; b=Do1c8j2SvIbujd8GAPXSSKYN07LYR83KSjJtjN0Lyv0gYKl78lKjAJ3Z0k7eyPz+AEpSho3RX7pt4/YekwRQWLgP+Ka/4p36Q/0uFtxFx/0gHYoXOtQ8CkmPP7j99SuEtzGYGGBFBwPYXm6iroCQxgt6+RFTGD6sKZrxlS3Noag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777266; c=relaxed/simple;
	bh=eELEyoKu7HoXyM7HEzFMfMHGBGCFRY1nFEexb26aR80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4Fj72TWeJKLO8fmRdX/GFu6Sr20nSIZ9SVNLchN8JifQw0SZkHBBlgBPcvgYhA1BPwqS5+XGhQaPLuIpB50HUghUkR7IheY0DrY6uvUEOE+FoJvys15dTA/1cioKwRrj0swHK/kbXmN0424ZUu2LNPd9W6vvYQPpVq5d0WuLoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMzhii9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMzhii9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4F6C2BCF4;
	Wed,  3 Dec 2025 15:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777266;
	bh=eELEyoKu7HoXyM7HEzFMfMHGBGCFRY1nFEexb26aR80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMzhii9ZF07Lav/Ohvm+0KqJmqYJ/oFud1eSWzahphedh2+5co1PxmDeVPozNuUd7
	 0A99nR7lvjOmUdfm3G4AU9OJSjAxcd4o9xYU9WJi/hJH/mc3qYyT/7dfc8Esv+/gr6
	 VhHMGqFeu9wzQblkGxqzE5wcbDmD5JsSoh5EoLfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Hung <alex.hung@amd.com>
Subject: [PATCH 6.17 132/146] drm/amd/display: Dont change brightness for disabled connectors
Date: Wed,  3 Dec 2025 16:28:30 +0100
Message-ID: <20251203152351.303039770@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit 81f4d4ba509522596143fd5d7dc2fc3495296b0a upstream.

[WHY]
When a laptop lid is closed the connector is disabled but userspace
can still try to change brightness.  This doesn't work because the
panel is turned off. It will eventually time out, but there is a lot
of stutter along the way.

[How]
Iterate all connectors to check whether the matching one for the backlight
index is enabled.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4675
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f6eeab30323d1174a4cc022e769d248fe8241304)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4898,6 +4898,21 @@ static void amdgpu_dm_backlight_set_leve
 	struct dc_link *link;
 	u32 brightness;
 	bool rc, reallow_idle = false;
+	struct drm_connector *connector;
+
+	list_for_each_entry(connector, &dm->ddev->mode_config.connector_list, head) {
+		struct amdgpu_dm_connector *aconnector = to_amdgpu_dm_connector(connector);
+
+		if (aconnector->bl_idx != bl_idx)
+			continue;
+
+		/* if connector is off, save the brightness for next time it's on */
+		if (!aconnector->base.encoder) {
+			dm->brightness[bl_idx] = user_brightness;
+			dm->actual_brightness[bl_idx] = 0;
+			return;
+		}
+	}
 
 	amdgpu_dm_update_backlight_caps(dm, bl_idx);
 	caps = &dm->backlight_caps[bl_idx];


