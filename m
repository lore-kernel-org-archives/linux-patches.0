Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8388211703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EFBC433C9;
	Mon, 21 Aug 2023 19:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647734;
	bh=bEXIITThi8D8NdwdR9mUvs/pfPrs71ERLHsPzE2esRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lvif631kPpS4c436rKEsjCKcW6li3+wj+DkzClXyBOWIfv/dn7kD/Cu/wFpFI1QqT
	 LHh5vgUKvO848G/t+QnoVcXr5ioAv40fd6PLT3t+uZkf0pKjdgDXcRQe22+FNjDuLG
	 lyTHYGLaCayqQR0Dj/Kt/g7D5zkmkEGtEeaGa2Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/194] octeon_ep: cancel tx_timeout_task later in remove sequence
Date: Mon, 21 Aug 2023 21:41:38 +0200
Message-ID: <20230821194127.934063814@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 28458c80006bb4e993a09fc094094a8578cad292 ]

tx_timeout_task is canceled too early when removing the driver. Nothing
prevents .ndo_tx_timeout from triggering and queuing the work again.

Better cancel it after the netdev is unregistered.
It's harmless for octep_tx_timeout_task to run in the window between the
unregistration and cancelation, because it checks netif_running.

Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Link: https://lore.kernel.org/r/20230810150114.107765-3-mschmidt@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 8979dd05e873f..d4ec46d1c8cfb 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1121,12 +1121,12 @@ static void octep_remove(struct pci_dev *pdev)
 	if (!oct)
 		return;
 
-	cancel_work_sync(&oct->tx_timeout_task);
 	cancel_work_sync(&oct->ctrl_mbox_task);
 	netdev = oct->netdev;
 	if (netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(netdev);
 
+	cancel_work_sync(&oct->tx_timeout_task);
 	octep_device_cleanup(oct);
 	pci_release_mem_regions(pdev);
 	free_netdev(netdev);
-- 
2.40.1



