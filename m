Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2186C6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A611C433D2;
	Mon, 16 Jan 2023 17:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888783;
	bh=YEgiewZsAafs6FNPEwbKCgRf2pO5TrJB9ccMy3yLldU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZbHe8SsAibEaLF518eYUcKf2ea+nhr82Xbq82ySEgsSxLwNAMauY/9L8nZJrqR7Z
	 M1GEUfolVLsLVzzwX2t99AzYNyvRhrfdE++K5A6FyiKRflg2WengB7hWRkb+7p1UKO
	 7zTvF9px1R5NxXleMRYqcU6+ah04K4A8H5Y09Zh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 137/338] Bluetooth: hci_bcsp: dont call kfree_skb() under spin_lock_irqsave()
Date: Mon, 16 Jan 2023 16:50:10 +0100
Message-Id: <20230116154826.803181005@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 7b503e339c1a80bf0051ec2d19c3bc777014ac61 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_bcsp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index ee6c403de6af..aad29ebad9ed 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -392,7 +392,7 @@ static void bcsp_pkt_cull(struct bcsp_struct *bcsp)
 		i++;
 
 		__skb_unlink(skb, &bcsp->unack);
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 	}
 
 	if (skb_queue_empty(&bcsp->unack))
-- 
2.35.1



