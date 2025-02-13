Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBB8335BA;
	Thu, 13 Feb 2025 15:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460147; cv=none; b=HGkvx4gOfE0XRxFOfHSohg5+9qFIfO2ozBJL4QBJ+GuG/pdjlsVX9+DySiESmAixhSwcrMa/mE7zyAHbk9v8ep0ZTh4zPbDNw3JiBkTAGIrJRRdbFkluE1kxrpXUEdXWMZzgwbtBqRRdHHSkHF88xIQmigDGkPqoMigduCApcDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460147; c=relaxed/simple;
	bh=PAn6dYH5mivf5DeUb8T0D8CZuDmrSUMjyrnWZ8kKngk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZri8j1eBiRvt0GVpCca66znp/UXFx2cObfmS0uiBzL6LoCOxB5mGs8RQ/BBnbskv8sBaY0j/JF2Y0ke28k3AgQBLLLaO1Z4NuP3JRg7v/pQcnFajgRluw/pyOY/whA6MLVAPvHylzuOj9V4LclTISTWSkd7R5nQjsnRcCIzOPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yqS1iW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yqS1iW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0059C4CED1;
	Thu, 13 Feb 2025 15:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460147;
	bh=PAn6dYH5mivf5DeUb8T0D8CZuDmrSUMjyrnWZ8kKngk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yqS1iW0oX6mAIx4cis514P4LJ0cFWJj6aGOS0wcV1ZslNaZttmbVqAXVNr4P+/8C
	 V5NYvLeBIP4AeDJO99w5Hsb7M5j20vOW+/6UHrBzXkPYcpguE4Py3C7fqbKljZFVRL
	 b/3coqNfqsXgivVykfSVApR0tlTXMH70NJ3xSbhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/273] wifi: rtw89: add crystal_cap check to avoid setting as overflow value
Date: Thu, 13 Feb 2025 15:26:40 +0100
Message-ID: <20250213142408.470156722@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit 7b98caea39676561f22db58752551161bb36462b ]

In the original flow, the crystal_cap might be calculated as a negative
value and set as an overflow value. Therefore, we added a check to limit
the calculated crystal_cap value. Additionally, we shrank the crystal_cap
adjustment according to specific CFO.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241128055433.11851-7-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/phy.c | 11 ++++++-----
 drivers/net/wireless/realtek/rtw89/phy.h |  2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index fac83b718a30c..457c1dd31bf9d 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -2438,7 +2438,6 @@ static void rtw89_phy_cfo_set_crystal_cap(struct rtw89_dev *rtwdev,
 
 	if (!force && cfo->crystal_cap == crystal_cap)
 		return;
-	crystal_cap = clamp_t(u8, crystal_cap, 0, 127);
 	if (chip->chip_id == RTL8852A || chip->chip_id == RTL8851B) {
 		rtw89_phy_cfo_set_xcap_reg(rtwdev, true, crystal_cap);
 		rtw89_phy_cfo_set_xcap_reg(rtwdev, false, crystal_cap);
@@ -2552,7 +2551,7 @@ static void rtw89_phy_cfo_crystal_cap_adjust(struct rtw89_dev *rtwdev,
 					     s32 curr_cfo)
 {
 	struct rtw89_cfo_tracking_info *cfo = &rtwdev->cfo_tracking;
-	s8 crystal_cap = cfo->crystal_cap;
+	int crystal_cap = cfo->crystal_cap;
 	s32 cfo_abs = abs(curr_cfo);
 	int sign;
 
@@ -2569,15 +2568,17 @@ static void rtw89_phy_cfo_crystal_cap_adjust(struct rtw89_dev *rtwdev,
 	}
 	sign = curr_cfo > 0 ? 1 : -1;
 	if (cfo_abs > CFO_TRK_STOP_TH_4)
-		crystal_cap += 7 * sign;
+		crystal_cap += 3 * sign;
 	else if (cfo_abs > CFO_TRK_STOP_TH_3)
-		crystal_cap += 5 * sign;
-	else if (cfo_abs > CFO_TRK_STOP_TH_2)
 		crystal_cap += 3 * sign;
+	else if (cfo_abs > CFO_TRK_STOP_TH_2)
+		crystal_cap += 1 * sign;
 	else if (cfo_abs > CFO_TRK_STOP_TH_1)
 		crystal_cap += 1 * sign;
 	else
 		return;
+
+	crystal_cap = clamp(crystal_cap, 0, 127);
 	rtw89_phy_cfo_set_crystal_cap(rtwdev, (u8)crystal_cap, false);
 	rtw89_debug(rtwdev, RTW89_DBG_CFO,
 		    "X_cap{Curr,Default}={0x%x,0x%x}\n",
diff --git a/drivers/net/wireless/realtek/rtw89/phy.h b/drivers/net/wireless/realtek/rtw89/phy.h
index d6dc0cbbae43b..15ed23fa4218f 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.h
+++ b/drivers/net/wireless/realtek/rtw89/phy.h
@@ -51,7 +51,7 @@
 #define CFO_TRK_STOP_TH_4 (30 << 2)
 #define CFO_TRK_STOP_TH_3 (20 << 2)
 #define CFO_TRK_STOP_TH_2 (10 << 2)
-#define CFO_TRK_STOP_TH_1 (00 << 2)
+#define CFO_TRK_STOP_TH_1 (03 << 2)
 #define CFO_TRK_STOP_TH (2 << 2)
 #define CFO_SW_COMP_FINE_TUNE (2 << 2)
 #define CFO_PERIOD_CNT 15
-- 
2.39.5



