Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5C02C1595;
	Tue,  6 Jan 2026 17:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721587; cv=none; b=iG3HtYl86J4EC3Err2FcRrZjIA4rtQJXQ/hHWFqU9Xg+W9auYmwMB51G3fAMOcHWUqQvXMKj6ZQVU5E3KEhtc1VoDitwYjRK+RK6yn8Ja86Xi9NzNfCznjB6qtOFG8ASEmrjPSevLxYLWhZ5xv/eZbcx6OsetCQkEttITJJb1VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721587; c=relaxed/simple;
	bh=Tu+Zj78WEgJYj5sUJVedW8QY+lKnnJ2AGxHE6sOEmk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTpzbnM73HIdhZZvMqaBeZbQ3OnlnCcv7cxM4aN348dlgYXH67vaNSNymBPykyWdWPQOOTr4Q4DZsGOJfWlrI8HqiBKRC2yJer7+biAzGPZQPYUFeH3IVGCrp02Jsmmu0CiYsaYP//9002v6214IXHac6HU+KanX4MHNIwUD8Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3ejMmew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3ejMmew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F58C116C6;
	Tue,  6 Jan 2026 17:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721586;
	bh=Tu+Zj78WEgJYj5sUJVedW8QY+lKnnJ2AGxHE6sOEmk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3ejMmewXyvee4dbRzuNQ9TjDc5tAhRtMgZJdfm15shRQl+GGg4bHF3p2/6P9790m
	 z+VEOLEJjPf0Q8WzdNcgFDetyxMuf8WbUYFztiipdfnsI9GFQpyUU/ad4BuPtqY58q
	 DfFiQxaYOWtXIPZp9Ec6ItBgqEUma+KqR+hsI4Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Morning Star <alexbestoso@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 013/312] wifi: rtlwifi: 8192cu: fix tid out of range in rtl92cu_tx_fill_desc()
Date: Tue,  6 Jan 2026 18:01:27 +0100
Message-ID: <20260106170548.333868369@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Morning Star <alexbestoso@gmail.com>

[ Upstream commit dd39edb445f07400e748da967a07d5dca5c5f96e ]

TID getting from ieee80211_get_tid() might be out of range of array size
of sta_entry->tids[], so check TID is less than MAX_TID_COUNT. Othwerwise,
UBSAN warn:

 UBSAN: array-index-out-of-bounds in drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c:514:30
 index 10 is out of range for type 'rtl_tid_data [9]'

Fixes: 8ca4cdef9329 ("wifi: rtlwifi: rtl8192cu: Fix TX aggregation")
Signed-off-by: Morning Star <alexbestoso@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/1764232628-13625-1-git-send-email-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
index aa702ba7c9f5..d6c35e8d02a5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
@@ -511,7 +511,8 @@ void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 	if (sta) {
 		sta_entry = (struct rtl_sta_info *)sta->drv_priv;
 		tid = ieee80211_get_tid(hdr);
-		agg_state = sta_entry->tids[tid].agg.agg_state;
+		if (tid < MAX_TID_COUNT)
+			agg_state = sta_entry->tids[tid].agg.agg_state;
 		ampdu_density = sta->deflink.ht_cap.ampdu_density;
 	}
 
-- 
2.51.0



