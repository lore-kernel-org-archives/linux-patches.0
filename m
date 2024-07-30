Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E2018C915;
	Tue, 30 Jul 2024 17:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359274; cv=none; b=WlwaTHAhlLx9WgU6PkkRSZsfR+ZiZ5FGSjNbafXrXvUdYxSaFkPBrOIjm6n3CLYTPVo/lzH8V81Xs8rCHLVrZYn6Q+d9kkE0n8AVo2mrBf2Eb45tlxkszJli++KR+ce3DCnrH7ctiL26ERQAft0DrLuC0t5hFCC7/9nyPMYX+8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359274; c=relaxed/simple;
	bh=mX1DGJyqyNxB+1yQ5qvyBqlPs+5OczgPIQJP9v4RFqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ey9ILJKzkmDOp5D2TvCVa7Ou401Utx+PljaETNhVRSyhxyaY5xQOP/PjF3mrNMB7jW6CdB0r0ygcf+xLfLzBWc+XewSX01IdnaBm4LGz153VdLh+PZbtW58lq3EhHB4Y8EBLqEdiDtn2ZE4oQVWp8oXNVLJyBzXg4hQ0cVQwqpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9KyIHzg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9KyIHzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24314C32782;
	Tue, 30 Jul 2024 17:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359274;
	bh=mX1DGJyqyNxB+1yQ5qvyBqlPs+5OczgPIQJP9v4RFqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9KyIHzgpoxdtzHkBosPym4s+GMgo63o+3pz4WiR21zOpHY1A7CRQgbVoR2kx8LNH
	 /wQ8wA8jR5SQj95TwFnpF6Zs2eI9fqIGhL/XG6jOxZ+rvbUGt4Un/mWFcNVHWHi1zW
	 Raz/uFfLcLnFGO/pS8wDdP8kn99urvANOzCz3vAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 460/809] RDMA/hns: Check atomic wr length
Date: Tue, 30 Jul 2024 17:45:36 +0200
Message-ID: <20240730151742.895393425@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 6afa2c0bfb8ef69f65715ae059e5bd5f9bbaf03b ]

8 bytes is the only supported length of atomic. Add this check in
set_rc_wqe(). Besides, stop processing WQEs and return from
set_rc_wqe() if there is any error.

Fixes: 384f88185112 ("RDMA/hns: Add atomic support")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240710133705.896445-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 2 ++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 9 +++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index ff0b3f68ee3a4..05005079258cf 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -91,6 +91,8 @@
 /* Configure to HW for PAGE_SIZE larger than 4KB */
 #define PG_SHIFT_OFFSET				(PAGE_SHIFT - 12)
 
+#define ATOMIC_WR_LEN				8
+
 #define HNS_ROCE_IDX_QUE_ENTRY_SZ		4
 #define SRQ_DB_REG				0x230
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 4287818a737f9..eb6052ee89383 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -591,11 +591,16 @@ static inline int set_rc_wqe(struct hns_roce_qp *qp,
 		     (wr->send_flags & IB_SEND_SIGNALED) ? 1 : 0);
 
 	if (wr->opcode == IB_WR_ATOMIC_CMP_AND_SWP ||
-	    wr->opcode == IB_WR_ATOMIC_FETCH_AND_ADD)
+	    wr->opcode == IB_WR_ATOMIC_FETCH_AND_ADD) {
+		if (msg_len != ATOMIC_WR_LEN)
+			return -EINVAL;
 		set_atomic_seg(wr, rc_sq_wqe, valid_num_sge);
-	else if (wr->opcode != IB_WR_REG_MR)
+	} else if (wr->opcode != IB_WR_REG_MR) {
 		ret = set_rwqe_data_seg(&qp->ibqp, wr, rc_sq_wqe,
 					&curr_idx, valid_num_sge);
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * The pipeline can sequentially post all valid WQEs into WQ buffer,
-- 
2.43.0



