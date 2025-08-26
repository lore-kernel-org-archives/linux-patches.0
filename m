Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CFA1A256B;
	Tue, 26 Aug 2025 11:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207458; cv=none; b=MSunNMUUoM63bY4StD/wReDk1NzpRH5wNyzPXOp6eC2yPXlb1HJL40eUFfqJbmoiVCMYITkhF663A1sg23h/qkKR19rkdOGzKzTRDrKZm+G3LoHHgPaaiyTBdqoRaAPC9xhbsoLwsKMtd4MUGYYdss0RumGm9oKUpNGprnJCF5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207458; c=relaxed/simple;
	bh=iLfUe6yOFyvDG1hJLHXgFxLLVDlIITTZcpooWY0p3fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFFIryjZPs1nLJtMeZVaYiGU9ZMFQJ7zwfLt7jwb2BwDX6mb4L3lpfND4RwJGN994j7WZq1x8f3ecRtjVbBQg22UOsNhy2G+37it2X3Rtyk4/y/O/dzeDbaPeJqD2xNqZBP9r9iJ7l6w0r4L/FkoANe+5h403il8dTglwY7D6+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lM6EhDlx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lM6EhDlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E4CC4CEF1;
	Tue, 26 Aug 2025 11:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207458;
	bh=iLfUe6yOFyvDG1hJLHXgFxLLVDlIITTZcpooWY0p3fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lM6EhDlxhOdCLvk/kGqdKPu2OGq48jEopRP0lpMhFmgPwfDoO0xsabl0NccSAMk4/
	 shqw3MRBF1ChPY99Dl6JoyjBIrIQbTiHrLXB2ZfASPFkevxdFxNJTji2wkqekKCtgf
	 wODb+GXNbR+i70jt7N6B18IvF+Hv9YpBwTwe/9lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lauri Tirkkonen <lauri@hacktheplanet.fi>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 190/457] drm/amd/display: fix initial backlight brightness calculation
Date: Tue, 26 Aug 2025 13:07:54 +0200
Message-ID: <20250826110942.063774811@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lauri Tirkkonen <lauri@hacktheplanet.fi>

commit 9c2883057b3c861879b647f34e8bc448954e8729 upstream.

DIV_ROUND_CLOSEST(x, 100) returns either 0 or 1 if 0<x<=100, so the
division needs to be performed after the multiplication and not the
other way around, to properly scale the value.

Fixes: 8b5f3a229a70 ("drm/amd/display: Fix default DC and AC levels")
Signed-off-by: Lauri Tirkkonen <lauri@hacktheplanet.fi>
Cc: stable@vger.kernel.org
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/aH2Q_HJvxKbW74vU@hacktheplanet.fi
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4952,9 +4952,9 @@ amdgpu_dm_register_backlight_device(stru
 	caps = &dm->backlight_caps[aconnector->bl_idx];
 	if (get_brightness_range(caps, &min, &max)) {
 		if (power_supply_is_system_supplied() > 0)
-			props.brightness = (max - min) * DIV_ROUND_CLOSEST(caps->ac_level, 100);
+			props.brightness = DIV_ROUND_CLOSEST((max - min) * caps->ac_level, 100);
 		else
-			props.brightness = (max - min) * DIV_ROUND_CLOSEST(caps->dc_level, 100);
+			props.brightness = DIV_ROUND_CLOSEST((max - min) * caps->dc_level, 100);
 		/* min is zero, so max needs to be adjusted */
 		props.max_brightness = max - min;
 		drm_dbg(drm, "Backlight caps: min: %d, max: %d, ac %d, dc %d\n", min, max,


