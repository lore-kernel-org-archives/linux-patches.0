Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A356E46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04124C433EF;
	Mon, 16 Jan 2023 16:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885932;
	bh=WDWVJsU54yrKIMxl39Xh66r9MI1mM4lWGsO59b5hmDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeI+1ZpiCeLXd7LkQVSqx3Gy65HmKBHdWGYPM5zifivdgY94GP4JyZWCVBrx+Xp1Y
	 HJMCRUtrGVQtNkPFOSwCIkb+lRPyWH2Z4zGv/OqwfqKBDQV9vhNfsdPewrq8VKCXAC
	 9/n+J+OMBXhwAFnjGNPFPT8JttqghhiNYS2tdnXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 238/658] Bluetooth: RFCOMM: dont call kfree_skb() under spin_lock_irqsave()
Date: Mon, 16 Jan 2023 16:45:26 +0100
Message-Id: <20230116154920.439851640@linuxfoundation.org>
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

[ Upstream commit 0ba18967d4544955b2eff2fbc4f2a8750c4df90a ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave().

Fixes: 81be03e026dc ("Bluetooth: RFCOMM: Replace use of memcpy_from_msg with bt_skb_sendmmsg")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/rfcomm/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 83a8c48dfaa8..2db9e285215c 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -594,7 +594,7 @@ int rfcomm_dlc_send(struct rfcomm_dlc *d, struct sk_buff *skb)
 
 		ret = rfcomm_dlc_send_frag(d, frag);
 		if (ret < 0) {
-			kfree_skb(frag);
+			dev_kfree_skb_irq(frag);
 			goto unlock;
 		}
 
-- 
2.35.1



