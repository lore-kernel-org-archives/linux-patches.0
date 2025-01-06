Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC9682D98;
	Mon,  6 Jan 2025 15:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176864; cv=none; b=c/MAzt2JJ1effTpHiRsiOkB25Pg1TbFaYKJpkS9PrxjXNlJxQHawslDxvJ5SCoYMzjL8kSc7Y/yPzhkwAJQnffv1X/J2l/UbXwqbfd+6eAGgjwOFZk5VrniKXEJZGCfPB5oj32RRokitrZBuC8ojxOrMqdH4hiGx7ShWYJ4cfYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176864; c=relaxed/simple;
	bh=rKhGRD6T+8/cO0VtLwzlSsjMz9S2ve4YJRvZ9l1vPu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsE2Z6hJqelIA0OCKALYQLrcD/Oa1bMUNoyjK/DVuQ/caB1e7Z5R2N/FvL6wmo29+kutgh0Qncyj1m8QcPnWzaxINqMsP4Uo75DzQH4nVtlbiHTumkXbEAac5ZPS96zOMAsTYshG7OCqwuaWxoqfjc0Ls54YWaQ2S/vCCvPoACY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qU1XB9oN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qU1XB9oN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C741AC4CED2;
	Mon,  6 Jan 2025 15:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176864;
	bh=rKhGRD6T+8/cO0VtLwzlSsjMz9S2ve4YJRvZ9l1vPu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qU1XB9oN4UtJX/lawny9UjALj/5yO2fuPnKKu91/Ebz+s2KjUHEDwDWSfOYIfeeBC
	 CTSETXbhv3B0VhS9CoPAKcS8e4aOGAyR+btCNv44BnaufLXshAM7mfeazVAW44LmXk
	 CSEiO1RHjZSj+ZdP2vq8QkuH9Bu7JNE5JVP51oOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/81] RDMA/hns: Fix warning storm caused by invalid input in IO path
Date: Mon,  6 Jan 2025 16:15:56 +0100
Message-ID: <20250106151130.349924896@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 60628ef1c46e..23667cfbf8e7 100644
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



