Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4DE2F12A4;
	Fri, 21 Nov 2025 13:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730872; cv=none; b=PB+Ngi5J241LwqSWNjVY35n2WA9e4XxtY3u7AgPHp5P6eg/66rLI2TmJ5tkdW9DUaemwgvqHv9mJoXE3BCAPluY2FIPzi30XTGVZLKxhqe+MZHsM/lsjTSkVIcvp+fdo+gpHvNEwDluXqlbAae8/U3rJtzqhnFun7PvUVeUQe7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730872; c=relaxed/simple;
	bh=dpseHaQpLG7t7pSowCgx0kc1CSmOEhpRBXtIjLHD7TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+qW+1gU/toNGlpXB2yZr4K1Ls8abI/APOjSZQv/lJnbdbNnild62Ptq1NzhYnIkdcJov8djL6WDjtQlLIjOrT9mr6m/TlNv0g2PPttxZ6rkE3wiV8oIcXYZCbrvm8z/w/3vzC9b7PFtB6+Pz0qB7+4iB2ZFe3JvvJ9zQn186wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+3DkCki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+3DkCki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87174C4CEF1;
	Fri, 21 Nov 2025 13:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730871;
	bh=dpseHaQpLG7t7pSowCgx0kc1CSmOEhpRBXtIjLHD7TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+3DkCkiZjbEyo4ueuFNERVbjbDfPnRXWVsmZM8GMoDWW6Hx5fLZnRjfQVrnnVJAd
	 w21Qxol/ZWGHwDAzEnNHV9Y0btdqcTL4BeAqSz0Zc4L3IoAZYluaV6JCTzuwkdr4on
	 iuacSa+OC8mLZaaWOxOhFHvhZfDT/H5M8A7607xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 004/247] drm/i915: Fix conversion between clock ticks and nanoseconds
Date: Fri, 21 Nov 2025 14:09:11 +0100
Message-ID: <20251121130154.753585550@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 6c499692d61ef..3eb4206b371d2 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_clock_utils.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_clock_utils.c
@@ -205,7 +205,7 @@ static u64 div_u64_roundup(u64 nom, u32 den)
 
 u64 intel_gt_clock_interval_to_ns(const struct intel_gt *gt, u64 count)
 {
-	return div_u64_roundup(count * NSEC_PER_SEC, gt->clock_frequency);
+	return mul_u64_u32_div(count, NSEC_PER_SEC, gt->clock_frequency);
 }
 
 u64 intel_gt_pm_interval_to_ns(const struct intel_gt *gt, u64 count)
@@ -215,7 +215,7 @@ u64 intel_gt_pm_interval_to_ns(const struct intel_gt *gt, u64 count)
 
 u64 intel_gt_ns_to_clock_interval(const struct intel_gt *gt, u64 ns)
 {
-	return div_u64_roundup(gt->clock_frequency * ns, NSEC_PER_SEC);
+	return mul_u64_u32_div(ns, gt->clock_frequency, NSEC_PER_SEC);
 }
 
 u64 intel_gt_ns_to_pm_interval(const struct intel_gt *gt, u64 ns)
-- 
2.51.0



