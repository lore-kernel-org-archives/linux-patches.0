Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1695D383C6A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302042; cv=none; b=SpbYxmM0jQ6LUAIpCKtgVAcLxoHe0WDA31IFhPh484x+bskoDm92mvmdL3laSFnE6P5TcvgFLPZmVKTg0sErg7v/Hseh8rntNUKaUtP9EL2XPs9LZuaMeyJotjTA/e6I0PQPOIlQPqa9vZbWrGDLWeTB6Q59zWkf824G/aCZaHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302042; c=relaxed/simple;
	bh=Lq4/uP9/HRFETnBxeNpHXcV+5O7wyd/KCHPYTac3k5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZooWjKDByW2AuYcVsB+LUXVRndSBOfC8Wla5jfqhiEY2So2Mw6D4Aag7GI3e3Cq33j4CO6lnH2upLsPHmGRBNtTuvry/fHRbNAA37WEb4RJ86dDKipUwwKDCH9j+I5ObAYpJqxYrw95Ry5r14WrGNjCvir4Cu0BL1a7SgtPmrnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MK3mdaVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MK3mdaVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFCFC19423;
	Sat, 28 Feb 2026 18:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302042;
	bh=Lq4/uP9/HRFETnBxeNpHXcV+5O7wyd/KCHPYTac3k5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MK3mdaVfJj6/iI1Dcecud9ClaAkNl/qT2On/9ECKaRpNff5tW44u5+4cY/ADldpah
	 Lkzqo2OCIiznC9nIMh/Lp5eICMIEXtQSO66BJZDEM40x2/RqwTYMaikV82E4LaOpA4
	 oEPb5jF/Rw/BOGGpvlvGwg5btDAppW+7BvLUdgZ4ptzeRwjvg0N1KuhC3c+obwngib
	 q9z3VqSTzcqYednVnLtMob6ctwSLW7v/lZIbBiew/kj1il7oXBwjh+mzVdgSEUtFcN
	 yucTHKbrBm1HY9dBkT0ThG4JVZnxxMjAXtP0ROWOnGEvBlGz3Z9HL4H3dN57brDWwC
	 e/dfIEGWppU1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/283] gfs2: Retries missing in gfs2_{rename,exchange}
Date: Sat, 28 Feb 2026 13:02:36 -0500
Message-ID: <20260228180709.1583486-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 11d763f0b0afc2cf5f92f4adae5dbbbbef712f8f ]

Fix a bug in gfs2's asynchronous glock handling for rename and exchange
operations.  The original async implementation from commit ad26967b9afa
("gfs2: Use async glocks for rename") mentioned that retries were needed
but never implemented them, causing operations to fail with -ESTALE
instead of retrying on timeout.

Also makes the waiting interruptible.

In addition, the timeouts used were too high for situations in which
timing out is a rare but expected scenario.  Switch to shorter timeouts
with randomization and exponentional backoff.

Fixes: ad26967b9afa ("gfs2: Use async glocks for rename")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 36 +++++++++++++++++++++++++++---------
 fs/gfs2/glock.h |  3 ++-
 fs/gfs2/inode.c | 18 ++++++++++++++----
 3 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index c4bc86c3535ba..9265262807f09 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1396,31 +1396,45 @@ static int glocks_pending(unsigned int num_gh, struct gfs2_holder *ghs)
  * gfs2_glock_async_wait - wait on multiple asynchronous glock acquisitions
  * @num_gh: the number of holders in the array
  * @ghs: the glock holder array
+ * @retries: number of retries attempted so far
  *
  * Returns: 0 on success, meaning all glocks have been granted and are held.
  *          -ESTALE if the request timed out, meaning all glocks were released,
  *          and the caller should retry the operation.
  */
 
