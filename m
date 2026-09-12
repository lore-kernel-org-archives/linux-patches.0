Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86882C21F7;
	Sat, 12 Sep 2026 08:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200707; cv=none; b=qtIXYTcf9RimkxPK+q3cl4yQ+ax/VBlL90l5dhhMpPiy5gNWUpICyG+6Ewm8JCuE5yMnKlyFy5UGr4M+4tTXqtsw/nhMxpLMhiuf29UZoHbRUC8MMn6ifQpBpPbJ+loyJi6etvuT/3La91DMNxmacP9snGXquOJXOlcPMbO/wkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200707; c=relaxed/simple;
	bh=f28SjDsgjFBz/oy8/hSt1t0xioJkz0hvttZmPeoD9XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8AlL5ZcQSE0ZIK6XHY+NtqNcgK/WW9uqLsRRmoumA+2aA08SqQwQkY2yEtb1y0wpEUx9uRA+Lc+XKlSiaHLVPBeiDn8bx/1X3Hqyi8qXAtJ2hLDMoqDc4q4wlZH65p/pfCn3H100dcplt41Am7EY9SbcTa0Dv8L1XUBQ5L0SAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2Teft3S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2Teft3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9AD1F000FF;
	Sat, 12 Sep 2026 08:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200705;
	bh=RQE+uWsLlpASpBpGMjgbKC4SVMThtRiaxYMKc+BIwCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z2Teft3ShXYJ5xnOZCBmmL7ObmIB64M7uXYmj8VaqKNu7f7hAx99Qi13ComnJIrus
	 EHrdFNuoUYNY4xEPEYfcCL41s6Q7GxvWZHsBvLcDJk+nTCLV26kpElr67e2Ol5pYkL
	 5lWdrECqNBG3yhxEloWXM95tczZsY/TVX2kbfeUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b3bd9f8a06658479d4a@syzkaller.appspotmail.com,
	Yu Peng <pengyu@kylinos.cn>,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0845/1815] fs: annotate inode timestamp accessors
Date: Sat, 12 Sep 2026 08:43:15 +0200
Message-ID: <20260912065708.755927569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Peng <pengyu@kylinos.cn>

[ Upstream commit c610d2d0787961cdd6fc1de69d9be1ff3687e1a6 ]

syzbot reported a KCSAN race between fill_mg_cmtime() and
inode_set_ctime_to_ts() on inode->i_ctime_{sec,nsec}.

stat/getattr can sample inode timestamps while update paths store new
values concurrently, so KCSAN can report benign races on these fields.

Annotate the timestamp accessors with READ_ONCE()/WRITE_ONCE(), and use
the ctime accessor for the remaining ctime loads.  This avoids the KCSAN
reports without changing timestamp semantics.

