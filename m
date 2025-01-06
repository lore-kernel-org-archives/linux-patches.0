Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430A9136E09;
	Mon,  6 Jan 2025 15:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177391; cv=none; b=gESXO+cXysk8YRlN+KWIGLIge1RTW+eDgTP+oILPnfvw3hzTcT4bkui45x71QOHCAGxAsLCdWO9wN02/4qsFUxStMIRnm8GacStTgQe2+BdJisJIMuPxvRt2O5eNakzapX5TI1n4PNtPuDyZ4t2+3wCCIDcinCxWQ0zXgyWfq+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177391; c=relaxed/simple;
	bh=U9lIpYmxppOnB499+gb+NXRqrPZY/XcR5oDiwuZw6e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e40WtnHdJwJd+IaQP4sr4dT83BZDDhJx3zZWzcHMrm0Ax5O2wPheEkz39LfGx1u9I5k0rBY9qHHKZO+iYBXLYRTogSGauhR/0pW3d+efauUrdGPdrOT++PHIh01IcdTERdQWjq6PIYbMKr0IvKC8BzP5X5PN3ffStwoBnoydijA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTmjkYOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTmjkYOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0944C4CED2;
	Mon,  6 Jan 2025 15:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177391;
	bh=U9lIpYmxppOnB499+gb+NXRqrPZY/XcR5oDiwuZw6e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTmjkYOY5eD+UxMda0zfTVORJVWV09vgYjPvYbdnl+1VcXj10ubBpOTAIvhZzToS2
	 hA9zk475wOb8wM84QZ85Paq0woYdWeHkq0TOpbcjpNPb4FUED86Tk+lL7I+JTQx7ON
	 MTwsdZYMXQksxcUP2DRlArZ0NSTdXWG6mY9Ze0Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/222] RDMA/hns: Fix warning storm caused by invalid input in IO path
Date: Mon,  6 Jan 2025 16:15:52 +0100
Message-ID: <20250106151156.368175796@linuxfoundation.org>
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

[ Upstream commit fa5c4ba8cdbfd2c2d6422e001311c8213283ebbf ]

WARN_ON() is called in the IO path. And it could lead to a warning
storm. Use WARN_ON_ONCE() instead of WARN_ON().

Fixes: 12542f1de179 ("RDMA/hns: Refactor process about opcode in post_send()")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20241220055249.146943-4-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index aed9c403f3be..c9c9be122471 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -471,7 +471,7 @@ static inline int set_ud_wqe(struct hns_roce_qp *qp,
 	valid_num_sge = calc_wr_sge_num(wr, &msg_len);
 
 	ret = set_ud_opcode(ud_sq_wqe, wr);
-	if (WARN_ON(ret))
+	if (WARN_ON_ONCE(ret))
 		return ret;
 
 	ud_sq_wqe->msg_len = cpu_to_le32(msg_len);
@@ -575,7 +575,7 @@ static inline int set_rc_wqe(struct hns_roce_qp *qp,
 	rc_sq_wqe->msg_len = cpu_to_le32(msg_len);
 
 	ret = set_rc_opcode(hr_dev, rc_sq_wqe, wr);
-	if (WARN_ON(ret))
+	if (WARN_ON_ONCE(ret))
 		return ret;
 
 	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_SO,
-- 
2.39.5



