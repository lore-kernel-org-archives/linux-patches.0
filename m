Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD6E749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601CAC433D2;
	Thu, 12 Jan 2023 14:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532874;
	bh=1BT/LQ3KXOdV3MoHfEz0X5vUAJ6h2hwWPrzLL2+74FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgVrTmtciWi3f1vMjrGtds2YNOkEE5dTDEOo+d2uDdHjrlAy3K9BCzrHjW0Ippq4G
	 SaTPf9Z5r5MeNYk+/usYcRue6i+v/mSAAt1lAeLblIwVlOsvNPwgoSd4Tp3EI5qrHf
	 Lr3x8KXvfqWcg/PdNBA4rrWKgRhr1Ml/OwDQraO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 274/783] Bluetooth: hci_core: dont call kfree_skb() under spin_lock_irqsave()
Date: Thu, 12 Jan 2023 14:49:50 +0100
Message-Id: <20230112135537.097138795@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

[ Upstream commit 39c1eb6fcbae8ce9bb71b2ac5cb609355a2b181b ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave().

Fixes: 9238f36a5a50 ("Bluetooth: Add request cmd_complete and cmd_status functions")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index f8aab38ab595..2af1477a05ca 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4910,7 +4910,7 @@ void hci_req_cmd_complete(struct hci_dev *hdev, u16 opcode, u8 status,
 			*req_complete_skb = bt_cb(skb)->hci.req_complete_skb;
 		else
 			*req_complete = bt_cb(skb)->hci.req_complete;
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 	}
 	spin_unlock_irqrestore(&hdev->cmd_q.lock, flags);
 }
-- 
2.35.1



