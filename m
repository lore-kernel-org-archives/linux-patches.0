Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23B14C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71652C433C1;
	Mon, 14 Nov 2022 12:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430156;
	bh=pk3zc17bA9NFxGjKEx0G0CWZC0Alrk24WYF/ssid2TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwzDMxk3Otxo24DgpaDR9YrIWhsIIBUI9/ibwX//IV73kpXGVi4DtkLw8MmT5wTNJ
	 YawYsXyPAKz5paJfaXwgHrqi2K5wyAS9EAvbLdHBorlTmkrWHse86zV/lBpcwBiuf0
	 Et7yDpbQjdGJ3Ry+5rXRsrqT2Hp2M3qIQVqIF8Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 41/95] net: cpsw: disable napi in cpsw_ndo_open()
Date: Mon, 14 Nov 2022 13:45:35 +0100
Message-Id: <20221114124444.257829534@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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
index b0f00b4edd94..5af0f9f8c097 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -864,6 +864,8 @@ static int cpsw_ndo_open(struct net_device *ndev)
 
 err_cleanup:
 	if (!cpsw->usage_count) {
+		napi_disable(&cpsw->napi_rx);
+		napi_disable(&cpsw->napi_tx);
 		cpdma_ctlr_stop(cpsw->dma);
 		cpsw_destroy_xdp_rxqs(cpsw);
 	}
-- 
2.35.1