-int gfs2_glock_async_wait(unsigned int num_gh, struct gfs2_holder *ghs)
+int gfs2_glock_async_wait(unsigned int num_gh, struct gfs2_holder *ghs,
+			  unsigned int retries)
 {
 	struct gfs2_sbd *sdp = ghs[0].gh_gl->gl_name.ln_sbd;
-	int i, ret = 0, timeout = 0;
 	unsigned long start_time = jiffies;
+	int i, ret = 0;
+	long timeout;
 
 	might_sleep();
-	/*
-	 * Total up the (minimum hold time * 2) of all glocks and use that to
-	 * determine the max amount of time we should wait.
-	 */
-	for (i = 0; i < num_gh; i++)
-		timeout += ghs[i].gh_gl->gl_hold_time << 1;
 
-	if (!wait_event_timeout(sdp->sd_async_glock_wait,
+	timeout = GL_GLOCK_MIN_HOLD;
+	if (retries) {
+		unsigned int max_shift;
+		long incr;
+
+		/* Add a random delay and increase the timeout exponentially. */
+		max_shift = BITS_PER_LONG - 2 - __fls(GL_GLOCK_HOLD_INCR);
+		incr = min(GL_GLOCK_HOLD_INCR << min(retries - 1, max_shift),
+			   10 * HZ - GL_GLOCK_MIN_HOLD);
+		schedule_timeout_interruptible(get_random_long() % (incr / 3));
+		if (signal_pending(current))
+			goto interrupted;
+		timeout += (incr / 3) + get_random_long() % (incr / 3);
+	}
+
+	if (!wait_event_interruptible_timeout(sdp->sd_async_glock_wait,
 				!glocks_pending(num_gh, ghs), timeout)) {
 		ret = -ESTALE; /* request timed out. */
 		goto out;
 	}
+	if (signal_pending(current))
+		goto interrupted;
 
 	for (i = 0; i < num_gh; i++) {
 		struct gfs2_holder *gh = &ghs[i];
@@ -1444,6 +1458,10 @@ int gfs2_glock_async_wait(unsigned int num_gh, struct gfs2_holder *ghs)
 		}
 	}
 	return ret;
+
+interrupted:
+	ret = -EINTR;
+	goto out;
 }
 
 /**
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index aae9fabbb76cc..e86dccdd61332 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -204,7 +204,8 @@ int gfs2_glock_poll(struct gfs2_holder *gh);
 int gfs2_instantiate(struct gfs2_holder *gh);
 int gfs2_glock_holder_ready(struct gfs2_holder *gh);
 int gfs2_glock_wait(struct gfs2_holder *gh);
-int gfs2_glock_async_wait(unsigned int num_gh, struct gfs2_holder *ghs);
+int gfs2_glock_async_wait(unsigned int num_gh, struct gfs2_holder *ghs,
+			  unsigned int retries);
 void gfs2_glock_dq(struct gfs2_holder *gh);
 void gfs2_glock_dq_wait(struct gfs2_holder *gh);
 void gfs2_glock_dq_uninit(struct gfs2_holder *gh);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 1cb5ce63fbf69..b65444bc1b5f2 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1408,7 +1408,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	unsigned int num_gh;
 	int dir_rename = 0;
 	struct gfs2_diradd da = { .nr_blocks = 0, .save_loc = 0, };
-	unsigned int x;
+	unsigned int retries = 0, x;
 	int error;
 
 	gfs2_holder_mark_uninitialized(&r_gh);
@@ -1458,12 +1458,17 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		num_gh++;
 	}
 
+again:
 	for (x = 0; x < num_gh; x++) {
 		error = gfs2_glock_nq(ghs + x);
 		if (error)
 			goto out_gunlock;
 	}
-	error = gfs2_glock_async_wait(num_gh, ghs);
+	error = gfs2_glock_async_wait(num_gh, ghs, retries);
+	if (error == -ESTALE) {
+		retries++;
+		goto again;
+	}
 	if (error)
 		goto out_gunlock;
 
@@ -1652,7 +1657,7 @@ static int gfs2_exchange(struct inode *odir, struct dentry *odentry,
 	struct gfs2_sbd *sdp = GFS2_SB(odir);
 	struct gfs2_holder ghs[4], r_gh;
 	unsigned int num_gh;
-	unsigned int x;
+	unsigned int retries = 0, x;
 	umode_t old_mode = oip->i_inode.i_mode;
 	umode_t new_mode = nip->i_inode.i_mode;
 	int error;
@@ -1696,13 +1701,18 @@ static int gfs2_exchange(struct inode *odir, struct dentry *odentry,
 	gfs2_holder_init(nip->i_gl, LM_ST_EXCLUSIVE, GL_ASYNC, ghs + num_gh);
 	num_gh++;
 
+again:
 	for (x = 0; x < num_gh; x++) {
 		error = gfs2_glock_nq(ghs + x);
 		if (error)
 			goto out_gunlock;
 	}
 
-	error = gfs2_glock_async_wait(num_gh, ghs);
+	error = gfs2_glock_async_wait(num_gh, ghs, retries);
+	if (error == -ESTALE) {
+		retries++;
+		goto again;
+	}
 	if (error)
 		goto out_gunlock;
 
-- 
2.51.0

