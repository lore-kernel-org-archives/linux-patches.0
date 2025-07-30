Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C68274666;
	Wed, 30 Jul 2025 09:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869080; cv=none; b=TzCizCxw2eHMZfsMS/BK90NRV2XLYejDAH7KZ9p/x716IEdnVVtPjgQjvYNfR2QtuSyqYz0HXYQ1pbe4R7KXGNEEXLI3o9jM5pJJIle0gpXfSwkJVQo2zYzLHbLOOJrqKGthRbNb+aIMUPKsCKaogppIeFI8/4lH9PnPwiAImS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869080; c=relaxed/simple;
	bh=pJiNb5x7hbhKcLwdf71UUhEAy8Lim3cvLxK5TxJ2sJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SL/PWHH5nCZMkloU4vZ+jaVc1lGXh9+pSynLyXLTkXPQrYhO6U+hpokRqt5uuUllUKSoE4lvgMZaz3uPyJWK7Gcn7o7dnxmkEydmNbgf1ajE3WTghdpRJ9oxoDEoMbJYOVG3X3zRJDOyBQT7K90hQQQd5TXoztHjKmKXT9QJ5BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kyx9BJtP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kyx9BJtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA81C4CEF6;
	Wed, 30 Jul 2025 09:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869077;
	bh=pJiNb5x7hbhKcLwdf71UUhEAy8Lim3cvLxK5TxJ2sJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kyx9BJtPyzEYuRzpMaXnl5k9gF0P0t2ZsitJjbApgj8HWtJAZGWzm9Jf9sRwKAJYe
	 27eggsOYlvdR+kVXaO+PodJiTzRpUGlKtp7XDTrBpSKzp3Cpq8PCqOmouxaoGQci7g
	 fiVNh3/qpDUHkOR22ZNolh/U11N/90OJnEg6thGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 04/92] drm/amd/display: Dont allow OLED to go down to fully off
Date: Wed, 30 Jul 2025 11:35:12 +0200
Message-ID: <20250730093230.805950628@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

[ Upstream commit 39d81457ad3417a98ac826161f9ca0e642677661 ]

[Why]
OLED panels can be fully off, but this behavior is unexpected.

[How]
Ensure that minimum luminance is at least 1.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4338
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 51496c7737d06a74b599d0aa7974c3d5a4b1162e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 87c2bc5f64a6c..f6d71bf7c89c2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3548,13 +3548,15 @@ static void update_connector_ext_caps(struct amdgpu_dm_connector *aconnector)
 
 	luminance_range = &conn_base->display_info.luminance_range;
 
-	if (luminance_range->max_luminance) {
-		caps->aux_min_input_signal = luminance_range->min_luminance;
+	if (luminance_range->max_luminance)
 		caps->aux_max_input_signal = luminance_range->max_luminance;
-	} else {
-		caps->aux_min_input_signal = 0;
+	else
 		caps->aux_max_input_signal = 512;
-	}
+
+	if (luminance_range->min_luminance)
+		caps->aux_min_input_signal = luminance_range->min_luminance;
+	else
+		caps->aux_min_input_signal = 1;
 
 	min_input_signal_override = drm_get_panel_min_brightness_quirk(aconnector->drm_edid);
 	if (min_input_signal_override >= 0)
-- 
2.39.5



