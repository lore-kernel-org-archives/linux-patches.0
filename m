Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714145102A;
	Mon, 11 Dec 2023 18:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPVXaHtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8D7C433C7;
	Mon, 11 Dec 2023 18:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320468;
	bh=MqMnIWL3lmg5YDKzr/7izU68XQQ39xFWqVkWOzEJ7OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hPVXaHtS+klt3XP1SexI5dRLSK7E8QBFhHVuFAKU//FQMc9vePT+ZaLLGCFRzuFcb
	 Aic4ED6vjOIpy9lZgOiIgGG72017iTDPqyaikjorlUqWwUvCk4lVgPj7XB6sklg0DA
	 TBLzVZ93qshbN+xkbIcRTFPxKKLuHjCDozVMG1RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/194] RDMA/rtrs-srv: Check return values while processing info request
Date: Mon, 11 Dec 2023 19:21:02 +0100
Message-ID: <20231211182039.711988785@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Md Haris Iqbal <haris.iqbal@ionos.com>

[ Upstream commit ed1e52aefa16f15dc2f04054a3baf11726a7460e ]

While processing info request, it could so happen that the srv_path goes
to CLOSING state, cause of any of the error events from RDMA. That state
change should be picked up while trying to change the state in
process_info_req, by checking the return value. In case the state change
call in process_info_req fails, we fail the processing.

We should also check the return value for rtrs_srv_path_up, since it
sends a link event to the client above, and the client can fail for any
reason.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>
Link: https://lore.kernel.org/r/20231120154146.920486-4-haris.iqbal@ionos.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index e26488ee36eac..6710887b1a13f 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -715,20 +715,23 @@ static void rtrs_srv_info_rsp_done(struct ib_cq *cq, struct ib_wc *wc)
 	WARN_ON(wc->opcode != IB_WC_SEND);
 }
 
-static void rtrs_srv_path_up(struct rtrs_srv_path *srv_path)
+static int rtrs_srv_path_up(struct rtrs_srv_path *srv_path)
 {
 	struct rtrs_srv_sess *srv = srv_path->srv;
 	struct rtrs_srv_ctx *ctx = srv->ctx;
-	int up;
+	int up, ret = 0;
 
 	mutex_lock(&srv->paths_ev_mutex);
 	up = ++srv->paths_up;
 	if (up == 1)
-		ctx->ops.link_ev(srv, RTRS_SRV_LINK_EV_CONNECTED, NULL);
+		ret = ctx->ops.link_ev(srv, RTRS_SRV_LINK_EV_CONNECTED, NULL);
 	mutex_unlock(&srv->paths_ev_mutex);
 
 	/* Mark session as established */
-	srv_path->established = true;
+	if (!ret)
+		srv_path->established = true;
+
+	return ret;
 }
 
 static void rtrs_srv_path_down(struct rtrs_srv_path *srv_path)
@@ -857,7 +860,12 @@ static int process_info_req(struct rtrs_srv_con *con,
 		goto iu_free;
 	kobject_get(&srv_path->kobj);
 	get_device(&srv_path->srv->dev);
-	rtrs_srv_change_state(srv_path, RTRS_SRV_CONNECTED);
+	err = rtrs_srv_change_state(srv_path, RTRS_SRV_CONNECTED);
+	if (!err) {
+		rtrs_err(s, "rtrs_srv_change_state(), err: %d\n", err);
+		goto iu_free;
+	}
+
 	rtrs_srv_start_hb(srv_path);
 
 	/*
@@ -866,7 +874,11 @@ static int process_info_req(struct rtrs_srv_con *con,
 	 * all connections are successfully established.  Thus, simply notify
 	 * listener with a proper event if we are the first path.
 	 */
-	rtrs_srv_path_up(srv_path);
+	err = rtrs_srv_path_up(srv_path);
+	if (err) {
+		rtrs_err(s, "rtrs_srv_path_up(), err: %d\n", err);
+		goto iu_free;
+	}
 
 	ib_dma_sync_single_for_device(srv_path->s.dev->ib_dev,
 				      tx_iu->dma_addr,
-- 
2.42.0



