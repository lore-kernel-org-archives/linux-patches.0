Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5711D0E24;
	Wed,  2 Oct 2024 14:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878847; cv=none; b=WXjWOYIfHxXxBQ/78EmLxCnvozRwT1TMRnI/M8c3zNDa+3C1OdOQ0Y07ykRLX9fG5e/Iy6wyVLMHC7CFmYGAdVYrbvqEF4X+AHepga2mctQ6A1NrGV8O8aY4/ARbh2sPfewgKGFWhqDKKRv0h/T6EWae1qQlt0i/fv6KsGxuMjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878847; c=relaxed/simple;
	bh=GqvpvuU7k6bF80BsziqfAkZ92giUJlQ7y7yN5CeQ98o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvdGbVvgjRjvbX4RiBVijyVvJI0dJHt2bOlGiNk/Fnr3Z3Vx4yiF8i+uXzC7mo0095GwW71p0lPrzPlQTAHe2DPmg7JudkTYb0Ye7LzGL8mzLjwfSyHRrzp01r8DY2Xm33cZ442V/lVnj8zCD4/oNtiImrFJSzR1OjwQ2/rmfvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omk10pG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omk10pG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A25C4CEC5;
	Wed,  2 Oct 2024 14:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878846;
	bh=GqvpvuU7k6bF80BsziqfAkZ92giUJlQ7y7yN5CeQ98o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omk10pG3xggzbgs6L+E/cTu2AD96mEiUpqi62/jwYka9lAQB3NkAtZL3TF7M1LOhs
	 8fuDrykfTY3VN7DWlf90l4kWqiiVlPstCvoqzgIOA9fC6pG+JYCMhTBDGrIIKk7QBv
	 ut0AG84aCqUJBNjTx+A5ZvKSRdv/CduyNdbCEpOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.10 553/634] wifi: rtw88: 8822c: Fix reported RX band width
Date: Wed,  2 Oct 2024 15:00:53 +0200
Message-ID: <20241002125832.938249774@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

commit a71ed5898dfae68262f79277915d1dfe34586bc6 upstream.

"iw dev wlp2s0 station dump" shows incorrect rx bitrate:

tx bitrate:     866.7 MBit/s VHT-MCS 9 80MHz short GI VHT-NSS 2
rx bitrate:     86.7 MBit/s VHT-MCS 9 VHT-NSS 1

This is because the RX band width is calculated incorrectly. Fix the
calculation according to the phydm_rxsc_2_bw() function from the
official drivers.

After:

tx bitrate:     866.7 MBit/s VHT-MCS 9 80MHz short GI VHT-NSS 2
rx bitrate:     390.0 MBit/s VHT-MCS 9 80MHz VHT-NSS 1

It also works correctly with the AP configured for 20 MHz and 40 MHz.

Tested with RTL8822CE.

Cc: stable@vger.kernel.org
Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/bca8949b-e2bd-4515-98fd-70d3049a0097@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -2611,12 +2611,14 @@ static void query_phy_status_page1(struc
 	else
 		rxsc = GET_PHY_STAT_P1_HT_RXSC(phy_status);
 
-	if (rxsc >= 9 && rxsc <= 12)
+	if (rxsc == 0)
+		bw = rtwdev->hal.current_band_width;
+	else if (rxsc >= 1 && rxsc <= 8)
+		bw = RTW_CHANNEL_WIDTH_20;
+	else if (rxsc >= 9 && rxsc <= 12)
 		bw = RTW_CHANNEL_WIDTH_40;
-	else if (rxsc >= 13)
-		bw = RTW_CHANNEL_WIDTH_80;
 	else
-		bw = RTW_CHANNEL_WIDTH_20;
+		bw = RTW_CHANNEL_WIDTH_80;
 
 	channel = GET_PHY_STAT_P1_CHANNEL(phy_status);
 	rtw_set_rx_freq_band(pkt_stat, channel);


