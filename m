Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC68A43AD3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sB6EfKYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADDEC4E778;
	Wed, 15 Nov 2023 20:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081609;
	bh=rMf7q/SnFp/cGWoOs0hG7up9y52DFAQjpSDXHvSZiaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sB6EfKYC+sDGCfH1R/5R5fiaszt7TTrcEjeqeG/WQDpafRXFZaQ7T5CnSO/xZgGud
	 ROZFUywdmCYVGvQnsVA/J3axTIAbSwYeZak1FJJCdROCJcAlu6o5Uj3szSYMwDmgJe
	 jT70pqxHNhSrI7bp8FXQ4R+KYnp//oH76hbI5M9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/191] gve: Use size_add() in call to struct_size()
Date: Wed, 15 Nov 2023 15:44:49 -0500
Message-ID: <20231115204645.363529171@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit d692873cbe861a870cdc9cbfb120eefd113c3dfd ]

If, for any reason, `tx_stats_num + rx_stats_num` wraps around, the
protection that struct_size() adds against potential integer overflows
is defeated. Fix this by hardening call to struct_size() with size_add().

Fixes: 691f4077d560 ("gve: Replace zero-length array with flexible-array member")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index f0c1e6c80b61c..b76d1d019a81d 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -128,7 +128,7 @@ static int gve_alloc_stats_report(struct gve_priv *priv)
 	rx_stats_num = (GVE_RX_STATS_REPORT_NUM + NIC_RX_STATS_REPORT_NUM) *
 		       priv->rx_cfg.num_queues;
 	priv->stats_report_len = struct_size(priv->stats_report, stats,
-					     tx_stats_num + rx_stats_num);
+					     size_add(tx_stats_num, rx_stats_num));
 	priv->stats_report =
 		dma_alloc_coherent(&priv->pdev->dev, priv->stats_report_len,
 				   &priv->stats_report_bus, GFP_KERNEL);
-- 
2.42.0



