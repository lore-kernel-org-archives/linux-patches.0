Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222E84C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA6FC433D6;
	Mon, 14 Nov 2022 12:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430653;
	bh=XSp47mdWlNz4ywSzJBRhftkGTaSsMRST3jCivCRWNVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3ACqjumRwKF+xeEWDIfY6WpVEtL3DxnV8GyCacAo/YBbUaE8V1+LGo+YR/LjH2R2
	 28jbGHz73mxyQkXM48f7+MFmVxYUW8ZEtR+B3C1rEes8Ji0v5GnF/5G3kXnRpq/w/e
	 JvUhIDPYv1dtnJSqNi+B1Z/cif0wIIkLtOt6pY/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/131] net: cpsw: disable napi in cpsw_ndo_open()
Date: Mon, 14 Nov 2022 13:45:33 +0100
Message-Id: <20221114124451.394865678@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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
index e226ecd95a2c..ca587fe28150 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -856,6 +856,8 @@ static int cpsw_ndo_open(struct net_device *ndev)
 
 err_cleanup:
 	if (!cpsw->usage_count) {
+		napi_disable(&cpsw->napi_rx);
+		napi_disable(&cpsw->napi_tx);
 		cpdma_ctlr_stop(cpsw->dma);
 		cpsw_destroy_xdp_rxqs(cpsw);
 	}
-- 
2.35.1



