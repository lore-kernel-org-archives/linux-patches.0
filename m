Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8D18634A;
	Mon,  6 Jan 2025 15:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178892; cv=none; b=DFl8G+v7dd/5Z/pu7ovu3MwwQxopqUQM9xPu5bhxCbp8+dT/YB7iYKGjIwFMBqh8WInd+iDZv4E7j8Qf7+I+bLukBQON0k/PUwLSy9yKEAT5JdB3m7obQrmyfRkdXg7+OSn9oOWbOJEW5RBV+uo8mRMc0PAmElDj3ckeGbRYpss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178892; c=relaxed/simple;
	bh=+nbsGlP9PxXbtdNtyXV03zJeted4ZU6NoeH6ZPHNcRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuHTJ44l4YUirLjLBTxSVuvb2xQUIyBBD8hfD75KwQRJWG8wFpD5O4j4qKWEN7vcoW8DLw5vIrrMSLFscbtI9Y3DBudaXr6FL6BPlqr13YjIbFg+ed5VJQcspPrqclJQNW8yRT3g1P0tndTqQjX/ZKfGBrvVdhozyFjZ8iitdTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXnkKusS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXnkKusS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5331C4CED2;
	Mon,  6 Jan 2025 15:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178892;
	bh=+nbsGlP9PxXbtdNtyXV03zJeted4ZU6NoeH6ZPHNcRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXnkKusSNxrR8iAT5GWHr4ofzrhgF1eeriise8ytDiDqOLjx8sxRR+MXrRKviV7YH
	 jnOd/YQ+0gplxuJoHLEZsZajcysMB3NWS04ge7roE1zxusk4+I9T2lfcoUqh08SmZY
	 V4C2Vz1FrW+6jc+TM6h4AkViNm0keDlIIk3r9Xqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/168] RDMA/hns: Fix missing flush CQE for DWQE
Date: Mon,  6 Jan 2025 16:17:15 +0100
Message-ID: <20250106151143.240305167@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit e3debdd48423d3d75b9d366399228d7225d902cd ]

Flush CQE handler has not been called if QP state gets into errored
mode in DWQE path. So, the new added outstanding WQEs will never be
flushed.

It leads to a hung task timeout when using NFS over RDMA:
    __switch_to+0x7c/0xd0
    __schedule+0x350/0x750
    schedule+0x50/0xf0
    schedule_timeout+0x2c8/0x340
    wait_for_common+0xf4/0x2b0
    wait_for_completion+0x20/0x40
    __ib_drain_sq+0x140/0x1d0 [ib_core]
    ib_drain_sq+0x98/0xb0 [ib_core]
    rpcrdma_xprt_disconnect+0x68/0x270 [rpcrdma]
    xprt_rdma_close+0x20/0x60 [rpcrdma]
    xprt_autoclose+0x64/0x1cc [sunrpc]
    process_one_work+0x1d8/0x4e0
    worker_thread+0x154/0x420
    kthread+0x108/0x150
    ret_from_fork+0x10/0x18

Fixes: 01584a5edcc4 ("RDMA/hns: Add support of direct wqe")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20241220055249.146943-5-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index aa0e5076f02a..4f2e8f9d228b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -656,6 +656,10 @@ static void write_dwqe(struct hns_roce_dev *hr_dev, struct hns_roce_qp *qp,
 #define HNS_ROCE_SL_SHIFT 2
 	struct hns_roce_v2_rc_send_wqe *rc_sq_wqe = wqe;
 
+	if (unlikely(qp->state == IB_QPS_ERR)) {
+		flush_cqe(hr_dev, qp);
+		return;
+	}
 	/* All kinds of DirectWQE have the same header field layout */
 	hr_reg_enable(rc_sq_wqe, RC_SEND_WQE_FLAG);
 	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_DB_SL_L, qp->sl);
-- 
2.39.5



