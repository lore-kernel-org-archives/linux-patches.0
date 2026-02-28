Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43F02DE717
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301109; cv=none; b=iMHrehQMVssfjtKUdYYxvj0XRjDprDGnB7mAGaCuv6TVgPY8SHzldCYa29buU4j6smY2ZEbFPKDG6+ZRfPmYBMWIvu0vN6JfyNP7YCSls1FZVmAbRGzm3jrNAORQKQU31lYuK3sM7m47NF2S4D4N3ycyLUfZcfP5oLob2Y8ImTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301109; c=relaxed/simple;
	bh=O6C8S6vRXBsHphTnKx+9Jk67r9IKqOeq5Szq5CasPt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MK9pXFIMyUKh+Ko4zdybrU9wmHIb2KFUGuSsX/PDOpvrvsEnNNDOVz+HPl2rRFcYCtkucADTHYdf/yNANherMf24FCraZFewyiXEb4RQUpXCiQ4ppPLs56JytPctexBg2Q0g4CdrK3JJOA5v35RPye2Qr95ObURhnRBsxJe210E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vN3D658R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vN3D658R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB0AC19425;
	Sat, 28 Feb 2026 17:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301109;
	bh=O6C8S6vRXBsHphTnKx+9Jk67r9IKqOeq5Szq5CasPt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vN3D658RcFZUajg6E9r8vWWB2PzHK8YSwRFKi5j16cbFbynNyPeeYbdHzwKQKC4jX
	 0gW6bH9Z1gy32g20jTNfwvlpnU9HXyoiiL8QJi7wyuLogXRbQ3RlioH/tn7EtO5iiB
	 ZUK9p5aNK96ffMISzVI4BEODcENNkzEV8KDJZZROF8kQX6Do6FNEPRPsK3ZSVcMyiC
	 xVgZicNELVzGFwJS/wPtdSdtMJZwYZWFfUizdHPPETQ/VKbd13su26J1kY9tt+CoJV
	 HyX1+m/S/2zvvvt5lpue6S1KSH9Dbi50L1bhxSDKHdCQpwWuPkVMinq4/W4vGJupSf
	 lzLWUsxiCOMNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Gerd Rausch <gerd.rausch@oracle.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 264/752] net/rds: No shortcut out of RDS_CONN_ERROR
Date: Sat, 28 Feb 2026 12:39:35 -0500
Message-ID: <20260228174750.1542406-264-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Gerd Rausch <gerd.rausch@oracle.com>

[ Upstream commit ad22d24be635c6beab6a1fdd3f8b1f3c478d15da ]

RDS connections carry a state "rds_conn_path::cp_state"
and transitions from one state to another and are conditional
upon an expected state: "rds_conn_path_transition."

There is one exception to this conditionality, which is
"RDS_CONN_ERROR" that can be enforced by "rds_conn_path_drop"
regardless of what state the condition is currently in.

But as soon as a connection enters state "RDS_CONN_ERROR",
the connection handling code expects it to go through the
shutdown-path.

The RDS/TCP multipath changes added a shortcut out of
"RDS_CONN_ERROR" straight back to "RDS_CONN_CONNECTING"
via "rds_tcp_accept_one_path" (e.g. after "rds_tcp_state_change").

A subsequent "rds_tcp_reset_callbacks" can then transition
the state to "RDS_CONN_RESETTING" with a shutdown-worker queued.

That'll trip up "rds_conn_init_shutdown", which was
never adjusted to handle "RDS_CONN_RESETTING" and subsequently
drops the connection with the dreaded "DR_INV_CONN_STATE",
which leaves "RDS_SHUTDOWN_WORK_QUEUED" on forever.

So we do two things here:

a) Don't shortcut "RDS_CONN_ERROR", but take the longer
   path through the shutdown code.

b) Add "RDS_CONN_RESETTING" to the expected states in
  "rds_conn_init_shutdown" so that we won't error out
  and get stuck, if we ever hit weird state transitions
  like this again."

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Link: https://patch.msgid.link/20260122055213.83608-2-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/connection.c | 2 ++
 net/rds/tcp_listen.c | 5 -----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index 68bc88cce84ec..ad8027e6f54ef 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -382,6 +382,8 @@ void rds_conn_shutdown(struct rds_conn_path *cp)
 		if (!rds_conn_path_transition(cp, RDS_CONN_UP,
 					      RDS_CONN_DISCONNECTING) &&
 		    !rds_conn_path_transition(cp, RDS_CONN_ERROR,
+					      RDS_CONN_DISCONNECTING) &&
+		    !rds_conn_path_transition(cp, RDS_CONN_RESETTING,
 					      RDS_CONN_DISCONNECTING)) {
 			rds_conn_path_error(cp,
 					    "shutdown called in state %d\n",
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 91e34af3fe5d5..65c5425a02de4 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -59,9 +59,6 @@ void rds_tcp_keepalive(struct socket *sock)
  * socket and force a reconneect from smaller -> larger ip addr. The reason
  * we special case cp_index 0 is to allow the rds probe ping itself to itself
  * get through efficiently.
- * Since reconnects are only initiated from the node with the numerically
- * smaller ip address, we recycle conns in RDS_CONN_ERROR on the passive side
- * by moving them to CONNECTING in this function.
  */
 static
 struct rds_tcp_connection *rds_tcp_accept_one_path(struct rds_connection *conn)
@@ -86,8 +83,6 @@ struct rds_tcp_connection *rds_tcp_accept_one_path(struct rds_connection *conn)
 		struct rds_conn_path *cp = &conn->c_path[i];
 
 		if (rds_conn_path_transition(cp, RDS_CONN_DOWN,
-					     RDS_CONN_CONNECTING) ||
-		    rds_conn_path_transition(cp, RDS_CONN_ERROR,
 					     RDS_CONN_CONNECTING)) {
 			return cp->cp_transport_data;
 		}
-- 
2.51.0

