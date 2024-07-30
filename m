Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7F11A6160;
	Tue, 30 Jul 2024 16:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356518; cv=none; b=h7j2pt/y2puUQIUNRZNaHcEsp99Bl7T02Y82DDaBT/uGVhacRm45+R10FjdcULvZFo4ovcTWVQVTBReulupV8NBbyGnJD2uljKL5OQU3bKJZqmsgf2Zd/+MpxtZaOnm3x0UkPNzKpCBSsaIfDVXMmOhYfn+96ZWc1jQsZVCFKkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356518; c=relaxed/simple;
	bh=gUVLNwTQe3ItUazMinidKMPO1MzpyxexCqhvQ90vChU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUkdpvrD8jznRHb3skI5G8oRzxXeXOHNGK3nRN/+GcYZH24H8eF3i3WlI+AhgnxPxo6IIHPVSVM3dv2rzdTN2v5V1WeOctAuUTwzGqiSarsw0s1MMd3H3SLAaUKLIBaYj2t2hUns6vvUijkGjUfEH7CnhwgigVuS6w9R44Rc0d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7pY+Tgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7pY+Tgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4EFC32782;
	Tue, 30 Jul 2024 16:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356518;
	bh=gUVLNwTQe3ItUazMinidKMPO1MzpyxexCqhvQ90vChU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7pY+TgnII0ZpJfuVU0iUTZYbByTxbZnvNsVaAE+NnFP9E3dDWUfFa/jTlXnySQU8
	 XYSE6VtvgW6r4GOUA+c1Gln8O0Qvc7Spt1Tg9JgsGd2eWg4QpCZMiuCzZtX90mZu8y
	 QKBgglcBNMoHIxG2Rn41RmRzxNiwEFcBEyzyO6lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 157/809] wifi: rtw89: 8852b: restore setting for RFE type 5 after device resume
Date: Tue, 30 Jul 2024 17:40:33 +0200
Message-ID: <20240730151730.805123019@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 2c1fc7c24cd47396580c5a7b238673da618aeedd ]

The RFE type 5 set SPS analog parameters only once at probe stage, but the
setting is missing after suspend/resume, so remove restriction and set the
value when card power on/off.

Fixes: 3ef60f44830a ("wifi: rtw89: 8852b: update hardware parameters for RFE type 5")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/20240517013543.11533-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8852b.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b.c b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
index d351096fa4b41..767de9a2de7e4 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
@@ -403,6 +403,8 @@ static int rtw8852b_pwr_on_func(struct rtw89_dev *rtwdev)
 	u32 val32;
 	u32 ret;
 
+	rtw8852b_pwr_sps_ana(rtwdev);
+
 	rtw89_write32_clr(rtwdev, R_AX_SYS_PW_CTRL, B_AX_AFSM_WLSUS_EN |
 						    B_AX_AFSM_PCIE_SUS_EN);
 	rtw89_write32_set(rtwdev, R_AX_SYS_PW_CTRL, B_AX_DIS_WLBT_PDNSUSEN_SOPC);
@@ -530,9 +532,7 @@ static int rtw8852b_pwr_off_func(struct rtw89_dev *rtwdev)
 	u32 val32;
 	u32 ret;
 
-	/* Only do once during probe stage after reading efuse */
-	if (!test_bit(RTW89_FLAG_PROBE_DONE, rtwdev->flags))
-		rtw8852b_pwr_sps_ana(rtwdev);
+	rtw8852b_pwr_sps_ana(rtwdev);
 
 	ret = rtw89_mac_write_xtal_si(rtwdev, XTAL_SI_ANAPAR_WL, XTAL_SI_RFC2RF,
 				      XTAL_SI_RFC2RF);
-- 
2.43.0



