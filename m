Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B2B74BF5;
	Mon,  8 Apr 2024 13:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582463; cv=none; b=UAIhKMgM8Hk3bJFeMRsV6DITNfskX1OUmm0ceJjCrP7SRRsySpDqtU+URcy+Xule2di6F58tEcMIicYdICCnNZ+ak+oNm83ir+/FypnwJE17zK4XmEicxA3Hm0P/pxIP/p1sVVmUqjqXskBKvF6Hgn0n5hX0Z9PMI8Mic29KIa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582463; c=relaxed/simple;
	bh=srGjS6wC6xztwvSqhzohZnwhyXtrsDFPk0WMCR8FCfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szHrhc0Kz0Nd0QRaes/HB3Y8+0fMzhH/7ndsrHLdSL53+2MmE8xLImuE4PNvlvBxq+85/57VXWEDhi1CXK1kQ3SWXoie7/HyAITA3Mg7iytVHNTWazQm/GR+azRFQsda022lHBp+J4IX0ULmBs6joV8WpNLKCfARV7LW7NmX7Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Op5Ja9+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Op5Ja9+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C528C433C7;
	Mon,  8 Apr 2024 13:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582463;
	bh=srGjS6wC6xztwvSqhzohZnwhyXtrsDFPk0WMCR8FCfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Op5Ja9+DOLtEv9UsXOmNnR8vuj0huVSkVWdQwKUJ/2PuY8gUQVFpNUDrvLqqSjK8H
	 heYhfFkn42l2T4GDJi1KOr/hidpOoHqmDOktFAIcCR1Af8V0W6wIYzrkFvGsDZxesV
	 r3PXpy91G8m5fhfV1WRLHmhqvq0xLEZqXLRAIRBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/138] s390/pai: fix sampling event removal for PMU device driver
Date: Mon,  8 Apr 2024 14:58:42 +0200
Message-ID: <20240408125259.590784335@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit e9f3af02f63909f41b43c28330434cc437639c5c ]

In case of a sampling event, the PAI PMU device drivers need a
reference to this event.  Currently to PMU device driver reference
is removed when a sampling event is destroyed. This may lead to
situations where the reference of the PMU device driver is removed
while being used by a different sampling event.
Reset the event reference pointer of the PMU device driver when
a sampling event is deleted and before the next one might be added.

Fixes: 39d62336f5c1 ("s390/pai: add support for cryptography counters")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_pai_crypto.c | 10 +++++++---
 arch/s390/kernel/perf_pai_ext.c    | 10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/perf_pai_crypto.c b/arch/s390/kernel/perf_pai_crypto.c
index ba2d2e61df747..93ccb5c955530 100644
--- a/arch/s390/kernel/perf_pai_crypto.c
+++ b/arch/s390/kernel/perf_pai_crypto.c
@@ -53,7 +53,6 @@ static void paicrypt_event_destroy(struct perf_event *event)
 {
 	struct paicrypt_map *cpump = per_cpu_ptr(&paicrypt_map, event->cpu);
 
-	cpump->event = NULL;
 	static_branch_dec(&pai_key);
 	mutex_lock(&pai_reserve_mutex);
 	debug_sprintf_event(cfm_dbg, 5, "%s event %#llx cpu %d users %d"
@@ -275,10 +274,15 @@ static int paicrypt_add(struct perf_event *event, int flags)
 
 static void paicrypt_stop(struct perf_event *event, int flags)
 {
-	if (!event->attr.sample_period)	/* Counting */
+	struct paicrypt_mapptr *mp = this_cpu_ptr(paicrypt_root.mapptr);
+	struct paicrypt_map *cpump = mp->mapptr;
+
+	if (!event->attr.sample_period) {	/* Counting */
 		paicrypt_read(event);
-	else				/* Sampling */
+	} else {				/* Sampling */
 		perf_sched_cb_dec(event->pmu);
+		cpump->event = NULL;
+	}
 	event->hw.state = PERF_HES_STOPPED;
 }
 
diff --git a/arch/s390/kernel/perf_pai_ext.c b/arch/s390/kernel/perf_pai_ext.c
index 09aebfcf679df..bbaad21123d38 100644
--- a/arch/s390/kernel/perf_pai_ext.c
+++ b/arch/s390/kernel/perf_pai_ext.c
@@ -128,7 +128,6 @@ static void paiext_event_destroy(struct perf_event *event)
 	struct paiext_map *cpump = mp->mapptr;
 
 	mutex_lock(&paiext_reserve_mutex);
-	cpump->event = NULL;
 	if (refcount_dec_and_test(&cpump->refcnt))	/* Last reference gone */
 		paiext_free(mp);
 	paiext_root_free();
@@ -361,10 +360,15 @@ static int paiext_add(struct perf_event *event, int flags)
 
 static void paiext_stop(struct perf_event *event, int flags)
 {
-	if (!event->attr.sample_period)	/* Counting */
+	struct paiext_mapptr *mp = this_cpu_ptr(paiext_root.mapptr);
+	struct paiext_map *cpump = mp->mapptr;
+
+	if (!event->attr.sample_period) {	/* Counting */
 		paiext_read(event);
-	else				/* Sampling */
+	} else {				/* Sampling */
 		perf_sched_cb_dec(event->pmu);
+		cpump->event = NULL;
+	}
 	event->hw.state = PERF_HES_STOPPED;
 }
 
-- 
2.43.0



