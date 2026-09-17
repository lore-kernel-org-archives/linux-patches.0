Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706403C7E19;
	Thu, 17 Sep 2026 17:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667516; cv=none; b=P2ihbDSJbAaPzEswi0U0F24J6jpV2obKZUBp0aQ7xYF6cy2OFnwGii6VfRssABEKm6oY2Q3KP0F8ySMzkKWXuO4guZ/wexB8J6mpM6jncTJRkztBikR5Thag2TbIW3uEO8zpxOdj7SxrlKrFx8pAZjz3v69rzxYJc0b6DDrBfew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667516; c=relaxed/simple;
	bh=rMDmK3QaZaDS3FR4HZpEMHqwnseUMaOlzLXywerqLlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQuis9YP4QiqJkZyjMpyN6/Mp6IEv15PjOJNBOdce+gNEGvE22LSyTsAvz3z1t2GUTXPvsnQlECGpLwibZKQlrDF4CwnlqueyGLnkmgamJkLNeWxjVOKybfZ5KU+8NYeHxD2MBjGhbTvtiWJ+4WzZeuD7wvrX12pb+2CSEynDIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4t6PvJM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4t6PvJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FF41F000FF;
	Thu, 17 Sep 2026 17:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667515;
	bh=aP4/tG8Bo+KFMEV77UYpYGlEs5vMGL7DLBTPGw93+oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J4t6PvJMkm4yw5gnoELn9eSOjtKrszHVbjUc7+nxSPs8nlcB0dz1UbswFQVw+/iE1
	 7ntih7M5mPyyIlQvqxrts88XKXxTUWMHK3ST+PLFvHrpMiGMsDNoVyR+yi2D+9OEdQ
	 dxV2LJdTaSbJQq0ew52bPcAphxBhXbsRfxsKDIbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0118/1102] net/rds: Dont sleep inside rds_ib_conn_path_shutdown
Date: Thu, 17 Sep 2026 16:01:01 +0100
Message-ID: <20260917151542.471093728@linuxfoundation.org>
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

From: Allison Henderson <achender@kernel.org>

[ Upstream commit 16f48efaeb6991193fb7775c577f06f5b20b0c90 ]

New rds rdma self tests exposed a hang when tearing down
the ib network configs.  This is caused by the shutdown worker
thread sleeping on the wait_event call, which blocks other work
items in the queue. Fix this by changing wait_event to
wait_event timeout, and looping until the wait check succeeds.

Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260518012443.2629206-2-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/ib_cm.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index e50e01abb0799..d9b6c9d2f6791 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -1043,6 +1043,19 @@ int rds_ib_conn_path_connect(struct rds_conn_path *cp)
 	return ret;
 }
 
+static unsigned long rds_ib_conn_path_shutdown_check_wait(struct rds_conn_path *cp)
+{
+	struct rds_connection *conn = cp->cp_conn;
+	struct rds_ib_connection *ic = conn->c_transport_data;
+
+	return (!ic->i_cm_id ||
+		(rds_ib_ring_empty(&ic->i_recv_ring) &&
+		 (atomic_read(&ic->i_signaled_sends) == 0) &&
+		 (atomic_read(&ic->i_fastreg_inuse_count)) == 0 &&
+		 (atomic_read(&ic->i_fastreg_wrs) == RDS_IB_DEFAULT_FR_WR))) ? 0
+		: msecs_to_jiffies(1000);
+}
+
 /*
  * This is so careful about only cleaning up resources that were built up
  * so that it can be called at any point during startup.  In fact it
@@ -1083,11 +1096,13 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 		 * sends to complete we're ensured that there will be no
 		 * more tx processing.
 		 */
-		wait_event(rds_ib_ring_empty_wait,
-			   rds_ib_ring_empty(&ic->i_recv_ring) &&
-			   (atomic_read(&ic->i_signaled_sends) == 0) &&
-			   (atomic_read(&ic->i_fastreg_inuse_count) == 0) &&
-			   (atomic_read(&ic->i_fastreg_wrs) == RDS_IB_DEFAULT_FR_WR));
+		while (!wait_event_timeout(rds_ib_ring_empty_wait,
+					   rds_ib_conn_path_shutdown_check_wait(cp) == 0,
+					   msecs_to_jiffies(1000))) {
+			tasklet_schedule(&ic->i_send_tasklet);
+			tasklet_schedule(&ic->i_recv_tasklet);
+		}
+
 		tasklet_kill(&ic->i_send_tasklet);
 		tasklet_kill(&ic->i_recv_tasklet);
 
-- 
2.53.0



