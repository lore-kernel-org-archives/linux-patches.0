Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4E2355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301070; cv=none; b=ArKOzM6P+lKODigZllOx5bw0gfk6pG4MSIb0TAyAimecY3NVcvT4/mkxjRf7MDuOKRdb56tRO1NK34Jd4LJkdkM+QnsxwYLu3iHev4JfEi1ahvjiv4v/FLTyjj+mdxYCniMM2AMXBJBEGYukzBWuXqvfMi3LyDkhiL4fBdljtik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301070; c=relaxed/simple;
	bh=CqTb2ncDZyCvY79JtpCtWTkhOpSciKWJvwe2gLjveiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQ0N9jGkSbk3rGFaV2YJTgfryENPkmOmvNh+9IHbcGSyM0o1DPx3qgeLGsHAMCn4XaVbEeq6Beeovt0exaKgZryvInowSsIn0v9J9XK3aJufXifid58n7pEXbCm5VXj4HTn/mk2INQyFG+ylY1AHCJ8gCKs8ZxvCx8RDhZuCOy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OIrlXQr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OIrlXQr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E66C19424;
	Sat, 28 Feb 2026 17:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301070;
	bh=CqTb2ncDZyCvY79JtpCtWTkhOpSciKWJvwe2gLjveiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OIrlXQr0cNGIAjeJ3ZIZOcpVbgSTBTTM0xmi6DfnMicRMvdN9Wo9hr995C6Ls1sOs
	 IjiaGFhibZRwOJCWV0LwWMBZd577Z6aBER76Vg0z/XIyZk/+LsDd6VHhd6IDFFZu4n
	 Ot9QS1ftVbJgxwN55tqxC+JCn57oSvNHqo9kwsBE86Zq6h0o3UgGpghVxZhVbWc1ox
	 Gvyz9/m+NWe23P/j9ualDVPdHKsFden4UQY04AlXvs2vRPnWMHq8MJBqZ6F1o2WU9A
	 +whRLHeUrQOYjyv0uqhBkHu50Zgq15zDrF9gQYNTx8RKL5czAWwdSfQ3XnBAzMK0ZQ
	 hfr40wf+Ztf3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Roman Peshkichev <roman.peshkichev@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 214/752] wifi: rtw88: fix DTIM period handling when conf->dtim_period is zero
Date: Sat, 28 Feb 2026 12:38:45 -0500
Message-ID: <20260228174750.1542406-214-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Roman Peshkichev <roman.peshkichev@gmail.com>

[ Upstream commit 9f68fdcdc9dbf21be2a48feced90ff7f77d07443 ]

The function rtw_set_dtim_period() accepted an 'int' dtim_period parameter,
while mac80211 provides dtim_period as 'u8' in struct ieee80211_bss_conf.
In IBSS (ad-hoc) mode mac80211 may set dtim_period to 0.

The driver unconditionally wrote (dtim_period - 1) to
REG_DTIM_COUNTER_ROOT, which resulted in 0xFF when dtim_period was 0. This
caused delays in broadcast/multicast traffic processing and issues with
ad-hoc operation.

Convert the function parameter to u8 to match ieee80211_bss_conf and avoid
the underflow by writing 0 when dtim_period is 0.

Link: https://github.com/lwfinger/rtw88/issues/406
Signed-off-by: Roman Peshkichev <roman.peshkichev@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251125180937.22977-1-roman.peshkichev@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 4 ++--
 drivers/net/wireless/realtek/rtw88/main.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index d93d21656f26c..f72d12c3b2bc6 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -730,10 +730,10 @@ void rtw_set_rx_freq_band(struct rtw_rx_pkt_stat *pkt_stat, u8 channel)
 }
 EXPORT_SYMBOL(rtw_set_rx_freq_band);
 
-void rtw_set_dtim_period(struct rtw_dev *rtwdev, int dtim_period)
+void rtw_set_dtim_period(struct rtw_dev *rtwdev, u8 dtim_period)
 {
 	rtw_write32_set(rtwdev, REG_TCR, BIT_TCR_UPDATE_TIMIE);
-	rtw_write8(rtwdev, REG_DTIM_COUNTER_ROOT, dtim_period - 1);
+	rtw_write8(rtwdev, REG_DTIM_COUNTER_ROOT, dtim_period ? dtim_period - 1 : 0);
 }
 
 void rtw_update_channel(struct rtw_dev *rtwdev, u8 center_channel,
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 43ed6d6b42919..1ab70214ce36e 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -2226,7 +2226,7 @@ enum nl80211_band rtw_hw_to_nl80211_band(enum rtw_supported_band hw_band)
 }
 
 void rtw_set_rx_freq_band(struct rtw_rx_pkt_stat *pkt_stat, u8 channel);
-void rtw_set_dtim_period(struct rtw_dev *rtwdev, int dtim_period);
+void rtw_set_dtim_period(struct rtw_dev *rtwdev, u8 dtim_period);
 void rtw_get_channel_params(struct cfg80211_chan_def *chandef,
 			    struct rtw_channel_params *ch_param);
 bool check_hw_ready(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 target);
-- 
2.51.0

