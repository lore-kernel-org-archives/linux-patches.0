Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B55B335BA3;
	Mon, 18 Aug 2025 13:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524909; cv=none; b=hHlixQHbfmlFvD135rpWtRMqN5I1lMFh9H1SQucERjhtI03VwqvyfQKy9wyiVy35UfR4W+h1Kb4VdEQcEdYbAEbz0bWnAO94VZKXJlAQX3x6DPrWQd0XayOhzJ7cepR5JaE/B0bLj3HXiwpLXFY7h7firbTdl+e7ZDjJkV07hAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524909; c=relaxed/simple;
	bh=qzdtJziQ2GXhffLAzPKDDZcc5prK5BliasrvIT7zUPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXOR4XBN3puEeCNPz9y0Wv3V3VP5v9zzv3gdijIGEiA2vmM6Ryl/DZaZ4GzrE2uZ3qbCoP7EfZlb3btDCXIGtAmQObCxJm0PWOxvmIKf0Hf6dLpxaSLRGv/xj2RNEi4sJ0mkwGc5QYqfa0YhxINqmJ6nKmKCki13lRKiRVKX0hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ez8J/5tL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ez8J/5tL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74A8C4CEEB;
	Mon, 18 Aug 2025 13:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524909;
	bh=qzdtJziQ2GXhffLAzPKDDZcc5prK5BliasrvIT7zUPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ez8J/5tLXzWNNucBEIpY5sy7Qrue7XuarvX0GSF2vq49q3qAyRxPo/3OMSTcV6YuB
	 IzEcjolX+3sZipfO4pVJlc3B5WSDJOuN1fJFknTkDuYu4gW9GqrIBg0C03dhl4S8ov
	 13d+fgXbTMJRty3BWjjmHpaHTDmRO2n5TbqacNf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 068/570] net: hibmcge: fix the division by zero issue
Date: Mon, 18 Aug 2025 14:40:55 +0200
Message-ID: <20250818124508.432341812@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 7004b26f0b64331143eb0b312e77a357a11427ce ]

When the network port is down, the queue is released, and ring->len is 0.
In debugfs, hbg_get_queue_used_num() will be called,
which may lead to a division by zero issue.

This patch adds a check, if ring->len is 0,
hbg_get_queue_used_num() directly returns 0.

Fixes: 40735e7543f9 ("net: hibmcge: Implement .ndo_start_xmit function")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.h b/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.h
index 2883a5899ae2..8b6110599e10 100644
--- a/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.h
+++ b/drivers/net/ethernet/hisilicon/hibmcge/hbg_txrx.h
@@ -29,7 +29,12 @@ static inline bool hbg_fifo_is_full(struct hbg_priv *priv, enum hbg_dir dir)
 
 static inline u32 hbg_get_queue_used_num(struct hbg_ring *ring)
 {
-	return (ring->ntu + ring->len - ring->ntc) % ring->len;
+	u32 len = READ_ONCE(ring->len);
+
+	if (!len)
+		return 0;
+
+	return (READ_ONCE(ring->ntu) + len - READ_ONCE(ring->ntc)) % len;
 }
 
 netdev_tx_t hbg_net_start_xmit(struct sk_buff *skb, struct net_device *netdev);
-- 
2.50.1



