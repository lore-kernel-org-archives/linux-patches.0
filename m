Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA89B19E7F9;
	Mon, 23 Jun 2025 22:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717112; cv=none; b=GT/mu1TgHw8Joz1HX8wkiBp8Jb99gqwnfibEOAUUcjMf7HdDO8PvUiOCoBtkDlPUPvB2J2YVhkaRzjUJVdEt8/p5cIzzbNshcx96Pai96Cfh0D+PYM+7QckuysJHxN4qfGV+lqF+hhEtbADu2Ahk8tsjmGBjddfenIcXNZmQecM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717112; c=relaxed/simple;
	bh=Ar4phHCW1MhhMno7fVSCJnsREEJr+E/lRH7Xd5ag2ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZmePGlqBeqwrvQQLFIwvOp4Qv07C0s7JYCvHLonfQxgPC42cuScyOgBsoWgitWy/aKpaCcuSjTWyGI3l0E3fJEoCddxygOsWUgotUXkKFzzEMQo2BpBzdB9zk15znZ9rEKYMWxMwWCUNLwhRXnTWKdxln671LQvskuQMeJLKig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jm422E0A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jm422E0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77ADDC4CEEA;
	Mon, 23 Jun 2025 22:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717111;
	bh=Ar4phHCW1MhhMno7fVSCJnsREEJr+E/lRH7Xd5ag2ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jm422E0AR66DYTBVCkZirKNkrVjrf8CO/ZdP6Xr2OMrbCwJCc19YMh3AEkzfVKMjc
	 ksVsKTq4naZQ9QdfDZSGr67A9I2O0oFBxDIH3e56cGVOxo6w4CDIh7xNaXD8iPHWs0
	 Bn7qxPuxG7UJYxWNnTTlvrUq6DjIPgukw/BlzbWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Zenm Chen <zenmchen@gmail.com>
Subject: [PATCH 6.12 325/414] wifi: rtw89: phy: add dummy C2H event handler for report of TAS power
Date: Mon, 23 Jun 2025 15:07:42 +0200
Message-ID: <20250623130650.119403520@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

commit 09489812013f9ff3850c3af9900c88012b8c1e5d upstream.

The newer firmware, lik RTL8852C version 0.27.111.0, will notify driver
report of TAS (Time Averaged SAR) power by new C2H events. This is to
assist in higher accurate calculation of TAS.

For now, driver doesn't use the report yet, so add a dummy handler to
avoid it throws info like:
   rtw89_8852ce 0000:03:00.0: c2h class 9 func 6 not support

Also add "MAC" and "PHY" to the message to disambiguate the source of
C2H event.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241209042127.21424-1-pkshih@realtek.com
Signed-off-by: Zenm Chen <zenmchen@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/mac.c |    4 ++--
 drivers/net/wireless/realtek/rtw89/phy.c |   10 ++++++++--
 drivers/net/wireless/realtek/rtw89/phy.h |    1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -5513,11 +5513,11 @@ void rtw89_mac_c2h_handle(struct rtw89_d
 	case RTW89_MAC_C2H_CLASS_FWDBG:
 		return;
 	default:
-		rtw89_info(rtwdev, "c2h class %d not support\n", class);
+		rtw89_info(rtwdev, "MAC c2h class %d not support\n", class);
 		return;
 	}
 	if (!handler) {
-		rtw89_info(rtwdev, "c2h class %d func %d not support\n", class,
+		rtw89_info(rtwdev, "MAC c2h class %d func %d not support\n", class,
 			   func);
 		return;
 	}
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -3062,10 +3062,16 @@ rtw89_phy_c2h_rfk_report_state(struct rt
 		    (int)(len - sizeof(report->hdr)), &report->state);
 }
 
+static void
+rtw89_phy_c2h_rfk_log_tas_pwr(struct rtw89_dev *rtwdev, struct sk_buff *c2h, u32 len)
+{
+}
+
 static
 void (* const rtw89_phy_c2h_rfk_report_handler[])(struct rtw89_dev *rtwdev,
 						  struct sk_buff *c2h, u32 len) = {
 	[RTW89_PHY_C2H_RFK_REPORT_FUNC_STATE] = rtw89_phy_c2h_rfk_report_state,
+	[RTW89_PHY_C2H_RFK_LOG_TAS_PWR] = rtw89_phy_c2h_rfk_log_tas_pwr,
 };
 
 bool rtw89_phy_c2h_chk_atomic(struct rtw89_dev *rtwdev, u8 class, u8 func)
@@ -3119,11 +3125,11 @@ void rtw89_phy_c2h_handle(struct rtw89_d
 			return;
 		fallthrough;
 	default:
-		rtw89_info(rtwdev, "c2h class %d not support\n", class);
+		rtw89_info(rtwdev, "PHY c2h class %d not support\n", class);
 		return;
 	}
 	if (!handler) {
-		rtw89_info(rtwdev, "c2h class %d func %d not support\n", class,
+		rtw89_info(rtwdev, "PHY c2h class %d func %d not support\n", class,
 			   func);
 		return;
 	}
--- a/drivers/net/wireless/realtek/rtw89/phy.h
+++ b/drivers/net/wireless/realtek/rtw89/phy.h
@@ -151,6 +151,7 @@ enum rtw89_phy_c2h_rfk_log_func {
 
 enum rtw89_phy_c2h_rfk_report_func {
 	RTW89_PHY_C2H_RFK_REPORT_FUNC_STATE = 0,
+	RTW89_PHY_C2H_RFK_LOG_TAS_PWR = 6,
 };
 
 enum rtw89_phy_c2h_dm_func {


