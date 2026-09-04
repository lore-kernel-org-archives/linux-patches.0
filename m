Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605B61AA1F4;
	Fri,  4 Sep 2026 05:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498771; cv=none; b=GbOiF3zocqFQjdnw7Uuq4gxT2+Vm+wCsRaBbq5rzSsAPoskVyvm1VKEJuWR8HQPHCWptKPyZiQpV+5q8NX7dhtirYK/oOrJhKZpZuJ4wRI0PNeT2zSIlwQN9kmyI1eJo45qkXUtUdiEkFxpWP8EFoeCig45PzlrPM7H63YbceTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498771; c=relaxed/simple;
	bh=yy8QXBgbeffGFdeYwMZKTYl6YnoDgUwsD18iWmhkg+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFMrb7MkILri8WxJfnRz4pb7wR4r9mr+ni6dPiiPtsW1lIUelFwSWNrp8tDdTrXMqK+LmL+y+aazi0FWrPUtTTm/BADwXFlJ2euvfbsTtotoi0GVJORR+ijBs7dEmksWKwaovzl8Qxw0htaktH1Crt4NDK//+TFhjBt/WLIS5O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwHQ0dNF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwHQ0dNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4C41F00A3D;
	Fri,  4 Sep 2026 05:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498770;
	bh=e34iIlb26N5tLZFaHpFAhcrhgVjPgfME95kM/YqSNRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kwHQ0dNFJKkFVXHacEAOjGfj/+2OTpfMHtaxs9q9Hw8ZuVLUvU3GL8+G3ISq5nQC+
	 eKKNQR9W18mmMxM3FVKhYBdjFHynX8eGlsW8+FyF4mZDIlhfPNPXS6MJYxkhfn4Ka1
	 pDsbqPIk4/hK4f7AOXOHq3SDQp6obloNQFboyBhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 182/713] nfsd: fix layout fence worker double-reference race
Date: Fri,  4 Sep 2026 06:52:30 +0200
Message-ID: <20260904045807.896136930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 8580571227451384399b3fa53fcde19848c48e5a upstream.

The workqueue core clears WORK_STRUCT_PENDING before the callback
is invoked, so delayed_work_pending() in lm_breaker_timedout() can
return false while the fence worker is already running. This lets
the breaker take a duplicate sc_count reference and schedule a new
worker that coalesces with the in-progress one. The extra reference
is never put, leaking the layout stateid.

Replace the racy delayed_work_pending() check with an
ls_fence_inflight boolean set atomically with
refcount_inc_not_zero() under ls_lock, and cleared under ls_lock
before the final nfs4_put_stid() on the dispose path; the retry
path intentionally retains it.  Remove the self-rearm
mod_delayed_work() at the top of the worker.

Fixes: f52792f484ba ("NFSD: Enforce timeout on layout recall and integrate lease manager fencing")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260531-nfsd-testing-v1-6-7bfa481b0540@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4layouts.c | 27 +++++++++++++++------------
 fs/nfsd/state.h       |  1 +
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index 1de2f6cd1f09..279ff1e9dffb 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -260,6 +260,7 @@ nfsd4_alloc_layout_stateid(struct nfsd4_compound_state *cstate,
 	}
 
 	ls->ls_fenced = false;
+	ls->ls_fence_inflight = false;
 	ls->ls_fence_delay = 0;
 	INIT_DELAYED_WORK(&ls->ls_fence_work, nfsd4_layout_fence_worker);
 
@@ -797,15 +798,6 @@ nfsd4_layout_fence_worker(struct work_struct *work)
 	struct nfs4_client *clp;
 	struct nfsd_net *nn;
 
-	/*
-	 * The workqueue clears WORK_STRUCT_PENDING before invoking
-	 * this callback. Re-arm immediately so that
-	 * delayed_work_pending() returns true while the fence
-	 * operation is in progress, preventing
-	 * lm_breaker_timedout() from taking a duplicate reference.
-	 */
-	mod_delayed_work(system_dfl_wq, &ls->ls_fence_work, 0);
-
 	spin_lock(&ls->ls_lock);
 	if (list_empty(&ls->ls_layouts)) {
 		spin_unlock(&ls->ls_lock);
@@ -815,6 +807,9 @@ nfsd4_layout_fence_worker(struct work_struct *work)
 		nfsd4_close_layout(ls);
 
 		ls->ls_fenced = true;
+		spin_lock(&ls->ls_lock);
+		ls->ls_fence_inflight = false;
+		spin_unlock(&ls->ls_lock);
 		nfs4_put_stid(&ls->ls_stid);
 		return;
 	}
@@ -900,18 +895,26 @@ nfsd4_layout_lm_breaker_timedout(struct file_lease *fl)
 	if ((!nfsd4_layout_ops[ls->ls_layout_type]->fence_client) ||
 			ls->ls_fenced)
 		return true;
-	if (delayed_work_pending(&ls->ls_fence_work))
-		return false;
 	/*
 	 * Make sure layout has not been returned yet before
-	 * taking a reference count on the layout stateid.
+	 * taking a reference count on the layout stateid. The
+	 * ls_fence_inflight flag is set together with the sc_count
+	 * increment under ls_lock so that a fence worker invocation
+	 * already in progress (which has cleared WORK_STRUCT_PENDING
+	 * but not yet reached dispose:) cannot be coalesced with a
+	 * fresh schedule that takes an extra unmatched reference.
 	 */
 	spin_lock(&ls->ls_lock);
+	if (ls->ls_fence_inflight) {
+		spin_unlock(&ls->ls_lock);
+		return false;
+	}
 	if (list_empty(&ls->ls_layouts) ||
 			!refcount_inc_not_zero(&ls->ls_stid.sc_count)) {
 		spin_unlock(&ls->ls_lock);
 		return true;
 	}
+	ls->ls_fence_inflight = true;
 	spin_unlock(&ls->ls_lock);
 
 	mod_delayed_work(system_dfl_wq, &ls->ls_fence_work, 0);
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index ac6fd0d6d099..f44ea672670f 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -755,6 +755,7 @@ struct nfs4_layout_stateid {
 	struct delayed_work		ls_fence_work;
 	unsigned int			ls_fence_delay;
 	bool				ls_fenced;
+	bool				ls_fence_inflight;
 };
 
 static inline struct nfs4_layout_stateid *layoutstateid(struct nfs4_stid *s)
-- 
2.55.0



