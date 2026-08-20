Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BA347D449;
	Thu, 20 Aug 2026 16:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243687; cv=none; b=SwruaN+pZQBLSKBJcNdV6SiSk0mMA9YOpWcTVLYN/AJP+75rs5zII7RL83YPYrfGhgGkkzTpI7p8XKYTvwqEyfoau75gjRYnftZs3VgrGijBgbpmlU4dtXnJzKrvizeg0xUsH6bW0QFDV/XXALT8cR87lc9n6b1Ckvg1so4lBIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243687; c=relaxed/simple;
	bh=pC/Wt4ryqPjiyNjtP6nnNAaLfzq8Ghvy33OFdR2NS+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KX4Q1dK/+jNUiB/apmp5W9oeO1lMSrFdgIgeb5UpGj/lO3aLLj6HIwFSr1TufavC2UjALPyXf4TKwjZZ7/4sXbAF2fXwZhF9uHj+YQXAGx/353BQuz4j5ZFB9LFmINlCKWw8IcC0wEnGmDEWFFPjQMfmIyD9l6eN71hGN5ITk6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zv6I2aF9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zv6I2aF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BF01F000E9;
	Thu, 20 Aug 2026 16:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243684;
	bh=w/FwSY1Xutg93DJ5mqPIjwdUa/PkPczAK9Do3dseCgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zv6I2aF9qKV1mdDY3oTV6a7FGIuAwVH12pwXQeTrKv+djpIM6r+Kop8JznFAijw5+
	 +tF2DxeQSFCMD5zPldKQUnFIHNT5IenUV/f8PkfGMVwOK8yTtSOb1I/IXFDnMtHKgy
	 UOluK/MXatQNZzm+e9xEa7OKOYyrrpDPh95Mkbe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/272] drm/i915/vrr: require valid min/max vfreq for VRR
Date: Thu, 20 Aug 2026 16:56:04 +0200
Message-ID: <20260820145236.861651423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit f8a9262c7a6fc2de9802e14b0228114f0333869e ]

Ensure the EDID provided min/max vfreq are valid. Most scenarios are
already covered (by coincidence) through the checks in
intel_vrr_is_capable() and intel_vrr_is_in_range(), but be more explicit
about it. At worst, a zero min_vfreq could lead to a division by zero in
intel_vrr_compute_vmax().

Discovered using AI-assisted static analysis confirmed by Intel Product
Security.

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: 117cd09ba528 ("drm/i915/display/dp: Compute VRR state in atomic_check")
Cc: stable@vger.kernel.org # v5.12+
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20260625131040.1051272-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 1765cf59f517b02f3b0591fe5120930d08bddeb6)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
[ adjusted context to 5.15's `intel_vrr_is_capable(struct drm_connector *)` form, inserting the guard before the existing compound `return HAS_VRR(i915) && ...` instead of upstream's refactored bare return. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_vrr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_vrr.c
+++ b/drivers/gpu/drm/i915/display/intel_vrr.c
@@ -26,6 +26,10 @@ bool intel_vrr_is_capable(struct drm_con
 	 * EDID monitor range also should be atleast 10 for reasonable
 	 * Adaptive Sync or Variable Refresh Rate end user experience.
 	 */
+	if (!info->monitor_range.min_vfreq || !info->monitor_range.max_vfreq ||
+	    info->monitor_range.min_vfreq > info->monitor_range.max_vfreq)
+		return false;
+
 	return HAS_VRR(i915) &&
 		drm_dp_sink_can_do_video_without_timing_msa(intel_dp->dpcd) &&
 		info->monitor_range.max_vfreq - info->monitor_range.min_vfreq > 10;


