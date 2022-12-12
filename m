Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D6328ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A8EC433EF;
	Mon, 12 Dec 2022 13:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851934;
	bh=8VnjgRBhaM2Et1c02AY5ECrC5bDgkZVGbjm9eKwy2kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbN2+Vw1vCmZZgii5gi2YzXGkzG2HtdQJk3JC8YRmZqIs7JpdvVIlGwVDhTbkDWqB
	 kfXUtrNph+IvpjC01lEXHyL8EDDcxFSWap9ehas4E4FHtqlr54wzBkbmFJ5OlkD6nq
	 jRLtuG8gBNVWyhUwg7ReyODzyN9gDlYD8ZvzJpx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Liu <liuyongqiang13@huawei.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/123] net: thunderx: Fix missing destroy_workqueue of nicvf_rx_mode_wq
Date: Mon, 12 Dec 2022 14:17:46 +0100
Message-Id: <20221212130931.359196192@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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
index a27227aeae88..b43b97e15a6f 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2250,7 +2250,7 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
-		goto err_unregister_interrupts;
+		goto err_destroy_workqueue;
 	}
 
 	nic->msg_enable = debug;
@@ -2259,6 +2259,8 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+err_destroy_workqueue:
+	destroy_workqueue(nic->nicvf_rx_mode_wq);
 err_unregister_interrupts:
 	nicvf_unregister_interrupts(nic);
 err_free_netdev:
-- 
2.35.1



