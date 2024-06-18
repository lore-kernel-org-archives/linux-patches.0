Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724EA13C9CF;
	Tue, 18 Jun 2024 13:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716461; cv=none; b=uJecLQngL9T7bHq6oX0TYamyZVtw2YwFeNl9/jTbNku6hLIz5IhkW2blF1htLnMDrPLjp91J/wiGRGlojC3FZVnp7vCLZqLVtI3EWLWg79VykcD+DBd0o8VaDLPFwz0z1MNenKP55lxbOlTI78PsNibN8WDuEoUYFKlUA+4c5r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716461; c=relaxed/simple;
	bh=mHniQHz87xq4EYrFSX7D6Lr+FUs8LMpA0lg0U1GF9aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEfwL7x+pl69q+O4HGGJFGQaDDrZN1QB81G4KpTS+0n+pqQ/j6TmJ9VJomeXvLd2pHfu4Yxn32Q3c8b2pz05kfRrSbPC2/SVCv7Tvz9coL7DPWfVBi5+QitKuCzNjsA8AnFU7OdY0VR0Q1+NCPWjNQiJQh+df3LwuxIjjgjyx+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=upw2qFqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upw2qFqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF93C3277B;
	Tue, 18 Jun 2024 13:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716461;
	bh=mHniQHz87xq4EYrFSX7D6Lr+FUs8LMpA0lg0U1GF9aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=upw2qFqKhuBDB8idkFzXxXFhRqpaB7p0TeaAT0MbcFidO8RW5zaNQlt3VHaYrUcVn
	 9G6Z0VoKcsrymT4SNV4NdHtb/2/h0wyoYybIqSGG2aUqgMdQc6SfLFST2RV6KI9eDT
	 p51MqSkk+xlE6V83gKSuhjWFAGsdX3xatK5Gtp1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kasiak <j.kasiak@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 623/770] lockd: detect and reject lock arguments that overflow
Date: Tue, 18 Jun 2024 14:37:56 +0200
Message-ID: <20240618123431.333340237@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 6930bcbfb6ceda63e298c6af6d733ecdf6bd4cde ]

lockd doesn't currently vet the start and length in nlm4 requests like
it should, and can end up generating lock requests with arguments that
overflow when passed to the filesystem.

The NLM4 protocol uses unsigned 64-bit arguments for both start and
length, whereas struct file_lock tracks the start and end as loff_t
values. By the time we get around to calling nlm4svc_retrieve_args,
we've lost the information that would allow us to determine if there was
an overflow.

Start tracking the actual start and len for NLM4 requests in the
nlm_lock. In nlm4svc_retrieve_args, vet these values to ensure they
won't cause an overflow, and return NLM4_FBIG if they do.

Link: https://bugzilla.linux-nfs.org/show_bug.cgi?id=392
Reported-by: Jan Kasiak <j.kasiak@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <stable@vger.kernel.org> # 5.14+
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svc4proc.c       |  8 ++++++++
 fs/lockd/xdr4.c           | 19 ++-----------------
 include/linux/lockd/xdr.h |  2 ++
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index 4f247ab8be611..bf274f23969b3 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -32,6 +32,10 @@ nlm4svc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 	if (!nlmsvc_ops)
 		return nlm_lck_denied_nolocks;
 
+	if (lock->lock_start > OFFSET_MAX ||
+	    (lock->lock_len && ((lock->lock_len - 1) > (OFFSET_MAX - lock->lock_start))))
+		return nlm4_fbig;
+
 	/* Obtain host handle */
 	if (!(host = nlmsvc_lookup_host(rqstp, lock->caller, lock->len))
 	 || (argp->monitor && nsm_monitor(host) < 0))
@@ -50,6 +54,10 @@ nlm4svc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 		/* Set up the missing parts of the file_lock structure */
 		lock->fl.fl_file  = file->f_file[mode];
 		lock->fl.fl_pid = current->tgid;
+		lock->fl.fl_start = (loff_t)lock->lock_start;
+		lock->fl.fl_end = lock->lock_len ?
+				   (loff_t)(lock->lock_start + lock->lock_len - 1) :
+				   OFFSET_MAX;
 		lock->fl.fl_lmops = &nlmsvc_lock_operations;
 		nlmsvc_locks_init_private(&lock->fl, host, (pid_t)lock->svid);
 		if (!lock->fl.fl_owner) {
diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index 856267c0864bd..712fdfeb8ef06 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -20,13 +20,6 @@
 
 #include "svcxdr.h"
 
-static inline loff_t
-s64_to_loff_t(__s64 offset)
-{
-	return (loff_t)offset;
-}
-
-
 static inline s64
 loff_t_to_s64(loff_t offset)
 {
@@ -70,8 +63,6 @@ static bool
 svcxdr_decode_lock(struct xdr_stream *xdr, struct nlm_lock *lock)
 {
 	struct file_lock *fl = &lock->fl;
-	u64 len, start;
-	s64 end;
 
 	if (!svcxdr_decode_string(xdr, &lock->caller, &lock->len))
 		return false;
@@ -81,20 +72,14 @@ svcxdr_decode_lock(struct xdr_stream *xdr, struct nlm_lock *lock)
 		return false;
 	if (xdr_stream_decode_u32(xdr, &lock->svid) < 0)
 		return false;
-	if (xdr_stream_decode_u64(xdr, &start) < 0)
+	if (xdr_stream_decode_u64(xdr, &lock->lock_start) < 0)
 		return false;
-	if (xdr_stream_decode_u64(xdr, &len) < 0)
+	if (xdr_stream_decode_u64(xdr, &lock->lock_len) < 0)
 		return false;
 
 	locks_init_lock(fl);
 	fl->fl_flags = FL_POSIX;
 	fl->fl_type  = F_RDLCK;
-	end = start + len - 1;
-	fl->fl_start = s64_to_loff_t(start);
-	if (len == 0 || end < 0)
-		fl->fl_end = OFFSET_MAX;
-	else
-		fl->fl_end = s64_to_loff_t(end);
 
 	return true;
 }
diff --git a/include/linux/lockd/xdr.h b/include/linux/lockd/xdr.h
index 398f70093cd35..67e4a2c5500bd 100644
--- a/include/linux/lockd/xdr.h
+++ b/include/linux/lockd/xdr.h
@@ -41,6 +41,8 @@ struct nlm_lock {
 	struct nfs_fh		fh;
 	struct xdr_netobj	oh;
 	u32			svid;
+	u64			lock_start;
+	u64			lock_len;
 	struct file_lock	fl;
 };
 
-- 
2.43.0



