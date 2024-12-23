Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EB517A597;
	Mon, 23 Dec 2024 16:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970715; cv=none; b=s17wFJ4HUq82p7Ee4sSa8B7QM0Qk93hwUU8V/smtRUB/J2rzvX8ZaHCEenRz3bV1FPC9X+ku6YrhmcZqG8fAIJb8PKIDFygtm2FJ5XRlsmxvshZ79IGEAmuJ5xsPGi33YuIG/qbQqfNrccnUu3anclu6Y1Hq/z87k11bVwtvzsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970715; c=relaxed/simple;
	bh=W4ORcxNRKmfo8LzkeigmN+tYYVFeBdyZzcyQj5kel+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNLxSDz5rUNKdUs13SJE6LTByVge66amIZtkD0zeJVdV6jMW5k62zc0TUgy8XjnKrxbGJYWhaIZ7stxBNcx0r1WpCnzJrMsdXpWwga53L72lb63l4e3aQ8WZBt0XgmOYGv0VVEMMgJwc4wEcG5C3pxo3NjJG00X+Gpc4/oAiNaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHx3xtId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHx3xtId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37F8C4CED3;
	Mon, 23 Dec 2024 16:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970715;
	bh=W4ORcxNRKmfo8LzkeigmN+tYYVFeBdyZzcyQj5kel+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHx3xtId5Hb4pEJ55TmDtsXtXA+d3SWKo0t7bXMvrV0ZtqZtwm2wzmUCrezOeMzdc
	 XQ0h8OLQlZMxcRIr+fJYv9SqFx4dWX3fSJB3/coeD5QTUm73vonFf6O8L6hmk+eA9q
	 TxGWzXVYL/A2xOny1q6PAhrkL94WSZDrUIlh3WYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 48/83] i915/guc: Accumulate active runtime on gt reset
Date: Mon, 23 Dec 2024 16:59:27 +0100
Message-ID: <20241223155355.490648459@linuxfoundation.org>
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
index 2cd1f43f8a3c..2e0eb6cb8eab 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1368,8 +1368,21 @@ static void __reset_guc_busyness_stats(struct intel_guc *guc)
 
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



