Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709B417A5A4;
	Mon, 23 Dec 2024 16:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969944; cv=none; b=S2067vP4qTiY3ngdKk0y6gXdahwhUB85L67DwNWpI0O4/tJ2ZKBH3Su++CqNedLl0/iXZw9bdRErJK5lepQJb+wqjnaI0+NMFOiFFdV0LeZD7ELzdA8m6r6u1kdzyShaTrlwedH1iqBvw/XPRVo4yC4ZeeM3YRgzrBCBeHT6wpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969944; c=relaxed/simple;
	bh=ZH3heqY5FBvbS5thmdRmsMYeNh+ANO17PtW1bfPoNgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmR76NlLfKUvStoqHd6TVm7KmTt01g6vpnKNRRvlbi0yYbKAat5qQiRejXtRdtV5PNy5KXwD9fsSpSGR4t/lIRm18I/gCL6iXcfzV62L/Qe4lm2c3RQ2BoQcvNIC3gA4Zj/tKXlBJZRXQw7xYTYuMq/yO1oyW4HBGFk1GJo7M4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFt9a125; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFt9a125"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AF1C4CED3;
	Mon, 23 Dec 2024 16:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969944;
	bh=ZH3heqY5FBvbS5thmdRmsMYeNh+ANO17PtW1bfPoNgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFt9a125xbENufmZyA6E0RaINNOq7GGJagJivO3I8cSqwYjRTNgq8Yr4lRhIxU4Cv
	 N3qmzExRfm7ghUfZT3i0ic7KO7+wCZG54ZRG0AxTbbF48tC55BBgzJ8pijUXVYOmry
	 gG/8gK4NJoBwupFPaMIto4UORPYuD+pB7Qw5fKhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/160] i915/guc: Ensure busyness counter increases motonically
Date: Mon, 23 Dec 2024 16:58:29 +0100
Message-ID: <20241223155412.473370687@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit 59a0b46788d58fdcee8d2f6b4e619d264a1799bf ]

Active busyness of an engine is calculated using gt timestamp and the
context switch in time. While capturing the gt timestamp, it's possible
that the context switches out. This race could result in an active
busyness value that is greater than the actual context runtime value by a
small amount. This leads to a negative delta and throws off busyness
calculations for the user.

If a subsequent count is smaller than the previous one, just return the
previous one, since we expect the busyness to catch up.

Fixes: 77cdd054dd2c ("drm/i915/pmu: Connect engine busyness stats from GuC to pmu")
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241127174006.190128-3-umesh.nerlige.ramappa@intel.com
(cherry picked from commit cf907f6d294217985e9dafd9985dce874e04ca37)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_types.h      | 5 +++++
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c | 5 ++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
index ba55c059063d..fe1f85e5dda3 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -343,6 +343,11 @@ struct intel_engine_guc_stats {
 	 * @start_gt_clk: GT clock time of last idle to active transition.
 	 */
 	u64 start_gt_clk;
+
+	/**
+	 * @total: The last value of total returned
+	 */
+	u64 total;
 };
 
 union intel_engine_tlb_inv_reg {
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index 4793759f4d4a..fbff9b9a067c 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1378,9 +1378,12 @@ static ktime_t guc_engine_busyness(struct intel_engine_cs *engine, ktime_t *now)
 		total += intel_gt_clock_interval_to_ns(gt, clk);
 	}
 
+	if (total > stats->total)
+		stats->total = total;
+
 	spin_unlock_irqrestore(&guc->timestamp.lock, flags);
 
-	return ns_to_ktime(total);
+	return ns_to_ktime(stats->total);
 }
 
 static void guc_enable_busyness_worker(struct intel_guc *guc)
-- 
2.39.5



