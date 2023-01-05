Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDFE8494
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 13:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59405C433EF;
	Thu,  5 Jan 2023 13:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923725;
	bh=jpWgG7Yzec5WjkENwDZihEJpPFUosVadviWqRlbtCJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTA7CRIUfyOAMsFfEMZvwspLphsSzCGPK2062Hx08GjNVXhYgJH4KielxbAKSFaQ+
	 QmhtZwj7rf+gYJZKW+kGM3xu5NV/+do7Ev6wDl4taOkIZb6EihJoyij5gamyoKWZQV
	 yrXZWHpXCPoX9KIZtdPE6sED392MVOy1SbU2UUBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 112/251] Bluetooth: hci_bcsp: dont call kfree_skb() under spin_lock_irqsave()
Date: Thu,  5 Jan 2023 13:54:09 +0100
Message-Id: <20230105125339.959764738@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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
index 26f9982bab26..2056d5c01afa 100644
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



