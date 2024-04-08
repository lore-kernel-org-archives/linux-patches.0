Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB2B62148;
	Mon,  8 Apr 2024 13:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582387; cv=none; b=JTnfV5b2Pf5EtQd+8fVxBH1B2EoWH2zEtMnOtzE5Fo7Y4VQBEHtn2rxwKc64aJQYBCJWfb2OFRQdfjFZrzIeBlvHSGodYMBXYESOF+fziHKsnpu+YGmwps3FkrsaLw01kL0hzhgbj09cIUu7dewkjPvBykxeUTxAttrUZSwg0/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582387; c=relaxed/simple;
	bh=CM3Nu5I+k16cinOtbpOBb7GEOXDRchHeHMMRbZdOBLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdmnXacYERfcCaNVqXqKKdrcBiXcbbEVufx9y7fcbPmBjq1bq4aoqFaBl4jurcN0FRTYu6FncUOFNUPYNcEjkOnhzEmihIRa/qlAk4Fm6avS14G08LZv0YUk/CqM6MmbBVJbAQpFZxf1afdvkB+6EqNQBZdAWERlwOjFM24GvEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsnYjDfB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsnYjDfB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FF3C433C7;
	Mon,  8 Apr 2024 13:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582386;
	bh=CM3Nu5I+k16cinOtbpOBb7GEOXDRchHeHMMRbZdOBLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsnYjDfBFb3TNK5vVKpMN4L91bozBm9dPV4Qdoa5Y5WDYl5ZtUp74Q7sSlm9J+eDx
	 zxvFXekmR70UvX0uE34hPL3/Finewqbw0KoAAlGJxmnYy+S5/cdecAgtqn59a6pUX5
	 TWWwmeuahEdzTqWfvKHrtcVvYiTZHi2Z8UVucyac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/138] s390/pai: rework pai_crypto mapped buffer reference count
Date: Mon,  8 Apr 2024 14:58:35 +0200
Message-ID: <20240408125259.373910514@linuxfoundation.org>
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

[ Upstream commit d3db4ac3c761def3d3a8e5ea6d05d1636c44c2ba ]

Rework the mapped buffer reference count in PMU pai_crypto
to match the same technique as in PMU pai_ext.
This simplifies the logic.
Do not count the individual number of counter and sampling
processes. Remember the type of access and the total number of
references to the buffer.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Stable-dep-of: e9f3af02f639 ("s390/pai: fix sampling event removal for PMU device driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_pai_crypto.c | 42 ++++++++++++++----------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/s390/kernel/perf_pai_crypto.c b/arch/s390/kernel/perf_pai_crypto.c
index f61a652046cfb..68a6132937f3e 100644
--- a/arch/s390/kernel/perf_pai_crypto.c
+++ b/arch/s390/kernel/perf_pai_crypto.c
@@ -36,8 +36,8 @@ struct paicrypt_map {
 	unsigned long *page;		/* Page for CPU to store counters */
 	struct pai_userdata *save;	/* Page to store no-zero counters */
 	unsigned int users;		/* # of PAI crypto users */
-	unsigned int sampler;		/* # of PAI crypto samplers */
-	unsigned int counter;		/* # of PAI crypto counters */
+	unsigned int refcnt;		/* Reference count mapped buffers */
+	enum paievt_mode mode;		/* Type of event */
 	struct perf_event *event;	/* Perf event for sampling */
 };
 
@@ -56,15 +56,11 @@ static void paicrypt_event_destroy(struct perf_event *event)
 	cpump->event = NULL;
 	static_branch_dec(&pai_key);
 	mutex_lock(&pai_reserve_mutex);
-	if (event->attr.sample_period)
-		cpump->sampler -= 1;
-	else
-		cpump->counter -= 1;
-	debug_sprintf_event(cfm_dbg, 5, "%s event %#llx cpu %d"
-			    " sampler %d counter %d\n", __func__,
-			    event->attr.config, event->cpu, cpump->sampler,
-			    cpump->counter);
-	if (!cpump->counter && !cpump->sampler) {
+	debug_sprintf_event(cfm_dbg, 5, "%s event %#llx cpu %d users %d"
+			    " mode %d refcnt %d\n", __func__,
+			    event->attr.config, event->cpu, cpump->users,
+			    cpump->mode, cpump->refcnt);
+	if (!--cpump->refcnt) {
 		debug_sprintf_event(cfm_dbg, 4, "%s page %#lx save %p\n",
 				    __func__, (unsigned long)cpump->page,
 				    cpump->save);
@@ -72,6 +68,7 @@ static void paicrypt_event_destroy(struct perf_event *event)
 		cpump->page = NULL;
 		kvfree(cpump->save);
 		cpump->save = NULL;
+		cpump->mode = PAI_MODE_NONE;
 	}
 	mutex_unlock(&pai_reserve_mutex);
 }
@@ -136,17 +133,14 @@ static u64 paicrypt_getall(struct perf_event *event)
  */
 static int paicrypt_busy(struct perf_event_attr *a, struct paicrypt_map *cpump)
 {
-	unsigned int *use_ptr;
 	int rc = 0;
 
 	mutex_lock(&pai_reserve_mutex);
 	if (a->sample_period) {		/* Sampling requested */
-		use_ptr = &cpump->sampler;
-		if (cpump->counter || cpump->sampler)
+		if (cpump->mode != PAI_MODE_NONE)
 			rc = -EBUSY;	/* ... sampling/counting active */
 	} else {			/* Counting requested */
-		use_ptr = &cpump->counter;
-		if (cpump->sampler)
+		if (cpump->mode == PAI_MODE_SAMPLING)
 			rc = -EBUSY;	/* ... and sampling active */
 	}
 	if (rc)
@@ -172,12 +166,16 @@ static int paicrypt_busy(struct perf_event_attr *a, struct paicrypt_map *cpump)
 	rc = 0;
 
 unlock:
-	/* If rc is non-zero, do not increment counter/sampler. */
-	if (!rc)
-		*use_ptr += 1;
-	debug_sprintf_event(cfm_dbg, 5, "%s sample_period %#llx sampler %d"
-			    " counter %d page %#lx save %p rc %d\n", __func__,
-			    a->sample_period, cpump->sampler, cpump->counter,
+	/* If rc is non-zero, do not set mode and reference count */
+	if (!rc) {
+		cpump->refcnt++;
+		cpump->mode = a->sample_period ? PAI_MODE_SAMPLING
+					       : PAI_MODE_COUNTING;
+	}
+	debug_sprintf_event(cfm_dbg, 5, "%s sample_period %#llx users %d"
+			    " mode %d refcnt %d page %#lx save %p rc %d\n",
+			    __func__, a->sample_period, cpump->users,
+			    cpump->mode, cpump->refcnt,
 			    (unsigned long)cpump->page, cpump->save, rc);
 	mutex_unlock(&pai_reserve_mutex);
 	return rc;
-- 
2.43.0



