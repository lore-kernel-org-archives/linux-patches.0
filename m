Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB90352FFA;
	Tue, 26 Aug 2025 14:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218689; cv=none; b=Oz+z6C+itZ7YS/Fe664jgV5Z9JvCB/XA7pDPSsEFjibNaKt3Z2aKZ1lp+d2Di69vLLUX0JtTzXnMqC98XX8kYZR3/vmX3032tEKCZxEiaB0Nr2owyBO+E6o41m+HqDqQMSL+7xB5FPq/iy0Ot6hsyyxP2kGhHsq8Lc3KV905EJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218689; c=relaxed/simple;
	bh=N8xGr8qsFyHU88YCAv/CPHAg8+oYdCmKeWhWa5eAZOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBGdL3j9WNQvI77mgV4Yw66tvx/wVthMdOoEIIQVo1k29By+/I/7Stp8zuV6lh/8PaWwihvMskLt9Iy5K6f/Jl9dRHBqE7SWuUzAXkdURRtF3CukchErr509C/keS+nyotn9zBRtPZ+6J7aoMoIXUXv2j5e/0x0xUsQ0RLUTKno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AfD1ymGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfD1ymGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320BCC113D0;
	Tue, 26 Aug 2025 14:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218689;
	bh=N8xGr8qsFyHU88YCAv/CPHAg8+oYdCmKeWhWa5eAZOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfD1ymGn7kYWE4wRNQmaTvwTjimakPOGGfnKNLQFjtZKnOzg6AfZqw+Dkv0WtRD4O
	 YB/wG+yo8aaB9TS+TFi4n1TSgNp7RZKD8R6GALBupJ7rw11pTakMzTfIiUb9NU5bet
	 vQVn/6SyZ7cfk0qA/6us3g4ufwLCtlKTKZOfzWEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaistra <martin.kaistra@linutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/403] wifi: rtl8xxxu: Fix RX skb size for aggregation disabled
Date: Tue, 26 Aug 2025 13:07:02 +0200
Message-ID: <20250826110909.324188564@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaistra <martin.kaistra@linutronix.de>

[ Upstream commit d76a1abcf57734d2bcd4a7ec051617edd4513d7f ]

Commit 1e5b3b3fe9e0 ("rtl8xxxu: Adjust RX skb size to include space for
phystats") increased the skb size when aggregation is enabled but decreased
it for the aggregation disabled case.

As a result, if a frame near the maximum size is received,
rtl8xxxu_rx_complete() is called with status -EOVERFLOW and then the
driver starts to malfunction and no further communication is possible.

Restore the skb size in the aggregation disabled case.

Fixes: 1e5b3b3fe9e0 ("rtl8xxxu: Adjust RX skb size to include space for phystats")
Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250709121522.1992366-1-martin.kaistra@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 5611f00ef0bd..81d1c544313f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5387,7 +5387,7 @@ static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
 		skb_size = fops->rx_agg_buf_size;
 		skb_size += (rx_desc_sz + sizeof(struct rtl8723au_phy_stats));
 	} else {
-		skb_size = IEEE80211_MAX_FRAME_LEN;
+		skb_size = IEEE80211_MAX_FRAME_LEN + rx_desc_sz;
 	}
 
 	skb = __netdev_alloc_skb(NULL, skb_size, GFP_KERNEL);
-- 
2.39.5



