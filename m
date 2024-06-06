Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307471B1519;
	Thu,  6 Jun 2024 14:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683400; cv=none; b=XXr9gFoSFKN69bF59oy0J2iw/w2/c6gXVSkNbCs/DbGbEKrRbxcKiwWUtD/ZgGiD0b/CjfKUe5VRnrJgkp8J2Yrgmg05DxBPsAOj/EmfIN/OJAdPsPdOfQujhqNCsZ4UThy6ja25jFsKfUMM3Q0Ad3KOfSr8TK8vzhKnqZgZ4rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683400; c=relaxed/simple;
	bh=VwZVw69QCD2Yg1v2B9z+Lz+eu2vJYWtoksY5ag4LzWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBO8tf21bTDvgqZMw5005uF9P4Gapgv4raf+rFKCsZwK+InxM5ngXgmaOmUpsNwkCBMK7fKbZqT9CZ1ShdM9zBX5iv471LfVgcRBgqSfSjybJshg3wKDO4uhlBhlGfa2asXGcdrbeTTDJrLgNqyTeHI+oDBqP3+rE851QpfyWSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EN9rUWhx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EN9rUWhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BADC2BD10;
	Thu,  6 Jun 2024 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683400;
	bh=VwZVw69QCD2Yg1v2B9z+Lz+eu2vJYWtoksY5ag4LzWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EN9rUWhxJOn5W7VgfinUdV0MOKs69NgIJjGqrCIkNnYRexmXLrhqzcFzUdga1tlqv
	 vcq5Hu+oOyid/jrFX9GvQkTurGO97NqKnaLC4K62eOY+wN8yLmpP2nF6SX0E/WjLUW
	 /BtReK/Z6qT+vYaVt/MJoHF/Dl/zBeO+TCvG7o5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 344/744] RDMA/hns: Modify the print level of CQE error
Date: Thu,  6 Jun 2024 16:00:16 +0200
Message-ID: <20240606131743.509556850@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 349e859952285ab9689779fb46de163f13f18f43 ]

Too much print may lead to a panic in kernel. Change ibdev_err() to
ibdev_err_ratelimited(), and change the printing level of cqe dump
to debug level.

Fixes: 7c044adca272 ("RDMA/hns: Simplify the cqe code of poll cq")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240412091616.370789-11-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 2f88e7853abff..32fb2c00a8f26 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3698,8 +3698,9 @@ static void get_cqe_status(struct hns_roce_dev *hr_dev, struct hns_roce_qp *qp,
 		   wc->status == IB_WC_WR_FLUSH_ERR))
 		return;
 
-	ibdev_err(&hr_dev->ib_dev, "error cqe status 0x%x:\n", cqe_status);
-	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_NONE, 16, 4, cqe,
+	ibdev_err_ratelimited(&hr_dev->ib_dev, "error cqe status 0x%x:\n",
+			      cqe_status);
+	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_NONE, 16, 4, cqe,
 		       cq->cqe_size, false);
 	wc->vendor_err = hr_reg_read(cqe, CQE_SUB_STATUS);
 
-- 
2.43.0



