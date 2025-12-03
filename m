Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3EC343D98;
	Wed,  3 Dec 2025 16:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779695; cv=none; b=WZpoJQleVNOmc2bLHs/bXcLaRA8pJG8bHs5OajmAH+rkomd4JDg68nknPc9AMHtciXRUW+bTaUrxx1mhsmYZHl1sA1F1amxEJ4faS4dwHv5b9ZTK3rMCL7THoLVvTg/qe7ZMFZZLCO51+VrMEI9VXpnw/Kx9wvPdt12ogOl718U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779695; c=relaxed/simple;
	bh=pKImpRCnnPNrSI+eRRp9LrpU73x/ttnZgWHCmlPX2eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOwJviIhILTYANuErwt3QQi4ddr2FIdvibVq6GPHAOmAlYoBiDFiyGPodIIex082BMhSuqCEmielIosphFCGCSmepP6B6bfyilpljD7KuCqy2RPE4bbHhARX5I5D629nsTh+/hepatNs25/m9Cb5BPA2lL0VoxXwoN7GbbLPYms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+C+nWrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+C+nWrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA25CC4CEF5;
	Wed,  3 Dec 2025 16:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779695;
	bh=pKImpRCnnPNrSI+eRRp9LrpU73x/ttnZgWHCmlPX2eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+C+nWrN8MZAa6S4jxfO8QViKvNKnIlpwWa71kHhJ48FheTqaKUiQaCWxmYFMgYTN
	 OeK20J6H+fwzg0eZ+fb4BIyOE3cDgFKaJgR+qlHeA0h/Jarqmf+gl7xBJ0Li0exE6E
	 RAuWdAGQyLW2l8w2TkViQV1FxcnPPPEbiy7DEFLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 334/568] drm/i915: Fix conversion between clock ticks and nanoseconds
Date: Wed,  3 Dec 2025 16:25:36 +0100
Message-ID: <20251203152452.942517510@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3f656d3dba9a8..8eebf41799781 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_clock_utils.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_clock_utils.c
@@ -180,7 +180,7 @@ static u64 div_u64_roundup(u64 nom, u32 den)
 
 u64 intel_gt_clock_interval_to_ns(const struct intel_gt *gt, u64 count)
 {
-	return div_u64_roundup(count * NSEC_PER_SEC, gt->clock_frequency);
+	return mul_u64_u32_div(count, NSEC_PER_SEC, gt->clock_frequency);
 }
 
 u64 intel_gt_pm_interval_to_ns(const struct intel_gt *gt, u64 count)
@@ -190,7 +190,7 @@ u64 intel_gt_pm_interval_to_ns(const struct intel_gt *gt, u64 count)
 
 u64 intel_gt_ns_to_clock_interval(const struct intel_gt *gt, u64 ns)
 {
-	return div_u64_roundup(gt->clock_frequency * ns, NSEC_PER_SEC);
+	return mul_u64_u32_div(ns, gt->clock_frequency, NSEC_PER_SEC);
 }
 
 u64 intel_gt_ns_to_pm_interval(const struct intel_gt *gt, u64 ns)
-- 
2.51.0



