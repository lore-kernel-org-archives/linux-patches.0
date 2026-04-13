Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979252EBB8C;
	Mon, 13 Apr 2026 16:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097507; cv=none; b=ZzeGLXU96Oi0tan8y9mZ+z7HWhzy4T/7Wee0GwgsT9TqH/MNQFvtZVxAEND+Q3JVK0DjQT+wwVWcHUsfY0+uos3wqrnjJvSYuFdnkGXELif2tX/K++HuOamdyyQ5oyhkWL7XiklaBHlMXuEIyetlTfcqX4mmVfepnQIW1DvBRcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097507; c=relaxed/simple;
	bh=9kTGN2aNO9KzuIr2Y8gt0HjYVT+a/2xJ3730F4HLdt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbAG6clBWrubveznbVzAo+upN7b4eU6EyLVW0pNZNQvn43V0SRkWwZdVoDCEtboenIYkIWDcDib+iYwuVe7GDVjUnbLmjzwt+FZ6tYIsYQ2f4uvBUSpjQCwQnl19p3uD2M0AjP7H3u0kO1ABxpEi06hHPAPpWhTUo3itkSnmYPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxhlRiej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxhlRiej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA2BC2BCB6;
	Mon, 13 Apr 2026 16:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097507;
	bh=9kTGN2aNO9KzuIr2Y8gt0HjYVT+a/2xJ3730F4HLdt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxhlRiejkqXD8M1QxJ7nbM8MizB+jtk9QhNwvRTT2bHg1L20KSBnCVbcn7TKPC/gR
	 IOCtKhzRSjiaMSbzepl/YcP3FeLso2B4tmYGAWZXdu1u6Smya3vZN78BYh8iYSztVW
	 bYi901QkkJTctoNGhn7T8czpvtV/P7rvx/nVoZuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/570] sched: idle: Make skipping governor callbacks more consistent
Date: Mon, 13 Apr 2026 17:54:11 +0200
Message-ID: <20260413155834.938788023@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 20b9f77a8fb02..e371d6972f8d9 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -319,16 +319,6 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
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
index 499a3e286cd05..407835d23eacf 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -223,7 +223,7 @@ static void cpuidle_idle_call(void)
 
 		next_state = cpuidle_find_deepest_state(drv, dev, max_latency_ns);
 		call_cpuidle(drv, dev, next_state);
-	} else {
+	} else if (drv->state_count > 1) {
 		bool stop_tick = true;
 
 		/*
@@ -241,6 +241,15 @@ static void cpuidle_idle_call(void)
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



