Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EC23F54CE;
	Tue, 17 Mar 2026 17:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767395; cv=none; b=kGWWV3keeVez83pblUsF4pXNuQW1lVQmA9+MHai4LB6v/H9bx2zDyQTPZcyJ4WVCOScwoVVngXuj22D/rnk7SnD5NrlC69U5yeLEOtggSwU+iHampUawHNOCJtlpubQKafOGvQOS8yvHpZsQvgD+Qa8D03MD+BefLvQLePEBWJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767395; c=relaxed/simple;
	bh=IWzJhA58+jzzu5F1n033G8LGztQDC7rmdd2LKJdIvYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eo4Oj/1w9pw6m0LYsKxP90XCN49UpY03mr21yhsL8bNPpNw84DKZcrs/7Wro9d7PWQaFh9i6LDWdcolqrMO/klVKfol9w/6+rvI6CdAfbcdUk1wUUv0ZwYaYkyLMacp/LTT51aP9zkX4XTK5Je4u3hFbVRBmYYgQOjKxTkFjcjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6znX5Y3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6znX5Y3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D3BC4CEF7;
	Tue, 17 Mar 2026 17:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767394;
	bh=IWzJhA58+jzzu5F1n033G8LGztQDC7rmdd2LKJdIvYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6znX5Y3YPWtrCf15CdIsnsTJx6kh7WbydidFs0gebfKmQDhE0WYntqlDHYT0Cqt1
	 9piD7RsfhsEXe8XnIdq75Bz82BMwo7IDWX0oe2P6fzSYbK5tjjautOMlHpm3UgFX12
	 b52NtBLDW9JHyWVdTfLeLLghNyzLNqPWoBcpep4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/333] sched: idle: Make skipping governor callbacks more consistent
Date: Tue, 17 Mar 2026 17:31:47 +0100
Message-ID: <20260317163002.268874790@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit d557640e4ce589a24dca5ca7ce3b9680f471325f ]

If the cpuidle governor .select() callback is skipped because there
is only one idle state in the cpuidle driver, the .reflect() callback
should be skipped as well, at least for consistency (if not for
correctness), so do it.

Fixes: e5c9ffc6ae1b ("cpuidle: Skip governor when only one idle state is available")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Reviewed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://patch.msgid.link/12857700.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle.c | 10 ----------
 kernel/sched/idle.c       | 11 ++++++++++-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 8950796a493de..56132e843c991 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -357,16 +357,6 @@ noinstr int cpuidle_enter_state(struct cpuidle_device *dev,
 int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		   bool *stop_tick)
 {
-	/*
-	 * If there is only a single idle state (or none), there is nothing
-	 * meaningful for the governor to choose. Skip the governor and
-	 * always use state 0 with the tick running.
-	 */
-	if (drv->state_count <= 1) {
-		*stop_tick = false;
-		return 0;
-	}
-
 	return cpuidle_curr_governor->select(drv, dev, stop_tick);
 }
 
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index ac9690805be4f..d9c515da328e5 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -219,7 +219,7 @@ static void cpuidle_idle_call(void)
 
 		next_state = cpuidle_find_deepest_state(drv, dev, max_latency_ns);
 		call_cpuidle(drv, dev, next_state);
-	} else {
+	} else if (drv->state_count > 1) {
 		bool stop_tick = true;
 
 		/*
@@ -237,6 +237,15 @@ static void cpuidle_idle_call(void)
 		 * Give the governor an opportunity to reflect on the outcome
 		 */
 		cpuidle_reflect(dev, entered_state);
+	} else {
+		tick_nohz_idle_retain_tick();
+
+		/*
+		 * If there is only a single idle state (or none), there is
+		 * nothing meaningful for the governor to choose.  Skip the
+		 * governor and always use state 0.
+		 */
+		call_cpuidle(drv, dev, 0);
 	}
 
 exit_idle:
-- 
2.51.0



