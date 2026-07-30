Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEE043F0AA;
	Thu, 30 Jul 2026 14:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421460; cv=none; b=hL8+Z1LI0vUrSWa2A9nbcsZCGF2qPNHzlUhxwmDEz+QNHGecfIwLw2uEWz4NMe8arbdrCSOpd0DMBesrlM8VuIhxJUNsLb88fmY0wlX7RVVTYKeZ2mf09sxG8Vm/E2IUaYD8ijFEZ5CpyFzIdcPWuWQTLkWg7smw97+93dcPx9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421460; c=relaxed/simple;
	bh=fJN4eHCC/IV48SYM1IEEGxNerHP8yX2KvAyjMKyFnEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpQneGUpzPm7bsSW2Zz9hWiID+e0llnyjQPs5x+OA6WlGbc35v5dBrtmUSg1uS/Db7RiRpmQ9ObPGREO1QRp3+//2Pj0phGTS2opd+xdPZQWrQhLA8uqlulzByxFneQT+6FY3WwM5X0NjdS6FVNfo0I/Xrx+k6qgWcQfAr+fCLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tK/rYa5W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tK/rYa5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EC61F000E9;
	Thu, 30 Jul 2026 14:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421457;
	bh=VKB8xagwa9ZADlx/AOyOlf7eM3LnYmmGHyJ9LFu/6Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tK/rYa5Wf8mk8gp78r8GziWUvh/J5voWps+QfVxClFl9WEmXMDdDoE+8QrCsJmsAB
	 lX1uLyGptal4eraKlesMv5VIXpoF72zXu01uWq/5lo7TsJxogG98PlBm9Jf1Hh7nZ9
	 mJqbmTzVQrusKCbg5KTpL7usFipGEFQoRCOjgjZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 109/744] drm/i915/gt: use correct selftest config symbol
Date: Thu, 30 Jul 2026 16:06:22 +0200
Message-ID: <20260730141446.594029554@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
index be4bbff1a57c9c..d5190e11b27062 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_user.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_user.c
@@ -259,7 +259,7 @@ void intel_engines_driver_register(struct drm_i915_private *i915)
 		p = &prev->rb_right;
 	}
 
-	if (IS_ENABLED(CONFIG_DRM_I915_SELFTESTS) &&
+	if (IS_ENABLED(CONFIG_DRM_I915_SELFTEST) &&
 	    IS_ENABLED(CONFIG_DRM_I915_DEBUG_GEM)) {
 		struct intel_engine_cs *engine;
 		unsigned int isolation;
-- 
2.53.0



