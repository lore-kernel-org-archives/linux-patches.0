Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026601FF5EC;
	Wed,  7 May 2025 18:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643917; cv=none; b=ocBko8IdyFcqvT6meQKbXLa12hXWDaroWEElS+GVEDzbCD/SF+Xptc/754MyrnKALaiR6sapCE+/qwmIBSObbf+3GvvvpdlU0mVoHD6rmS1XdTUrZCMWmqs5fJG0TYWpVX5fLHd9fpKsmGkyherxRR8YZjC+ItGrAEJFKjPs8Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643917; c=relaxed/simple;
	bh=jZtAFZ/Ya4TN5M+/wApRbcHwuMqQBY/Z81A3qevJ5RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dc1/AaqjJqcS99YWqpvrRRU5dPpgbKflBehoBNyir/RCaFtpyIA7S5fD5bZHKJTcGs0VYankjloq+b6YbC1MuvWyfIbT79euIcOZhu9dN+SP9hB5AmliQ4l05aC1+Yiac/XWoFPQ2WQtXDhsSiRYEFWNH0rYhfepxpsLNql3K6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q66mUFgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q66mUFgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FEEC4CEEB;
	Wed,  7 May 2025 18:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643915;
	bh=jZtAFZ/Ya4TN5M+/wApRbcHwuMqQBY/Z81A3qevJ5RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q66mUFgIOgoIrwRhWsLdUODf5LEYEm+J/2AZEdTwV75IEvc0jvPT7VD3RgRbmx3z0
	 XaUDd8hKGlXeU/2j9ciMKV+GKcUytkqyLTosQ9LjaMhqm8joDjhBdu9kM44VregseF
	 /WWVSmm2mpGUCq35eXWaordErLvOSORiov+Gibxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 060/183] drm/i915/pxp: fix undefined reference to `intel_pxp_gsccs_is_ready_for_sessions
Date: Wed,  7 May 2025 20:38:25 +0200
Message-ID: <20250507183827.116670706@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 9aae779c4da31..4969d3de2bac3 100644
--- a/drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.h
+++ b/drivers/gpu/drm/i915/pxp/intel_pxp_gsccs.h
@@ -23,6 +23,7 @@ int intel_pxp_gsccs_init(struct intel_pxp *pxp);
 
 int intel_pxp_gsccs_create_session(struct intel_pxp *pxp, int arb_session_id);
 void intel_pxp_gsccs_end_arb_fw_session(struct intel_pxp *pxp, u32 arb_session_id);
+bool intel_pxp_gsccs_is_ready_for_sessions(struct intel_pxp *pxp);
 
 #else
 static inline void intel_pxp_gsccs_fini(struct intel_pxp *pxp)
@@ -34,8 +35,11 @@ static inline int intel_pxp_gsccs_init(struct intel_pxp *pxp)
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



