Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039989;
	b=uOWtA4Fu3DsJ2W1t2NkQcIl8BqGF4RoLug2Yw/mKSv7EOSx+9m+xjAXPlNkRoEbyClL8
	 DUb5QivZtz+Tw1HTrU5CncNRpKirG25CNvbKhMLnagiZjAAEs2pgxzgcJy99slCUuIUb6
	 7ztGDbLgSa9e2+qX9GbX7TwRVm4VtaITGl4pg9yfMH7Hrxlgd0SEMC/w9IT0SKwicwdZg
	 d0ziJTfrb9oDHjn56tc9FhxhHB8kHNs39URMWVR4Jbv6Kr/ItyoWgDIr03sMyTEd1tOEF
	 UjIzK3R5yQ/DOVDlDRLz9X93Hn4TccpPAj+EwsUh3WUVNCOkGSjMDev5keY/06rAEeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jvzkNW6UGm0q28cpHQyJVid+oIAnuox//U45aN/s0iA=;
	b=IShumriZI2x2OhtfX61ARplHDk2jLd4BbVk7SDc/B2vIvDtI9pSFBpNsa58q8SOS3O7u
	 9g4O25GcT3CrEbWND+t3sIfJSq7JsIx31p7guKGhI9xXT6KG8+0PDFY+FVc4xbbL1Hnjz
	 xVaT7xRlFLIcuww/3guBpuBEunzDK7VPWl/2Rb8LvkkeVEG1tFNMMF5718sTetxXffEDb
	 Mod0EN837R7RtZQApdvlHGIbAO4xDNDShRcksYB9eBFHesPCaWWklSII4qGz3vmvcFfeK
	 nMBzP6ZNw3VJFrt3EysaVSoGH1nMznedgyFYK9X7gxeRSM8Jeaj/sSiHK9INJVGO7/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k0eV8nYg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC0A606A31C;
	Wed, 18 Nov 2026 22:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k0eV8nYg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206031F000C4;
	Wed, 18 Nov 2026 22:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039989;
	bh=jvzkNW6UGm0q28cpHQyJVid+oIAnuox//U45aN/s0iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0eV8nYgc71TNzjEXDrVPvBoVqD1WD7mrjPYGUwcbk5cdhnoFBf+EIRVQlX+gdPt3
	 6KQpH4BfP+VGEqf89UK3MXuTh7tMw5Y3OTjBkHJiSFG5PX4dfjq4zQKkgdn4y7HkOz
	 SugQfbcLUD0EGXKXVDNvAnqRsYbWgt3VniFI3tao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kim Wooseok <5mghybrid@khu.ac.kr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2297/3318] wifi: rtl8xxxu: free RX skb when URB submission fails
Date: Wed, 18 Nov 2026 15:48:39 +0100
Message-ID: <20261118150430.633881380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kim Wooseok <5mghybrid@khu.ac.kr>

[ Upstream commit 9f7edf4e8584c87e3c478c6dd87c08d51b5157c2 ]

When usb_submit_urb() fails, rtl8xxxu_submit_rx_urb() unanchors the URB
but leaves the newly allocated skb in urb.context. For ENOMEM/EAGAIN,
the RX worker puts the request back on the pending list. The next
submission allocates another skb and overwrites that pointer, leaking
the previous buffer. Stopping before the retry also leaks it, because
pending-list cleanup frees only the URB.

Free the skb and clear urb.context in rtl8xxxu_submit_rx_urb() when
submission fails. This keeps buffer allocation and failure cleanup in
the same function, so a request returned for retry or teardown no longer
owns an skb. Remove the corresponding cleanup from start and the RX
worker; they only need to decide whether to retry or free the URB.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Assisted-by: GPT-6 Astra
Signed-off-by: Kim Wooseok <5mghybrid@khu.ac.kr>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260921-codex-rtl-rx-v3-submit-v4-1-eeb09fe8f791@khu.ac.kr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c    | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index bbaebdd821c8d..b625de928ebd7 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5856,7 +5856,6 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 	struct rtl8xxxu_priv *priv;
 	struct rtl8xxxu_rx_urb *rx_urb, *tmp;
 	struct list_head local;
-	struct sk_buff *skb;
 	unsigned long flags;
 	int ret;
 
@@ -5888,8 +5887,6 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 		default:
 			dev_warn(&priv->udev->dev,
 				 "failed to requeue urb with error %i\n", ret);
-			skb = (struct sk_buff *)rx_urb->urb.context;
-			dev_kfree_skb(skb);
 			usb_free_urb(&rx_urb->urb);
 		}
 	}
@@ -6503,8 +6500,11 @@ static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
 			  skb_size, rtl8xxxu_rx_complete, skb);
 	usb_anchor_urb(&rx_urb->urb, &priv->rx_anchor);
 	ret = usb_submit_urb(&rx_urb->urb, GFP_ATOMIC);
-	if (ret)
+	if (ret) {
 		usb_unanchor_urb(&rx_urb->urb);
+		dev_kfree_skb(skb);
+		rx_urb->urb.context = NULL;
+	}
 	return ret;
 }
 
@@ -7185,7 +7185,6 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct rtl8xxxu_rx_urb *rx_urb;
 	struct rtl8xxxu_tx_urb *tx_urb;
-	struct sk_buff *skb;
 	unsigned long flags;
 	int ret, i;
 
@@ -7236,13 +7235,8 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 		rx_urb->hw = hw;
 
 		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
-		if (ret) {
-			if (ret != -ENOMEM) {
-				skb = (struct sk_buff *)rx_urb->urb.context;
-				dev_kfree_skb(skb);
-			}
+		if (ret)
 			rtl8xxxu_queue_rx_urb(priv, rx_urb);
-		}
 	}
 
 	schedule_delayed_work(&priv->ra_watchdog, 2 * HZ);
-- 
2.53.0



