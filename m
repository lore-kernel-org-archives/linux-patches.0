Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21B51863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A8EC433D2;
	Wed, 28 Dec 2022 15:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240700;
	bh=nU/xSYPLo+sw3yh5YquAmJTrR4UDXn/4p8oi/2yMZhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDwDuVowagpTTnNCApxIEjHY4F031ZPflVcSwq3/eO5IT78sH5xB4Nt7aR6as4HT0
	 2YN1HQPKp1kezelyVn5RNnZjzJs+5JQDrwf4xQ8m3foVJGzfVOeOX7U+awBYYZuePd
	 qqhpe11W4EqqxRrIdIPIlCmYSXP+8ZbSdKDrnl9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Heib <kamalheib1@gmail.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 381/731] RDMA/irdma: Report the correct link speed
Date: Wed, 28 Dec 2022 15:38:08 +0100
Message-Id: <20221228144307.604414992@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shiraz Saleem <shiraz.saleem@intel.com>

[ Upstream commit 4eace75e0853273755b878ffa9cce6de84df975a ]

The active link speed is currently hard-coded in irdma_query_port due
to which the port rate in ibstatus does reflect the active link speed.

Call ib_get_eth_speed in irdma_query_port to get the active link speed.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Reported-by: Kamal Heib <kamalheib1@gmail.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20221104234957.1135-1-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 35 +++--------------------------
 1 file changed, 3 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 911902d2b93e..c5971a840b87 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -60,36 +60,6 @@ static int irdma_query_device(struct ib_device *ibdev,
 	return 0;
 }
 
-/**
- * irdma_get_eth_speed_and_width - Get IB port speed and width from netdev speed
- * @link_speed: netdev phy link speed
- * @active_speed: IB port speed
- * @active_width: IB port width
- */
-static void irdma_get_eth_speed_and_width(u32 link_speed, u16 *active_speed,
-					  u8 *active_width)
-{
-	if (link_speed <= SPEED_1000) {
-		*active_width = IB_WIDTH_1X;
-		*active_speed = IB_SPEED_SDR;
-	} else if (link_speed <= SPEED_10000) {
-		*active_width = IB_WIDTH_1X;
-		*active_speed = IB_SPEED_FDR10;
-	} else if (link_speed <= SPEED_20000) {
-		*active_width = IB_WIDTH_4X;
-		*active_speed = IB_SPEED_DDR;
-	} else if (link_speed <= SPEED_25000) {
-		*active_width = IB_WIDTH_1X;
-		*active_speed = IB_SPEED_EDR;
-	} else if (link_speed <= SPEED_40000) {
-		*active_width = IB_WIDTH_4X;
-		*active_speed = IB_SPEED_FDR10;
-	} else {
-		*active_width = IB_WIDTH_4X;
-		*active_speed = IB_SPEED_EDR;
-	}
-}
-
 /**
  * irdma_query_port - get port attributes
  * @ibdev: device pointer from stack
@@ -117,8 +87,9 @@ static int irdma_query_port(struct ib_device *ibdev, u32 port,
 		props->state = IB_PORT_DOWN;
 		props->phys_state = IB_PORT_PHYS_STATE_DISABLED;
 	}
-	irdma_get_eth_speed_and_width(SPEED_100000, &props->active_speed,
-				      &props->active_width);
+
+	ib_get_eth_speed(ibdev, port, &props->active_speed,
+			 &props->active_width);
 
 	if (rdma_protocol_roce(ibdev, 1)) {
 		props->gid_tbl_len = 32;
-- 
2.35.1



