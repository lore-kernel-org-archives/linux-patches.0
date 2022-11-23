Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06171C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE26C433C1;
	Wed, 23 Nov 2022 09:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194739;
	bh=GeC7NvKqm718jF98ewFwJhQZ2YZOROyEMwggYRyroFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjeMuD4/8slHta4xmZn/8XsMF3Pwii+z7txaz4TMrwETdNV5r8U5rfEgflfTcdNt1
	 HrYeuN5D3G5XJMGHxd2x8wEISaMNLbqB9j0Au5W+Bd6GWzT7/xHeiABuKpKBenUNEI
	 osqteviOxLfBEyfkSB5lLHKisA64903I0YHta5b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/156] net: cpsw: disable napi in cpsw_ndo_open()
Date: Wed, 23 Nov 2022 09:49:47 +0100
Message-Id: <20221123084559.050258138@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 6d47b53fb3f363a74538a1dbd09954af3d8d4131 ]

When failed to create xdp rxqs or fill rx channels in cpsw_ndo_open() for
opening device, napi isn't disabled. When open cpsw device next time, it
will report a invalid opcode issue. Compiled tested only.

Fixes: d354eb85d618 ("drivers: net: cpsw: dual_emac: simplify napi usage")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221109011537.96975-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 33eca554424a..774a72db7c96 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1753,6 +1753,8 @@ static int cpsw_ndo_open(struct net_device *ndev)
 
 err_cleanup:
 	if (!cpsw->usage_count) {
+		napi_disable(&cpsw->napi_rx);
+		napi_disable(&cpsw->napi_tx);
 		cpdma_ctlr_stop(cpsw->dma);
 		cpsw_destroy_xdp_rxqs(cpsw);
 	}
-- 
2.35.1



