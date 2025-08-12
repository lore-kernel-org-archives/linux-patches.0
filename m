Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADA8221FAC;
	Tue, 12 Aug 2025 17:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021217; cv=none; b=WR+brVA3l6PNciiuqxwEeWJ/oD4NkfEK91Q1gadky95v/Mwog6w4u48vs/hlPVmTXxarch/lPeFQakWjlLNFatgUQX/8x7GCC19ooIU3D1FMppX7qWNsveBTd8BX4HHweaTeuDZVLR1eSyNhg4//34mvH8PQxPoawWYfhl6cJEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021217; c=relaxed/simple;
	bh=gIwpxsZ8zMHPDmxUMd5ePgvj+EAV5o+37PRdUZHxjj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uh5pDcf6LKq1AJ5KqXDj8iFxL8uLW51AHKjaswUzWK6mo3woRjuYzZN4HWu6oQvV5JRDLPvq9K/eoZuRHApu5WsmrCrtiMCHGYlwTgNE8irABE21mV/fXStV4oHOKzwlNCVUkJf/NUPJXxF+eIYBfKHNff69dA7jCZHTSVIk69o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6WQ7Tzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6WQ7Tzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDE4C4CEF0;
	Tue, 12 Aug 2025 17:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021217;
	bh=gIwpxsZ8zMHPDmxUMd5ePgvj+EAV5o+37PRdUZHxjj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6WQ7TzbF4C5gcl+Vb+VyQlek+Qtm+fE6ZrWeB7hjj3KC4Zennrp4QkJYZTl4xs9E
	 uu0DcFJ+q2CRHYBt7v45UTZDt9O4IPoGwpUZ1TZzqx2ZXZ/Zy+o87T103Nw/VISw6f
	 2eg0q323hV/SxnQA3QxFyGDaH6uamRMHCaHcAlLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaistra <martin.kaistra@linutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/262] wifi: rtl8xxxu: Fix RX skb size for aggregation disabled
Date: Tue, 12 Aug 2025 19:27:47 +0200
Message-ID: <20250812172956.403851164@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 05e77d2bda37..03aacb7a4317 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6501,7 +6501,7 @@ static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
 		skb_size = fops->rx_agg_buf_size;
 		skb_size += (rx_desc_sz + sizeof(struct rtl8723au_phy_stats));
 	} else {
-		skb_size = IEEE80211_MAX_FRAME_LEN;
+		skb_size = IEEE80211_MAX_FRAME_LEN + rx_desc_sz;
 	}
 
 	skb = __netdev_alloc_skb(NULL, skb_size, GFP_KERNEL);
-- 
2.39.5



