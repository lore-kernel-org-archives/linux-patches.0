Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A4546B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC4EC433F2;
	Mon, 16 Jan 2023 16:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885927;
	bh=PIhhYrO0m6xsP04/1gfXmKNLgZ/bPaC/Gg09AVypPh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LcGRVfFnPs86CBQpKlQQL/VbzqW0vBpFhd3ZGZW6PeMe/L8PhgcL2ctAkc7cKHF2e
	 6xDOAjPaq2KhiAcxjHdzsUpi96C5KccXfLATzfLSr+WRD1ggms+qW58jMX2RvQG+2S
	 Q1rX9qCOxdnEypRKN+Cmab6iiqciUAd5l1HhM8zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 219/658] net: farsync: Fix kmemleak when rmmods farsync
Date: Mon, 16 Jan 2023 16:45:07 +0100
Message-Id: <20230116154919.504260054@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 1901ec7948d8..a2527351f8a7 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -2613,6 +2613,7 @@ fst_remove_one(struct pci_dev *pdev)
 	for (i = 0; i < card->nports; i++) {
 		struct net_device *dev = port_to_dev(&card->ports[i]);
 		unregister_hdlc_device(dev);
+		free_netdev(dev);
 	}
 
 	fst_disable_intr(card);
@@ -2633,6 +2634,7 @@ fst_remove_one(struct pci_dev *pdev)
 				    card->tx_dma_handle_card);
 	}
 	fst_card_array[card->card_no] = NULL;
+	kfree(card);
 }
 
 static struct pci_driver fst_driver = {
-- 
2.35.1



