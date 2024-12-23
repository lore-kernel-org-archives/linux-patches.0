Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0ED22EAE6;
	Mon, 23 Dec 2024 16:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969947; cv=none; b=ixCkj6ewoSV7v+TMUg5mN21euUOtQL0OK5QfV3274nAy9I7cFE6ewUcAQzV/9lcokKneley+jI2XSkWTwYoUCnHhQyVLcax331sbQll6JCX8RbsVxofamJ6AJl7jzOVIMS4TIoKpCwQIdiAI//pXgduY9f0UH5NMxycfIObgrYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969947; c=relaxed/simple;
	bh=1Zb3tLXZCBXt9XWoCcR4TtbsrfuiQKhiFSj2wfTup38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exL3Fr/GB6p5ZUnw8pvtC6e46tvaleGdHpbz4lv2StVWXCVwYqS1a2qVhyzxw1eV5PHrbrkf+HTEqGP16geDjuAH0gARTDEDX60afsRPXEJl2KqEJ/L+iHAxlOhK/858E9sNi1i8nmc/9WeMotVNVRWbsc+dO9yALDo1V1Rlmc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7h/FD1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7h/FD1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC09C4CED3;
	Mon, 23 Dec 2024 16:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969947;
	bh=1Zb3tLXZCBXt9XWoCcR4TtbsrfuiQKhiFSj2wfTup38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7h/FD1nu+JVcFHvXo9UZPzSZQWC++4gDzviaz1dhSb2AeRVUeWk+6qOaylzsPw3Z
	 KyBMZa5CxYSIE0Bz5MfpTWFpgK7qU7w4cePTmx8XAu4SJUKzyILbm6omMOHC6AGaoS
	 8zPZ0W8vrJ5JmLVTQK2MBZOCulArpvqpK+6kMfI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/160] i915/guc: Accumulate active runtime on gt reset
Date: Mon, 23 Dec 2024 16:58:30 +0100
Message-ID: <20241223155412.509198262@linuxfoundation.org>
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

[ Upstream commit 1622ed27d26ab4c234476be746aa55bcd39159dd ]

On gt reset, if a context is running, then accumulate it's active time
into the busyness counter since there will be no chance for the context
to switch out and update it's run time.

v2: Move comment right above the if (John)

Fixes: 77cdd054dd2c ("drm/i915/pmu: Connect engine busyness stats from GuC to pmu")
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241127174006.190128-4-umesh.nerlige.ramappa@intel.com
(cherry picked from commit 7ed047da59cfa1acb558b95169d347acc8d85da1)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index fbff9b9a067c..ee12ee0ed418 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1449,8 +1449,21 @@ static void __reset_guc_busyness_stats(struct intel_guc *guc)
 
 	guc_update_pm_timestamp(guc, &unused);
 	for_each_engine(engine, gt, id) {
+		struct intel_engine_guc_stats *stats = &engine->stats.guc;
+
 		guc_update_engine_gt_clks(engine);
-		engine->stats.guc.prev_total = 0;
+
+		/*
+		 * If resetting a running context, accumulate the active
+		 * time as well since there will be no context switch.
+		 */
+		if (stats->running) {
+			u64 clk = guc->timestamp.gt_stamp - stats->start_gt_clk;
+
+			stats->total_gt_clks += clk;
+		}
+		stats->prev_total = 0;
+		stats->running = 0;
 	}
 
 	spin_unlock_irqrestore(&guc->timestamp.lock, flags);
-- 
2.39.5



