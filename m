Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855F3129E7C;
	Mon,  8 Apr 2024 13:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583413; cv=none; b=MSQwASciDttOxFJpfwGNjdBPt3Cx585z5A/nkxvc7n2BtBVdM8iPSPVv0bb4sybRmA6DH7Y5eu5qW+B368uOFU/4JTXMJtxXAnfMyJbTBcf+AUwJ6A7Ppbsq74jtPjgUblTKOLeReAOvB9K+buDqcgsUNZZIvyis9fiYVqLei1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583413; c=relaxed/simple;
	bh=JwTVEe8Fuot0oZ4Gdpv5VvbMEuiKVcOqf86n9ES3l5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hG2IQ702q9n0dQ/w2ZYoE1x6oyLcTKjLT1Em9tJLo46+WG7wf9yhB4jo6TUFrwHD4OHESOcgHbuoBSyGIVBoIUDSUCJh70/mNjeqFK57HklyvCp059QEAh+F2W57qUYnWDULAmAQ/8ZZ/lbN4vhJRKPIJoH7KVrr/maOml4lau8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TiQ8VHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TiQ8VHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA806C433C7;
	Mon,  8 Apr 2024 13:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583413;
	bh=JwTVEe8Fuot0oZ4Gdpv5VvbMEuiKVcOqf86n9ES3l5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TiQ8VHSSq7kO3iO6FH7+0tV44SZxZB2NvjiFlsWizo78KQqgG+D6vqcTP8NT2coA
	 XeBgI/yeR+rugxASZR3HF8Xrbnb1p2SahpIr2LuFybvdAr4TSWVptkYbaPoTFm72Ru
	 6/VwYd/JJb36eoIEfeQdh4BRfaz/VPPlcbL7c6hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Mete Durlu <meted@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 193/252] s390/pai: rework paiXXX_start and paiXXX_stop functions
Date: Mon,  8 Apr 2024 14:58:12 +0200
Message-ID: <20240408125312.646555044@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit cb1259b7b574bd90ef22dac2c6282327cdae31c6 ]

The PAI crypto counter and PAI NNPA counters start and stop functions
are streamlined. Move the conditions to invoke start and stop functions
to its respective function body and call them unconditionally.
The start and stop functions now determine how to proceed.
No functional change.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Mete Durlu <meted@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Stable-dep-of: e9f3af02f639 ("s390/pai: fix sampling event removal for PMU device driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_pai_crypto.c | 29 ++++++++++++-------------
 arch/s390/kernel/perf_pai_ext.c    | 35 ++++++++++++++----------------
 2 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/arch/s390/kernel/perf_pai_crypto.c b/arch/s390/kernel/perf_pai_crypto.c
index 270255acacb02..65cc74ab4cdd8 100644
--- a/arch/s390/kernel/perf_pai_crypto.c
+++ b/arch/s390/kernel/perf_pai_crypto.c
@@ -248,10 +248,14 @@ static void paicrypt_start(struct perf_event *event, int flags)
 	 * Events are added, deleted and re-added when 2 or more events
 	 * are active at the same time.
 	 */
-	if (!event->hw.last_tag) {
-		event->hw.last_tag = 1;
-		sum = paicrypt_getall(event);		/* Get current value */
-		local64_set(&event->hw.prev_count, sum);
+	if (!event->attr.sample_period) {	/* Counting */
+		if (!event->hw.last_tag) {
+			event->hw.last_tag = 1;
+			sum = paicrypt_getall(event);	/* Get current value */
+			local64_set(&event->hw.prev_count, sum);
+		}
+	} else {				/* Sampling */
+		perf_sched_cb_inc(event->pmu);
 	}
 }
 
@@ -266,19 +270,18 @@ static int paicrypt_add(struct perf_event *event, int flags)
 		__ctl_set_bit(0, 50);
 	}
 	cpump->event = event;
-	if (flags & PERF_EF_START && !event->attr.sample_period) {
-		/* Only counting needs initial counter value */
+	if (flags & PERF_EF_START)
 		paicrypt_start(event, PERF_EF_RELOAD);
-	}
 	event->hw.state = 0;
