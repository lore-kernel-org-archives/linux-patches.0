Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBC11C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F401C433EF;
	Wed, 28 Dec 2022 16:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243549;
	bh=bT5Fk04Bkb07fBBG+fbMfqZeGA2yX7czI1av1s6bY8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZpdJ5iD0tni72A4BGYwOvZlZws7M5vkThqdbVBZO7COkJaUyA3G+nIgU3SMxXh8T
	 O8cLosg6aaXOjGXKiOHv/KuYM3Xa32H+I+RfBYw7KHIrlpoWCc5lCJY9SHXx/TTB0t
	 0hTxIYmDNaQ8eR6WUnuUUUXKq3fR1n95qCYzi+QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0546/1073] Bluetooth: hci_h5: dont call kfree_skb() under spin_lock_irqsave()
Date: Wed, 28 Dec 2022 15:35:34 +0100
Message-Id: <20221228144342.885809405@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 383630cc6758d619874c2e8bb2f68a61f3f9ef6e ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave().

Fixes: 43eb12d78960 ("Bluetooth: Fix/implement Three-wire reliable packet sending")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_h5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index c5a0409ef84f..6455bc4fb5bb 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -313,7 +313,7 @@ static void h5_pkt_cull(struct h5 *h5)
 			break;
 
 		__skb_unlink(skb, &h5->unack);
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 	}
 
 	if (skb_queue_empty(&h5->unack))
-- 
2.35.1



