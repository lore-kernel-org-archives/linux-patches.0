Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3D51863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183FAC433EF;
	Wed, 28 Dec 2022 15:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240425;
	bh=P2lpu2OpEi8iruibbunIjy84xM5ZdFStPfUBIyYLynk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3MeDbwrRvaFW54BObIrPT7sH/A+gnS6eSiIi5F0nd7d09BTyb+q9tprgjW5w/A1G
	 xaupxhqgZUZp8rtKeXoP73CQRHXsEuX/yGMrKvb7pSQI5mrDNwxH24fBM+Oijru+1c
	 k6f45FOGPRlrZOuc2DkW5mdyCpd9DpgpDwDarQhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 348/731] Bluetooth: btusb: dont call kfree_skb() under spin_lock_irqsave()
Date: Wed, 28 Dec 2022 15:37:35 +0100
Message-Id: <20221228144306.652609094@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit b15a6bd3c80c77faec8317319b97f976b1a08332 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave().

Fixes: 803b58367ffb ("Bluetooth: btusb: Implement driver internal packet reassembly")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 69380cb03dd3..9c32263f872b 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -735,13 +735,13 @@ static inline void btusb_free_frags(struct btusb_data *data)
 
 	spin_lock_irqsave(&data->rxlock, flags);
 
-	kfree_skb(data->evt_skb);
+	dev_kfree_skb_irq(data->evt_skb);
 	data->evt_skb = NULL;
 
-	kfree_skb(data->acl_skb);
+	dev_kfree_skb_irq(data->acl_skb);
 	data->acl_skb = NULL;
 
-	kfree_skb(data->sco_skb);
+	dev_kfree_skb_irq(data->sco_skb);
 	data->sco_skb = NULL;
 
 	spin_unlock_irqrestore(&data->rxlock, flags);
-- 
2.35.1



