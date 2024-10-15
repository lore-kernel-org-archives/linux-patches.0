Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69211D0492;
	Tue, 15 Oct 2024 11:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993182; cv=none; b=E+DzWgfSVkeM9Fpf/knoNMaKnPmg7t0HhSGgvh+aumWF52zUSz2VUwsQiyjFzklxZ57viKxTVHeY3xkuk4hV5my4fH/GMwBKecEvTptClnOa9fOWsYyq9ACr0oijDOhyeyCczdCuBmkOlKDze2oYjrj9+pxrDVlVOUY2mLeCJS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993182; c=relaxed/simple;
	bh=GY3N990jJNEdkasYfVZgtwxTw6AO8d79ufE4zwX2OQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKlWCkvCQUpv8LPTUdqvw0SJVQZl55KrkKeQnLq8azdAfOlj3q3MHoZ5ocWI/xK9F9QxDSXNrxtZCQ4Af7RlrejDK3VYE+i7LOjLNQQRrMyJfdRs9IJv70ahs6ZxPMvZIK3Fn90kjozGsCC87DjMwcogPpz4qLyG53ET7Y9B5XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yg8tQ5EP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yg8tQ5EP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674D0C4CEC6;
	Tue, 15 Oct 2024 11:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993181;
	bh=GY3N990jJNEdkasYfVZgtwxTw6AO8d79ufE4zwX2OQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yg8tQ5EPVIvysP3+3O4lkTzciW1HmCIE3RfIeJ9a+qifj6hfFezYp3rTGKo6t5Pqn
	 ZNn0KdconfkwvdAzwMDl9JfvubLcCZVCObNBMFebxFHGuZORWO7D1JIwK47hpD+VFv
	 LCCrd0PyN/QQW+lhB36GXO9bCqIf+Ybt7MkZgwVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 5.15 335/691] wifi: rtw88: 8822c: Fix reported RX band width
Date: Tue, 15 Oct 2024 13:24:43 +0200
Message-ID: <20241015112453.632555749@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2584,12 +2584,14 @@ static void query_phy_status_page1(struc
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
 
 	pkt_stat->rx_power[RF_PATH_A] = GET_PHY_STAT_P1_PWDB_A(phy_status) - 110;
 	pkt_stat->rx_power[RF_PATH_B] = GET_PHY_STAT_P1_PWDB_B(phy_status) - 110;


