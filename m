Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEA934AB0D;
	Tue, 26 Aug 2025 14:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217348; cv=none; b=Q3xwhBqpMiyyIShVQ5yJGrmwdR4UXAqvsmQAGic2DUg33pNbqz1AAgbGcD0sJA0in/Z4bYTX4ARv5t5mRfic05Qyhn9pXbi6oeMiUujDvkC0tzhEba4HV2inRgn3W6Vy9feHa7BbS7mbztBWoRbSmlBsIcSRDyxv2rVP1Z6i4PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217348; c=relaxed/simple;
	bh=rjP+RyjvnwXvzARTuKy0y42NKA5hXM1isyWTOCcjsr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRd78EYj61rCWN7F/WZmvCyrtyZlwDF9CsMatStiSKiLwuyq8uwuEWg4zRjOnzYdfyIHsmnldnjhdymNRs5pN9xAKiAzV10Icu2YzUHyBQUkBSY504PYDOKcUtmtJPfJXTTyTVNpoXK8Zzw0WbVii7MSmeIiYt5dK1C9os4GqLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8GqkA/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8GqkA/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E932C113D0;
	Tue, 26 Aug 2025 14:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217348;
	bh=rjP+RyjvnwXvzARTuKy0y42NKA5hXM1isyWTOCcjsr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8GqkA/FiHwARemUgOOnyYgibJzPPn8KPsjRgZjgxBsiqZqrnbIjaIYf1567csNZq
	 c8w6AXolXkBdFrFxfriOCDVhKqLbD6J5ZqsUsN1c+QBURZ9oggnWibsQ0RDMiSco+D
	 nczlwkg7KHuRJh23C6afpmo2egmH2hJlzGvF/nVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaistra <martin.kaistra@linutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/523] wifi: rtl8xxxu: Fix RX skb size for aggregation disabled
Date: Tue, 26 Aug 2025 13:05:20 +0200
Message-ID: <20250826110927.242783600@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5b27c22e7e58..7cf2693619c9 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5794,7 +5794,7 @@ static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
 		skb_size = fops->rx_agg_buf_size;
 		skb_size += (rx_desc_sz + sizeof(struct rtl8723au_phy_stats));
 	} else {
-		skb_size = IEEE80211_MAX_FRAME_LEN;
+		skb_size = IEEE80211_MAX_FRAME_LEN + rx_desc_sz;
 	}
 
 	skb = __netdev_alloc_skb(NULL, skb_size, GFP_KERNEL);
-- 
2.39.5



