Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2794F50EBFE;
	Wed, 30 Sep 2026 15:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783353; cv=none; b=WiAnED6vI8qRAc6XQrTaN+prMiz8q3nbUMFUNIAOxj6gL0SB7O64CQI69jBS+dSzKUQr96ZefCoJ8TdODJ7GYVyPUTvMXZm5fk3ZiRxXDj+qdosXPWddodBgXmDMf55sHMnDd7+DeMTjXVfz8S03pQVqQr2iI5fFdLMyvb75wiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783353; c=relaxed/simple;
	bh=XW2OK80j1MFl9vOAG5G18UE4koRoeAw2xKSH4Mh6DnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqljYyqMwfzzmcQYN//5H01lt7xuYPE72F4eyHYJ4Znhc4mlIS0hbMyyk5A6A6q6rWw4RGhogEyorqr4keRsLYXraxH7SrX2yv5tg4UB0ms4FZng98paRJz3KLOQZGUvbedFTJHb4Pm8S4/9Rzr+d7tl/gmhQS+QQXA6zwwqBcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ts86d6fF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ts86d6fF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC631F00898;
	Wed, 30 Sep 2026 15:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783348;
	bh=6DCDWVyVUm3Vrsft9J1iQLGi+yUZM4sGAvevoE+fy/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ts86d6fFZKgeKDT1yXUmlndy7i5U95QM/gA8LOtFV1w/0J1/efYN500iac6iM53Hd
	 qfeOewNKeEdINT7LkoWxyzj8MAn8Qi26naGy496gOct0FgtpA8RZ4zAPhZIVMBhFLf
	 HLUqh8r6HtkFVc/ZbRKY/PsSSrqxd4EbpXnCIEc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mariano Baragiola <mbaragiola@linux.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 368/595] wifi: virt_wifi: free skb when disconnected
Date: Wed, 30 Sep 2026 17:24:21 +0200
Message-ID: <20260930152355.591644614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mariano Baragiola <mbaragiola@linux.com>

[ Upstream commit f9edf7cf63b96d2b776fca8d258d3c5256e40c8e ]

When the simulated link is disconnected, virt_wifi_start_xmit() returns
NET_XMIT_DROP without freeing the skb. dev_hard_start_xmit() treats this
return value as consumed, so every packet sent while disconnected leaks its
skb.

Free the skb before returning the drop status.

Fixes: c7cdba31ed8b ("mac80211-next: rtnetlink wifi simulation device")
Signed-off-by: Mariano Baragiola <mbaragiola@linux.com>
Link: https://patch.msgid.link/20260809124947.3590270-1-mbaragiola@linux.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virt_wifi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
index dd6675436bda6..e6dfb1180b19a 100644
--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
@@ -430,6 +430,7 @@ static netdev_tx_t virt_wifi_start_xmit(struct sk_buff *skb,
 	priv->tx_packets++;
 	if (!priv->is_connected) {
 		priv->tx_failed++;
+		dev_kfree_skb_any(skb);
 		return NET_XMIT_DROP;
 	}
 
-- 
2.53.0



