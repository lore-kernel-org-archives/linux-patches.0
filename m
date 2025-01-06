Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399B714884C;
	Mon,  6 Jan 2025 15:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177394; cv=none; b=SSYSHRaiBVBrv4my7YqdrINjjGCT6UaTaMnEgg+aNSynDkPvfJZizVdE7NeWppX9DPmc0gg5fpd+er3OhzXu8073PH24Dpp/KGEUAw+xO3bnBB7j+Hgx44yJ+OwCnlYJUWqWAoazNCxPNKSWYUlvL40EJXMCihc7mpkbSTYITQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177394; c=relaxed/simple;
	bh=1vFW0mltXMfEtscWt+orFz2ObB0rfQ8csNJBETHarc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axHjOv4rd7nJm16fHZOV5Mf4jNZ7r7KMhUVrLNN6+lMrn/uYvm/81epc4OvdIvyZlhUxJsh34gCMU3Q1JHt8dne9HPbrETGE5+PxnM/t6FSpeaGThPOuEdDEUiH96/+rybOrdkLBjbbtVmqsbqg1fsaGmYCICmv2sFasuNx2yhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0ep6epp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0ep6epp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6061C4CED2;
	Mon,  6 Jan 2025 15:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177394;
	bh=1vFW0mltXMfEtscWt+orFz2ObB0rfQ8csNJBETHarc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0ep6eppSg2TScHgu1necJdWSPF7aYBu8j70Jz0DpHtORiXJZqaJVAqkO1HYFRaBv
	 9sS+Nk3DH38Xk5QzcvaD+kfvjGTDV8IH4hxZQe0Bn1zZcmTNONYfOl3V1lcZijs6ba
	 cniSl6B4qP9uz/CUSVCoZ6XXL9McbOsw6gGqi7tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/222] RDMA/hns: Fix missing flush CQE for DWQE
Date: Mon,  6 Jan 2025 16:15:53 +0100
Message-ID: <20250106151156.405662780@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c9c9be122471..aded0a7f4283 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -673,6 +673,10 @@ static void write_dwqe(struct hns_roce_dev *hr_dev, struct hns_roce_qp *qp,
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



