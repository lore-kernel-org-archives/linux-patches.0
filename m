Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2E4418A44;
	Thu, 30 Jul 2026 15:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425647; cv=none; b=shtIKyi17MVCsPb7FAOeptzfecP0NbmV2NR52M5YIRpXTRyfi9WwSMty/pr/+QU2VgCr30DvRQQuzMJEl59lzcEP7o3MAyjrIg1CvkzaqYOxNLbPV+Lg0CuTdl3sbjMOCAYQg5qqQiJmDmzwvG7St/xRoeMj5hUHl6FMkL2uqv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425647; c=relaxed/simple;
	bh=pyV8Pk3740mOQn7l+xbdyBkPH7wZ2J/MrnnN5YB9lA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovT+sNAkojj1znxyNhL99SWNZkao3w3nWkQZcQXfftqK60Nb4/VmLJQlsR4clYlei6U9Z2TS9sl/jSXmLUWngnm/LodWkFBpYI9B6GKMRr7rHzLU76LaxS6uhCJ7O+tx1yP9vcQJ2+/qSBRoFWu3WnVf5jQy5BncXT30sfTA994=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKpF7lut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKpF7lut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93571F000E9;
	Thu, 30 Jul 2026 15:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425646;
	bh=w+t/z3+h3pJ1eNi4IMo7d/1HFcVLxxZjH5XWyq3dV4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZKpF7lutwtcw+6QePqlq2E6jxPxuqqsSTNtFeCFFoCXdIzTTT0xrBTBGGOXnHyoco
	 AJuo7be6c2j06nhImdA5EEMKshJzlsdA6fsypUwZYWLfPMB3qzqVIUtF3ZxNHKA444
	 S2CwdTC2YeIErzDRPMcgPS5BrAMcO2OGzlYNkTrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/602] drm/i915/gt: use correct selftest config symbol
Date: Thu, 30 Jul 2026 16:08:09 +0200
Message-ID: <20260730141438.033044645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit a82f1bb8191aec98a971a2196136016ef70c0880 ]

intel_engine_user.c checks CONFIG_DRM_I915_SELFTESTS before running
the engine UABI isolation check. Kconfig defines DRM_I915_SELFTEST,
without the trailing "S", and the rest of i915 uses
CONFIG_DRM_I915_SELFTEST.

Because CONFIG_DRM_I915_SELFTESTS is not backed by any Kconfig symbol,
the IS_ENABLED() test is always false. Use the existing selftest symbol
so the debug/selftest guarded path can be reached when selftests are
enabled.

This is a source-level fix. It does not claim dynamic hardware
reproduction; the evidence is the Kconfig definition and the inconsistent
guard in intel_engine_user.c.

Fixes: 750e76b4f9f6 ("drm/i915/gt: Move the [class][inst] lookup for engines onto the GT")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Link: https://lore.kernel.org/r/20260705080225.436-1-pengpeng@iscas.ac.cn
(cherry picked from commit 14a2012a490258f3f93857bc4f1b203405964be7)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_user.c b/drivers/gpu/drm/i915/gt/intel_engine_user.c
index 833987015b8bbc..ed42b9d05a07d5 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_user.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_user.c
@@ -257,7 +257,7 @@ void intel_engines_driver_register(struct drm_i915_private *i915)
 		p = &prev->rb_right;
 	}
 
-	if (IS_ENABLED(CONFIG_DRM_I915_SELFTESTS) &&
+	if (IS_ENABLED(CONFIG_DRM_I915_SELFTEST) &&
 	    IS_ENABLED(CONFIG_DRM_I915_DEBUG_GEM)) {
 		struct intel_engine_cs *engine;
 		unsigned int isolation;
-- 
2.53.0



