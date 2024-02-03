Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB7C111AA;
	Sat,  3 Feb 2024 04:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933895; cv=none; b=siJAWxHy1cNvSdXLjphHute4Rdboyp5zOPQdHhiPT/wM/s2H2D9yvcWIyArlBNRwbrmGvEMctflBjpuqHhSnhKFutbKhFUXh3S/0X9q8iBY+5ZYsa4J8i+DHSideWDyhfhyZD6h7CtcC11ZKTf1+KHbPS76DoAqRZewN2Wc1dZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933895; c=relaxed/simple;
	bh=/FvYLrmxg79nmucSl+NgUC7Crin09AhRKIVGNJ5kr64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TamGTZWztX1tDMFlbDuYln4Bxgcp9mEywP2EXJX8db2cmxLHmWjwQ2QDlZEd/jcxXgwQecFfroWg6RLMXyzrv4BwakeOHc4HeoIFNaxOUt4HIylGQAQsbGOJb8VLB8xu16jnUrcAfW2sZYKOYAPigM9+gCKkqoJxvfgMkI8WjqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYrzti1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYrzti1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C1CC43390;
	Sat,  3 Feb 2024 04:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933895;
	bh=/FvYLrmxg79nmucSl+NgUC7Crin09AhRKIVGNJ5kr64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYrzti1TbXjnkeWJ/SiW2PTUt4gqIF9g9cF0S3V5BjBk0zHOwgm5juDiyWn/5kRqu
	 8Nu4s86qHmSNi/BBMmBiLUN4Ya8tlbnrM9LMJY2+TM6XBmmRps1AOviP9N7XOb4QBF
	 FBi5G2nibb8F2ZtgRp3/W4fy8oCfVptsIh8q75W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Whitchurch <Vincent.Whitchurch@axis.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 242/353] um: time-travel: fix time corruption
Date: Fri,  2 Feb 2024 20:06:00 -0800
Message-ID: <20240203035411.347563487@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit abe4eaa8618bb36c2b33e9cdde0499296a23448c ]

In 'basic' time-travel mode (without =inf-cpu or =ext), we
still get timer interrupts. These can happen at arbitrary
points in time, i.e. while in timer_read(), which pushes
time forward just a little bit. Then, if we happen to get
the interrupt after calculating the new time to push to,
but before actually finishing that, the interrupt will set
the time to a value that's incompatible with the forward,
and we'll crash because time goes backwards when we do the
forwarding.

Fix this by reading the time_travel_time, calculating the
adjustment, and doing the adjustment all with interrupts
disabled.

Reported-by: Vincent Whitchurch <Vincent.Whitchurch@axis.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/time.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index fddd1dec27e6..3e270da6b6f6 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -432,9 +432,29 @@ static void time_travel_update_time(unsigned long long next, bool idle)
 	time_travel_del_event(&ne);
 }
 
+static void time_travel_update_time_rel(unsigned long long offs)
+{
+	unsigned long flags;
+
+	/*
+	 * Disable interrupts before calculating the new time so
+	 * that a real timer interrupt (signal) can't happen at
+	 * a bad time e.g. after we read time_travel_time but
+	 * before we've completed updating the time.
+	 */
+	local_irq_save(flags);
+	time_travel_update_time(time_travel_time + offs, false);
+	local_irq_restore(flags);
+}
+
 void time_travel_ndelay(unsigned long nsec)
 {
-	time_travel_update_time(time_travel_time + nsec, false);
+	/*
+	 * Not strictly needed to use _rel() version since this is
+	 * only used in INFCPU/EXT modes, but it doesn't hurt and
+	 * is more readable too.
+	 */
+	time_travel_update_time_rel(nsec);
 }
 EXPORT_SYMBOL(time_travel_ndelay);
 
@@ -568,7 +588,11 @@ static void time_travel_set_start(void)
 #define time_travel_time 0
 #define time_travel_ext_waiting 0
 
-static inline void time_travel_update_time(unsigned long long ns, bool retearly)
+static inline void time_travel_update_time(unsigned long long ns, bool idle)
+{
+}
+
+static inline void time_travel_update_time_rel(unsigned long long offs)
 {
 }
 
@@ -720,9 +744,7 @@ static u64 timer_read(struct clocksource *cs)
 		 */
 		if (!irqs_disabled() && !in_interrupt() && !in_softirq() &&
 		    !time_travel_ext_waiting)
-			time_travel_update_time(time_travel_time +
-						TIMER_MULTIPLIER,
-						false);
+			time_travel_update_time_rel(TIMER_MULTIPLIER);
 		return time_travel_time / TIMER_MULTIPLIER;
 	}
 
-- 
2.43.0