Fixes: 4e40eff0b573 ("fs: add infrastructure for multigrain timestamps")
Reported-by: syzbot+8b3bd9f8a06658479d4a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8b3bd9f8a06658479d4a
Signed-off-by: Yu Peng <pengyu@kylinos.cn>
Link: https://patch.msgid.link/20260708080232.2564807-1-pengyu@kylinos.cn
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c         | 18 +++++++++---------
 fs/stat.c          |  2 +-
 include/linux/fs.h | 20 ++++++++++----------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 31c5b9ee3a81d..95e981b4e19c9 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2833,8 +2833,8 @@ struct timespec64 inode_set_ctime_to_ts(struct inode *inode, struct timespec64 t
 {
 	trace_inode_set_ctime_to_ts(inode, &ts);
 	set_normalized_timespec64(&ts, ts.tv_sec, ts.tv_nsec);
-	inode->i_ctime_sec = ts.tv_sec;
-	inode->i_ctime_nsec = ts.tv_nsec;
+	WRITE_ONCE(inode->i_ctime_sec, ts.tv_sec);
+	WRITE_ONCE(inode->i_ctime_nsec, ts.tv_nsec);
 	return ts;
 }
 EXPORT_SYMBOL(inode_set_ctime_to_ts);
@@ -2908,7 +2908,7 @@ struct timespec64 inode_set_ctime_current(struct inode *inode)
 	 */
 	cns = smp_load_acquire(&inode->i_ctime_nsec);
 	if (cns & I_CTIME_QUERIED) {
-		struct timespec64 ctime = { .tv_sec = inode->i_ctime_sec,
+		struct timespec64 ctime = { .tv_sec = inode_get_ctime_sec(inode),
 					    .tv_nsec = cns & ~I_CTIME_QUERIED };
 
 		if (timespec64_compare(&now, &ctime) <= 0) {
@@ -2920,7 +2920,7 @@ struct timespec64 inode_set_ctime_current(struct inode *inode)
 	mgtime_counter_inc(mg_ctime_updates);
 
 	/* No need to cmpxchg if it's exactly the same */
-	if (cns == now.tv_nsec && inode->i_ctime_sec == now.tv_sec) {
+	if (cns == now.tv_nsec && inode_get_ctime_sec(inode) == now.tv_sec) {
 		trace_ctime_xchg_skip(inode, &now);
 		goto out;
 	}
@@ -2929,7 +2929,7 @@ struct timespec64 inode_set_ctime_current(struct inode *inode)
 	/* Try to swap the nsec value into place. */
 	if (try_cmpxchg(&inode->i_ctime_nsec, &cur, now.tv_nsec)) {
 		/* If swap occurred, then we're (mostly) done */
-		inode->i_ctime_sec = now.tv_sec;
+		WRITE_ONCE(inode->i_ctime_sec, now.tv_sec);
 		trace_ctime_ns_xchg(inode, cns, now.tv_nsec, cur);
 		mgtime_counter_inc(mg_ctime_swaps);
 	} else {
@@ -2944,7 +2944,7 @@ struct timespec64 inode_set_ctime_current(struct inode *inode)
 			goto retry;
 		}
 		/* Otherwise, keep the existing ctime */
-		now.tv_sec = inode->i_ctime_sec;
+		now.tv_sec = inode_get_ctime_sec(inode);
 		now.tv_nsec = cur & ~I_CTIME_QUERIED;
 	}
 out:
@@ -2977,7 +2977,7 @@ struct timespec64 inode_set_ctime_deleg(struct inode *inode, struct timespec64 u
 	/* pairs with try_cmpxchg below */
 	cur = smp_load_acquire(&inode->i_ctime_nsec);
 	cur_ts.tv_nsec = cur & ~I_CTIME_QUERIED;
-	cur_ts.tv_sec = inode->i_ctime_sec;
+	cur_ts.tv_sec = inode_get_ctime_sec(inode);
 
 	/* If the update is older than the existing value, skip it. */
 	if (timespec64_compare(&update, &cur_ts) <= 0)
@@ -3003,7 +3003,7 @@ struct timespec64 inode_set_ctime_deleg(struct inode *inode, struct timespec64 u
 retry:
 	old = cur;
 	if (try_cmpxchg(&inode->i_ctime_nsec, &cur, update.tv_nsec)) {
-		inode->i_ctime_sec = update.tv_sec;
+		WRITE_ONCE(inode->i_ctime_sec, update.tv_sec);
 		mgtime_counter_inc(mg_ctime_swaps);
 		return update;
 	}
@@ -3019,7 +3019,7 @@ struct timespec64 inode_set_ctime_deleg(struct inode *inode, struct timespec64 u
 		goto retry;
 
 	/* Otherwise, it was a new timestamp. */
-	cur_ts.tv_sec = inode->i_ctime_sec;
+	cur_ts.tv_sec = inode_get_ctime_sec(inode);
 	cur_ts.tv_nsec = cur & ~I_CTIME_QUERIED;
 	return cur_ts;
 }
diff --git a/fs/stat.c b/fs/stat.c
index 89909746bed19..c461c30542340 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -53,7 +53,7 @@ void fill_mg_cmtime(struct kstat *stat, u32 request_mask, struct inode *inode)
 	}
 
 	stat->mtime = inode_get_mtime(inode);
-	stat->ctime.tv_sec = inode->i_ctime_sec;
+	stat->ctime.tv_sec = inode_get_ctime_sec(inode);
 	stat->ctime.tv_nsec = (u32)atomic_read(pcn);
 	if (!(stat->ctime.tv_nsec & I_CTIME_QUERIED))
 		stat->ctime.tv_nsec = ((u32)atomic_fetch_or(I_CTIME_QUERIED, pcn));
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 50ce731a2b78f..09de7bf6f1d28 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1598,12 +1598,12 @@ struct timespec64 inode_set_ctime_deleg(struct inode *inode,
 
 static inline time64_t inode_get_atime_sec(const struct inode *inode)
 {
-	return inode->i_atime_sec;
+	return READ_ONCE(inode->i_atime_sec);
 }
 
 static inline long inode_get_atime_nsec(const struct inode *inode)
 {
-	return inode->i_atime_nsec;
+	return READ_ONCE(inode->i_atime_nsec);
 }
 
 static inline struct timespec64 inode_get_atime(const struct inode *inode)
@@ -1617,8 +1617,8 @@ static inline struct timespec64 inode_get_atime(const struct inode *inode)
 static inline struct timespec64 inode_set_atime_to_ts(struct inode *inode,
 						      struct timespec64 ts)
 {
-	inode->i_atime_sec = ts.tv_sec;
-	inode->i_atime_nsec = ts.tv_nsec;
+	WRITE_ONCE(inode->i_atime_sec, ts.tv_sec);
+	WRITE_ONCE(inode->i_atime_nsec, ts.tv_nsec);
 	return ts;
 }
 
@@ -1633,12 +1633,12 @@ static inline struct timespec64 inode_set_atime(struct inode *inode,
 
 static inline time64_t inode_get_mtime_sec(const struct inode *inode)
 {
-	return inode->i_mtime_sec;
+	return READ_ONCE(inode->i_mtime_sec);
 }
 
 static inline long inode_get_mtime_nsec(const struct inode *inode)
 {
-	return inode->i_mtime_nsec;
+	return READ_ONCE(inode->i_mtime_nsec);
 }
 
 static inline struct timespec64 inode_get_mtime(const struct inode *inode)
@@ -1651,8 +1651,8 @@ static inline struct timespec64 inode_get_mtime(const struct inode *inode)
 static inline struct timespec64 inode_set_mtime_to_ts(struct inode *inode,
 						      struct timespec64 ts)
 {
-	inode->i_mtime_sec = ts.tv_sec;
-	inode->i_mtime_nsec = ts.tv_nsec;
+	WRITE_ONCE(inode->i_mtime_sec, ts.tv_sec);
+	WRITE_ONCE(inode->i_mtime_nsec, ts.tv_nsec);
 	return ts;
 }
 
@@ -1677,12 +1677,12 @@ static inline struct timespec64 inode_set_mtime(struct inode *inode,
 
 static inline time64_t inode_get_ctime_sec(const struct inode *inode)
 {
-	return inode->i_ctime_sec;
+	return READ_ONCE(inode->i_ctime_sec);
 }
 
 static inline long inode_get_ctime_nsec(const struct inode *inode)
 {
-	return inode->i_ctime_nsec & ~I_CTIME_QUERIED;
+	return READ_ONCE(inode->i_ctime_nsec) & ~I_CTIME_QUERIED;
 }
 
 static inline struct timespec64 inode_get_ctime(const struct inode *inode)
-- 
2.53.0



