Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455113BBA03;
	Mon, 23 Mar 2026 16:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282515; cv=none; b=Y9dB83UgAFACskumAjmHxMT6dssHT3Db7/5AlP2sAncgo+D4eORRB5N4gp4wsGDX0GLrHCGaG8eyPuTafDew9o1gYsHVYqIJU9Bb99M2btfESk+5th5TF/vpRcTPnFzZ33DgB8rbrLRCPpK8R54qXnL1Twv2fQ2NY7n+IdUtrEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282515; c=relaxed/simple;
	bh=3up0qiJ9Omar2b0hroYMAkmfL3cbkNgVt1bxwStEI0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tH2Yan2oVPzbee1aF7m4b31Di89vCie/WC3KoK8VPHDkei1vwRKr7RALetD5BWYN8aMrx+DCl1q+1Ndj6gyfMza6W9rSnaCb+WyAWO+kMmt1BcFfH9CfYM1PY4mPfgMAD+r+PAgjf8XMox+0S4trdKYFuXt76AgOiur0P1OT+q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJEdymt+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJEdymt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5341DC2BCB4;
	Mon, 23 Mar 2026 16:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282514;
	bh=3up0qiJ9Omar2b0hroYMAkmfL3cbkNgVt1bxwStEI0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJEdymt+bQlIWTnHu9d0j5a/gMPEMXH2YNqaiPGgIR4oPu/8fSY0LWJf6dMxvICZ7
	 kHDTG/y+Mkbz6iyUrHX54Xw4tyokC3kbkYymxKrdFI0JY8GJksVAh50r2FO9Nv3TRc
	 c1Fh8USObvmxmpnVi2djfXXPhm2vwrD6aBDLnADU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 183/481] sched: idle: Make skipping governor callbacks more consistent
Date: Mon, 23 Mar 2026 14:42:45 +0100
Message-ID: <20260323134529.665510825@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 482bf87354a38..fdd25271106a3 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -324,16 +324,6 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
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
index 200a0fac03b8e..6ff593a8eeb17 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -220,7 +220,7 @@ static void cpuidle_idle_call(void)
 
 		next_state = cpuidle_find_deepest_state(drv, dev, max_latency_ns);
 		call_cpuidle(drv, dev, next_state);
-	} else {
+	} else if (drv->state_count > 1) {
 		bool stop_tick = true;
 
 		/*
@@ -238,6 +238,15 @@ static void cpuidle_idle_call(void)
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



