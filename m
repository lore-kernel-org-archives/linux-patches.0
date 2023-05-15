Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD40FFBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421D4C433EF;
	Mon, 15 May 2023 16:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169491;
	bh=PvErCNWy9upi3n+FPP0v22rDzyW1zD8pthpoUcTZ12w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sY/6zsYqO7Y7cMoq9jW7htadmwvlYlweLoZfXND/nrWq/C0Gu8Zvyts5yzgprZMY9
	 fRuA9vJXm1vmsYM0873qodoDLkW8PkqEmrKXvSqtRAA8ztze0rN2AcRmCmHa+BEwZw
	 IgsUUo1MtHnWEDlnIEZRJGeUhSg0BdIlbOWC05AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	Sai Krishna <saikrishnag@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 074/246] octeontx2-pf: Disable packet I/O for graceful exit
Date: Mon, 15 May 2023 18:24:46 +0200
Message-Id: <20230515161724.790822644@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit c926252205c424c4842dbdbe02f8e3296f623204 ]

At the stage of enabling packet I/O in otx2_open, If mailbox
timeout occurs then interface ends up in down state where as
hardware packet I/O is enabled. Hence disable packet I/O also
before bailing out.

Fixes: 1ea0166da050 ("octeontx2-pf: Fix the device state on error")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index a75c944cc739d..18284ad751572 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1835,13 +1835,22 @@ int otx2_open(struct net_device *netdev)
 		otx2_dmacflt_reinstall_flows(pf);
 
 	err = otx2_rxtx_enable(pf, true);
-	if (err)
+	/* If a mbox communication error happens at this point then interface
+	 * will end up in a state such that it is in down state but hardware
+	 * mcam entries are enabled to receive the packets. Hence disable the
+	 * packet I/O.
+	 */
+	if (err == EIO)
+		goto err_disable_rxtx;
+	else if (err)
 		goto err_tx_stop_queues;
 
 	otx2_do_set_rx_mode(pf);
 
 	return 0;
 
+err_disable_rxtx:
+	otx2_rxtx_enable(pf, false);
 err_tx_stop_queues:
 	netif_tx_stop_all_queues(netdev);
 	netif_carrier_off(netdev);
-- 
2.39.2



