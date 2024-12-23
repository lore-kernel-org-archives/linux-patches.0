Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB1519E971;
	Mon, 23 Dec 2024 16:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970415; cv=none; b=UQOdurBIobQLNdVzuJUZyA8ZJESFRBTZwY3W1W2he/RNSHy5z4LuTjUwsSFn7c4rLmswI5N3Tx/MOFBh7dNgXK5mASCoPow/0AKzjR2RIOWOfcHcNbtpw937z9YiggHrHdwVEuVWTYVWAuRCJSJGUZMlAYx8JzND77tlctX8O48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970415; c=relaxed/simple;
	bh=GPIR0tWW7tlUthf92uyN48xdTsJRQmfjeC/Gbqyn/6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Azyie/tRYlZP26J99qoRioBEe3tAXKsRbvNeapeKE27wZWBWcX9Qojc9C3Odht/q0349QXnYKwIRpZP1tjG6Ixtvm8QTOmRadV/oGAvlVTGf3riY5Pz65ZsE2z9X5pwv0IgkirtI6OWsSP0GVqXEHB5J9u0uebfRz+fyvag51rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECeow7JY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECeow7JY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50862C4CED3;
	Mon, 23 Dec 2024 16:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970414;
	bh=GPIR0tWW7tlUthf92uyN48xdTsJRQmfjeC/Gbqyn/6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECeow7JYLsdECfaYN65ou3JGomvofkMYM9PU4kqca0D98put+aKkbxaa5kw4ywPLD
	 QggkDclrJeYja6qfhhbyG33KHB1G0WCttmP4tPbmE4D4b2iPZ4++zX/iRpeMMCm8Ow
	 GmTjGNFxMuL9s/kwvZn21mNyGVvPDM1O/1/5USMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/116] i915/guc: Accumulate active runtime on gt reset
Date: Mon, 23 Dec 2024 16:59:07 +0100
Message-ID: <20241223155402.555677552@linuxfoundation.org>
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
index 9028160b8448..ccaf9437cd0d 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -1394,8 +1394,21 @@ static void __reset_guc_busyness_stats(struct intel_guc *guc)
 
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



