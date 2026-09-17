Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D95547060;
	Thu, 17 Sep 2026 18:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668209; cv=none; b=K8xNgytCBf9u3c0YM5scFtkxZ0R7iRcM/Zfy63CQiD6nJ6IGCRVYtz3+yMlGGmo+DpCLR6gUTVNFbI3iijmUdVinJXv3KHXlkLh67qzm/qfAMBA7O4Yf9Y+2kRZqifEymc9wbGqStNNcGm2lH4zs9sTLRArMMA2hxD2esdC9vMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668209; c=relaxed/simple;
	bh=Ka1q5BUiGfwejnu429kAE5tUVOGtsDVKky5HuoAvbHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8147yUDg6DR3qmxxOxnrM4GM3FKXILbiQdkMngYdx6ydkx9PZAzwuGuyl1nnWbNyqDGN+B3Fb3NXxIINWiKaHbJEGpoMQWeBVKTKPW45wN9s9vilnZx3xkrS8/4fcHLGA1LQK7+wlclhgE1KJiAmD3tLucjVMSov/Vwbv3Woy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fFy4Ilt3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fFy4Ilt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5677E1F000FF;
	Thu, 17 Sep 2026 18:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668207;
	bh=GVXk2DPYjIqsG3JhUWxhJ0BFSIYTqRisgozjzAwckkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fFy4Ilt38mbiaxF/m1ooth9s4FPz1JYUamqxx/fRQtOStwLYy1o6/Qayy0KQShBOW
	 e5Al8JYZKmC4dab4oJ2bFj/sFCqrwmytctJVkT+crgkD72VHKxfYe/WXvytv2gK8GE
	 k+Pzu4eebOwuPZQg4iqS8mSzFk8JQHbyYRSVlQOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0349/1102] ceph: harden send_mds_reconnect and handle active-MDS peer reset
Date: Thu, 17 Sep 2026 16:04:52 +0100
Message-ID: <20260917151548.404206141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Markuze <amarkuze@redhat.com>

[ Upstream commit 39fe3031589386ae7ce3fd7132beb6bb229e22ce ]

Change send_mds_reconnect() to return an error code so callers can detect
and report reconnect failures instead of silently ignoring them. Add early
bailout checks for sessions that are already closed, rejected, or
unregistered, which avoids sending reconnect messages for sessions that
can no longer be recovered.

The early -ESTALE and -ENOENT bailouts use a separate fail_return label
that skips the pr_err_client diagnostic, since these codes indicate
expected concurrent-teardown races rather than genuine reconnect build
failures.

Move the "reconnect start" log after the early-bailout checks so it
only appears for sessions that actually proceed with reconnect.

Save the prior session state before transitioning to RECONNECTING,
and restore it in the failure path.  Without this, a transient
build or encoding failure (-ENOMEM, -ENOSPC) strands the session
in RECONNECTING indefinitely because check_new_map() only retries
sessions in RESTARTING state.

Rewrite mds_peer_reset() to handle the case where the MDS is past its
RECONNECT phase (i.e. active). An active MDS rejects CLIENT_RECONNECT
messages because it only accepts them during its own RECONNECT window
after restart. Previously, the client would send a doomed reconnect
that the MDS would reject or ignore. Now, the client tears the session
down locally and lets new requests re-open a fresh session, which is
the correct recovery for this scenario. The RECONNECTING state is
handled on the same teardown path, since the MDS will reject reconnect
attempts from an active client regardless of the session's local state.

Add explicit cases for CLOSED and REJECTED session states in
mds_peer_reset() since these are terminal states where a connection
drop is expected behavior.

The session teardown path in mds_peer_reset() follows the established
drop-and-reacquire locking pattern from check_new_map(): take
mdsc->mutex for session unregistration, release it, then take s->s_mutex
separately for cleanup. This avoids introducing a new simultaneous lock
nesting pattern.

