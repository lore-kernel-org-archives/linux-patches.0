Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A8657CA1;
	Tue, 14 May 2024 10:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682584; cv=none; b=J+znr/iHAd9p0n/lQVNebk74SgMoi81WaDIgtce/EwnsmEaphT+LhfmKHy1lnal/FtRaZaN9RhDsvXMicFHY/2Ln0MMxjGG1R28il942Y5QiJk3oldvV9TtiVm23rLYJgkCT5En4qJsMcM/VHj3MA8Jgvh5LJjZcQv8bzBFIB50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682584; c=relaxed/simple;
	bh=ctDR2JlXjd93Gy5wH6AZvKzRK12xQbeDPoiaB6SRTbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUM8tOtVrGyfqKrgPwjYkhvAtza/bF8HNpxLp8AUYmsWYHJWYzuhXBRk55aAsAOk/Zeecx3sBOHjRYdjPE2h3t2SfAEA6sE3PClfjUKior98JJyn8c8rHdx9f580mLqgwDm5EexefwGyvqKav1dyt3c/oeRe5LQe6YwFgFfd7ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MM5c6iw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MM5c6iw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029E0C2BD10;
	Tue, 14 May 2024 10:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682584;
	bh=ctDR2JlXjd93Gy5wH6AZvKzRK12xQbeDPoiaB6SRTbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MM5c6iw6tFnMnwDxu8yV1op6MyeDJ9GLKlzazDdDFVyLyMOVKrraHAyvUyb1owU6w
	 D1ajgsE7YgVvDg5Osu7z4t0wf4CxfSNhYwoqfZy00t7nA87NM5ZGqYpEwNk/2ihLH2
	 oKWI8RCKTkirey4k5Ijmx7l6DtwyF9rudUi968o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 086/336] drm/xe/display: Fix ADL-N detection
Date: Tue, 14 May 2024 12:14:50 +0200
Message-ID: <20240514101041.854251215@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit df04b152fca2d46e75fbb74ed79299bc420bc9e6 ]

Contrary to i915, in xe ADL-N is kept as a different platform, not a
subplatform of ADL-P. Since the display side doesn't need to
differentiate between P and N, i.e. IS_ALDERLAKE_P_N() is never called,
just fixup the compat header to check for both P and N.

Moving ADL-N to be a subplatform would be more complex as the firmware
loading in xe only handles platforms, not subplatforms, as going forward
the direction is to check on IP version rather than
platforms/subplatforms.

Fix warning when initializing display:

	xe 0000:00:02.0: [drm:intel_pch_type [xe]] Found Alder Lake PCH
	------------[ cut here ]------------
	xe 0000:00:02.0: drm_WARN_ON(!((dev_priv)->info.platform == XE_ALDERLAKE_S) && !((dev_priv)->info.platform == XE_ALDERLAKE_P))

And wrong paths being taken on the display side.

Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240425181610.2704633-1-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 6a2a90cba12b42eb96c2af3426b77ceb4be31df2)
Fixes: 44e694958b95 ("drm/xe/display: Implement display support")
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h b/drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h
index 5d2a77b52db41..d9a81e6a4b85a 100644
--- a/drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h
+++ b/drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h
@@ -84,7 +84,8 @@ static inline struct drm_i915_private *kdev_to_i915(struct device *kdev)
 #define IS_ROCKETLAKE(dev_priv)	IS_PLATFORM(dev_priv, XE_ROCKETLAKE)
 #define IS_DG1(dev_priv)        IS_PLATFORM(dev_priv, XE_DG1)
 #define IS_ALDERLAKE_S(dev_priv) IS_PLATFORM(dev_priv, XE_ALDERLAKE_S)
-#define IS_ALDERLAKE_P(dev_priv) IS_PLATFORM(dev_priv, XE_ALDERLAKE_P)
+#define IS_ALDERLAKE_P(dev_priv) (IS_PLATFORM(dev_priv, XE_ALDERLAKE_P) || \
+				  IS_PLATFORM(dev_priv, XE_ALDERLAKE_N))
 #define IS_XEHPSDV(dev_priv) (dev_priv && 0)
 #define IS_DG2(dev_priv)	IS_PLATFORM(dev_priv, XE_DG2)
 #define IS_PONTEVECCHIO(dev_priv) IS_PLATFORM(dev_priv, XE_PVC)
-- 
2.43.0



