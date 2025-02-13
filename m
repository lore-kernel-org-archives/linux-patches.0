Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CE8156C71;
	Thu, 13 Feb 2025 14:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458708; cv=none; b=Z9vCfwmteAHL1S30gRMVPtMluxC5oOyBLSWa9eAR5EZwcCTGVincCohhmrdeWuHa0XA6SpDafPrwRHsg8MX50PD4BHb0oGewXYzIOYBG8cprEScbmrMxxGfFQMp4SrMyCP1wnfvuxiX+3Ddl8vfsqFg/ju4vv7mOw1G2MODTiXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458708; c=relaxed/simple;
	bh=yW8MWjbFGBDoXBF9TlLC1k3GpmDtAhJ2ruZdb1/J7Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlZ5hw5FuAiEnfv++74BUY7PqVVS2QNb1tJkddwqR3B9xqgdziLv5KwEXNw7A2crIca5z+hg22fAqxWR9mcp9jQkESUxiktZera6zcJQgKaK4SeqEIfw/BMNpW4VQ5zPaZPJkIqdXa/uxt6KiBaOlsELhDOo8CYISj3OmUs8rhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TePzDtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TePzDtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA28CC4CED1;
	Thu, 13 Feb 2025 14:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458708;
	bh=yW8MWjbFGBDoXBF9TlLC1k3GpmDtAhJ2ruZdb1/J7Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TePzDtX9HAo3Mr//82xM2BnnCh4711Pv/VoG9Kiu/ZtP6RvhAHxrz9Fwfe6FjCO6
	 kg+lmWd4DJ5vjZBtW8+zk/vz070mkXCz0gO3nFy39AIjjRI21WfKS48KTvaSIuMhda
	 s3iDllMI26p/uOn3pB4Q35/a2bs2c9+tki43plak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 055/443] wifi: rtw89: add crystal_cap check to avoid setting as overflow value
Date: Thu, 13 Feb 2025 15:23:40 +0100
Message-ID: <20250213142442.746179946@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index f24aca663cf00..b9171f6ccae07 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -4058,7 +4058,6 @@ static void rtw89_phy_cfo_set_crystal_cap(struct rtw89_dev *rtwdev,
 
 	if (!force && cfo->crystal_cap == crystal_cap)
 		return;
-	crystal_cap = clamp_t(u8, crystal_cap, 0, 127);
 	if (chip->chip_id == RTL8852A || chip->chip_id == RTL8851B) {
 		rtw89_phy_cfo_set_xcap_reg(rtwdev, true, crystal_cap);
 		rtw89_phy_cfo_set_xcap_reg(rtwdev, false, crystal_cap);
@@ -4181,7 +4180,7 @@ static void rtw89_phy_cfo_crystal_cap_adjust(struct rtw89_dev *rtwdev,
 					     s32 curr_cfo)
 {
 	struct rtw89_cfo_tracking_info *cfo = &rtwdev->cfo_tracking;
-	s8 crystal_cap = cfo->crystal_cap;
+	int crystal_cap = cfo->crystal_cap;
 	s32 cfo_abs = abs(curr_cfo);
 	int sign;
 
@@ -4202,15 +4201,17 @@ static void rtw89_phy_cfo_crystal_cap_adjust(struct rtw89_dev *rtwdev,
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
index c683f4d7d29b0..bc6912b3a2fba 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.h
+++ b/drivers/net/wireless/realtek/rtw89/phy.h
@@ -57,7 +57,7 @@
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



