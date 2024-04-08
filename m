Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0340279955;
	Mon,  8 Apr 2024 13:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584574; cv=none; b=cqJ71L44GxluEkyBCAO2EACJFQG9OBUTDmNHK/TKSoQfnXfD2D0Xfrfq/5EyUHy52VP2DttOW7FTI3Yiv26zU7kPJavJMeUxXLvovm5G7lvqGIMmrqxTkToqUBqi7W0g/uc76FXLBe7kHWPeWHt9A9sHwiNFyMQYh4NOW046+3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584574; c=relaxed/simple;
	bh=XbP0xYplS0jvWwoYPA9CAyT/BwdUo0aV+G4hscHLPiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMVx1wdjm9nZib4MzAHM3wJgI9dvGgRrLZk8/gxd1PH7byVXWkEbbAS9kYp4DoggizDrS7nmW0IilAgh3nZCuZ/V8OkRSSFWDAERTD4gPbesqlJUa2SKDIF9kuD0R0mYan1w9GZuJiXolB3jJLn1T67IIeUjoMuGe4Woy9g4aOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaWhi4hl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaWhi4hl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A26EC433C7;
	Mon,  8 Apr 2024 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584573;
	bh=XbP0xYplS0jvWwoYPA9CAyT/BwdUo0aV+G4hscHLPiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HaWhi4hltLsI/lUrepAy11AvztV+cVi1E1Glth9prGWgwQSN8LMsDTeVTjKrYudxs
	 D3lgZ07oAqm+ZRvYNgVSCUdNU50MeiIMK0QY/LYrtSZk5LLqVMccE0tCj2iS7BUEvV
	 DAKAzxE6oaJ3XoXvKmw07uri3ODq/Ctrdm0w7xG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 454/690] nfsd: make nfsd4_run_cb a bool return function
Date: Mon,  8 Apr 2024 14:55:20 +0200
Message-ID: <20240408125416.084787175@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit b95239ca4954a0d48b19c09ce7e8f31b453b4216 ]

queue_work can return false and not queue anything, if the work is
already queued. If that happens in the case of a CB_RECALL, we'll have
taken an extra reference to the stid that will never be put. Ensure we
throw a warning in that case.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4callback.c | 14 ++++++++++++--
 fs/nfsd/nfs4state.c    |  5 ++---
 fs/nfsd/state.h        |  2 +-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index face8908a40b1..39989c14c8a1e 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1373,11 +1373,21 @@ void nfsd4_init_cb(struct nfsd4_callback *cb, struct nfs4_client *clp,
 	cb->cb_holds_slot = false;
 }
 
-void nfsd4_run_cb(struct nfsd4_callback *cb)
+/**
+ * nfsd4_run_cb - queue up a callback job to run
+ * @cb: callback to queue
+ *
+ * Kick off a callback to do its thing. Returns false if it was already
+ * on a queue, true otherwise.
+ */
+bool nfsd4_run_cb(struct nfsd4_callback *cb)
 {
 	struct nfs4_client *clp = cb->cb_clp;
+	bool queued;
 
 	nfsd41_cb_inflight_begin(clp);
-	if (!nfsd4_queue_cb(cb))
+	queued = nfsd4_queue_cb(cb);
+	if (!queued)
 		nfsd41_cb_inflight_end(clp);
+	return queued;
 }
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index e98306c69f424..61978ad43a0f7 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4874,14 +4874,13 @@ static void nfsd_break_one_deleg(struct nfs4_delegation *dp)
 	 * we know it's safe to take a reference.
 	 */
 	refcount_inc(&dp->dl_stid.sc_count);
-	nfsd4_run_cb(&dp->dl_recall);
+	WARN_ON_ONCE(!nfsd4_run_cb(&dp->dl_recall));
 }
 
 /* Called from break_lease() with flc_lock held. */
 static bool
 nfsd_break_deleg_cb(struct file_lock *fl)
 {
-	bool ret = false;
 	struct nfs4_delegation *dp = (struct nfs4_delegation *)fl->fl_owner;
 	struct nfs4_file *fp = dp->dl_stid.sc_file;
 	struct nfs4_client *clp = dp->dl_stid.sc_client;
@@ -4907,7 +4906,7 @@ nfsd_break_deleg_cb(struct file_lock *fl)
 	fp->fi_had_conflict = true;
 	nfsd_break_one_deleg(dp);
 	spin_unlock(&fp->fi_lock);
-	return ret;
+	return false;
 }
 
 /**
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index b3477087a9fc3..e2daef3cc0034 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -692,7 +692,7 @@ extern void nfsd4_probe_callback_sync(struct nfs4_client *clp);
 extern void nfsd4_change_callback(struct nfs4_client *clp, struct nfs4_cb_conn *);
 extern void nfsd4_init_cb(struct nfsd4_callback *cb, struct nfs4_client *clp,
 		const struct nfsd4_callback_ops *ops, enum nfsd4_cb_op op);
-extern void nfsd4_run_cb(struct nfsd4_callback *cb);
+extern bool nfsd4_run_cb(struct nfsd4_callback *cb);
 extern int nfsd4_create_callback_queue(void);
 extern void nfsd4_destroy_callback_queue(void);
 extern void nfsd4_shutdown_callback(struct nfs4_client *);
-- 
2.43.0