Log reconnect failures from check_new_map() and mds_peer_reset() at
pr_warn level rather than pr_err, since return codes like -ESTALE
(closed/rejected session) and -ENOENT (unregistered session) are
expected during concurrent teardown. Log dropped messages for
unregistered sessions via doutc() (dynamic debug) rather than
pr_info, as post-reset message arrival is routine and does not
warrant unconditional logging.

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 178 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 163 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index b1f2ef990ff45..1e453828f3bcb 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4414,9 +4414,14 @@ static void handle_session(struct ceph_mds_session *session,
 		break;
 
 	case CEPH_SESSION_REJECT:
-		WARN_ON(session->s_state != CEPH_MDS_SESSION_OPENING);
-		pr_info_client(cl, "mds%d rejected session\n",
-			       session->s_mds);
+		WARN_ON(session->s_state != CEPH_MDS_SESSION_OPENING &&
+			session->s_state != CEPH_MDS_SESSION_RECONNECTING);
+		if (session->s_state == CEPH_MDS_SESSION_RECONNECTING)
+			pr_info_client(cl, "mds%d reconnect rejected\n",
+				       session->s_mds);
+		else
+			pr_info_client(cl, "mds%d rejected session\n",
+				       session->s_mds);
 		session->s_state = CEPH_MDS_SESSION_REJECTED;
 		cleanup_session_requests(mdsc, session);
 		remove_session_caps(session);
@@ -4676,6 +4681,14 @@ static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 	cap->mseq = 0;       /* and migrate_seq */
 	cap->cap_gen = atomic_read(&cap->session->s_cap_gen);
 
+	/*
+	 * Note: CEPH_I_ERROR_FILELOCK is not set during reconnect.
+	 * Instead, locks are submitted for best-effort MDS reclaim
+	 * via the flock_len field below.  If reclaim fails (e.g.,
+	 * another client grabbed a conflicting lock), future lock
+	 * operations will fail and set the error flag at that point.
+	 */
+
 	/* These are lost when the session goes away */
 	if (S_ISDIR(inode->i_mode)) {
 		if (cap->issued & CEPH_CAP_DIR_CREATE) {
@@ -4889,20 +4902,19 @@ static int encode_snap_realms(struct ceph_mds_client *mdsc,
  *
  * This is a relatively heavyweight operation, but it's rare.
  */
-static void send_mds_reconnect(struct ceph_mds_client *mdsc,
-			       struct ceph_mds_session *session)
+static int send_mds_reconnect(struct ceph_mds_client *mdsc,
+			      struct ceph_mds_session *session)
 {
 	struct ceph_client *cl = mdsc->fsc->client;
 	struct ceph_msg *reply;
 	int mds = session->s_mds;
 	int err = -ENOMEM;
+	int old_state;
 	struct ceph_reconnect_state recon_state = {
 		.session = session,
 	};
 	LIST_HEAD(dispose);
 
-	pr_info_client(cl, "mds%d reconnect start\n", mds);
-
 	recon_state.pagelist = ceph_pagelist_alloc(GFP_NOFS);
 	if (!recon_state.pagelist)
 		goto fail_nopagelist;
@@ -4911,9 +4923,37 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
 	if (!reply)
 		goto fail_nomsg;
 
+	mutex_lock(&session->s_mutex);
+
+	/* Serialized by s_mutex against concurrent ceph_get_deleg_ino(). */
 	xa_destroy(&session->s_delegated_inos);
+	if (session->s_state == CEPH_MDS_SESSION_CLOSED ||
+	    session->s_state == CEPH_MDS_SESSION_REJECTED) {
+		pr_info_client(cl, "mds%d skipping reconnect, session %s\n",
+			       mds,
+			       ceph_session_state_name(session->s_state));
+		mutex_unlock(&session->s_mutex);
+		ceph_msg_put(reply);
+		err = -ESTALE;
+		goto fail_return;
+	}
 
-	mutex_lock(&session->s_mutex);
+	/* s_mutex -> mdsc->mutex matches cleanup_session_requests() order. */
+	mutex_lock(&mdsc->mutex);
+	if (mds >= mdsc->max_sessions || mdsc->sessions[mds] != session) {
+		mutex_unlock(&mdsc->mutex);
+		pr_info_client(cl,
+			       "mds%d skipping reconnect, session unregistered\n",
+			       mds);
+		mutex_unlock(&session->s_mutex);
+		ceph_msg_put(reply);
+		err = -ENOENT;
+		goto fail_return;
+	}
+	mutex_unlock(&mdsc->mutex);
+
+	pr_info_client(cl, "mds%d reconnect start\n", mds);
+	old_state = session->s_state;
 	session->s_state = CEPH_MDS_SESSION_RECONNECTING;
 	session->s_seq = 0;
 
@@ -5043,18 +5083,34 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
 
 	up_read(&mdsc->snap_rwsem);
 	ceph_pagelist_release(recon_state.pagelist);
-	return;
+	return 0;
 
 fail:
 	ceph_msg_put(reply);
 	up_read(&mdsc->snap_rwsem);
+	/*
+	 * Restore prior session state so map-driven reconnect logic
+	 * (check_new_map) can retry.  Without this, a transient build
+	 * failure strands the session in RECONNECTING indefinitely.
+	 */
+	session->s_state = old_state;
 	mutex_unlock(&session->s_mutex);
 fail_nomsg:
 	ceph_pagelist_release(recon_state.pagelist);
 fail_nopagelist:
 	pr_err_client(cl, "error %d preparing reconnect for mds%d\n",
 		      err, mds);
-	return;
+	return err;
+
+fail_return:
+	/*
+	 * Early-exit path for expected concurrent-teardown races
+	 * (-ESTALE for closed/rejected sessions, -ENOENT for
+	 * unregistered sessions).  Skip the pr_err_client diagnostic
+	 * since these are not genuine reconnect build failures.
+	 */
+	ceph_pagelist_release(recon_state.pagelist);
+	return err;
 }
 
 
@@ -5135,9 +5191,15 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		 */
 		if (s->s_state == CEPH_MDS_SESSION_RESTARTING &&
 		    newstate >= CEPH_MDS_STATE_RECONNECT) {
+			int rc;
+
 			mutex_unlock(&mdsc->mutex);
 			clear_bit(i, targets);
-			send_mds_reconnect(mdsc, s);
+			rc = send_mds_reconnect(mdsc, s);
+			if (rc)
+				pr_warn_client(cl,
+					       "mds%d reconnect failed: %d\n",
+					       i, rc);
 			mutex_lock(&mdsc->mutex);
 		}
 
@@ -5201,7 +5263,11 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 		}
 		doutc(cl, "send reconnect to export target mds.%d\n", i);
 		mutex_unlock(&mdsc->mutex);
-		send_mds_reconnect(mdsc, s);
+		err = send_mds_reconnect(mdsc, s);
+		if (err)
+			pr_warn_client(cl,
+				       "mds%d export target reconnect failed: %d\n",
+				       i, err);
 		ceph_put_mds_session(s);
 		mutex_lock(&mdsc->mutex);
 	}
@@ -6283,12 +6349,92 @@ static void mds_peer_reset(struct ceph_connection *con)
 {
 	struct ceph_mds_session *s = con->private;
 	struct ceph_mds_client *mdsc = s->s_mdsc;
+	int session_state;
 
 	pr_warn_client(mdsc->fsc->client, "mds%d closed our session\n",
 		       s->s_mds);
-	if (READ_ONCE(mdsc->fsc->mount_state) != CEPH_MOUNT_FENCE_IO &&
-	    ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) >= CEPH_MDS_STATE_RECONNECT)
-		send_mds_reconnect(mdsc, s);
+
+	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO ||
+	    ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) < CEPH_MDS_STATE_RECONNECT)
+		return;
+
+	/*
+	 * Only reconnect if MDS is in its RECONNECT phase.  An MDS past
+	 * RECONNECT (REJOIN, CLIENTREPLAY, ACTIVE) will reject reconnect
+	 * attempts, so those states fall through to session teardown below.
+	 */
+	if (ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) == CEPH_MDS_STATE_RECONNECT) {
+		int rc = send_mds_reconnect(mdsc, s);
+
+		if (rc)
+			pr_warn_client(mdsc->fsc->client,
+				       "mds%d reconnect failed: %d\n",
+				       s->s_mds, rc);
+		return;
+	}
+
+	/*
+	 * MDS is active (past RECONNECT).  It will not accept a
+	 * CLIENT_RECONNECT from us, so tear the session down locally
+	 * and let new requests re-open a fresh session.
+	 *
+	 * Snapshot session state with READ_ONCE, then revalidate under
+	 * mdsc->mutex before acting.  The subsequent mdsc->mutex
+	 * section rechecks s_state to catch concurrent transitions, so
+	 * the lockless snapshot here is safe.  s->s_mutex is taken
+	 * separately for cleanup after unregistration, which avoids
+	 * introducing a new s->s_mutex + mdsc->mutex nesting.
+	 */
+	session_state = READ_ONCE(s->s_state);
+
+	switch (session_state) {
+	case CEPH_MDS_SESSION_RESTARTING:
+	case CEPH_MDS_SESSION_RECONNECTING:
+	case CEPH_MDS_SESSION_CLOSING:
+	case CEPH_MDS_SESSION_OPEN:
+	case CEPH_MDS_SESSION_HUNG:
+	case CEPH_MDS_SESSION_OPENING:
+		mutex_lock(&mdsc->mutex);
+		if (s->s_mds >= mdsc->max_sessions ||
+		    mdsc->sessions[s->s_mds] != s ||
+		    s->s_state != session_state) {
+			pr_info_client(mdsc->fsc->client,
+				       "mds%d state changed to %s during peer reset\n",
+				       s->s_mds,
+				       ceph_session_state_name(s->s_state));
+			mutex_unlock(&mdsc->mutex);
+			return;
+		}
+
+		ceph_get_mds_session(s);
+		s->s_state = CEPH_MDS_SESSION_CLOSED;
+		__unregister_session(mdsc, s);
+		__wake_requests(mdsc, &s->s_waiting);
+		mutex_unlock(&mdsc->mutex);
+
+		mutex_lock(&s->s_mutex);
+		cleanup_session_requests(mdsc, s);
+		remove_session_caps(s);
+		mutex_unlock(&s->s_mutex);
+
+		wake_up_all(&mdsc->session_close_wq);
+
+		mutex_lock(&mdsc->mutex);
+		kick_requests(mdsc, s->s_mds);
+		mutex_unlock(&mdsc->mutex);
+
+		ceph_put_mds_session(s);
+		break;
+	case CEPH_MDS_SESSION_CLOSED:
+	case CEPH_MDS_SESSION_REJECTED:
+		break;
+	default:
+		pr_warn_client(mdsc->fsc->client,
+			       "mds%d peer reset in unexpected state %s\n",
+			       s->s_mds,
+			       ceph_session_state_name(session_state));
+		break;
+	}
 }
 
 static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
@@ -6300,6 +6446,8 @@ static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
 
 	mutex_lock(&mdsc->mutex);
 	if (__verify_registered_session(mdsc, s) < 0) {
+		doutc(cl, "dropping tid %llu from unregistered session %d\n",
+		      le64_to_cpu(msg->hdr.tid), s->s_mds);
 		mutex_unlock(&mdsc->mutex);
 		goto out;
 	}
-- 
2.53.0



