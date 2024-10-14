Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC4D1AB6E2;
	Mon, 14 Oct 2024 15:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918053; cv=none; b=q7w/Nu+QSTFSm1lWjDI1getlzj1RYq13a2iN45M9X7ozgRijejptfowfxuISRSFxxzL9HpVufDyhl7fWB2QZq4pTRlsBSvSrRXLzYPa2KcO6Bwm0aSHIh7FYxhA7E3OSsiI8HPBxk5gF8CtzTOQWN62A5z0Bz55bqAUSMNfPnyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918053; c=relaxed/simple;
	bh=d/p/HvxJrISm3CSxf1fAbQVLjU3ziFba/hYSHR8fOXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fd5zCf215udIqEQeCBH5wFJOn0CZi7GWwl3KbZ+34qIiHpfdW+BeY8aChPA/kT9lPtVEME0HjRV+7NdxXeDXSiY41QdlYaT2rGaix8+Ulx7/uJ71xZmpdECG1WR4ZBjVNCQ+jTAi86YODFYG5ILCD1jIhUCTJcRPvhbdC6qzFAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgeQsu8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgeQsu8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A759C4CEC3;
	Mon, 14 Oct 2024 15:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918053;
	bh=d/p/HvxJrISm3CSxf1fAbQVLjU3ziFba/hYSHR8fOXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgeQsu8a7HU74emgjopCM8MalngdZEhwuPCain3C9k1If0Sscwb7SvPhqvxl/GKNF
	 VCtr2THqruz9d0FDt8XT60JvzaiRmcPuIsif02L0TXv7BKDoCb30VNSTX9x2HKZE25
	 abI/dctCyxWLEr5GuwNDAcPpPgK0C+/BaE3PC03s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 208/798] RDMA/rtrs: Reset hb_missed_cnt after receiving other traffic from peer
Date: Mon, 14 Oct 2024 16:12:42 +0200
Message-ID: <20241014141226.103765350@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index cc07c91f9c549..9beae1e50d115 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -624,6 +624,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 		 */
 		if (WARN_ON(wc->wr_cqe->done != rtrs_clt_rdma_done))
 			return;
+		clt_path->s.hb_missed_cnt = 0;
 		rtrs_from_imm(be32_to_cpu(wc->ex.imm_data),
 			       &imm_type, &imm_payload);
 		if (imm_type == RTRS_IO_RSP_IMM ||
@@ -641,7 +642,6 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 				return  rtrs_clt_recv_done(con, wc);
 		} else if (imm_type == RTRS_HB_ACK_IMM) {
 			WARN_ON(con->c.cid);
-			clt_path->s.hb_missed_cnt = 0;
 			clt_path->s.hb_cur_latency =
 				ktime_sub(ktime_get(), clt_path->s.hb_last_sent);
 			if (clt_path->flags & RTRS_MSG_NEW_RKEY_F)
@@ -668,6 +668,7 @@ static void rtrs_clt_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 		/*
 		 * Key invalidations from server side
 		 */
+		clt_path->s.hb_missed_cnt = 0;
 		WARN_ON(!(wc->wc_flags & IB_WC_WITH_INVALIDATE ||
 			  wc->wc_flags & IB_WC_WITH_IMM));
 		WARN_ON(wc->wr_cqe->done != rtrs_clt_rdma_done);
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index e978ee4bb73ae..726b690ebe652 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1234,6 +1234,7 @@ static void rtrs_srv_rdma_done(struct ib_cq *cq, struct ib_wc *wc)
 		 */
 		if (WARN_ON(wc->wr_cqe != &io_comp_cqe))
 			return;
+		srv_path->s.hb_missed_cnt = 0;
 		err = rtrs_post_recv_empty(&con->c, &io_comp_cqe);
 		if (err) {
 			rtrs_err(s, "rtrs_post_recv(), err: %d\n", err);
-- 
2.43.0



