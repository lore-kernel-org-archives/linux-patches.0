Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A9A47A876;
	Fri,  7 Aug 2026 15:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117755; cv=none; b=tIqtydqjCsGhciWP7jqJjL+U19Zlm7ooTQKz+XD9oBY4SET6xHRCOEpM5sNP3hFQCRFOHwMKTEMh9idZYyCbZeZ5vBRsC7gD5jSIluO0smyAdERhBAgng+fCZn6AuH9+MaVB3PA1nb+o6jkXsLdulBHTSUDDSXQ3k2rfxgt2OOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117755; c=relaxed/simple;
	bh=TVzxkri/cGYhCEBzD1QcOePo3kptqbZkgRrZf2wocSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8oW0urG89OZOl3JH6jrzeB8fHeUCgosvWoz11SljNiwNYIHBl4S+vExV2fBNGeZ4QB6wRte69Rm4DVlW04hxMOShwQRJ6tEdMrkymF02tQ26hSIgbu/qEZm/vnyGcCrmWICZZuVl3cnw6sWmSJlWIHrjcqeeKJ6k3yGHYtfvfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rm1S5jJM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rm1S5jJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5611F000E9;
	Fri,  7 Aug 2026 15:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117754;
	bh=0k4FYkIwmfxqYBOjTHnwTIok/bJ68rgZTgc39kCRxH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rm1S5jJMscIdr/GwXSFOh+XojsusR99bitOooOjw9WOLLFvGFaONbjiTg0EVkaxmR
	 5ws6dZmOX6eAdMySv+KU8u84TynlBByZ5lPWFujIvNO24gc8kuDB4JY1vIFaI92Raz
	 aGcGX2BQDHSRISyIhd2qMy6aeyBafUOBfoU7+OHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 429/438] drm/xe: Move xe->info.force_execlist initialization
Date: Fri,  7 Aug 2026 16:40:25 +0200
Message-ID: <20260807143437.112723696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit f1d581bb50ed54b71a8121d3d46fe2627fddd147 ]

The xe_info_init_early() is a place where we initialize those of
the xe->info fields that do not require any additional hardware
probes. Move the initialization of the force_execlist flag there.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patch.msgid.link/20260526195452.20545-4-michal.wajdeczko@intel.com
Stable-dep-of: ba7fd1634228 ("drm/xe: Set TTM device beneficial_order to 9 (2M)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_device.c |    1 -
 drivers/gpu/drm/xe/xe_pci.c    |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -475,7 +475,6 @@ struct xe_device *xe_device_create(struc
 
 	xe->info.devid = pdev->device;
 	xe->info.revid = pdev->revision;
-	xe->info.force_execlist = xe_modparam.force_execlist;
 	xe->atomic_svm_timeslice_ms = 5;
 	xe->min_run_period_lr_ms = 5;
 
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -774,6 +774,7 @@ static int xe_info_init_early(struct xe_
 	xe->info.probe_display = IS_ENABLED(CONFIG_DRM_XE_DISPLAY) &&
 				 xe_modparam.probe_display &&
 				 desc->has_display;
+	xe->info.force_execlist = xe_modparam.force_execlist;
 
 	xe_assert(xe, desc->max_gt_per_tile > 0);
 	xe_assert(xe, desc->max_gt_per_tile <= XE_MAX_GT_PER_TILE);


