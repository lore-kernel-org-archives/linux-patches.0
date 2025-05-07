Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602B42144C1;
	Wed,  7 May 2025 19:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645088; cv=none; b=oD3ayqQkfRMO9TNqB9sKJScdI0moLhu/2G5NMaqIoUO0Jmqz4NBMVXfUE6HGu9CoHt3JQQnf+OiagCBQwrFhPROe4v6H/mFtGA6s1RcNL82NFw1iHjrI9L4u3qS2rwnfcO38r6YL2ogKo8tErL9YSC43c554IfjeSgLOZJh+udk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645088; c=relaxed/simple;
	bh=qAz1E8er0nD020c3Gakm8w5bhTFkiUMJtdH7z86E+Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYAhDkshdbazCPeApLr88w+2TIAHcSNETGEjFZizcbMdiEyOJ9ov70Lb+NYkRx38bAEO+oZTgCf74j6QRZmzEq+7LSUE/W/cEqzm7CNhDJWY2BZtuiZvIXzFjyt1duSl85nv4/Ey2LcFfOGk84yldN904OrHxU8UqCr6lbfLEyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duYHvOu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duYHvOu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8ED0C4CEE2;
	Wed,  7 May 2025 19:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645088;
	bh=qAz1E8er0nD020c3Gakm8w5bhTFkiUMJtdH7z86E+Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duYHvOu3a3vCkm7v/SzvyRMGmqvOAk/itCbQJyTn19/kfLHrWtFjHIHb0Np22m3J5
	 kAJpOs8lFbqXwtHgK2sD/Yc+9GcVKEsSfUH6Pfw83j2A8JocqNdKz+JY63OXu4mxhI
	 Qv75oxdS0xS0WGj1/I32CAH+mMROTVQGUGSOVMPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/129] drm/i915/pxp: fix undefined reference to `intel_pxp_gsccs_is_ready_for_sessions
Date: Wed,  7 May 2025 20:39:46 +0200
Message-ID: <20250507183815.565611089@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Linxuan <chenlinxuan@uniontech.com>

[ Upstream commit 7e21ea8149a0e41c3666ee52cc063a6f797a7a2a ]

On x86_64 with gcc version 13.3.0, I compile kernel with:

  make defconfig
  ./scripts/kconfig/merge_config.sh .config <(
    echo CONFIG_COMPILE_TEST=y
  )
  make KCFLAGS="-fno-inline-functions -fno-inline-small-functions -fno-inline-functions-called-once"

Then I get a linker error:

  ld: vmlinux.o: in function `pxp_fw_dependencies_completed':
  kintel_pxp.c:(.text+0x95728f): undefined reference to `intel_pxp_gsccs_is_ready_for_sessions'

This is caused by not having a intel_pxp_gsccs_is_ready_for_sessions()
header stub for CONFIG_DRM_I915_PXP=n. Add it.

Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
Fixes: 99afb7cc8c44 ("drm/i915/pxp: Add ARB session creation and cleanup")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://lore.kernel.org/r/20250415090616.2649889-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit b484c1e225a6a582fc78c4d7af7b286408bb7d41)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.h b/drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.h
index 298ad38e6c7df..c36d956b9b824 100644
--- a/drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.h
+++ b/drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.h
@@ -25,6 +25,7 @@ int intel_pxp_gsccs_init(struct intel_pxp *pxp);
 
 int intel_pxp_gsccs_create_session(struct intel_pxp *pxp, int arb_session_id);
 void intel_pxp_gsccs_end_arb_fw_session(struct intel_pxp *pxp, u32 arb_session_id);
+bool intel_pxp_gsccs_is_ready_for_sessions(struct intel_pxp *pxp);
 
 #else
 static inline void intel_pxp_gsccs_fini(struct intel_pxp *pxp)
@@ -36,8 +37,11 @@ static inline int intel_pxp_gsccs_init(struct intel_pxp *pxp)
 	return 0;
 }
 
-#endif
+static inline bool intel_pxp_gsccs_is_ready_for_sessions(struct intel_pxp *pxp)
+{
+	return false;
+}
 
-bool intel_pxp_gsccs_is_ready_for_sessions(struct intel_pxp *pxp);
+#endif
 
 #endif /*__INTEL_PXP_GSCCS_H__ */
-- 
2.39.5



