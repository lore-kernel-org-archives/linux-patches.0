Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66801FBE4;
	Sat,  3 Feb 2024 04:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933368; cv=none; b=V0FpfsVQn44ZQZMPfLQSZwfNd3lmjKzzyZgTQQwF9kTOlKAjNpyw+5KRgoHT3a9TGmIaWbvcx76fTNYgw6AryjtnzPSZALVj1oJce0ihBWnqT9y/HQHJz53Ao8hm/4BOaw5W4kGQ5HN+UUkX0NhK7jsKo79H93ceG+4b0JxD3e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933368; c=relaxed/simple;
	bh=mVgOKmx4HRqFpJ9F1bkpkyeGHl+6LMv/Ln13e4z4GJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K+qhSFpO1tWkOs1IGUlG8IKbyhHY88WoFCkvcazds7M/2Wm6AmQj2RJGKSDFlQakDNZFSE2VzJjUzIPtnkiXhwCjz6dgZVzhdex9OYUB8Y9LXK/tEHEUmG8Xdl1NdUatfmsX3WGP1pl+xRbNSeuAZGL6UFnC0XMD4H5q+ZaL7Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnC8fnLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnC8fnLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8443C43390;
	Sat,  3 Feb 2024 04:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933367;
	bh=mVgOKmx4HRqFpJ9F1bkpkyeGHl+6LMv/Ln13e4z4GJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnC8fnLmowbWuymLOT8HCvsi5VNuTE38UCKhY2rwMcp1ixLq7Ity4arPGy790NYbA
	 8gaBSC7R3ue07QQnnVejxMefeG6HNBam6w2LamPT5AOYixbO1PamI+w6KsZTZjkXE0
	 PIZ6YOH5nra34e5ujvp8t2vdpnn3vVe960nehKkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/219] wifi: wfx: fix possible NULL pointer dereference in wfx_set_mfp_ap()
Date: Fri,  2 Feb 2024 20:04:00 -0800
Message-ID: <20240203035326.211859516@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 626dfb4b7a55..073e870b2641 100644
--- a/drivers/net/wireless/silabs/wfx/sta.c
+++ b/drivers/net/wireless/silabs/wfx/sta.c
@@ -354,29 +354,38 @@ static int wfx_upload_ap_templates(struct wfx_vif *wvif)
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
@@ -394,8 +403,7 @@ int wfx_start_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
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



