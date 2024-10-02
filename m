Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F3B1D1F69;
	Wed,  2 Oct 2024 14:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878268; cv=none; b=cEritq12/sGqqTt9UUn2SjMxLWC8f1bR4TA8awmFEcwuXAkoc6FA02qSczc5+tQeER5840q+papgce7kmkB136Ja/salWBRkyWgFtuxHNJVpbhjlZfFrJRdMBLOR+CnNjXPQ/T0u5nxX56rLzN45pnxkptzHNKDxTxiwGU1A8FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878268; c=relaxed/simple;
	bh=+bUqIXn6LQascmB2Mhz94hCowrkRVT1Lvhq0xaKaJmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtp4w9uK2vPa32TMqZizJJaf1oYbDzu3rv1s9M5ItDe+ZV8DmCjE4wAOVvGIDmVYMUQArRWVcy0slUYTIHzfntYc8EvCIfylB1Tr/nn9on4WBT0Vs6HkbBqN8b+q4/E6UAFII5lsQ8YqMGyb8GoczoIQZN6P1WBSJCttLNCoU2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUeF7My6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUeF7My6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C50C4CEC2;
	Wed,  2 Oct 2024 14:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878267;
	bh=+bUqIXn6LQascmB2Mhz94hCowrkRVT1Lvhq0xaKaJmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUeF7My64hwGlxMRBVntjuvD+RCddTQqQ+JNsAeaDBoDsYV+CaYit+xsT9MZKb6F7
	 meG7s2NS1KTYRR3MfIj2qmtcoeEFAU6KlNJCRStstV/qvQt+0QLV6xyq4/Jbufehrp
	 aiWt+KtaFVku4gvYWq+YeeOzazD0JcScSqbDwDkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 355/634] RDMA/rtrs: Reset hb_missed_cnt after receiving other traffic from peer
Date: Wed,  2 Oct 2024 14:57:35 +0200
Message-ID: <20241002125825.108875668@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 3258cbbd86deaa2675e1799bc3d18bd1ef472641 ]

Reset hb_missed_cnt after receiving traffic from other peer, so
hb is more robust again high load on host or network.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Grzegorz Prajsner <grzegorz.prajsner@ionos.com>
Link: https://patch.msgid.link/20240821112217.41827-5-haris.iqbal@ionos.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 3 ++-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 88106cf5ce550..9936a3354b478 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -626,6 +626,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 		 */
 		if (WARN_ON(wc->wr_cqe->done != rtrs_clt_rdma_done))
 			return;
+		clt_path->s.hb_missed_cnt = 0;
 		rtrs_from_imm(be32_to_cpu(wc->ex.imm_data),
 			       &imm_type, &imm_payload);
 		if (imm_type == RTRS_IO_RSP_IMM ||
@@ -643,7 +644,6 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 				return  rtrs_clt_recv_done(con, wc);
 		} else if (imm_type == RTRS_HB_ACK_IMM) {
 			WARN_ON(con->c.cid);
-			clt_path->s.hb_missed_cnt = 0;
 			clt_path->s.hb_cur_latency =
 				ktime_sub(ktime_get(), clt_path->s.hb_last_sent);
 			if (clt_path->flags & RTRS_MSG_NEW_RKEY_F)
@@ -670,6 +670,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 		/*
 		 * Key invalidations from server side
 		 */
+		clt_path->s.hb_missed_cnt = 0;
 		WARN_ON(!(wc->wc_flags & IB_WC_WITH_INVALIDATE ||
 			  wc->wc_flags & IB_WC_WITH_IMM));
 		WARN_ON(wc->wr_cqe->done != rtrs_clt_rdma_done);
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 1d33efb8fb03b..94ac99a4f696e 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1229,6 +1229,7 @@ static void rtrs_srv_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 		 */
 		if (WARN_ON(wc->wr_cqe != &io_comp_cqe))
 			return;
+		srv_path->s.hb_missed_cnt = 0;
 		err = rtrs_post_recv_empty(&con->c, &io_comp_cqe);
 		if (err) {
 			rtrs_err(s, "rtrs_post_recv(), err: %d\n", err);
-- 
2.43.0



