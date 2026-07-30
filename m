Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AF2274650;
	Thu, 30 Jul 2026 15:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424411; cv=none; b=QOtsBxgUj8CZcZdcqTZxLjv1T4vibgZjTUABWsGDRaFU6qbjtR2mljA/IbOosb2F/6gSRC/Pv+7TXCUNO3XgKanfYjqCgkK6SUUdw+FuCDM0a+oDUzPqxJjkkL3IkhQmQAW63MTlJ+bWneY7qCamrJjthyVJssa2+qGIz81Qp0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424411; c=relaxed/simple;
	bh=zLNu20WlQBkWLg7XnqAXWRJEtIrnFlO+6DvCJQJKsVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9tk1rjcJ7rbc0r2Xow3SUEjXH7V6WnscWKShKYpkRXxTKXVLzZctCx48YItkSxXgAI/KDFTeXNp3KW86oiyy7anVemrpOuWT3HU9QWUgu2OdEfsjx805BkspukCWEf/NXzl5jnJ7AR1Eqe3rxuSmqwmNK+xn2nMFCBApwxWfGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KfesSxPC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KfesSxPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712541F000E9;
	Thu, 30 Jul 2026 15:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424410;
	bh=d5QFX2Yh8rXrwxCXIxTSKBSXss4y2ET6sHpxawD7Hbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KfesSxPCXYBRvV1re+kmKOsWPoo1LZfHFFE5m/CaS1HS8/HzuGHuUQJfLF3KUKofG
	 LlDyy7/4rpxO+OVJ1FeWx4jJjJhgF8GpcsC38NMkKuUwzd6jlpNgc8z7ztxOj9FDOa
	 ZSTBKpIE8PRU8Keo4Wgk/enUgGvVmtaGbtja6O3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 384/675] drm/amd/display: Fix backlight max_brightness to match exported range
Date: Thu, 30 Jul 2026 16:11:54 +0200
Message-ID: <20260730141453.298586037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -5204,11 +5204,11 @@ amdgpu_dm_register_backlight_device(stru
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


