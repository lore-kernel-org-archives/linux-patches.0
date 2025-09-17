Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAFF32BBF8;
	Wed, 17 Sep 2025 12:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113205; cv=none; b=iHT8edndcJ1mb5/yvpkn/Jn7Rgtgq0Nkb+PVuY0vO7Tiq8VGsY9yaHQ51RsZ1GCQ9OzwWlcclejN0HUCROH0vlvJOV9MEn8SzvhgJEBURSP9WLWzZorrlM4QhxW4jVa3Y2di1nhuROjO5wVJ6QPKxhqb/3UyHZIrZGpxn5wVUn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113205; c=relaxed/simple;
	bh=3+i7EVaGglIQfByuGwItOSDoGoZxS83bumqli1EDNlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I99MM9xHQBuqG/H5KwqUjcMlD8spSGpMukgSncFzXZ/vRTBYT1/IYtJ4Pw5b4beo+pEb6NpV7wy5cGjE/mK21fQiZTVTJMfiwfiKDuzsDj1DDF5OUQ1+eyxEMjsKfVtGC16IlMahO1v+5QHRZYkGuTB8odHqYE5DDk1FXrtDzhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+PpKXJv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+PpKXJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83322C4CEF5;
	Wed, 17 Sep 2025 12:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113205;
	bh=3+i7EVaGglIQfByuGwItOSDoGoZxS83bumqli1EDNlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+PpKXJvffNSoSJLN7Mv3cbaTA0m+TZMSXCU19KcilBNSofKAwfmksFiLYVhr2Vb/
	 Goo/+c53qB+BogM2bGVZHdJ++J5BNXsKjNhtuqUV416fiYw0yC01SQefOc2jp3mYW5
	 ib1julKxpW35ZhvjUSgRL2eSTO2xkEv1P5RzHNNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/140] drm/i915/pmu: Fix zero delta busyness issue
Date: Wed, 17 Sep 2025 14:33:07 +0200
Message-ID: <20250917123344.685318021@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit cb5fab2afd906307876d79537ef0329033c40dd3 ]

When running igt@gem_exec_balancer@individual for multiple iterations,
it is seen that the delta busyness returned by PMU is 0. The issue stems
from a combination of 2 implementation specific details:

1) gt_park is throttling __update_guc_busyness_stats() so that it does
not hog PCI bandwidth for some use cases. (Ref: 59bcdb564b3ba)

2) busyness implementation always returns monotonically increasing
counters. (Ref: cf907f6d29421)

If an application queried an engine while it was active,
engine->stats.guc.running is set to true. Following that, if all PM
wakeref's are released, then gt is parked. At this time the throttling
of __update_guc_busyness_stats() may result in a missed update to the
running state of the engine (due to (1) above). This means subsequent
calls to guc_engine_busyness() will think that the engine is still
running and they will keep updating the cached counter (stats->total).
This results in an inflated cached counter.

Later when the application runs a workload and queries for busyness, we
return the cached value since it is larger than the actual value (due to
(2) above)

All subsequent queries will return the same large (inflated) value, so
the application sees a delta busyness of zero.

Fix the issue by resetting the running state of engines each time
intel_guc_busyness_park() is called.

v2: (Rodrigo)
- Use the correct tag in commit message
- Drop the redundant wakeref check in guc_engine_busyness() and update
  commit message

Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13366
Fixes: cf907f6d2942 ("i915/guc: Ensure busyness counter increases motonically")
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250123193839.2394694-1-umesh.nerlige.ramappa@intel.com
(cherry picked from commit 431b742e2bfc9f6dd713f261629741980996d001)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/i915/gt/uc/intel_guc_submission.c    | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index b48373b166779..355a21eb48443 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1469,6 +1469,19 @@ static void __reset_guc_busyness_stats(struct intel_guc *guc)
 	spin_unlock_irqrestore(&guc->timestamp.lock, flags);
 }
 
+static void __update_guc_busyness_running_state(struct intel_guc *guc)
+{
+	struct intel_gt *gt = guc_to_gt(guc);
+	struct intel_engine_cs *engine;
+	enum intel_engine_id id;
+	unsigned long flags;
+
+	spin_lock_irqsave(&guc->timestamp.lock, flags);
+	for_each_engine(engine, gt, id)
+		engine->stats.guc.running = false;
+	spin_unlock_irqrestore(&guc->timestamp.lock, flags);
+}
+
 static void __update_guc_busyness_stats(struct intel_guc *guc)
 {
 	struct intel_gt *gt = guc_to_gt(guc);
@@ -1619,6 +1632,9 @@ void intel_guc_busyness_park(struct intel_gt *gt)
 	if (!guc_submission_initialized(guc))
 		return;
 
+	/* Assume no engines are running and set running state to false */
+	__update_guc_busyness_running_state(guc);
+
 	/*
 	 * There is a race with suspend flow where the worker runs after suspend
 	 * and causes an unclaimed register access warning. Cancel the worker
-- 
2.51.0



