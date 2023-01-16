Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DAE6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE87C433EF;
	Mon, 16 Jan 2023 17:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888744;
	bh=ZSqTaZsaViMiaB+kQCVCuYD641i+qFiX5nYTpj6eric=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUrbtXQJJjaIl9ErKxDGmKePbTIHPMdeHHDDm9dQf5UhwHCTSh9HMHyDT3XKD7pO5
	 iNE7kIKJPDb13b11s4lUDYWRjHVvM3AM25wLGWPZYnL2VOqT9VWUVt7XjvZE/aMjMO
	 Pfns/oEdgkpmyrAEIPfSmD+XxYqCt8SRm5ZKQjL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 123/338] net: farsync: Fix kmemleak when rmmods farsync
Date: Mon, 16 Jan 2023 16:49:56 +0100
Message-Id: <20230116154826.211728341@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit 2f623aaf9f31de968dea6169849706a2f9be444c ]

There are two memory leaks reported by kmemleak:

  unreferenced object 0xffff888114b20200 (size 128):
    comm "modprobe", pid 4846, jiffies 4295146524 (age 401.345s)
    hex dump (first 32 bytes):
      e0 62 57 09 81 88 ff ff e0 62 57 09 81 88 ff ff  .bW......bW.....
      01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<ffffffff815bcd82>] kmalloc_trace+0x22/0x60
      [<ffffffff83d35c78>] __hw_addr_add_ex+0x198/0x6c0
      [<ffffffff83d3989d>] dev_addr_init+0x13d/0x230
      [<ffffffff83d1063d>] alloc_netdev_mqs+0x10d/0xe50
      [<ffffffff82b4a06e>] alloc_hdlcdev+0x2e/0x80
      [<ffffffffa016a741>] fst_add_one+0x601/0x10e0 [farsync]
      ...

  unreferenced object 0xffff88810b85b000 (size 1024):
    comm "modprobe", pid 4846, jiffies 4295146523 (age 401.346s)
    hex dump (first 32 bytes):
      00 00 b0 02 00 c9 ff ff 00 70 0a 00 00 c9 ff ff  .........p......
      00 00 00 f2 00 00 00 f3 0a 00 00 00 02 00 00 00  ................
    backtrace:
      [<ffffffff815bcd82>] kmalloc_trace+0x22/0x60
      [<ffffffffa016a294>] fst_add_one+0x154/0x10e0 [farsync]
      [<ffffffff82060e83>] local_pci_probe+0xd3/0x170
      ...

The root cause is traced to the netdev and fst_card_info are not freed
when removes one fst in fst_remove_one(), which may trigger oom if
repeated insmod and rmmod module.

Fix it by adding free_netdev() and kfree() in fst_remove_one(), just as
the operations on the error handling path in fst_add_one().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/farsync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index bd46b2552980..6284e8906e36 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -2619,6 +2619,7 @@ fst_remove_one(struct pci_dev *pdev)
 	for (i = 0; i < card->nports; i++) {
 		struct net_device *dev = port_to_dev(&card->ports[i]);
 		unregister_hdlc_device(dev);
+		free_netdev(dev);
 	}
 
 	fst_disable_intr(card);
@@ -2639,6 +2640,7 @@ fst_remove_one(struct pci_dev *pdev)
 				    card->tx_dma_handle_card);
 	}
 	fst_card_array[card->card_no] = NULL;
+	kfree(card);
 }
 
 static struct pci_driver fst_driver = {
-- 
2.35.1



