Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F2B3346AF;
	Fri,  9 Jan 2026 12:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960811; cv=none; b=Sv0AICcCWMiynXBChVAsRmKvntyJc1mciMwviTzp4E+e/uYeoJetHYI55+ti94NRwUt+Vt6mw+WFvDRcyjCjXpKZIHnaI7u59SJoMVTbZOiFLocC5EJW7OUKrZraBnaxsWyk+mK4oDAmZKvPSm+jHDFUxslTs9efBKMyKwjoSos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960811; c=relaxed/simple;
	bh=+jUVSiTvw0/s661JvwLa2ASO875HcYdbpu6II1D2tXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lhat9mWqWMcfbBTNifsgnQ1xee9uXOULs0s985IMAKKb+PJ/y88sUuD3TfO/mRtYYb5+lePhsy9UBGcDvuH0f6FP1OUFCXSL5p8n3g06Q5IE4HL91by9MYpPWEJEqCzEUP8L+YPp35SgEe/8Mqs7sRq93KJoXAhKWp3a6FkqLns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdoBDHdw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdoBDHdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780AEC4CEF1;
	Fri,  9 Jan 2026 12:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960810;
	bh=+jUVSiTvw0/s661JvwLa2ASO875HcYdbpu6II1D2tXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdoBDHdwu+cMyqZUfzvoZ1MTs6J/xFs0WC3LK2zDvy2jZ1Opwiii5+tGbWDDWYrNR
	 Vjk7mUG0vncEPrSa3KY70KitpMgXcuddnWUjSJGWrlRsyTa9AGngU39KpItE0Z1bqs
	 Aw2aHGEsR5S4/pfr+1IfaTL4nBSJZffpCkfBXI5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 501/737] wifi: rtw88: limit indirect IO under powered off for RTL8822CS
Date: Fri,  9 Jan 2026 12:40:40 +0100
Message-ID: <20260109112152.840567592@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit f3ccdfda345ca9a624ea425840a926b8338c1e25 ]

The indirect IO is necessary for RTL8822CS, but not necessary for other
chips. Otherwiese, it throws errors and becomes unusable.

 rtw88_8723cs mmc1:0001:1: WOW Firmware version 11.0.0, H2C version 0
 rtw88_8723cs mmc1:0001:1: Firmware version 11.0.0, H2C version 0
 rtw88_8723cs mmc1:0001:1: sdio read32 failed (0xf0): -110
 rtw88_8723cs mmc1:0001:1: sdio write8 failed (0x1c): -110
 rtw88_8723cs mmc1:0001:1: sdio read32 failed (0xf0): -110

By vendor driver, only RTL8822CS and RTL8822ES need indirect IO, but
RTL8822ES isn't supported yet. Therefore, limit it to RTL8822CS only.

Reported-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/07a32e2d6c764eb1bd9415b5a921a652@realtek.com/T/#m997b4522f7209ba629561c776bfd1d13ab24c1d4
Fixes: 58de1f91e033 ("wifi: rtw88: sdio: use indirect IO for device registers before power-on")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Tested-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Link: https://patch.msgid.link/1764034729-1251-1-git-send-email-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index df4248744d87..025a97526551 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -143,8 +143,10 @@ static u32 rtw_sdio_to_io_address(struct rtw_dev *rtwdev, u32 addr,
 
 static bool rtw_sdio_use_direct_io(struct rtw_dev *rtwdev, u32 addr)
 {
+	bool might_indirect_under_power_off = rtwdev->chip->id == RTW_CHIP_TYPE_8822C;
+
 	if (!test_bit(RTW_FLAG_POWERON, rtwdev->flags) &&
-	    !rtw_sdio_is_bus_addr(addr))
+	    !rtw_sdio_is_bus_addr(addr) && might_indirect_under_power_off)
 		return false;
 
 	return !rtw_sdio_is_sdio30_supported(rtwdev) ||
-- 
2.51.0



