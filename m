Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79CF34EEE1;
	Wed,  3 Dec 2025 16:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780948; cv=none; b=HWgYUUB4ldUn9AwXpLQeJvBUq9Ak4pkkvf4HOvkyWqM8AnK66XahzU1hn5y/ksekPJPFDYr52JXmqMjYJNxRHC65VU+y0RXYveQbhVbzNXCpsMOXvjBGIoxBuhMtb3czHUnPIKnh70+MSQqcHdNBItqSQeusEhUKgDlkhahbcl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780948; c=relaxed/simple;
	bh=6aGLcsSvkIVdlEQyHU5XFO+VeFYdaJddfe588FXmvyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOTCO2PbkKDmgV9RMd+lxymElwbj3OB0L5e+BDBEw2QxTcUsUiOCsNojdwRCQyC08CMPEMeDur2pJAjDvblDFi2ho/iQoNiK7aFChX5BVwDVDyk3rDeSZYg04ocEOGg16DRzpLjZ+xJLnZzkKsvbWgdyOKY/ity3pzIhFjjXS2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEypwomZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEypwomZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E5BC4CEF5;
	Wed,  3 Dec 2025 16:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780948;
	bh=6aGLcsSvkIVdlEQyHU5XFO+VeFYdaJddfe588FXmvyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEypwomZHzEzS1/gIyOrUe4JHaE9OydGgtwiPmefTVZuXnC6wdGbGjPo9Q+r2vAI2
	 70FteWji88Zre/jZHTJU8ft4YZU4IBIPAuFTvA8nCta94FCzk42QjUa1etLNDQkGvP
	 L/jEqDja5/qwCqRHtEuhwIhBU6+YFFCP/9UpNERQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Hung <alex.hung@amd.com>
Subject: [PATCH 6.12 107/132] drm/amd/display: Dont change brightness for disabled connectors
Date: Wed,  3 Dec 2025 16:29:46 +0100
Message-ID: <20251203152347.250022575@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4701,6 +4701,21 @@ static void amdgpu_dm_backlight_set_leve
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
 	caps = dm->backlight_caps[bl_idx];


