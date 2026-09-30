Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9B63DEFE7;
	Wed, 30 Sep 2026 19:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795954; cv=none; b=RPOiSZpoOgT2bpMZTyj77qyLGxhx7bX3Uh95Ec+GuBKdF+2DhJ0v9RNyC4TI8Yc3s7Vch6CqnWTs4FugxRr/zbi5WSywIyrhEiQkByvldQgo9jZ9KegWAlgDcAwLh0AyKknYroYBECsNbdPTM5ZH7DLO5/ntquGJqMkbUcNKwF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795954; c=relaxed/simple;
	bh=zAhiKadNdWcPFbhuTXW6U6cIO+4txfhJy4vrcAWpzDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJoK1a9hNJpd7d5xDWJlf7k3NI8CD/ali6TXV1fOo1N/Ho3vp7t84jrcd2Q4nGEeiGwLoVujhLFBG0TVmVtjU182ii2dpZmCkGFSVHcsbGGxS/zgjSEcHEqs7z/6PTJcGhGXLdQFCZa+CDVCrBMlqvGQboTvTNTpFgUQFOpWhUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fB32fX8p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fB32fX8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CB11F000FF;
	Wed, 30 Sep 2026 19:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795952;
	bh=SbEgUf4uM1QcDiMOGt/vERMxPHj813z6hKJ9DTFtOWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fB32fX8pQNMsgKuyQjKPqmx7NatEBXeNJcW64/9qxKzuCT4RJXWpoL74MY9W2B8Db
	 sT8W4WpU5qflrbphZcbMMJ5T2WGr2vows9qS4RqvrhyxjQIWsRv64WPxowYayLHC0i
	 /ffEpUYRM3Hl6X9PRTZfOZqJDkSohWYa9ew16CWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mariano Baragiola <mbaragiola@linux.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0741/1193] wifi: virt_wifi: free skb when disconnected
Date: Wed, 30 Sep 2026 17:23:45 +0200
Message-ID: <20260930152450.713366667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/wireless/virtual/virt_wifi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/virtual/virt_wifi.c b/drivers/net/wireless/virtual/virt_wifi.c
index 55b2d44e4315f..41a81642688d4 100644
--- a/drivers/net/wireless/virtual/virt_wifi.c
+++ b/drivers/net/wireless/virtual/virt_wifi.c
@@ -432,6 +432,7 @@ static netdev_tx_t virt_wifi_start_xmit(struct sk_buff *skb,
 	priv->tx_packets++;
 	if (!priv->is_connected) {
 		priv->tx_failed++;
+		dev_kfree_skb_any(skb);
 		return NET_XMIT_DROP;
 	}
 
-- 
2.53.0



