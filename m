Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAED546B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726C4C433F1;
	Mon, 16 Jan 2023 16:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885921;
	bh=tu183AR4/V2w6demOGY2U8lfXYgPky2DeM1mYA62/NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJFV9BPyyEyuyb+dYs1XUE7/xq8Rnaxf6/kZEp2gsXXjPjVmao9+00CVoNTZI3yld
	 I0soBkvsXogZ0gwTRtOVuktYR5bB3oV9XPsCZqa0D9hNdpVQvV1+NeY7Z0m/QsgrsU
	 DNiDjGoWnCZt2jY8C00camV6iMgeEFUyF16i8Ksw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 235/658] Bluetooth: hci_h5: dont call kfree_skb() under spin_lock_irqsave()
Date: Mon, 16 Jan 2023 16:45:23 +0100
Message-Id: <20230116154920.298134595@linuxfoundation.org>
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
index bf3e23104194..e77da593f290 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -298,7 +298,7 @@ static void h5_pkt_cull(struct h5 *h5)
 			break;
 
 		__skb_unlink(skb, &h5->unack);
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 	}
 
 	if (skb_queue_empty(&h5->unack))
-- 
2.35.1



