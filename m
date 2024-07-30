Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E3D1A6160;
	Tue, 30 Jul 2024 16:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356709; cv=none; b=pM6M7C6bgq0mRHweKAL6RGjdAjG7AYJjszmTcx47P0IzveCog2gxAsxv1/kZDrIlBH3upWRcEfWIOjuo3CWnt+OB5GWsRelu1CXVuApCaPGr6BG37ObDJ/9IuxfYGM4CgA68Rrkw3qsz3MN2c3xJ7HnloMhGSYLq/U+fFPOhC6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356709; c=relaxed/simple;
	bh=cLCb3FfBzrNFU6aAUsC+wLNjf2A0pf4l0yRuz1tpWo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4+Fa9f8Hy+Ci0DJHVsAvzVUWyowJG+TU/9mt0IOvOOkxSVIN1llK/g6l3ulwmA4CYIA9p69VnyfRm2XwYKmOm45z1aOUkS7hFXLpyzXU67ZWEmacUVf5iNgkWfLZsgpnNLh4gfKyPD56dcTZrhUjiwtIRH0nlUCgBWeda7ZuOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubw8IUg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubw8IUg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D3FC32782;
	Tue, 30 Jul 2024 16:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356708;
	bh=cLCb3FfBzrNFU6aAUsC+wLNjf2A0pf4l0yRuz1tpWo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubw8IUg1061AwItPAK8qiNfuSlfUm5qOqPpzvm60ys4zvgKBUPSrdvFzORo/WlzuL
	 gtYA3xAGL8lm8cQQbB0UROeJ7PyoRx7kiOQeOZwT7YDCByYQOCpMS22QbNzqlOcKiz
	 8xSaVZtxjhGnw/tKhERSthyY6LL6OycttplfhYPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 221/440] RDMA/hns: Check atomic wr length
Date: Tue, 30 Jul 2024 17:47:34 +0200
Message-ID: <20240730151624.492574117@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 8748b65c87ea7..0a4c046cdfac4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -90,6 +90,8 @@
 /* Configure to HW for PAGE_SIZE larger than 4KB */
 #define PG_SHIFT_OFFSET				(PAGE_SHIFT - 12)
 
+#define ATOMIC_WR_LEN				8
+
 #define HNS_ROCE_IDX_QUE_ENTRY_SZ		4
 #define SRQ_DB_REG				0x230
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index c931cce50d50d..176d75f2514eb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -602,11 +602,16 @@ static inline int set_rc_wqe(struct hns_roce_qp *qp,
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



