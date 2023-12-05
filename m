Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9206F6AC2;
	Tue,  5 Dec 2023 03:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLogE1Xd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEF5C433C8;
	Tue,  5 Dec 2023 03:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747719;
	bh=85jT6xy6QB9+Wsm8ZPLgEhGSqYKQ1uxvlibdNNOrkkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLogE1XdpJJp9FYUOdYqfhndCc87lFLH4cFnjYsNJPlBYmNNeGqpG0fxWAQD8xfU0
	 JeeSEkJQH1VGnUOstYKpmdjB3UGa1HT/iIuUllot2YjMFrJpFr0rYc1pHABPgG0pFi
	 ono5stFs+1YzIseqSqR6/xHI/3U6N4Vn+kJmn9No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 43/67] net: ravb: Start TX queues after HW initialization succeeded
Date: Tue,  5 Dec 2023 12:17:28 +0900
Message-ID: <20231205031522.318475110@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit 6f32c086602050fc11157adeafaa1c1eb393f0af ]

ravb_phy_start() may fail. If that happens, the TX queues will remain
started. Thus, move the netif_tx_start_all_queues() after PHY is
successfully initialized.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index a556faa47f036..0c73bc4df98d5 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1448,13 +1448,13 @@ static int ravb_open(struct net_device *ndev)
 	if (info->gptp)
 		ravb_ptp_init(ndev, priv->pdev);
 
-	netif_tx_start_all_queues(ndev);
-
 	/* PHY control start */
 	error = ravb_phy_start(ndev);
 	if (error)
 		goto out_ptp_stop;
 
+	netif_tx_start_all_queues(ndev);
+
 	return 0;
 
 out_ptp_stop:
-- 
2.42.0



