Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABA653A7;
	Fri,  6 Dec 2024 15:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497541; cv=none; b=dTv6D/50i+0ryqIiQ/HrMCIjp5bcpmcrclSCOqYmVU9vAKn1/wvIzcMGAeVGgQQ8BqYWMxs6ww2A4cgZnpnT6+phhPDVWhiy4tMV6xlbuAhn3t0tS6zbW3RKwpkgTw9JHn3D8e/ULUo3Mh0knw2Vi4NbOhbcTlJjjrl2QVMBmV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497541; c=relaxed/simple;
	bh=B177AZb1tq7UPsQlvUxDZ/hZJSjf/jwKE9oid/m/FuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+zej8otd3hcVL1/gAv6pvlYv045QB968ohBQvZEjwFhT+TUV6oXeeLRinnEymDVzrWQs+W6C6Rh4KgXry1azYKezPiYPZzi8aP3z95VAPNfNRoJSKvjlmopHfPcK/sgvHZe2W4kKxY73rWmUYz6KPAioB2aV5D5tLl6IOWasNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V/rCUWn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V/rCUWn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3136FC4CED1;
	Fri,  6 Dec 2024 15:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497540;
	bh=B177AZb1tq7UPsQlvUxDZ/hZJSjf/jwKE9oid/m/FuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V/rCUWn7ZGaFlFEe7Jd3KlFLyMOAfTfbh1HItSvNjeYtQdhMbYr5J9oBJNzPDzGrj
	 jSEFrNqbshIAddbiUr+mKUxzdPH0uVARekFN7TuX4ndYI8WKlyKFHHz/XapJmLk+Sj
	 lIEWhmWioWA3INuQZyMsM91gfugnWjMq0LIRibqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 313/676] RDMA/hns: Fix out-of-order issue of requester when setting FENCE
Date: Fri,  6 Dec 2024 15:32:12 +0100
Message-ID: <20241206143705.564320790@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 5dbcb1c1900f45182b5651c89257c272f1f3ead7 ]

The FENCE indicator in hns WQE doesn't ensure that response data from
a previous Read/Atomic operation has been written to the requester's
memory before the subsequent Send/Write operation is processed. This
may result in the subsequent Send/Write operation accessing the original
data in memory instead of the expected response data.

Unlike FENCE, the SO (Strong Order) indicator blocks the subsequent
operation until the previous response data is written to memory and a
bresp is returned. Set the SO indicator instead of FENCE to maintain
strict order.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20241108075743.2652258-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index b29c12e4e45c4..2824d390ec316 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -578,7 +578,7 @@ static inline int set_rc_wqe(struct hns_roce_qp *qp,
 	if (WARN_ON(ret))
 		return ret;
 
-	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_FENCE,
+	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_SO,
 		     (wr->send_flags & IB_SEND_FENCE) ? 1 : 0);
 
 	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_SE,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index a401b607592b9..b8e17721f6fde 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -899,6 +899,7 @@ struct hns_roce_v2_rc_send_wqe {
 #define RC_SEND_WQE_OWNER RC_SEND_WQE_FIELD_LOC(7, 7)
 #define RC_SEND_WQE_CQE RC_SEND_WQE_FIELD_LOC(8, 8)
 #define RC_SEND_WQE_FENCE RC_SEND_WQE_FIELD_LOC(9, 9)
+#define RC_SEND_WQE_SO RC_SEND_WQE_FIELD_LOC(10, 10)
 #define RC_SEND_WQE_SE RC_SEND_WQE_FIELD_LOC(11, 11)
 #define RC_SEND_WQE_INLINE RC_SEND_WQE_FIELD_LOC(12, 12)
 #define RC_SEND_WQE_WQE_INDEX RC_SEND_WQE_FIELD_LOC(30, 15)
-- 
2.43.0



