Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177DF1D0F4F;
	Wed,  2 Oct 2024 13:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876375; cv=none; b=mL6R2vRD7jRfYh0HebAEoCWo+biacIhCVA9MKOPXddxwozxHHeCBvp/VFYOWW7tUnk1mYRVu+JhgQpBEozshw1Y93aExFsQ+qruoZZZGJpydnWZPTIVRWMQ/eHKkKRjV1xjcuyv5GulWH64oqCyeKDd3g85JprOfjlFI33jvTKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876375; c=relaxed/simple;
	bh=1YAYCSVcR4sdxXsem9bMgze5lUF6T6AEvNNHAsMfbwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poYm49Q7tt5/RWndKu07z0F3FFgpgl+S55lrszRvYXI1vxsOgvcG6jEvlCrsuOSvRFtCuAvjxaEq/mdE3FXq6v3GexfLw32K/YtzaOzQP14j22Vlz1bNuqH/T6YVlO8KaMEzL46xX7g567VykJYDvdRKOvpGSgPNOq4P0cWvHQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AB0dx5rj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AB0dx5rj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A73EC4CECD;
	Wed,  2 Oct 2024 13:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876374;
	bh=1YAYCSVcR4sdxXsem9bMgze5lUF6T6AEvNNHAsMfbwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AB0dx5rjJkZjG0MJ5AWMTSMOR6UuP0aR44q9gI3aveBeZ+8+mzFTvCT9OL4yOH3PR
	 X13uSUA0gsrOIfgFL5In+kxr8z/1t5ADtUVbm3JrTdj5BRF6/NFBBpgG3p2qPtQwZD
	 qTO4vByxyK4W3djfuBtZI9dJvvDr1Tsshs2TN7Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>,
	Grzegorz Prajsner <grzegorz.prajsner@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 391/695] RDMA/rtrs: Reset hb_missed_cnt after receiving other traffic from peer
Date: Wed,  2 Oct 2024 14:56:29 +0200
Message-ID: <20241002125838.061635980@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



