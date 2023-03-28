Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC9D8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C779BC433EF;
	Tue, 28 Mar 2023 14:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015500;
	bh=SvjhRJNZI7DY7WVC6TxRCCZ2BImCIInodHJgRAUxZIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKfhPeseiTTJrHghc0oBLE3athj7H6fqBRpodIwdBuReNWVn3XBL1OENhlHKzmh4j
	 37y4/2UGbUz4y4eSu6L/ZFSZew2LZuHILinudR5K/7gehzS4aGHMlUa2FqJGLhO7qE
	 4fqgoTE8CZJOrJa7FPDPxJVNyMZH0RU/VUWyj+2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Francois Romieu <romieu@fr.zoreil.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/224] atm: idt77252: fix kmemleak when rmmod idt77252
Date: Tue, 28 Mar 2023 16:41:07 +0200
Message-Id: <20230328142620.306487999@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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

[ Upstream commit 4fe3c88552a3fbe1944426a4506a18cdeb457b5a ]

There are memory leaks reported by kmemleak:

  unreferenced object 0xffff888106500800 (size 128):
    comm "modprobe", pid 1017, jiffies 4297787785 (age 67.152s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<00000000970ce626>] __kmem_cache_alloc_node+0x20c/0x380
      [<00000000fb5f78d9>] kmalloc_trace+0x2f/0xb0
      [<000000000e947e2a>] idt77252_init_one+0x2847/0x3c90 [idt77252]
      [<000000006efb048e>] local_pci_probe+0xeb/0x1a0
    ...

  unreferenced object 0xffff888106500b00 (size 128):
    comm "modprobe", pid 1017, jiffies 4297787785 (age 67.152s)
    hex dump (first 32 bytes):
      00 20 3d 01 80 88 ff ff 00 20 3d 01 80 88 ff ff  . =...... =.....
      f0 23 3d 01 80 88 ff ff 00 20 3d 01 00 00 00 00  .#=...... =.....
    backtrace:
      [<00000000970ce626>] __kmem_cache_alloc_node+0x20c/0x380
      [<00000000fb5f78d9>] kmalloc_trace+0x2f/0xb0
      [<00000000f451c5be>] alloc_scq.constprop.0+0x4a/0x400 [idt77252]
      [<00000000e6313849>] idt77252_init_one+0x28cf/0x3c90 [idt77252]

The root cause is traced to the vc_maps which alloced in open_card_oam()
are not freed in close_card_oam(). The vc_maps are used to record
open connections, so when close a vc_map in close_card_oam(), the memory
should be freed. Moreover, the ubr0 is not closed when close a idt77252
device, leading to the memory leak of vc_map and scq_info.

Fix them by adding kfree in close_card_oam() and implementing new
close_card_ubr0() to close ubr0.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Francois Romieu <romieu@fr.zoreil.com>
Link: https://lore.kernel.org/r/20230320143318.2644630-1-lizetao1@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/idt77252.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 681cb3786794d..49cb4537344aa 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2909,6 +2909,7 @@ close_card_oam(struct idt77252_dev *card)
 
 				recycle_rx_pool_skb(card, &vc->rcv.rx_pool);
 			}
+			kfree(vc);
 		}
 	}
 }
@@ -2952,6 +2953,15 @@ open_card_ubr0(struct idt77252_dev *card)
 	return 0;
 }
 
+static void
+close_card_ubr0(struct idt77252_dev *card)
+{
+	struct vc_map *vc = card->vcs[0];
+
+	free_scq(card, vc->scq);
+	kfree(vc);
+}
+
 static int
 idt77252_dev_open(struct idt77252_dev *card)
 {
@@ -3001,6 +3011,7 @@ static void idt77252_dev_close(struct atm_dev *dev)
 	struct idt77252_dev *card = dev->dev_data;
 	u32 conf;
 
+	close_card_ubr0(card);
 	close_card_oam(card);
 
 	conf = SAR_CFG_RXPTH |	/* enable receive path           */
-- 
2.39.2



