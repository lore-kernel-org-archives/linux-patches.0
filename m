Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A43E25771;
	Wed,  2 Oct 2024 13:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875232; cv=none; b=A/GZpT6jzxBqayH+wCDVmzPgRdDpKDjFUdSFVJO5YF4cwXjtqh7GVOm4eQ3fCH7BquvkOJjuAy6vmMVMMNufRavGsouONPmhPllJ6uZum2azCIoKIa7amNswtXTCHnZ3qB8IEOiit8F0MetLUY7Ki7J38aFXUjd2RBB43AsGBxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875232; c=relaxed/simple;
	bh=aTrK1lh70QZsj6i8XwkH5XH68bE81Ff9sTTMoKcZtqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mka1gEygitCp+dHO6KZEzbsDJqh5OFb3LjQr9G3Ac7d/XcVKgRy2Mahb+bHaJ3DT/grAmpUx/SFu3q7NjBsldegK269I5SGvKnckMxh6fs7UPmmuvMO2EBNLt7BNhRUqeYEfH8HWk75Ttb32H+jcLkX4nO709BD3gv/2ixkK5Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sahY81g1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sahY81g1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CDEC4CEC5;
	Wed,  2 Oct 2024 13:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875232;
	bh=aTrK1lh70QZsj6i8XwkH5XH68bE81Ff9sTTMoKcZtqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sahY81g16oAHTbfSwbHCMRx53Y9CHAVTsDz/Ej5QE6Q1c2YeJ4eio95vr7NRvMWTj
	 VbWO0IGPUARvu+ovfQzk4QZdvpkgx6CFavsxlag26WbQF5ee3eoQTnCNqYJzL4RsQ4
	 LmvY/2Ved4ykitNyuOr8fLuFfwRNrKX1ADZbA5PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-Yuan Li <leo.li@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 035/695] wifi: rtw89: limit the PPDU length for VHT rate to 0x40000
Date: Wed,  2 Oct 2024 14:50:33 +0200
Message-ID: <20241002125823.892889925@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-Yuan Li <leo.li@realtek.com>

[ Upstream commit 124410976bf807e76c45e36685ed8bf959229545 ]

If the PPDU length for VHT rate exceeds 0x40000, calculating the PSDU
length will overflow. TMAC will determine the length to be too small and
as a result, all packets will be sent as ZLD (Zero Length Delimiter).

Fixes: 5f7e92c59b8e ("wifi: rtw89: 8852b: set AMSDU limit to 5000")
Signed-off-by: Chia-Yuan Li <leo.li@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240815134054.44649-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac.c | 7 +++++++
 drivers/net/wireless/realtek/rtw89/reg.h | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index e2399796aeb1e..facd32de37bce 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -2728,6 +2728,7 @@ bool rtw89_mac_is_qta_dbcc(struct rtw89_dev *rtwdev, enum rtw89_qta_mode mode)
 
 static int ptcl_init_ax(struct rtw89_dev *rtwdev, u8 mac_idx)
 {
+	enum rtw89_core_chip_id chip_id = rtwdev->chip->chip_id;
 	u32 val, reg;
 	int ret;
 
@@ -2766,6 +2767,12 @@ static int ptcl_init_ax(struct rtw89_dev *rtwdev, u8 mac_idx)
 				  B_AX_SPE_RPT_PATH_MASK, FWD_TO_WLCPU);
 	}
 
+	if (chip_id == RTL8852A || rtw89_is_rtl885xb(rtwdev)) {
+		reg = rtw89_mac_reg_by_idx(rtwdev, R_AX_AGG_LEN_VHT_0, mac_idx);
+		rtw89_write32_mask(rtwdev, reg,
+				   B_AX_AMPDU_MAX_LEN_VHT_MASK, 0x3FF80);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index 7df36f3bff0b0..b1c24eedc7e08 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -2440,6 +2440,10 @@
 #define B_AX_RTS_TXTIME_TH_MASK GENMASK(15, 8)
 #define B_AX_RTS_LEN_TH_MASK GENMASK(7, 0)
 
+#define R_AX_AGG_LEN_VHT_0 0xC618
+#define R_AX_AGG_LEN_VHT_0_C1 0xE618
+#define B_AX_AMPDU_MAX_LEN_VHT_MASK GENMASK(19, 0)
+
 #define S_AX_CTS2S_TH_SEC_256B 1
 #define R_AX_SIFS_SETTING 0xC624
 #define R_AX_SIFS_SETTING_C1 0xE624
-- 
2.43.0



