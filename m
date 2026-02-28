Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73505346AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302052; cv=none; b=nh4S3+DDwpQy66XBrB423JbEKDBvUj36DU7bm1Gds6/Qst0RVldyceJp/V7CxQkGYkMqwTk/SOqyAjvBhFGyp19VhON0wzhVF3865TSF/IMp2XQ+ybkMhpGXh2ujdi0EqUBpItvHhVIaIsVxoGKff6Iu9zkmfKINUqbFkeNXCvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302052; c=relaxed/simple;
	bh=jUNVdBPhuCzwCecYihv4JhrLIeJmuUsyLn9nbtcW7TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEUG5JiPTpFzi/LpZSgXkmFA3OzSLycTX/88GPDDoWefTZzLxbemRpwbl2epnqBmwM5ikLkeftahV1iUuBlcQO5jRwyO4QVEaDY5csysSYFo4tsaOrp+hAEPKNfCcZGLbPVsYw0aY0nCS0klPZFQ11q/5gImrn7yBTX+gGCl+Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WT6uo/os; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WT6uo/os"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48A3C19425;
	Sat, 28 Feb 2026 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302052;
	bh=jUNVdBPhuCzwCecYihv4JhrLIeJmuUsyLn9nbtcW7TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WT6uo/osewKe64Ky97Dtj9D3Pr2ObFb4nwrR7Pe1zcgPDCTp4LVjawGJbCVlQC45l
	 2LoZbq/53g4mLMtUqMFPiDDO6rrHyjnJZk24wze4UNf9OB8ZMz64lp/iiptoNEuC7D
	 4QyCnGRs15Vw3zxtDPKhoCAeCx+uxLoyWQnPQ6K/pRptlN0zQjFnsA54SXOkzGU9vs
	 hjE+uKiaPcXiHzcOXPaJn5lkg71R/2oM/ktXbN8nJJ5Y7mllf/RyzAwbKRXkdi4gcz
	 SuRnuCHVIuWGzAqLAa+Ig+zfZJitXIe6ICawMFomvuR3WVCPMznD5GaIhr2DbxNhIw
	 ANL0Qhyn6ZxaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/283] cpuidle: governors: menu: Always check timers with tick stopped
Date: Sat, 28 Feb 2026 13:02:49 -0500
Message-ID: <20260228180709.1583486-27-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 80606f4eb8d7484ab7f7d6f0fd30d71e6fbcf328 ]

After commit 5484e31bbbff ("cpuidle: menu: Skip tick_nohz_get_sleep_length()
call in some cases"), if the return value of get_typical_interval()
multiplied by NSEC_PER_USEC is not greater than RESIDENCY_THRESHOLD_NS,
the menu governor will skip computing the time till the closest timer.
If that happens when the tick has been stopped already, the selected
idle state may be too deep due to the subsequent check comparing
predicted_ns with TICK_NSEC and causing its value to be replaced with
the expected time till the closest timer, which is KTIME_MAX in that
case.  That will cause the deepest enabled idle state to be selected,
but the time till the closest timer very well may be shorter than the
target residency of that state, in which case a shallower state should
be used.

Address this by making menu_select() always compute the time till the
closest timer when the tick has been stopped.

Also move the predicted_ns check mentioned above into the branch in
which the time till the closest timer is determined because it only
needs to be done in that case.

Fixes: 5484e31bbbff ("cpuidle: menu: Skip tick_nohz_get_sleep_length() call in some cases")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/5959091.DvuYhMxLoT@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 864a7be7ba485..bedf6c4b8d1b5 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -269,7 +269,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 
 	/* Find the shortest expected idle interval. */
 	predicted_ns = get_typical_interval(data) * NSEC_PER_USEC;
-	if (predicted_ns > RESIDENCY_THRESHOLD_NS) {
+	if (predicted_ns > RESIDENCY_THRESHOLD_NS || tick_nohz_tick_stopped()) {
 		unsigned int timer_us;
 
 		/* Determine the time till the closest timer. */
@@ -289,6 +289,16 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 				   RESOLUTION * DECAY * NSEC_PER_USEC);
 		/* Use the lowest expected idle interval to pick the idle state. */
 		predicted_ns = min((u64)timer_us * NSEC_PER_USEC, predicted_ns);
+		/*
+		 * If the tick is already stopped, the cost of possible short
+		 * idle duration misprediction is much higher, because the CPU
+		 * may be stuck in a shallow idle state for a long time as a
+		 * result of it.  In that case, say we might mispredict and use
+		 * the known time till the closest timer event for the idle
+		 * state selection.
+		 */
+		if (tick_nohz_tick_stopped() && predicted_ns < TICK_NSEC)
+			predicted_ns = data->next_timer_ns;
 	} else {
 		/*
 		 * Because the next timer event is not going to be determined
@@ -314,16 +324,6 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		return 0;
 	}
 
-	/*
-	 * If the tick is already stopped, the cost of possible short idle
-	 * duration misprediction is much higher, because the CPU may be stuck
-	 * in a shallow idle state for a long time as a result of it.  In that
-	 * case, say we might mispredict and use the known time till the closest
-	 * timer event for the idle state selection.
-	 */
-	if (tick_nohz_tick_stopped() && predicted_ns < TICK_NSEC)
-		predicted_ns = data->next_timer_ns;
-
 	/*
 	 * Find the idle state with the lowest power while satisfying
 	 * our constraints.
-- 
2.51.0

