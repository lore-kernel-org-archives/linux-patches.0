Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DC6881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A47C433A0;
	Fri, 10 Mar 2023 14:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459620;
	bh=zGHRFoAzOqbZoTr8Eb9g8FmawEQ02ZQvdjQ+SCzP5lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JX60hFAmDjo6q8oAcNkbfUv7dLK31foCy2jc8c6MoEC+OG3NQiM5gJfuG0CgmZiqb
	 YWEnoRZdtwneT70lOfyl5GKXNSHRNd1soQBuTGaP+jqSSnQjHInq8HgZLQGbRXo7Cr
	 E2AZLWCbG+frYVW6esDiFTfnFiviWvmuLJ6IsbLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/529] wifi: libertas: if_usb: dont call kfree_skb() under spin_lock_irqsave()
Date: Fri, 10 Mar 2023 14:33:28 +0100
Message-Id: <20230310133808.001793390@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

[ Upstream commit 3968e81ba644f10a7d45bae2539560db9edac501 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave(). Compile
tested only.

Fixes: a3128feef6d5 ("libertas: use irqsave() in USB's complete callback")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221207150008.111743-3-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index 32fdc4150b605..2240b4db8c036 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -637,7 +637,7 @@ static inline void process_cmdrequest(int recvlength, uint8_t *recvbuff,
 	priv->resp_len[i] = (recvlength - MESSAGE_HEADER_LEN);
 	memcpy(priv->resp_buf[i], recvbuff + MESSAGE_HEADER_LEN,
 		priv->resp_len[i]);
-	kfree_skb(skb);
+	dev_kfree_skb_irq(skb);
 	lbs_notify_command_response(priv, i);
 
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
-- 
2.39.2



