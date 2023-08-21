Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2E11171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32283C433C7;
	Mon, 21 Aug 2023 20:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648371;
	bh=1wk4aTJ8eIgqv5ZFYMrth8BOS1DVWJxxlz+7yYzlDYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGCC0n/4ZPIxnDkMe8pj4S0NxC15bCclw2U4dSMPQlV3DfLe+PRtFFpw94wEsFm/h
	 vVjDBnLio/05FoFYlLB1P2dlWXMKhnmW6kgYj3GlJ59QkQqrlXT+7ZVyPC58zDS10E
	 xRkUFKFAe6dwJtuN6Il1h+7S/iDE/N90Ck2780Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 151/234] octeon_ep: cancel tx_timeout_task later in remove sequence
Date: Mon, 21 Aug 2023 21:41:54 +0200
Message-ID: <20230821194135.510391184@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
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
index 43eb6e8713511..d8066bff5f7b1 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1200,12 +1200,12 @@ static void octep_remove(struct pci_dev *pdev)
 	if (!oct)
 		return;
 
-	cancel_work_sync(&oct->tx_timeout_task);
 	cancel_work_sync(&oct->ctrl_mbox_task);
 	netdev = oct->netdev;
 	if (netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(netdev);
 
+	cancel_work_sync(&oct->tx_timeout_task);
 	oct->poll_non_ioq_intr = false;
 	cancel_delayed_work_sync(&oct->intr_poll_task);
 	octep_device_cleanup(oct);
-- 
2.40.1



