Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B88423EB9;
	Sat, 12 Sep 2026 10:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208922; cv=none; b=gyUKEp0WsOBbzsu7QopwXd4ou0Dq6PZ+m7ES5N5yFh90Jp/NmgRuITY+CbsHN7mRHFggYJK93nVtgV3FmYmRYxTN/QR7VpE18UEmb677wD3SEcNkaSaJ3z1UhLfAUzVN+gTLflkAvnJqffq4giTNH6oy7myawHiOnhGJ24mQLpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208922; c=relaxed/simple;
	bh=ve4MbkQp+EM1wZZGeKcgtS09tFflSvj2V/p6/5CECXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=coRpwsg7fX8Rv3R7zFS7Q3xSTSl2+cyB3AjplX5JPSvsxNxz6yNbmH3mo4aBcn3YHRhuNn9/sqeEvmdlMs892GRZIQ9ob3h06BsvRhcOp+coaejZMdcBOSzsxkWbX3DaGkSHMNq148Y3vZ+KhQ+1W03+j1CiIa0nzY9lbbWjFDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKEYCd2v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKEYCd2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC621F00893;
	Sat, 12 Sep 2026 10:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208919;
	bh=fjP9YIFhIWd6Z1EppzMlDTvmn6BWmH0CNREN2yKyAks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKEYCd2vic8njEMuW5u3L8aPxD5q5FoWJ+0CDDSiCsidwzcAhm4eXydPR5IepMdfR
	 ybc0SXkfTC1zH5oXN03jcF+PnVG1aZqzg3ymoELqrPhEVs+ZZHFB2weyeilqnqGwtq
	 ctXJZHOncC0tB+TJPDTC/tAmWhpbb6FGKIs0mzz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b3bd9f8a06658479d4a@syzkaller.appspotmail.com,
	Yu Peng <pengyu@kylinos.cn>,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0716/1518] fs: annotate inode timestamp accessors
Date: Sat, 12 Sep 2026 08:48:05 +0200
Message-ID: <20260912065639.632977182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2c55ec49b0239..a931126398ced 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2703,8 +2703,8 @@ struct timespec64 inode_set_ctime_to_ts(struct inode *inode, struct timespec64 t
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
@@ -2778,7 +2778,7 @@ struct timespec64 inode_set_ctime_current(struct inode *inode)
 	 */
 	cns = smp_load_acquire(&inode->i_ctime_nsec);
 	if (cns & I_CTIME_QUERIED) {
-		struct timespec64 ctime = { .tv_sec = inode->i_ctime_sec,
+		struct timespec64 ctime = { .tv_sec = inode_get_ctime_sec(inode),
 					    .tv_nsec = cns & ~I_CTIME_QUERIED };
 
 		if (timespec64_compare(&now, &ctime) <= 0) {
@@ -2790,7 +2790,7 @@ struct timespec64 inode_set_ctime_current(struct inode *inode)
 	mgtime_counter_inc(mg_ctime_updates);
 
 	/* No need to cmpxchg if it's exactly the same */
-	if (cns == now.tv_nsec && inode->i_ctime_sec == now.tv_sec) {
+	if (cns == now.tv_nsec && inode_get_ctime_sec(inode) == now.tv_sec) {
 		trace_ctime_xchg_skip(inode, &now);
 		goto out;
 	}
@@ -2799,7 +2799,7 @@ struct timespec64 inode_set_ctime_current(struct inode *inode)
 	/* Try to swap the nsec value into place. */
 	if (try_cmpxchg(&inode->i_ctime_nsec, &cur, now.tv_nsec)) {
 		/* If swap occurred, then we're (mostly) done */
-		inode->i_ctime_sec = now.tv_sec;
+		WRITE_ONCE(inode->i_ctime_sec, now.tv_sec);
 		trace_ctime_ns_xchg(inode, cns, now.tv_nsec, cur);
 		mgtime_counter_inc(mg_ctime_swaps);
 	} else {
@@ -2814,7 +2814,7 @@ struct timespec64 inode_set_ctime_current(struct inode *inode)
 			goto retry;
 		}
 		/* Otherwise, keep the existing ctime */
-		now.tv_sec = inode->i_ctime_sec;
+		now.tv_sec = inode_get_ctime_sec(inode);
 		now.tv_nsec = cur & ~I_CTIME_QUERIED;
 	}
 out:
@@ -2847,7 +2847,7 @@ struct timespec64 inode_set_ctime_deleg(struct inode *inode, struct timespec64 u
 	/* pairs with try_cmpxchg below */
 	cur = smp_load_acquire(&inode->i_ctime_nsec);
 	cur_ts.tv_nsec = cur & ~I_CTIME_QUERIED;
-	cur_ts.tv_sec = inode->i_ctime_sec;
+	cur_ts.tv_sec = inode_get_ctime_sec(inode);
 
 	/* If the update is older than the existing value, skip it. */
 	if (timespec64_compare(&update, &cur_ts) <= 0)
@@ -2873,7 +2873,7 @@ struct timespec64 inode_set_ctime_deleg(struct inode *inode, struct timespec64 u
 retry:
 	old = cur;
 	if (try_cmpxchg(&inode->i_ctime_nsec, &cur, update.tv_nsec)) {
-		inode->i_ctime_sec = update.tv_sec;
+		WRITE_ONCE(inode->i_ctime_sec, update.tv_sec);
 		mgtime_counter_inc(mg_ctime_swaps);
 		return update;
 	}
@@ -2889,7 +2889,7 @@ struct timespec64 inode_set_ctime_deleg(struct inode *inode, struct timespec64 u
 		goto retry;
 
 	/* Otherwise, it was a new timestamp. */
-	cur_ts.tv_sec = inode->i_ctime_sec;
+	cur_ts.tv_sec = inode_get_ctime_sec(inode);
 	cur_ts.tv_nsec = cur & ~I_CTIME_QUERIED;
 	return cur_ts;
 }
diff --git a/fs/stat.c b/fs/stat.c
index 6c79661e1b961..8c110555b3d7b 100644
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
index 14f5accc97b74..55ecd9d26b4fb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1783,12 +1783,12 @@ struct timespec64 inode_set_ctime_deleg(struct inode *inode,
 
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
@@ -1802,8 +1802,8 @@ static inline struct timespec64 inode_get_atime(const struct inode *inode)
 static inline struct timespec64 inode_set_atime_to_ts(struct inode *inode,
 						      struct timespec64 ts)
 {
-	inode->i_atime_sec = ts.tv_sec;
-	inode->i_atime_nsec = ts.tv_nsec;
+	WRITE_ONCE(inode->i_atime_sec, ts.tv_sec);
+	WRITE_ONCE(inode->i_atime_nsec, ts.tv_nsec);
 	return ts;
 }
 
@@ -1818,12 +1818,12 @@ static inline struct timespec64 inode_set_atime(struct inode *inode,
 
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
@@ -1836,8 +1836,8 @@ static inline struct timespec64 inode_get_mtime(const struct inode *inode)
 static inline struct timespec64 inode_set_mtime_to_ts(struct inode *inode,
 						      struct timespec64 ts)
 {
-	inode->i_mtime_sec = ts.tv_sec;
-	inode->i_mtime_nsec = ts.tv_nsec;
+	WRITE_ONCE(inode->i_mtime_sec, ts.tv_sec);
+	WRITE_ONCE(inode->i_mtime_nsec, ts.tv_nsec);
 	return ts;
 }
 
@@ -1862,12 +1862,12 @@ static inline struct timespec64 inode_set_mtime(struct inode *inode,
 
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



