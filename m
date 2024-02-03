Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A241C1BDED;
	Sat,  3 Feb 2024 04:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933796; cv=none; b=tXbwmCg9c4ez1JGKtkbAhT0XRYnbJiaZjUKg0LlstTmqfQzpY+vkXaeaX8RSDWKxA8yruYjlxqVy/Feyd9loAbF7iIAkT/Sn/NycveYLsmxK2QvsJrwi/fpqUX4PHXPAGQ+bJbkq9EVXjZstIVJcQPR6QT76nux3Nnd5fOB5i00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933796; c=relaxed/simple;
	bh=tIjZUOeRRjOGJk48HcxydNQdHzPq3e3B7XmiGd1L5sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MI574ZSMc3S5B4rf73omF0glSstDx9gCZ9pXaEk5lvzOs9P7zP0XURyRRDIYoNcG1QaZdcKzaewJbNbk/o0tcaHX8gnvIpOn9GFgPpUJFf3Vp7sAz/9PLVbx1MbXt00wY3bTKiCFhfd7MHfpAbJxVO20Q7rLLtVAW1Dsw5Egz6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OshFozEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OshFozEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D65DC43390;
	Sat,  3 Feb 2024 04:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933796;
	bh=tIjZUOeRRjOGJk48HcxydNQdHzPq3e3B7XmiGd1L5sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OshFozEEUmlsuXtW5VCe7dpwB2CIl4Szbuwxp1M9nBbzEKt7F5rfrrouwxN9po1eN
	 T1B2tSQHhHrhwlaPMFZtdJUnA74V9lRlbDeq3Dw4auIv7b2qnUkB+8fg4cmXvABWER
	 Q4LacWKPLYMj8/lZF9+hol3OimEeA66y0i+I6N9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 107/353] wifi: wfx: fix possible NULL pointer dereference in wfx_set_mfp_ap()
Date: Fri,  2 Feb 2024 20:03:45 -0800
Message-ID: <20240203035407.153415115@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit fe0a7776d4d19e613bb8dd80fe2d78ae49e8b49d ]

Since 'ieee80211_beacon_get()' can return NULL, 'wfx_set_mfp_ap()'
should check the return value before examining skb data. So convert
the latter to return an appropriate error code and propagate it to
return from 'wfx_start_ap()' as well. Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Tested-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Acked-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20231204171130.141394-1-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/silabs/wfx/sta.c | 42 ++++++++++++++++-----------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/silabs/wfx/sta.c b/drivers/net/wireless/silabs/wfx/sta.c
index 1b6c158457b4..537caf9d914a 100644
--- a/drivers/net/wireless/silabs/wfx/sta.c
+++ b/drivers/net/wireless/silabs/wfx/sta.c
@@ -336,29 +336,38 @@ static int wfx_upload_ap_templates(struct wfx_vif *wvif)
 	return 0;
 }
 
-static void wfx_set_mfp_ap(struct wfx_vif *wvif)
+static int wfx_set_mfp_ap(struct wfx_vif *wvif)
 {
 	struct ieee80211_vif *vif = wvif_to_vif(wvif);
 	struct sk_buff *skb = ieee80211_beacon_get(wvif->wdev->hw, vif, 0);
 	const int ieoffset = offsetof(struct ieee80211_mgmt, u.beacon.variable);
-	const u16 *ptr = (u16 *)cfg80211_find_ie(WLAN_EID_RSN, skb->data + ieoffset,
-						 skb->len - ieoffset);
 	const int pairwise_cipher_suite_count_offset = 8 / sizeof(u16);
 	const int pairwise_cipher_suite_size = 4 / sizeof(u16);
 	const int akm_suite_size = 4 / sizeof(u16);
+	const u16 *ptr;
 
-	if (ptr) {
-		ptr += pairwise_cipher_suite_count_offset;
-		if (WARN_ON(ptr > (u16 *)skb_tail_pointer(skb)))
-			return;
-		ptr += 1 + pairwise_cipher_suite_size * *ptr;
-		if (WARN_ON(ptr > (u16 *)skb_tail_pointer(skb)))
-			return;
-		ptr += 1 + akm_suite_size * *ptr;
-		if (WARN_ON(ptr > (u16 *)skb_tail_pointer(skb)))
-			return;
-		wfx_hif_set_mfp(wvif, *ptr & BIT(7), *ptr & BIT(6));
-	}
+	if (unlikely(!skb))
+		return -ENOMEM;
+
+	ptr = (u16 *)cfg80211_find_ie(WLAN_EID_RSN, skb->data + ieoffset,
+				      skb->len - ieoffset);
+	if (unlikely(!ptr))
+		return -EINVAL;
+
+	ptr += pairwise_cipher_suite_count_offset;
+	if (WARN_ON(ptr > (u16 *)skb_tail_pointer(skb)))
+		return -EINVAL;
+
+	ptr += 1 + pairwise_cipher_suite_size * *ptr;
+	if (WARN_ON(ptr > (u16 *)skb_tail_pointer(skb)))
+		return -EINVAL;
+
+	ptr += 1 + akm_suite_size * *ptr;
+	if (WARN_ON(ptr > (u16 *)skb_tail_pointer(skb)))
+		return -EINVAL;
+
+	wfx_hif_set_mfp(wvif, *ptr & BIT(7), *ptr & BIT(6));
+	return 0;
 }
 
 int wfx_start_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
@@ -376,8 +385,7 @@ int wfx_start_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	ret = wfx_hif_start(wvif, &vif->bss_conf, wvif->channel);
 	if (ret > 0)
 		return -EIO;
-	wfx_set_mfp_ap(wvif);
-	return ret;
+	return wfx_set_mfp_ap(wvif);
 }
 
 void wfx_stop_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-- 
2.43.0



