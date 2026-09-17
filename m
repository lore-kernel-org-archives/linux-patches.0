Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436263B27DF;
	Thu, 17 Sep 2026 16:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663890; cv=none; b=Kna9eWkblI+saeGg9mHSWs09TUmJcil88L5mLWgp0vznnkoD5pQaPM2/HxS+CwdhkTNpAHhpuDfmP8ySZbXy2xFZZ9YLVs3+GRrd5RkAGpY/PvK9h2bokI8M712rP4P9WvYHqDYItQwAjwhT3zH5Bt5H80gqlu+qoarW8W6YAls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663890; c=relaxed/simple;
	bh=3jWkmU4Phd6/5A/nzqVsgz6dlH7NPRy0tTCy+9pQa9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFIdxj3SWhKyEUFf7pgaDStIFpLduRUf2cw5MpY3JbcEPyk1MI7wIgQT4oPAp27jH4NEexcRLM17aR4Bh28/TUZzYQeZd9PvP/XfuqTeXVf423hhEpHwv/+hHRrfqxgwYL21FOQz5Xad3I7M74Ffi4vbNCEUlNS5/qzVp3CnjIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXK+37WC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXK+37WC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641411F000FF;
	Thu, 17 Sep 2026 16:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663888;
	bh=3eehNoyaNR9TYO+c6urY9nJuzqA4eE45YkcnA0RLup8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nXK+37WCnqXWoz2X3gclZ02IinAU7UnM9J64IgtxSQcAgJla501WgHSyqDtHvolVC
	 whC+703tpwJrr2Z4Y8EgKcKHGJC6TpkGm5sli6V7lhGBf12yVrvIFxquyjghg1aWxA
	 gXTGDbiEDwZQBXQprYpCuzsUv8aCswQuZFXEL0rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0171/1250] net/rds: Dont sleep inside rds_ib_conn_path_shutdown
Date: Thu, 17 Sep 2026 15:59:26 +0100
Message-ID: <20260917151556.730257769@linuxfoundation.org>
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



