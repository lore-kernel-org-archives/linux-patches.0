Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B304973BE;
	Thu, 17 Sep 2026 17:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665546; cv=none; b=RnfW+bD8fnZ2+flZPnVWk6Jqu6Q7lzY0Z+gNGZxVN5PRE9y1bwRLwCst1T1+dc2tS2RCL6xoijlddtZMM9U2pi3RHLS44KSi3kzA+ln2QIiF3YOBqczbuG+pG+dJYyCO0n84oxgmSrCXpgDCxN1NWxv5Ge1j4dpriC6YvDjpC74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665546; c=relaxed/simple;
	bh=xrNPIyoz7wJte/WKuPlZ2bhQHpGUgN8G4FgMTGmDE68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKjBCwvC+qX4UCJq0lSywSjLQbJzP4iRRcD56dyFe0kQRhNaZjEthhhZBvl458potTFx2dyqRhQR1OImiV3fqZmZZSPDG5UmWUnEho8TfaaX+I8/5JZCLFPRptCiQN4WWz+razswS8gAY6g9jXK9arK3kEPjeGV6bTBQQTKzGlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2tv6lGZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2tv6lGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4E71F000FF;
	Thu, 17 Sep 2026 17:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665544;
	bh=B2dwB0kjBWVLO6poTdmdnXbuoRY12vC78oJaO50Q6ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2tv6lGZqAF1k4w8jklRlE9Z/szVGZwzsiOWUbAXCJOEjBIqjJPHPhCKrokbZCKJF
	 kkBPtQMa1Rrktl7tSF0hiTgGj/KIEHiFeYfyPFiNExTMvDfpHl8BJHfTJan79a6y2o
	 +zwimnXYYCgi/TlH2k4/IQ8oQ0ILn/KEwejeUUhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Rausch <gerd.rausch@oracle.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0741/1250] net/rds: tcp: dont force RDS_CONN_RESETTING over a concurrent shutdown
Date: Thu, 17 Sep 2026 16:08:56 +0100
Message-ID: <20260917151611.975295533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Gerd Rausch <gerd.rausch@oracle.com>

[ Upstream commit e8e60d74fec49ccae2aea9b04a6eb162feb8d9af ]

rds_tcp_reset_callbacks() resolves a duelling SYN by storing
RDS_CONN_RESETTING into cp_state unconditionally.  Nothing serializes
that store against the shutdown path: rds_tcp_accept_one() checks
for RDS_CONN_CONNECTING or RDS_CONN_ERROR under t_conn_path_lock, but
neither rds_conn_path_drop(), which forces RDS_CONN_ERROR, nor
rds_conn_shutdown(), which moves the path to RDS_CONN_DISCONNECTING
under cp_cm_lock, takes that lock.  The store can therefore land on
top of a shutdown that is already in progress, or that gets queued
right after the accept-side check.

When it does, the shutdown worker's final DISCONNECTING -> DOWN
transition fails and the path goes through rds_conn_path_error() and
a second drop/shutdown cycle instead of a clean reconnect, tearing
down the socket the accept path has just installed.  Before commit
ad22d24be635 ("net/rds: No shortcut out of RDS_CONN_ERROR") a path
found in RDS_CONN_RESETTING even made rds_conn_shutdown() bail out
altogether.

Make the transition conditional: move CONNECTING -> RESETTING (or
stay in RESETTING from an earlier duel), and drop the path in any
other state.  The drop has side effects of its own: it replaces the
shutdown's RDS_CONN_DISCONNECTING (or RDS_CONN_ERROR) with
RDS_CONN_ERROR and queues one more cp_down_w run.  The difference is
that rds_conn_shutdown() accepts RDS_CONN_ERROR in its final
transition to RDS_CONN_DOWN, so the shutdown in flight completes
normally instead of through rds_conn_path_error(); the extra
down-work pass then finds the path already down and falls through to
the reconnect check, or catches a reconnect that has already started
and restarts it.  The accept path still installs the new socket,
rds_connect_path_complete() then fails its RESETTING -> UP transition
and drops it: the raced socket ends up torn down as it does today.
The comment at that call site, which promised that
rds_connect_path_complete() marks the path RDS_CONN_UP, is updated to
name this outcome as well.

The state can change again between the failed transitions and the
drop.  That is inherent to rds_conn_path_drop(), which the socket
state-change callbacks also call unconditionally, and costs at most
one extra drop/reconnect cycle.

Based on Oracle UEK commit "net/rds: Don't force state
RDS_CONN_RESETTING" by Gerd Rausch.

Fixes: 9c79440e2c5e ("RDS: TCP: fix race windows in send-path quiescence by rds_tcp_accept_one()")
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
[achender: port to net-next: use the two-argument
 rds_conn_path_transition()/rds_conn_path_drop() and rewrite the
 changelog for the upstream shutdown path]
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260828223921.202913-5-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c        | 17 +++++++++++++++--
 net/rds/tcp_listen.c |  6 +++++-
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index ab509498cf752..84cd673b8b7e1 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -150,9 +150,22 @@ void rds_tcp_reset_callbacks(struct socket *sock,
 	 * end up deadlocking with tcp_sendmsg(), and the RDS_IN_XMIT
 	 * would not get set. As a result, we set c_state to
 	 * RDS_CONN_RESETTTING, to ensure that rds_tcp_state_change
-	 * cannot mark rds_conn_path_up() in the window before lock_sock()
+	 * cannot mark rds_conn_path_up() in the window before lock_sock().
+	 *
+	 * Only make that transition if the path is still connecting
+	 * (or already resetting from an earlier duel).  A path in any
+	 * other state - typically RDS_CONN_DISCONNECTING or
+	 * RDS_CONN_ERROR with a shutdown in flight - is dropped
+	 * instead.  That still replaces its state, with RDS_CONN_ERROR,
+	 * and queues one more shutdown pass, but rds_conn_shutdown()
+	 * accepts RDS_CONN_ERROR in its final transition to
+	 * RDS_CONN_DOWN, so the shutdown in flight completes normally.
 	 */
-	atomic_set(&cp->cp_state, RDS_CONN_RESETTING);
+	if (!rds_conn_path_transition(cp, RDS_CONN_CONNECTING,
+				      RDS_CONN_RESETTING) &&
+	    !rds_conn_path_transition(cp, RDS_CONN_RESETTING,
+				      RDS_CONN_RESETTING))
+		rds_conn_path_drop(cp, 0);
 	wait_event(cp->cp_waitq, !test_bit(RDS_IN_XMIT, &cp->cp_flags));
 	/* reset receive side state for rds_tcp_data_recv() for osock  */
 	cancel_delayed_work_sync(&cp->cp_send_w);
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 65c5425a02de4..93e8ee10bc8d7 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -181,7 +181,11 @@ int rds_tcp_accept_one(struct socket *sock)
 	if (rs_tcp->t_sock) {
 		/* Duelling SYN has been handled in rds_tcp_accept_one() */
 		rds_tcp_reset_callbacks(new_sock, cp);
-		/* rds_connect_path_complete() marks RDS_CONN_UP */
+		/* rds_connect_path_complete() marks RDS_CONN_UP, or,
+		 * if a concurrent shutdown won the duel, drops the
+		 * path again and the pass that drop queues reaps the
+		 * socket installed above.
+		 */
 		rds_connect_path_complete(cp, RDS_CONN_RESETTING);
 	} else {
 		rds_tcp_set_callbacks(new_sock, cp);
-- 
2.53.0



