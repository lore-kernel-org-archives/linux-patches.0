Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230311C2B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC22C433C1;
	Wed, 23 Nov 2022 09:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195397;
	bh=r7TCqYdhccG16jbLPuh3M3onDTOS79O2F0bXMmexU1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cwq/DgPJvKzemmvXlfblQEUWIprj42d0VCjnDensHg7PvlUrSs0S0/KiXRuBtdnnY
	 j3D24kNYo4nh42ApVfueK7bUc6rfcKUENhitca/FDQhOSKlgP+QIcFHgztFIwGwxBx
	 PFcxSABOk73VYyKZvEIEB4IPg6HMH5MbGivP8Ajo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Shay Agroskin <shayagr@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/149] net: ena: Fix error handling in ena_init()
Date: Wed, 23 Nov 2022 09:50:56 +0100
Message-Id: <20221123084600.507946700@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit d349e9be5a2c2d7588a2c4e4bfa0bb3dc1226769 ]

The ena_init() won't destroy workqueue created by
create_singlethread_workqueue() when pci_register_driver() failed.
Call destroy_workqueue() when pci_register_driver() failed to prevent the
resource leak.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Acked-by: Shay Agroskin <shayagr@amazon.com>
Link: https://lore.kernel.org/r/20221114025659.124726-1-yuancan@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 52414ac2c901..1722d4091ea3 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4488,13 +4488,19 @@ static struct pci_driver ena_pci_driver = {
 
 static int __init ena_init(void)
 {
+	int ret;
+
 	ena_wq = create_singlethread_workqueue(DRV_MODULE_NAME);
 	if (!ena_wq) {
 		pr_err("Failed to create workqueue\n");
 		return -ENOMEM;
 	}
 
-	return pci_register_driver(&ena_pci_driver);
+	ret = pci_register_driver(&ena_pci_driver);
+	if (ret)
+		destroy_workqueue(ena_wq);
+
+	return ret;
 }
 
 static void __exit ena_cleanup(void)
-- 
2.35.1



