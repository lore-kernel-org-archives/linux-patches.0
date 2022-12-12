Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CA428ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A07C433EF;
	Mon, 12 Dec 2022 13:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852710;
	bh=42NiLQMKNAiPRmwZXw/fXqpeCCLXX4aJ496r3Sga2/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tS7UIEC51jk3qphf8X9C+KXKNNiU11kVxXGIYZooiJwpcwH6XWOLsyR7noHBmxTjb
	 pbsc2GbkbI/nYJ/5Dpi7sFHbHDY/htXqeZUqZr1wIbu/SVQSfzr+/tndnVHEKKljX8
	 w7yP76MtKujT8bUg4qBoD+6dDaLPmeIdJUuD+m0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Liu <liuyongqiang13@huawei.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 136/157] net: thunderx: Fix missing destroy_workqueue of nicvf_rx_mode_wq
Date: Mon, 12 Dec 2022 14:18:04 +0100
Message-Id: <20221212130940.517296668@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yongqiang Liu <liuyongqiang13@huawei.com>

[ Upstream commit 42330a32933fb42180c52022804dcf09f47a2f99 ]

The nicvf_probe() won't destroy workqueue when register_netdev()
failed. Add destroy_workqueue err handle case to fix this issue.

Fixes: 2ecbe4f4a027 ("net: thunderx: replace global nicvf_rx_mode_wq work queue for all VFs to private for each of them.")
Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://lore.kernel.org/r/20221203094125.602812-1-liuyongqiang13@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 768ea426d49f..745bd2dfb742 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2240,7 +2240,7 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
-		goto err_unregister_interrupts;
+		goto err_destroy_workqueue;
 	}
 
 	nic->msg_enable = debug;
@@ -2249,6 +2249,8 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+err_destroy_workqueue:
+	destroy_workqueue(nic->nicvf_rx_mode_wq);
 err_unregister_interrupts:
 	nicvf_unregister_interrupts(nic);
 err_free_netdev:
-- 
2.35.1



