Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE850260583;
	Tue, 12 Aug 2025 19:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025850; cv=none; b=AexjXNTw3rxyYLJQHJAAiBS4aG9JUJrFZDzlVXVmfazPtc8GXjyy1bwpnpOngJn8TDEXD+KNgSV/lLiSH8REJkNgzODaSP7sNcrwAQklnatSIrTud6J0uTwXpxoyPzPGTiZaYtuM4vfpKy75A8UIEayNAPnGXHpmOI5/YBSYqT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025850; c=relaxed/simple;
	bh=eFfzTzA/akrf9OXLq7TIopWSxpdlNnrL36dK6QrqvGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJyyGpVviyaiWLyrvsnT/L7DBn72L6uIhpnmSk5X5g1Zs5qIjcgtq0mDKMNAAFDFWKyVqlplDGQrMvFtHiSuXScvvdMazWCngWB76qccw6CS3ZEc2F9aP0O7C1DYy0WSr+dvUX8oOpPqqFI9gR7ZvunPVzZcFxydqRr0X9FApFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHKa1KPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHKa1KPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B528C4CEF0;
	Tue, 12 Aug 2025 19:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025850;
	bh=eFfzTzA/akrf9OXLq7TIopWSxpdlNnrL36dK6QrqvGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHKa1KPUPq8epsX8BtiL4teidZ4XsysBypddq105EuCBp4zsFMxHXWigASf1DEwV0
	 taxq2xciaENZGFIpkJ0ZwwvB8PKcXh7yIgC5+3K3zkh5xTB8XfP6OQNj2E/o621fYd
	 g6bqqDpKkY8AIpeJhx35iuCUlr8dBAjzcvKqnxZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaistra <martin.kaistra@linutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 163/480] wifi: rtl8xxxu: Fix RX skb size for aggregation disabled
Date: Tue, 12 Aug 2025 19:46:11 +0200
Message-ID: <20250812174404.246274264@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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
 drivers/net/wireless/realtek/rtl8xxxu/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 569856ca677f..c6f69d87c38d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -6617,7 +6617,7 @@ static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
 		skb_size = fops->rx_agg_buf_size;
 		skb_size += (rx_desc_sz + sizeof(struct rtl8723au_phy_stats));
 	} else {
-		skb_size = IEEE80211_MAX_FRAME_LEN;
+		skb_size = IEEE80211_MAX_FRAME_LEN + rx_desc_sz;
 	}
 
 	skb = __netdev_alloc_skb(NULL, skb_size, GFP_KERNEL);
-- 
2.39.5



