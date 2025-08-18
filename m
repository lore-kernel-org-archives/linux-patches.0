Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57FB31B11A;
	Mon, 18 Aug 2025 13:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523065; cv=none; b=s+E/xPQsooQczw6AAIdTi18A4I2DVMu9UFZVNL/zW4zmn8x/9rn3QIea82uiZNJJwBbXJuiuPqzHv7WBKFxgBtPAHCrl+ts82kdQbPJfvRJ4OEbbB3wk/rV3Z7v4H7N8t5zHGnVN+A/eqMaO359bvTMEZDBNIpKUvQF42nD8QoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523065; c=relaxed/simple;
	bh=X57BJ8+AxQRJglQ1QMEIY+91XeGFgOnT36Gxu23al6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQfN+WdrCfur49LA8AxwKZxPskCRWcU8E++FB9K+Q3/p8pj56VxvQRx5+tXB5Np/bw/7eg9WyZkqmlRSnJ/zF4/24Aw9WuV/Z/uQDd+3cT/9o2wlbSWt5Ro5Bue2lyugT2wsoYA7qrlvTIjbt0BayexVTV7mzsVic36Hp8AwgVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkhBXAL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkhBXAL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEABC4CEEB;
	Mon, 18 Aug 2025 13:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523065;
	bh=X57BJ8+AxQRJglQ1QMEIY+91XeGFgOnT36Gxu23al6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkhBXAL+yl1xRlrtq1Dvtr3UjiB8u6ievK2gJ7FKB2KCQ+N6/bb+rT0brFWEr1wsr
	 1FLbXw2k/EHtxlxj7V89m/CEr7JcVxagI94sQgLDx2bVzd4vE5EEYpRLPQbGvVy6K6
	 kPhYGTKiSqp5bRh8NlaiJowZk7yzM7xsDP0Aaapo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 061/515] net: hibmcge: fix the division by zero issue
Date: Mon, 18 Aug 2025 14:40:47 +0200
Message-ID: <20250818124500.758701944@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



