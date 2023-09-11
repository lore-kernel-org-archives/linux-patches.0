Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE55F11715
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C01DC433C8;
	Mon, 11 Sep 2023 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445015;
	bh=YzUHiHx3PKexEoBvdiVgtNQW0jsPPrpHe7jkrLm/xFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cn6f+n6pyosdZrcXyVZydy85cZN/gFs619qCPBqPRYjANvRJKCsH0JwHbnw+eaX1i
	 FNCnhwJqyyheH7EFFpi8Ia7CxmVavx8QyKEpF8KhHaWxANZnueXF8Ig8+LDBMVgb/b
	 e3hYPKKVDUnecww91HgO3RSQCbWgnlBOb+fNRPU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/600] Bluetooth: btusb: Do not call kfree_skb() under spin_lock_irqsave()
Date: Mon, 11 Sep 2023 15:43:49 +0200
Message-ID: <20230911134639.404732650@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 2a05334d7f91ff189692089c05fc48cc1d8204de ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with hardware interrupts being disabled.
So replace kfree_skb() with dev_kfree_skb_irq() under
spin_lock_irqsave(). Compile tested only.

Fixes: baac6276c0a9 ("Bluetooth: btusb: handle mSBC audio over USB Endpoints")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index d6f405763c56f..f2062c2a28da8 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1984,7 +1984,7 @@ static int btusb_switch_alt_setting(struct hci_dev *hdev, int new_alts)
 		 * alternate setting.
 		 */
 		spin_lock_irqsave(&data->rxlock, flags);
-		kfree_skb(data->sco_skb);
+		dev_kfree_skb_irq(data->sco_skb);
 		data->sco_skb = NULL;
 		spin_unlock_irqrestore(&data->rxlock, flags);
 
-- 
2.40.1



