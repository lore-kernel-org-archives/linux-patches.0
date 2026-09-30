Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6BD51813C;
	Wed, 30 Sep 2026 17:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790711; cv=none; b=hFygBoF0aL1TsFXXcY6Bzvlj7NWQyV2NgR13JIx8meKtfXoHPJ03wIMAJ+95QqhZIzeTfwF2pVE4kNLctkDUZWbvcX8V5Sshq8vBe+16RajKGlOWuuS5bpJl9+XvZTZLWbhnIp6saMoumRhsjUlpRhDvD9outco2wwvPPzYmwtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790711; c=relaxed/simple;
	bh=lVI8TOWM22pcYfNOdRmRnKD0M/wAg+A0A9o/dmvcymw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/N8yRz/OtsR85kJupye0XoNy4ad/KRlfzmctiOsslDGiQEv5stJa8UJUw0qvG323n7GwjKtQkccyUXixf2qjPjcgzFobkHg/ZLGjKl12IsbEyMsyNjhZddT+RXKOmGl3HbaandQzOwUK/P3s5vSC1SkPD+Gsff28xS84Dq9QRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsSlkW5V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsSlkW5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7E31F000FF;
	Wed, 30 Sep 2026 17:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790710;
	bh=5XuOh2xe1FBIiOLO5orJX9AJyzL/8nzJ6Q86h5umB68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AsSlkW5VMlu49HXp0h7PBWaipYZXZYck1HfSqig/Js4Pwek0mBe5Fc4CIF4SaduCe
	 z6GFkoc6BFn8vEdtCd/jz5tRSRWzeA++VipsDfPirmsWYA6ChV+5Wz1t6Allo+Z5wG
	 Kne30HTT5izqDM9PhiV0m6v23fm6iWVjjSCSyuEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/752] net/rds: Dont sleep inside rds_ib_conn_path_shutdown
Date: Wed, 30 Sep 2026 17:18:37 +0200
Message-ID: <20260930152359.171760639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



