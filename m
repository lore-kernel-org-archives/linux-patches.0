Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52294171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EC0C433D2;
	Mon, 22 May 2023 19:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784919;
	bh=fZFK39qpgb1p4RDjuyhrhJCjwjiENebnbjsOgOZr3wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUGidBadAaOmkZdAhvivaNgtche/Z1mmtxOSlWFbsETl7qoWh6sbV23GNV5l1mNiO
	 NPFq9xoehyO15UPdSMDW0Mp0gG8A3RNj6vTj6yL3IhS4M+CxzPu5VC9XjR3yamc7gN
	 s9VMQd/3FQwX+oTBi2HIbaz3LPO8qMag9RG36yrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 245/364] media: netup_unidvb: fix use-after-free at del_timer()
Date: Mon, 22 May 2023 20:09:10 +0100
Message-Id: <20230522190418.822057320@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 0f5bb36bf9b39a2a96e730bf4455095b50713f63 ]

When Universal DVB card is detaching, netup_unidvb_dma_fini()
uses del_timer() to stop dma->timeout timer. But when timer
handler netup_unidvb_dma_timeout() is running, del_timer()
could not stop it. As a result, the use-after-free bug could
happen. The process is shown below:

    (cleanup routine)          |        (timer routine)
                               | mod_timer(&dev->tx_sim_timer, ..)
netup_unidvb_finidev()         | (wait a time)
  netup_unidvb_dma_fini()      | netup_unidvb_dma_timeout()
    del_timer(&dma->timeout);  |
                               |   ndev->pci_dev->dev //USE

Fix by changing del_timer() to del_timer_sync().

Link: https://lore.kernel.org/linux-media/20230308125514.4208-1-duoming@zju.edu.cn
Fixes: 52b1eaf4c59a ("[media] netup_unidvb: NetUP Universal DVB-S/S2/T/T2/C PCI-E card driver")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 8287851b5ffdc..aaa1d2dedebdd 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -697,7 +697,7 @@ static void netup_unidvb_dma_fini(struct netup_unidvb_dev *ndev, int num)
 	netup_unidvb_dma_enable(dma, 0);
 	msleep(50);
 	cancel_work_sync(&dma->work);
-	del_timer(&dma->timeout);
+	del_timer_sync(&dma->timeout);
 }
 
 static int netup_unidvb_dma_setup(struct netup_unidvb_dev *ndev)
-- 
2.39.2



