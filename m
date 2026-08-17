Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95FC3033E7;
	Mon, 17 Aug 2026 14:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975468; cv=none; b=s4myI+NlXndeP5ELC+T5nuQzruMXiBS75I3ngPoT34ibe9Goxdx5bGuhPJ3yEB/8Mi+f6glGtBYQXv36nMmaDAu+rcPg04x8eapWM7ieB3LAb27Vm+rVDdqwB4XewSfUawmcT+/8MfrolLFNZ1AHbasnZ2VjIA0rZMfYdzvuCEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975468; c=relaxed/simple;
	bh=8buZTEAuDvj8zO0lQloU+yX0GzSGmlQZ6OLO3MCgwfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5i49exoTarLjMwJyD6fikWnyXNxZDLw/vqkY064EYVD42W0BsyxXNhsXrrK9fMjLrBKdC+IY3O0ft9TaV5/uWdlhm1QCNPxhcwd4MQXO51dWqs5UEf27LHc7uC1W1Zj2yV7N3RhFSgP1XmHBOfgkOI0EnwSEB1FCVF4atMMM+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWjqCAow; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWjqCAow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBCA1F000E9;
	Mon, 17 Aug 2026 14:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975467;
	bh=rV4qtAKpkOGJd66WgclwEtFvWcBNY+tXnwhXmFs7vfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWjqCAowb26C8xUWEyAYsVRhYlppp8ZUlTS2lKlm93TGqSTmE34yPxACjPrEA+DYJ
	 fkKXC7sbRDoxzl87QufhSV5c12inlCPysjVLBbqiZT00pZgXE0xBQDzBEExLJt4fLV
	 MTIQ5tu0qH4IN3lW8iSGrVWm2KTPizh0cx8LnDN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/389] drm/i915/gt: use correct selftest config symbol
Date: Mon, 17 Aug 2026 15:27:58 +0200
Message-ID: <20260817132540.509505921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index da21d2a10cc942..9aa7040e295ede 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_user.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_user.c
@@ -232,7 +232,7 @@ void intel_engines_driver_register(struct drm_i915_private *i915)
 		p = &prev->rb_right;
 	}
 
-	if (IS_ENABLED(CONFIG_DRM_I915_SELFTESTS) &&
+	if (IS_ENABLED(CONFIG_DRM_I915_SELFTEST) &&
 	    IS_ENABLED(CONFIG_DRM_I915_DEBUG_GEM)) {
 		struct intel_engine_cs *engine;
 		unsigned int isolation;
-- 
2.53.0



