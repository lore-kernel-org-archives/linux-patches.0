Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA395472798;
	Tue, 16 Jun 2026 16:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626423; cv=none; b=egNjn6Jf9nq5oWMD5L2bDfxagqJVJqEFOMDPsRcwIKLR08pEjrdwkloxzUdmTDkgFTTURNOPHzle00n9fH6T4wRxgc2pUJf1PqEj6TwpUMTEyvcOt7KkJ+1Np1+URRHqsxwPOk65ebg7VkzZS4vh0Zpo62eUIPd8npTYyA6C9dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626423; c=relaxed/simple;
	bh=L1fNJR969h7nYxRl1EfQUVLxcd9QR/opJlrqso8lEKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmCJdYeBlU8fWnzkprHSHKz5mj2f9tz5ivypvZQCUwoW3yybM2ZUTA6TAOWvhpOIdTGuoNx9ArONeOEd6PPdI6eLhdReqlNAmrVN/6Amc2N7ORwqhOgvv1neQsmNORSgDT+TSDepR1nvb+VZSynq/pWgUV5t5j46kd/hNXASm5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGGfc8N/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGGfc8N/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20381F000E9;
	Tue, 16 Jun 2026 16:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626422;
	bh=+vKTjGxG8AbOR4e7AlndOVU/tv72YcLVYERdH6iiEYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGGfc8N/RgrxYf5N8FhCoejkhMen+AY8q2Rv5og8BXUi8dJ/cBSYjWGbeQry4cVC8
	 cQMQLF+/OlDJ2qmb6JR5L5S4IHyY2D8ABdMQHF1QV1rbYrwCPT9hH4IETCyenYFAom
	 XkVQUslA+9bJ/3X30h2FNZ2QiHer1+xyd6Oqq4Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 6.18 285/325] drm/xe/display: fix oops in suspend/shutdown without display
Date: Tue, 16 Jun 2026 20:31:21 +0530
Message-ID: <20260616145112.955135136@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
@@ -109,6 +109,15 @@ int xe_display_init_early(struct xe_devi
 
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
 
@@ -122,8 +131,6 @@ int xe_display_init_early(struct xe_devi
 
 	intel_bw_init_hw(display);
 
-	intel_display_device_info_runtime_init(display);
-
 	err = intel_display_driver_probe_noirq(display);
 	if (err)
 		goto err_opregion;


