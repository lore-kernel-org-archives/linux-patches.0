Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9506136D4E1;
	Wed, 30 Sep 2026 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792042; cv=none; b=WMu7ZNjeIZBGfuyg1rdH5jZdUbZQynjilCGNeNIEU/wPtMkEY/SituIwgK8tUSi7frvtqiYRv5A+TrO8yaLZ3CFVbEVgGiL0a+DLwYXlYsQjmXUwrL6M5aSG4rIax7uQLdN91VjUl2K4/klbmsOkSg00VYau7lHuMBo6H49WTH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792042; c=relaxed/simple;
	bh=+dkVMS1Hg5DgvCA0GvhHjRZZifXnbVyZ+ix9VtjJCSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmtavvY1EdWkXIgByFV0IjZ47U7WcH+0uyXkQAeuwnX6fVMqd56NkDpQfolh2bE2lSIiupRjD2FQQbuz8CbJCJMExwF8KjiYwItDY4ZQZ1rDsRZqW/4hXltu5Xy1dzV3y7qpuv4BcfeyxIOARcCzKCcvTXORijs53MmwPodXomM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XA3tfFYQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XA3tfFYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0341F000FF;
	Wed, 30 Sep 2026 18:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792041;
	bh=noiKusiPi+1ZVf+kNgx/N9Xmi1ZRSHKbHm6AqkS2V1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XA3tfFYQn7zNoEvGk8vNn6I0f45pIy8VTC8Wm6JfxfBnGiqTXssX+vTRm+8YLle2w
	 BzMIVaGK6zZBq6eiSEKIEzWZGM1wqWugmOLYiyhZbGVZUEAud+VIhi1QS05mkWJXYC
	 yNtVn/6OMzMp9JP++jAAXfy5iHlv4h3b12MPtESE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mariano Baragiola <mbaragiola@linux.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 460/752] wifi: virt_wifi: free skb when disconnected
Date: Wed, 30 Sep 2026 17:25:30 +0200
Message-ID: <20260930152408.231177051@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4dca9827a4203..4302219d184d0 100644
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



