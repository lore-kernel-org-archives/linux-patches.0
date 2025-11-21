Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D627F34DB5C;
	Fri, 21 Nov 2025 13:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733180; cv=none; b=gqg8nQOFvdryx9NQr9EsAAvkCUF82JYicz8dD9DcWR3OZo+/ObrlSOc8x3zzlOhpOUWSUThRNg9q2FRlVx12fTyoLEwucTiRCh61tRszM6V7ADwAxu/ce8StfiMpxLX+3v23bwDYQVrnbht8cAwMUF9Ox2XFGInXUdMhWuVkBdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733180; c=relaxed/simple;
	bh=cKYh+hUhy4B1bqUQAX+4HJTh61FMTwTz7BOX8uvdMfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWiwc9Zz7ZYxsmR+PNm0/UNg1tXeUCz2O8Bo2lkzdukpfwmj9K8z7sF+nnC+jAuhYWMO/0TedGJxGOfGyoC4F/QVQ6jNrRexuS95wZRMp/xF5YsSOv5xP4nF/9UpZ+eLI8V4k+9iORDSo3aL4Q2+iUMPT/AQu9bhIwtDTPWBUg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDuyONAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDuyONAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC6EC4AF0C;
	Fri, 21 Nov 2025 13:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733180;
	bh=cKYh+hUhy4B1bqUQAX+4HJTh61FMTwTz7BOX8uvdMfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDuyONAZUwjMvnKbj+5tMYa2mnu0q4xCF6L6UBTL7mVb+fYP/jvsfo1+1VG7p/98G
	 bCZDk1chyOMB03yMbvh8oasVzW7vpapyT1rNK2pxZyXBHR5ezvcKWgQyboHeaPNTrL
	 FpJj3VRbuEYyxkFlolPePxP4D2i5VygPblv9HkYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 378/529] drm/i915: Fix conversion between clock ticks and nanoseconds
Date: Fri, 21 Nov 2025 14:11:17 +0100
Message-ID: <20251121130244.475016465@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7c9be4fd1c8c4..7a950c1502b6e 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_clock_utils.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_clock_utils.c
@@ -208,7 +208,7 @@ static u64 div_u64_roundup(u64 nom, u32 den)
 
 u64 intel_gt_clock_interval_to_ns(const struct intel_gt *gt, u64 count)
 {
-	return div_u64_roundup(count * NSEC_PER_SEC, gt->clock_frequency);
+	return mul_u64_u32_div(count, NSEC_PER_SEC, gt->clock_frequency);
 }
 
 u64 intel_gt_pm_interval_to_ns(const struct intel_gt *gt, u64 count)
@@ -218,7 +218,7 @@ u64 intel_gt_pm_interval_to_ns(const struct intel_gt *gt, u64 count)
 
 u64 intel_gt_ns_to_clock_interval(const struct intel_gt *gt, u64 ns)
 {
-	return div_u64_roundup(gt->clock_frequency * ns, NSEC_PER_SEC);
+	return mul_u64_u32_div(ns, gt->clock_frequency, NSEC_PER_SEC);
 }
 
 u64 intel_gt_ns_to_pm_interval(const struct intel_gt *gt, u64 ns)
-- 
2.51.0



