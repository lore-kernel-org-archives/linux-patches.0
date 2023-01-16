Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAD06FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6C9C433F1;
	Mon, 16 Jan 2023 16:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887579;
	bh=xnsC0OOoMToBZSxjl+r6hR5ELDSrIKCbZvukHA7KU14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgFyr+jbiMvdAcEl9QZiOr57Oqt4AShemJNGfaBGvMiNxv8mYphiixKRInmQAEe9x
	 LrRNYUFEiHz4wQpM6smm9QzilS8az2Iu1V6sjLdc4XZ/U8B2fpD9FHapihd278tcDg
	 xTBu+DtfqHDUsQPg5upAI8Xe2c7/BRYb7Qb4sHP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 174/521] Bluetooth: hci_qca: dont call kfree_skb() under spin_lock_irqsave()
Date: Mon, 16 Jan 2023 16:47:16 +0100
Message-Id: <20230116154854.884536236@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit df4cfc91208e0a98f078223793f5871b1a82cc54 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave().

Fixes: 0ff252c1976d ("Bluetooth: hciuart: Add support QCA chipset for UART")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index f96e58de049b..f8b6823db04a 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -810,7 +810,7 @@ static int qca_enqueue(struct hci_uart *hu, struct sk_buff *skb)
 	default:
 		BT_ERR("Illegal tx state: %d (losing packet)",
 		       qca->tx_ibs_state);
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 		break;
 	}
 
-- 
2.35.1



