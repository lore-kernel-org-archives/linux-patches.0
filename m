Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32717129E7C;
	Mon,  8 Apr 2024 13:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583422; cv=none; b=QSUhSOvZ4Oj/A0ZVpxnX5FtUrbIanlrGe1eoJUIm2GNlY0vlarmguQl73MEyXjiC4nDxPp4rTFDmd/GzZyXdso+Ttc0Fe78ycvfTbpO8cO7q+ZaWygU2QE9V0sDPBmZ3Bvr0WkDhwE1SzLTqskLg+XicxPO7Jx8SIGm9S6hazQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583422; c=relaxed/simple;
	bh=Zqo1zTxMjH/dHOrP7LQWbz3djpDWjl7Cuu/ed4N+8m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IY/2RFvD/c7SSQ3kZESb0z97wr//eGPpgpMf15dvYfbL8tGbmFXNrVIyMVx6QHGza4MmlsRn6zjPkYM7lhIrEzHSYfm7MRBQq8tRTgbTDpWBEh92WAuWKHsuBzKA8Io5RIbPaMAJNBkyJJCLgqnKZFF8pumgcM/vzXC5qH22fNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Su032Z8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Su032Z8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF03C43390;
	Mon,  8 Apr 2024 13:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583422;
	bh=Zqo1zTxMjH/dHOrP7LQWbz3djpDWjl7Cuu/ed4N+8m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Su032Z8jdFtrUFNsCnoGKVshNRF4yET5W36J0u9hLEzKLIrZ3V+KvakeKoJeS85Rh
	 1jPGfhBP0ubFNkXSFD8jtdAZd4hNHEbl7hpiDMMOAh5IQV32QsodPmvGrKlEgJWO0X
	 ui8NlfmNxB2tmdsOQ/PAOqnIfuPjmO9K17Ghygsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 194/252] s390/pai: fix sampling event removal for PMU device driver
Date: Mon,  8 Apr 2024 14:58:13 +0200
Message-ID: <20240408125312.677112733@linuxfoundation.org>
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
index 65cc74ab4cdd8..1eefbe2ff4189 100644
--- a/arch/s390/kernel/perf_pai_crypto.c
+++ b/arch/s390/kernel/perf_pai_crypto.c
@@ -53,7 +53,6 @@ static void paicrypt_event_destroy(struct perf_event *event)
 {
 	struct paicrypt_map *cpump = per_cpu_ptr(&paicrypt_map, event->cpu);
 
-	cpump->event = NULL;
 	static_branch_dec(&pai_key);
 	mutex_lock(&pai_reserve_mutex);
 	debug_sprintf_event(cfm_dbg, 5, "%s event %#llx cpu %d users %d"
@@ -278,10 +277,15 @@ static int paicrypt_add(struct perf_event *event, int flags)
 
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
index bac95261ec46d..a9235071ca70b 100644
--- a/arch/s390/kernel/perf_pai_ext.c
+++ b/arch/s390/kernel/perf_pai_ext.c
@@ -122,7 +122,6 @@ static void paiext_event_destroy(struct perf_event *event)
 	struct paiext_map *cpump = mp->mapptr;
 
 	mutex_lock(&paiext_reserve_mutex);
-	cpump->event = NULL;
 	if (refcount_dec_and_test(&cpump->refcnt))	/* Last reference gone */
 		paiext_free(mp);
 	paiext_root_free();
@@ -355,10 +354,15 @@ static int paiext_add(struct perf_event *event, int flags)
 
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



