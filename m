Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197744657CD;
	Tue, 16 Jun 2026 15:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624597; cv=none; b=gtXMVI8JLOkGuspO7eKgN6P1ACzzj/llgKVBQYezEhR6VEip9DGtI6RkSbbEm+aexX9/pPkxZ3BfKWOsKUjdLujD01U550RtpuUk0L4JJDuY3xamW0FMQBt7EYV+rtAZl0cm7qEPnEMMyjl/L4wFDx/ZXYKscvi7JMoOZwqq8jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624597; c=relaxed/simple;
	bh=jyPG1sOb0OjFvDBIoG9JFQTGJTDGKdwgb6YaSKyOrFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+ukI3zfX6gm7k+WSbLTueKDrDS9pzBKVDtuass4xGI8PM3TNtO+8T5gZJ+G5kMhlu4etpZUpp6XyIPE+3TEuZcfWkkfde5JzCPTSNf/yh3o4v9JJVDSeem+yV7knFM0zyJDANzaV/8r3tYRNCEP3jvlz9camoqbXlJcQmOR1d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fsX1Bfga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fsX1Bfga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9B31F000E9;
	Tue, 16 Jun 2026 15:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624595;
	bh=/1bpUiurgqfmOKKo+4wLJsv0Kpc4kaat9FVchQv1gXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsX1BfgaYas4Nd/evmY+lMI28Q2gDNPSyOXOUsG/oJ9QWSz4nxsXwDYcSoMSM4TLK
	 t5Qw5uOrkFR2JPkKmZFHNsQSLJqPbsIEmrUbeqsiWhuXFRjS7vqW7ACTSzkW82Cp4Z
	 hjnaZttjduErs7dMeITTf0oeML/9D3aOeKACuzU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 7.0 337/378] drm/xe/display: fix oops in suspend/shutdown without display
Date: Tue, 16 Jun 2026 20:29:28 +0530
Message-ID: <20260616145127.946309641@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 68938cc08e23a94fd881e845837ff918de005ce7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/display/xe_display.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/display/xe_display.c
+++ b/drivers/gpu/drm/xe/display/xe_display.c
@@ -119,6 +119,15 @@ int xe_display_init_early(struct xe_devi
 
 	intel_display_driver_early_probe(display);
 
+	intel_display_device_info_runtime_init(display);
+
+	/* Display may have been disabled at runtime init */
+	if (!intel_display_device_present(display)) {
+		xe->info.probe_display = false;
+		unset_display_features(xe);
+		return 0;
+	}
+
 	/* Early display init.. */
 	intel_opregion_setup(display);
 
@@ -132,8 +141,6 @@ int xe_display_init_early(struct xe_devi
 
 	intel_bw_init_hw(display);
 
-	intel_display_device_info_runtime_init(display);
-
 	err = intel_display_driver_probe_noirq(display);
 	if (err)
 		goto err_opregion;


