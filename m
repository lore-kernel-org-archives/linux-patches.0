Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585903;
	b=HprR8gbQ7mm/iAnzrrxSvpL9U4TRm+t8gFwmplbyerXEm+Hv543s91AC5l6MJAID2ya0
	 iHR45p5qnCuCdEnbL8ETt0UBV53YdtD1HCPIrfLmyTm2bHFtPl+wMOn/jkiewmd7vtwO4
	 rUZHT8ty9bKB5aBXXufr0aCC454VcwKXVp5QeV76DiI+65bes34OipLeYWCIVK+JH7npt
	 2bhR15bCnqIANWJyyTBy2R42bfAIZm/+3tBThzFsHvMSEPWMMkQn8CRRYske5CRA2dRS1
	 f0/zZsAp/5PHJRueeWexk/nkfxFIt5C0M1CelJlAjO4SnGvdXR8MBrVWyFI3O7mrwUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G23NZklRN2YqbPLxy50YJhT54IaAo5G9NQGVWcXQxH4=;
	b=KCpiIAQdlPnZJY5rync8vcTM0sjUoD3hiPbdnVDosTKtTDkkB2IDz1lptu9h6FlMD1tF
	 TmVk39DmlhsB7t3ecSJNDIdTUNTqRue8G88p0CqYYsvZEd8FgFH7whl+cEnrLmFGD7zGT
	 cPtbDltF3BBVR4a8uzCHZDtlYvxa9ZC9ylgT6miVsGORdSv3fVa1cipgtAu4zMM1DgYNM
	 AZSanZeZfZ+50kfufNFTWk2jAfJun40ixxiozVHGvYLv1fFqf3yjYuQU8mHo/ua8in7uQ
	 v3+kElkhkr93lA6SQ0apKMWR9KcVNB4a3s7q8w0qHqMKuXEvI09F6h0oKzI4bW8Vxtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=runyNXTU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71656070957;
	Fri, 13 Nov 2026 16:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=runyNXTU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC0F1F00936;
	Fri, 13 Nov 2026 16:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585903;
	bh=G23NZklRN2YqbPLxy50YJhT54IaAo5G9NQGVWcXQxH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=runyNXTUgr6iwoCS7iwhsuOTzuo/PL6Lo6VHO1l/p4jOl0hfLPYWnX1IckhY8Gx9Y
	 jB72jKfk95gbqC8jKT4SLOVVHpMvbyBsXsMYeaWXp4+3S8Um1/FFcHWwO87BCTqKGV
	 aglhVwyia/1PjAzHQYbXwcNDW0gpxNzl3EM2Q+qU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 469/507] wifi: rtw88: widen the ATIM window while an AP interface is up
Date: Fri, 13 Nov 2026 10:52:53 -0500
Message-ID: <20261113153812.644878410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

[ Upstream commit cf8b516f67652f550e040951b88a2040b375afcf ]

The frames held for dozing stations go out right after the DTIM beacon
and only for the duration of the ATIM window. The chips come up with a
2 TU window (the two that program it set 0x2 at init), which drains
about three frames per DTIM; the vendor driver sets 0xa or 0xc in AP
mode instead. With the 2 TU window the measured page pool exhaustion
takes ~100 s of ordinary multicast chatter; at 0x4 the same storm
already drains, so 0xa leaves comfortable headroom.

Program 0xa when an AP interface starts and put the default back when
it stops, since most chips never initialize the register themselves.
The bound and the filter of the previous patches still apply: the
window adds drain capacity, the budget protects the pool when that is
not enough, the filter keeps chatter off the beacon-paced path.

Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260910081716.769081-4-mehmet.fide@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 2 ++
 drivers/net/wireless/realtek/rtw88/reg.h      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 0b622d7663b66..2a9b09fa76e7e 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -474,6 +474,7 @@ static int rtw_ops_start_ap(struct ieee80211_hw *hw,
 
 	mutex_lock(&rtwdev->mutex);
 	rtw_write32_set(rtwdev, REG_TCR, BIT_TCR_UPDATE_HGQMD);
+	rtw_write16(rtwdev, REG_ATIMWND, ATIMWND_AP);
 	rtwdev->ap_active = true;
 	rtw_store_op_chan(rtwdev, true);
 	chip->ops->phy_calibration(rtwdev);
@@ -490,6 +491,7 @@ static void rtw_ops_stop_ap(struct ieee80211_hw *hw,
 
 	mutex_lock(&rtwdev->mutex);
 	rtw_write32_clr(rtwdev, REG_TCR, BIT_TCR_UPDATE_HGQMD);
+	rtw_write16(rtwdev, REG_ATIMWND, ATIMWND_DEFAULT);
 	rtwdev->ap_active = false;
 	if (!rtw_core_check_sta_active(rtwdev))
 		rtw_clear_op_chan(rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 08e9494977e06..0b9ba6f37680b 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -483,6 +483,8 @@
 #define REG_DRVERLYINT		0x0558
 #define REG_BCNDMATIM		0x0559
 #define REG_ATIMWND		0x055A
+#define ATIMWND_DEFAULT		0x2
+#define ATIMWND_AP		0xa
 #define REG_USTIME_TSF		0x055C
 #define REG_BCN_MAX_ERR		0x055D
 #define REG_RXTSF_OFFSET_CCK	0x055E
-- 
2.53.0



