Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA111170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98FEC433C8;
	Mon, 11 Sep 2023 13:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440374;
	bh=cALL11pxMCMbkkMlgSYOZevS+VGZLi48s8oi9YSpb6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cWgba850dL5+DPVYtcrKnL2/RW693UlBNu2M/2Gw5h+rwxwepOmCZwih7a/y0CWJN
	 MLMGX/YY5tLVMoPquDqMFKRGGJcHtjCXmulTKWSKMBC3NX/pDt3OWQUkEZytTtTcWB
	 NzAuIA86I10I7HJ46exg1inftMpCYSTvd3VctEe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Kajetan Puchalski <kajetan.puchalski@arm.com>
Subject: [PATCH 6.5 038/739] cpuidle: teo: Update idle duration estimate when choosing shallower state
Date: Mon, 11 Sep 2023 15:37:17 +0200
Message-ID: <20230911134652.164667237@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 3f0b0966b30982e843950b170b7a9ddfd8094428 ]

The TEO governor takes CPU utilization into account by refining idle state
selection when the utilization is above a certain threshold.  This is done by
choosing an idle state shallower than the previously selected one.

However, when doing this, the idle duration estimate needs to be
adjusted so as to prevent the scheduler tick from being stopped when the
candidate idle state is shallow, which may lead to excessive energy
usage if the CPU is not woken up quickly enough going forward.
Moreover, if the scheduler tick has been stopped already and the new
idle duration estimate is too small, the replacement candidate state
cannot be used.

Modify the relevant code to take the above observations into account.

Fixes: 9ce0f7c4bc64 ("cpuidle: teo: Introduce util-awareness")
Link: https://lore.kernel.org/linux-pm/CAJZ5v0jJxHj65r2HXBTd3wfbZtsg=_StzwO1kA5STDnaPe_dWA@mail.gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-and-tested-by: Kajetan Puchalski <kajetan.puchalski@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/teo.c | 40 ++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/cpuidle/governors/teo.c b/drivers/cpuidle/governors/teo.c
index 987fc5f3997dc..2cdc711679a5f 100644
--- a/drivers/cpuidle/governors/teo.c
+++ b/drivers/cpuidle/governors/teo.c
@@ -397,13 +397,23 @@ static int teo_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	 * the shallowest non-polling state and exit.
 	 */
 	if (drv->state_count < 3 && cpu_data->utilized) {
-		for (i = 0; i < drv->state_count; ++i) {
-			if (!dev->states_usage[i].disable &&
-			    !(drv->states[i].flags & CPUIDLE_FLAG_POLLING)) {
-				idx = i;
-				goto end;
-			}
-		}
+		/* The CPU is utilized, so assume a short idle duration. */
+		duration_ns = teo_middle_of_bin(0, drv);
+		/*
+		 * If state 0 is enabled and it is not a polling one, select it
+		 * right away unless the scheduler tick has been stopped, in
+		 * which case care needs to be taken to leave the CPU in a deep
+		 * enough state in case it is not woken up any time soon after
+		 * all.  If state 1 is disabled, though, state 0 must be used
+		 * anyway.
+		 */
+		if ((!idx && !(drv->states[0].flags & CPUIDLE_FLAG_POLLING) &&
+		    teo_time_ok(duration_ns)) || dev->states_usage[1].disable)
+			idx = 0;
+		else /* Assume that state 1 is not a polling one and use it. */
+			idx = 1;
+
+		goto end;
 	}
 
 	/*
@@ -539,10 +549,20 @@ static int teo_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 
 	/*
 	 * If the CPU is being utilized over the threshold, choose a shallower
-	 * non-polling state to improve latency
+	 * non-polling state to improve latency, unless the scheduler tick has
+	 * been stopped already and the shallower state's target residency is
+	 * not sufficiently large.
 	 */
-	if (cpu_data->utilized)
-		idx = teo_find_shallower_state(drv, dev, idx, duration_ns, true);
+	if (cpu_data->utilized) {
+		s64 span_ns;
+
+		i = teo_find_shallower_state(drv, dev, idx, duration_ns, true);
+		span_ns = teo_middle_of_bin(i, drv);
+		if (teo_time_ok(span_ns)) {
+			idx = i;
+			duration_ns = span_ns;
+		}
+	}
 
 end:
 	/*
-- 
2.40.1



