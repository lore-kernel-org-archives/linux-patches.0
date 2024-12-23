Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C271A8F80;
	Mon, 23 Dec 2024 16:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970712; cv=none; b=Mbc2jTqY4bF073UHcv8UhX8UESIGrZ17SVl37QRoPIIHo3ml0XlWY4nL4tU1ibj5woXHCZ2cxTlKyEs95wsLhAwrJO+hSyd1Rci49ACRFaz/AJnd/dCTaFN6WNGkfGJmhGrIiHHONj4Mt9c3ETbD+WKjKEyuDVLD9SEqkGWjA5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970712; c=relaxed/simple;
	bh=MBws/I1mgIK/yIXaj9d2WRGxSFLtWhzFReNcw8DzXQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MC7N9EY16T9viIr+aZTbmidYorgYQXKjUyB1DID0XlGKeTQpAwHBqyCa8NeewR9mqG86HRDoxIKOwEH/PHA5u7kKPNc8a9zFzheGOySWRF8TIvste+4Yr85WnpWMcduZY4+fMisujsKebBiwONSUfYNQYtvdLYeOEejBTyFhTuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pF/ei8iB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pF/ei8iB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C75CC4CED3;
	Mon, 23 Dec 2024 16:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970711;
	bh=MBws/I1mgIK/yIXaj9d2WRGxSFLtWhzFReNcw8DzXQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pF/ei8iB3lX9CEtrysecjPp35rtPdnatjfwMb2Y8Rlqeqxtz9iu8k6B9xqCFGV+bB
	 ovbas4UOli4rMkHioradxaMrraJ0T5owt4zWoERSnT6u0zko2Dt/td9U/Im91I2Lrj
	 elslsKCFvfIxpAXLY8oCk+YM23RWBLXLrA27/owI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 47/83] i915/guc: Ensure busyness counter increases motonically
Date: Mon, 23 Dec 2024 16:59:26 +0100
Message-ID: <20241223155355.453771248@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 107f465a27b9..458320d28e27 100644
--- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
+++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
@@ -339,6 +339,11 @@ struct intel_engine_guc_stats {
 	 * @start_gt_clk: GT clock time of last idle to active transition.
 	 */
 	u64 start_gt_clk;
+
+	/**
+	 * @total: The last value of total returned
+	 */
+	u64 total;
 };
 
 struct intel_engine_cs {
diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index 4bfc1131b4f0..2cd1f43f8a3c 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1346,9 +1346,12 @@ static ktime_t guc_engine_busyness(struct intel_engine_cs *engine, ktime_t *now)
 		total += intel_gt_clock_interval_to_ns(gt, clk);
 	}
 
+	if (total > stats->total)
+		stats->total = total;
+
 	spin_unlock_irqrestore(&guc->timestamp.lock, flags);
 
-	return ns_to_ktime(total);
+	return ns_to_ktime(stats->total);
 }
 
 static void __reset_guc_busyness_stats(struct intel_guc *guc)
-- 
2.39.5



