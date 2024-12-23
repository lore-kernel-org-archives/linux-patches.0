Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058FD13BC0C;
	Mon, 23 Dec 2024 16:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970412; cv=none; b=oz5GDLPWy7DDcCCOyUcr88ka/Hou7uGdfi042YbVQBkTzkJhONSfgJtVyqQG0kAqSgK/ZaMxNZu/Cs2qTEJrWDVVkQ7aJcpaXk4/eN2Gbg93Q7Gl5IA6Xr51tRATrRES2OHqEDK+/pIE5xoT3Ww4XrfDsdFoy81gH1oomYdeVrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970412; c=relaxed/simple;
	bh=o1+S6opr3JhIxK24S/sRSDBhPz8sTOBTqOqKANJywMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvLrqqnAcCwtfqj4Wp0MroFulwWi6miT2Cu1pZYzXbKIc6OwVund3CmkH9I/S0eeLX3H0ovX7d4+zsvV1dbXkKlRJ4MWHwl0wnuNY/j+A6YJNZ+wx1hn/PLgS6y9y0444UIVTkh5ctPDW5t3a+5ZHPaYf5WNC0QZQSW/Mn1e1iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMV8LAEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMV8LAEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FD5C4CED3;
	Mon, 23 Dec 2024 16:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970411;
	bh=o1+S6opr3JhIxK24S/sRSDBhPz8sTOBTqOqKANJywMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMV8LAEyqkTQZDITJLobxvMxIJj8bCuOhyq2ZlQK1mfmqT3EyaV9ETyBpIa502iIL
	 YRKWxGQicWkYlMzIP+bxC4tCSH3OI6mE0olLs3FG+eUHO7DC5ky9ZSCODjOPAhadPJ
	 pHIHru+mPqGgzhniWp4krYeF6ErrqxjRSIEohcU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/116] i915/guc: Ensure busyness counter increases motonically
Date: Mon, 23 Dec 2024 16:59:06 +0100
Message-ID: <20241223155402.518611103@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a7e677598004..5a7e464b4fb3 100644
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
index 44610c739fe7..9028160b8448 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1362,9 +1362,12 @@ static ktime_t guc_engine_busyness(struct intel_engine_cs *engine, ktime_t *now)
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



