Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E6D26CE33;
	Fri, 21 Nov 2025 13:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731586; cv=none; b=Bj2OmY0GGC+dJaSSsGoyOs1wjgFVdCtTrMMZ8BrPCfL5Xkpms1S65YAE0V0T1g1IkNCQkxtQI5jneXwmqUfkou1akWDrtnLq2rhTYBGaVedcjio8FR1TKBO2Y4l1ew1xT5y9jlUwe8xtPHmlnj2xh2nss36FJ3Y6J5b8ubMBgDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731586; c=relaxed/simple;
	bh=mAM2C41XQ23We/nFcXMtp5uB8dNnvo79TMPjsB9rXLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nk7bVDYW+a/IFQWb0M7k49yupYUoWirKv49432uwoerY/MdtSYM5NgrtpgkjEHiGTZGW2W07xkfFSmwl7UXQeKfTFwW/T3dzWB/drTenwbKyiEiMO0lCuhClzrqityAetNNDfEG1ChMco7+nz7SsFhCq+7FjLD/rZSdLy8EJwwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXVH3M82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXVH3M82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38850C4CEF1;
	Fri, 21 Nov 2025 13:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731586;
	bh=mAM2C41XQ23We/nFcXMtp5uB8dNnvo79TMPjsB9rXLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXVH3M82S6kd6b7FbkYKkiGcK+ExEK1+fqX18FoF96ZCEXUb0RpNSCP9yPqzo2zVY
	 CoQvgmMl/5UdO3D/QyEBxUFYcc1mcfi1aqwrt9hEDKzxa2TZID5WOg4fMqWSSvHxzQ
	 3aW65SYnl2aUMbguCWWuLVp9CDliatc9jUS/gwJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/185] drm/i915: Fix conversion between clock ticks and nanoseconds
Date: Fri, 21 Nov 2025 14:10:30 +0100
Message-ID: <20251121130143.990155373@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit 7d44ad6b43d0be43d080180413a1b6c24cfbd266 ]

When tick values are large, the multiplication by NSEC_PER_SEC is larger
than 64 bits and results in bad conversions.

The issue is seen in PMU busyness counters that look like they have
wrapped around due to bad conversion. i915 PMU implementation returns
monotonically increasing counters. If a count is lesser than previous
one, it will only return the larger value until the smaller value
catches up. The user will see this as zero delta between two
measurements even though the engines are busy.

Fix it by using mul_u64_u32_div()

Fixes: 77cdd054dd2c ("drm/i915/pmu: Connect engine busyness stats from GuC to pmu")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14955
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://lore.kernel.org/r/20251016000350.1152382-2-umesh.nerlige.ramappa@intel.com
(cherry picked from commit 2ada9cb1df3f5405a01d013b708b1b0914efccfe)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Rodrigo: Added the Fixes tag while cherry-picking to fixes]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_gt_clock_utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_gt_clock_utils.c b/drivers/gpu/drm/i915/gt/intel_gt_clock_utils.c
index 6e63505fe4781..f01399c78c99d 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_clock_utils.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_clock_utils.c
@@ -209,7 +209,7 @@ static u64 div_u64_roundup(u64 nom, u32 den)
 
 u64 intel_gt_clock_interval_to_ns(const struct intel_gt *gt, u64 count)
 {
-	return div_u64_roundup(count * NSEC_PER_SEC, gt->clock_frequency);
+	return mul_u64_u32_div(count, NSEC_PER_SEC, gt->clock_frequency);
 }
 
 u64 intel_gt_pm_interval_to_ns(const struct intel_gt *gt, u64 count)
@@ -219,7 +219,7 @@ u64 intel_gt_pm_interval_to_ns(const struct intel_gt *gt, u64 count)
 
 u64 intel_gt_ns_to_clock_interval(const struct intel_gt *gt, u64 ns)
 {
-	return div_u64_roundup(gt->clock_frequency * ns, NSEC_PER_SEC);
+	return mul_u64_u32_div(ns, gt->clock_frequency, NSEC_PER_SEC);
 }
 
 u64 intel_gt_ns_to_pm_interval(const struct intel_gt *gt, u64 ns)
-- 
2.51.0



