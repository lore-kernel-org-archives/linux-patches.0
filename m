Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F7F6775D;
	Tue, 23 Jan 2024 02:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975301; cv=none; b=kt8SNrW8cPdQQqMj6luPDrc+r91ytiqyBnwjM4ifI+vqn+aN0Tkwb44w6IKyQEx5xDEqFonSU1/8UweIJ7U8nW3+bRqix/gRqcPowTPaLr8NPj9C8tFBj82hTggQZ9kDWLRk7gBeVPicwT2w3LGIH6LfwiQ4u55MWaQjBTz0trs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975301; c=relaxed/simple;
	bh=VTkywE93UERfk17CmE+ihLfexeVOcqIgWtgrBq3YSC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUK+C9JuqKqYcCglLbSexxpdZ8tMQA74eTUHJTZWgdVJz/6fybM9d2UYWFTZE5G69/Wwg9llaAFeE6u6qUNQCrluqBzzLxmbGYk/L68vc505ib4qfdL1qmDUfWFXIPxhzhY1pvwO+FeWuDeJ8LY9aFsGgjagGrrN11PGayNY/5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7EYq6gt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7EYq6gt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AA4C433B1;
	Tue, 23 Jan 2024 02:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975301;
	bh=VTkywE93UERfk17CmE+ihLfexeVOcqIgWtgrBq3YSC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7EYq6gtCEZqEe+EtzEvzGVITPNCxpHnAxOXEVF+O/Pz2rxzhm7X4g8uU98kiWhkF
	 0fx8sh3s8uXOuQ5JzYsJ+FCXO5gZWkUfyMCHg/M6hIcziBmMyKP6h9vvYwrrja1VgJ
	 pSn7ytUEY3OXLgVsGRO8Mmmmzijo95YgijT/QufY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 266/583] RDMA/hns: Fix memory leak in free_mr_init()
Date: Mon, 22 Jan 2024 15:55:17 -0800
Message-ID: <20240122235820.144952754@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

[ Upstream commit 288f535951aa81ed674f5e5477ab11b9d9351b8c ]

When a reserved QP fails to be created, the memory of the remaining
created reserved QPs is leaked.

Fixes: 70f92521584f ("RDMA/hns: Use the reserved loopback QPs to free MR before destroying MPT")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20231207114231.2872104-6-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 84c18996517c..3c62a0042da4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2693,6 +2693,10 @@ static int free_mr_alloc_res(struct hns_roce_dev *hr_dev)
 	return 0;
 
 create_failed_qp:
+	for (i--; i >= 0; i--) {
+		hns_roce_v2_destroy_qp(&free_mr->rsv_qp[i]->ibqp, NULL);
+		kfree(free_mr->rsv_qp[i]);
+	}
 	hns_roce_destroy_cq(cq, NULL);
 	kfree(cq);
 
-- 
2.43.0



