Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3B12D8DC4;
	Thu,  2 Jul 2026 16:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010207; cv=none; b=FFjHO/h+4Fcve43pKiYdt9Fh0yz3yRBQZ1zoTE9FQ0jqy+4CGpKCCp/+gCJaE5n2RYE8AknAXr2a81Q1l3fSCpdW5qz9Q/ybKo7zC+JvrrYQr80W+uI9ymRmXc85D/BeCkWxl81GzoGwyDjrYJFg++zW9kjWagPuhhj36hjb0aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010207; c=relaxed/simple;
	bh=doVSSwEjTxwaNB08KcFVBTqe7iaQ8GiJiIJRYduLMGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAxxXik9P5JW6nUiXgE8w4WTjjhlYtfxehKJcTshX9C7UEVJ791AQc+gXPFzGj79yDKRJiCXGEGL2lDyzNvAt7o2lFLWVIsHdekHwA2yZjdIVCSM3F+ZS7SvorB50RU52mnkiwuYqEGmljtonYfZmG57+ldkNBqqW0zPDDYQb0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/GAOHyK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/GAOHyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05AA1F000E9;
	Thu,  2 Jul 2026 16:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010206;
	bh=q0CWFkEJJ1W0JS6tFcRsCZ7zq1COv3p/utzFsNpvmpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/GAOHyKFouPMKZXIVls715MZDXhf5YdCcrQfJWBsXH/imEnlf2HKRilc4OMIbI/R
	 5LXRg8EqunMV6Uxwn1AqCy2R9SSP//ko7x7qJVOGTUTqCxviZF+ycQ7vMfJ2+3XT2y
	 AxVhOI3A1TbTLa2nCVPKALCxC/tL/4i9RztM/44s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/204] drm/xe/display: fix oops in suspend/shutdown without display
Date: Thu,  2 Jul 2026 18:17:46 +0200
Message-ID: <20260702155118.865170211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 68938cc08e23a94fd881e845837ff918de005ce7 ]

The xe driver keeps track of whether to probe display, and whether
display hardware is there, using xe->info.probe_display. It gets set to
false if there's no display after intel_display_device_probe(). However,
the display may also be disabled via fuses, detected at a later time in
intel_display_device_info_runtime_init().

In this case, the xe driver does for_each_intel_crtc() on uninitialized
mode config in xe_display_flush_cleanup_work(), leading to a NULL
pointer dereference, and generally calls display code with display info
cleared.

Check for intel_display_device_present() after
intel_display_device_info_runtime_init(), and reset
xe->info.probe_display as necessary. Also do unset_display_features()
for completeness, although display runtime init has already done
that. This will need to be unified across all cases later.

Move intel_display_device_info_runtime_init() call slightly earlier,
similar to i915, to avoid a bunch of unnecessary setup for no display
cases.

Note #1: The xe driver has no business doing low level display plumbing
like for_each_intel_crtc() to begin with. It all needs to happen in
display code.

Note #2: The actual bug is present already in commit 44e694958b95
("drm/xe/display: Implement display support"), but the oops was likely
introduced later at commit ddf6492e0e50 ("drm/xe/display: Make display
suspend/resume work on discrete").

Fixes: 44e694958b95 ("drm/xe/display: Implement display support")
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/7904
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/6150
Cc: stable@vger.kernel.org # v6.8+
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260515160920.1082842-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 7c3eb9f47533220888a67266448185fd0775d4da)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/xe_display.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/display/xe_display.c b/drivers/gpu/drm/xe/display/xe_display.c
index e164e2d71e1157..de1fd4dff0e869 100644
--- a/drivers/gpu/drm/xe/display/xe_display.c
+++ b/drivers/gpu/drm/xe/display/xe_display.c
@@ -148,6 +148,15 @@ int xe_display_init_noirq(struct xe_device *xe)
 
 	intel_display_driver_early_probe(xe);
 
+	intel_display_device_info_runtime_init(xe);
+
+	/* Display may have been disabled at runtime init */
+	if (!has_display(xe)) {
+		xe->info.probe_display = false;
+		unset_display_features(xe);
+		return 0;
+	}
+
 	/* Early display init.. */
 	intel_opregion_setup(display);
 
@@ -159,8 +168,6 @@ int xe_display_init_noirq(struct xe_device *xe)
 
 	intel_bw_init_hw(xe);
 
-	intel_display_device_info_runtime_init(xe);
-
 	err = intel_display_driver_probe_noirq(xe);
 	if (err) {
 		intel_opregion_cleanup(display);
-- 
2.53.0



