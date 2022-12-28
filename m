Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D066B1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AEFC433D2;
	Wed, 28 Dec 2022 16:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243814;
	bh=h0ebuQw6yeNwxYI/mYOm5b0nhaqnrYRwf9i0frYrl+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALG+pfJkgx37uzOtbrcaS57cu98C9ZVHViI3NIZ1nlzCh8fh+8OrpsaN2yfG0Vu0M
	 HRRrPI/ptDLwUG9R4UQt55F7IwGiMxRrqBlCJSSrEfMv2q/2fQhgTwT4Jbm3qCjkkQ
	 JefX3/dBD2UaTwuXZcSrGUu4nranWPyW2DWxSF64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0560/1146] Bluetooth: btusb: dont call kfree_skb() under spin_lock_irqsave()
Date: Wed, 28 Dec 2022 15:34:59 +0100
Message-Id: <20221228144345.379684337@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index f05018988a17..6beafd62d722 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -802,13 +802,13 @@ static inline void btusb_free_frags(struct btusb_data *data)
 
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



