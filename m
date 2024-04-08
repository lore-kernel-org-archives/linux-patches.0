Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353AA7173E;
	Mon,  8 Apr 2024 13:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582413; cv=none; b=kMIFH+c0Gppt9PgEUTwgQSi/Gi0YU2LjttoJzjgXScA1YikoQ6edEhvz+FknkZzVLX9Tl1rtUSQWvf6gw1uiQU0cc5wF2VwspRupjTUd0jDkccvMEeWO2Az2/90jK+GgCtpxItEweV+wUZMqVTQL4EiDsvV/9WuAqpB8KGzPV/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582413; c=relaxed/simple;
	bh=YzvPJC9Di00qwqwvl9145bajP1dWuT57pSDMDzdI4sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWMeDQ/eHNGE5rJhGHzTD1aCgr1ory4sP3jIUJATsTc+22Jh8MFZSf0k319W1SlfGLj0I2SLVTlQnJQuSVfySOpkQgT0uA8A3B34fBHX6t2l9K7QGElExj3s5ULt7itxXMZfvLfY0+fA6MpG32zE2JC4RUhthzOGEWyWymqoucs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqXUWDNf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqXUWDNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7B8C433C7;
	Mon,  8 Apr 2024 13:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582413;
	bh=YzvPJC9Di00qwqwvl9145bajP1dWuT57pSDMDzdI4sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqXUWDNfTTwiUb0Yr63zpZIt80aN7jtRtior34w1YBPDNfZQ+rZpsdHhSaEIuDspG
	 B8oN2hEjHbjAj1FCoXI1/mcNqrcpgUd18R/nsN6oQgRnU4Gbq/gEJslAu+BzcUkr2E
	 X1CPDp5v/dbja/tme/g1Q4S0hnDba61Lhn4eS+Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/138] s390/pai_ext: replace atomic_t with refcount_t
Date: Mon,  8 Apr 2024 14:58:37 +0200
Message-ID: <20240408125259.434695895@linuxfoundation.org>
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

[ Upstream commit 1f2597cd3686955a4d64e01909dbfe625a2a35a1 ]

The s390 PMU of PAI extension 1 NNPA counters uses atomic_t for
reference counting. Replace this with the proper data type
refcount_t.

No functional change.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Stable-dep-of: e9f3af02f639 ("s390/pai: fix sampling event removal for PMU device driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_pai_ext.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kernel/perf_pai_ext.c b/arch/s390/kernel/perf_pai_ext.c
index b4d89654183a2..d6bc919530143 100644
--- a/arch/s390/kernel/perf_pai_ext.c
+++ b/arch/s390/kernel/perf_pai_ext.c
@@ -56,7 +56,7 @@ struct paiext_map {
 	struct pai_userdata *save;	/* Area to store non-zero counters */
 	enum paiext_mode mode;		/* Type of event */
 	unsigned int active_events;	/* # of PAI Extension users */
-	unsigned int refcnt;
+	refcount_t refcnt;
 	struct perf_event *event;	/* Perf event for sampling */
 	struct paiext_cb *paiext_cb;	/* PAI extension control block area */
 };
@@ -66,14 +66,14 @@ struct paiext_mapptr {
 };
 
 static struct paiext_root {		/* Anchor to per CPU data */
-	int refcnt;			/* Overall active events */
+	refcount_t refcnt;		/* Overall active events */
 	struct paiext_mapptr __percpu *mapptr;
 } paiext_root;
 
 /* Free per CPU data when the last event is removed. */
 static void paiext_root_free(void)
 {
-	if (!--paiext_root.refcnt) {
+	if (refcount_dec_and_test(&paiext_root.refcnt)) {
 		free_percpu(paiext_root.mapptr);
 		paiext_root.mapptr = NULL;
 	}
@@ -86,7 +86,7 @@ static void paiext_root_free(void)
  */
 static int paiext_root_alloc(void)
 {
-	if (++paiext_root.refcnt == 1) {
+	if (!refcount_inc_not_zero(&paiext_root.refcnt)) {
 		/* The memory is already zeroed. */
 		paiext_root.mapptr = alloc_percpu(struct paiext_mapptr);
 		if (!paiext_root.mapptr) {
@@ -97,6 +97,7 @@ static int paiext_root_alloc(void)
 			 */
 			return -ENOMEM;
 		}
+		refcount_set(&paiext_root.refcnt, 1);
 	}
 	return 0;
 }
@@ -128,7 +129,7 @@ static void paiext_event_destroy(struct perf_event *event)
 
 	mutex_lock(&paiext_reserve_mutex);
 	cpump->event = NULL;
-	if (!--cpump->refcnt)		/* Last reference gone */
+	if (refcount_dec_and_test(&cpump->refcnt))	/* Last reference gone */
 		paiext_free(mp);
 	paiext_root_free();
 	mutex_unlock(&paiext_reserve_mutex);
@@ -169,7 +170,7 @@ static int paiext_alloc(struct perf_event_attr *a, struct perf_event *event)
 		rc = -ENOMEM;
 		cpump = kzalloc(sizeof(*cpump), GFP_KERNEL);
 		if (!cpump)
-			goto unlock;
+			goto undo;
 
 		/* Allocate memory for counter area and counter extraction.
 		 * These are
@@ -189,8 +190,9 @@ static int paiext_alloc(struct perf_event_attr *a, struct perf_event *event)
 					     GFP_KERNEL);
 		if (!cpump->save || !cpump->area || !cpump->paiext_cb) {
 			paiext_free(mp);
-			goto unlock;
+			goto undo;
 		}
+		refcount_set(&cpump->refcnt, 1);
 		cpump->mode = a->sample_period ? PAI_MODE_SAMPLING
 					       : PAI_MODE_COUNTER;
 	} else {
@@ -201,15 +203,15 @@ static int paiext_alloc(struct perf_event_attr *a, struct perf_event *event)
 		if (cpump->mode == PAI_MODE_SAMPLING ||
 		    (cpump->mode == PAI_MODE_COUNTER && a->sample_period)) {
 			rc = -EBUSY;
-			goto unlock;
+			goto undo;
 		}
+		refcount_inc(&cpump->refcnt);
 	}
 
 	rc = 0;
 	cpump->event = event;
-	++cpump->refcnt;
 
-unlock:
+undo:
 	if (rc) {
 		/* Error in allocation of event, decrement anchor. Since
 		 * the event in not created, its destroy() function is never
@@ -217,6 +219,7 @@ static int paiext_alloc(struct perf_event_attr *a, struct perf_event *event)
 		 */
 		paiext_root_free();
 	}
+unlock:
 	mutex_unlock(&paiext_reserve_mutex);
 	/* If rc is non-zero, no increment of counter/sampler was done. */
 	return rc;
-- 
2.43.0