-	if (event->attr.sample_period)
-		perf_sched_cb_inc(event->pmu);
 	return 0;
 }
 
 static void paicrypt_stop(struct perf_event *event, int flags)
 {
-	paicrypt_read(event);
+	if (!event->attr.sample_period)	/* Counting */
+		paicrypt_read(event);
+	else				/* Sampling */
+		perf_sched_cb_dec(event->pmu);
 	event->hw.state = PERF_HES_STOPPED;
 }
 
@@ -286,11 +289,7 @@ static void paicrypt_del(struct perf_event *event, int flags)
 {
 	struct paicrypt_map *cpump = this_cpu_ptr(&paicrypt_map);
 
-	if (event->attr.sample_period)
-		perf_sched_cb_dec(event->pmu);
-	if (!event->attr.sample_period)
-		/* Only counting needs to read counter */
-		paicrypt_stop(event, PERF_EF_UPDATE);
+	paicrypt_stop(event, PERF_EF_UPDATE);
 	if (--cpump->active_events == 0) {
 		__ctl_clear_bit(0, 50);
 		WRITE_ONCE(S390_lowcore.ccd, 0);
diff --git a/arch/s390/kernel/perf_pai_ext.c b/arch/s390/kernel/perf_pai_ext.c
index 8fddde11cfb1f..bac95261ec46d 100644
--- a/arch/s390/kernel/perf_pai_ext.c
+++ b/arch/s390/kernel/perf_pai_ext.c
@@ -321,11 +321,15 @@ static void paiext_start(struct perf_event *event, int flags)
 {
 	u64 sum;
 
-	if (event->hw.last_tag)
-		return;
-	event->hw.last_tag = 1;
-	sum = paiext_getall(event);		/* Get current value */
-	local64_set(&event->hw.prev_count, sum);
+	if (!event->attr.sample_period) {	/* Counting */
+		if (!event->hw.last_tag) {
+			event->hw.last_tag = 1;
+			sum = paiext_getall(event);	/* Get current value */
+			local64_set(&event->hw.prev_count, sum);
+		}
+	} else {				/* Sampling */
+		perf_sched_cb_inc(event->pmu);
+	}
 }
 
 static int paiext_add(struct perf_event *event, int flags)
@@ -342,21 +346,19 @@ static int paiext_add(struct perf_event *event, int flags)
 		debug_sprintf_event(paiext_dbg, 4, "%s 1508 %llx acc %llx\n",
 				    __func__, S390_lowcore.aicd, pcb->acc);
 	}
-	if (flags & PERF_EF_START && !event->attr.sample_period) {
-		/* Only counting needs initial counter value */
+	cpump->event = event;
+	if (flags & PERF_EF_START)
 		paiext_start(event, PERF_EF_RELOAD);
-	}
 	event->hw.state = 0;
-	if (event->attr.sample_period) {
-		cpump->event = event;
-		perf_sched_cb_inc(event->pmu);
-	}
 	return 0;
 }
 
 static void paiext_stop(struct perf_event *event, int flags)
 {
-	paiext_read(event);
+	if (!event->attr.sample_period)	/* Counting */
+		paiext_read(event);
+	else				/* Sampling */
+		perf_sched_cb_dec(event->pmu);
 	event->hw.state = PERF_HES_STOPPED;
 }
 
@@ -366,12 +368,7 @@ static void paiext_del(struct perf_event *event, int flags)
 	struct paiext_map *cpump = mp->mapptr;
 	struct paiext_cb *pcb = cpump->paiext_cb;
 
-	if (event->attr.sample_period)
-		perf_sched_cb_dec(event->pmu);
-	if (!event->attr.sample_period) {
-		/* Only counting needs to read counter */
-		paiext_stop(event, PERF_EF_UPDATE);
-	}
+	paiext_stop(event, PERF_EF_UPDATE);
 	if (--cpump->active_events == 0) {
 		/* Disable CPU instruction lookup for PAIE1 control block */
 		__ctl_clear_bit(0, 49);
-- 
2.43.0



