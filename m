Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E60503BF6;
	Wed, 30 Sep 2026 15:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782432; cv=none; b=YZ1o+wlSEZ9kaItJzbiLebXCHEkbHgbsgAbiquq2QIzENvXdYuEXeTh4LOzt6uxe3KAcPTjxmF+7oZ1KDKc8He4IG+EsNdGgcccN7Pgf+XW73OdIzG0TOvzIkr7FC/huweeLzpcsX2n0c0sQ0KvCe6Y4NngpzjleHZd5rrCQyYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782432; c=relaxed/simple;
	bh=/FV6+nhxjoqmpmu6jF5HZqCX93wWU8oGowkekLlPUCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sa5e/ArnpvAt7e/+t7myOd+FLlNdta0Ohn8zSwxVOjvFPk367caXz4NFL3kgxlnBhff8erIkK1wi/7bNfdLTpYX8f44KsJRSHYhzOxLot7zXnerLHWIpm9ri/iAecUfgxanliNLFufKQPXcP3H9/lS85SISfnpa7sx7GSoFA9oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g55xyYyU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g55xyYyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481C81F00899;
	Wed, 30 Sep 2026 15:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782419;
	bh=h4vsAGB8VC3PqDnU3dpsbaHHFUO+zsnK3235OfaPXOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g55xyYyUHCR0uKroKS2sIcLUkOwiR8zeQo1SNkvXQ5P+bUA/eMzhHpWW5GViaflPX
	 nDajQHoLsjh29VOBfiCWjdhXA62Ke7+NRHEkO4C8XM18yRSuTLPPOoJc1jR+lIMeHH
	 obASBq8OrVwKL0aVVDGH0bNVVmu6lohWzJg1n51k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/595] net/rds: Dont sleep inside rds_ib_conn_path_shutdown
Date: Wed, 30 Sep 2026 17:18:53 +0200
Message-ID: <20260930152348.591347013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f23233e0a53c7..7c615fcc7b212 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -1076,6 +1076,19 @@ int rds_ib_conn_path_connect(struct rds_conn_path *cp)
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
@@ -1116,11 +1129,13 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
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



