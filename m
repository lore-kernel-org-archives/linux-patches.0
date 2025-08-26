Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABC91EB9F2;
	Tue, 26 Aug 2025 12:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212967; cv=none; b=VBdSl2dga920EHg462toRAEgM1LkeyY4WccKya7KbF/bX8/RQzcqT39kKHeZ+lvilZHDl38hgESCLeE2GDksHDDIFtYb4jItXCE1r6oibMwSdlS+D1dzPB/pqZkotVQYG49QRcG1dmvd2F7NkM41JKpb7pMGErg+0mRt2zx48Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212967; c=relaxed/simple;
	bh=zv3K83PCnvY5YoofCZvwZhulpa2sXYoIDJNroRbPgbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4EDxsVK1GaZ3nNMR5oVPSOX2ZcIcW2flk6sDYmi3AYAKpyIZrbuUoCp0c1EQauVIU2Qck3PhWaBKrytr3JEVsLRVrwAzEk8/y7Aa5DLHRNz3CGA2cOWKSZfssiE47Wn0NOp7521FzGicpIkliVqESi9zA6eXXFrW32ue2wLnQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXzLJh8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXzLJh8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA249C4CEF4;
	Tue, 26 Aug 2025 12:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212967;
	bh=zv3K83PCnvY5YoofCZvwZhulpa2sXYoIDJNroRbPgbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXzLJh8qwiIjUziV4bR3EIuxdmo/q6O24Z3mospInYKuPoBDQ2FEGXzYsGCFaudCz
	 3tHccLzhOuaY+iwOL6M/5zYOJm6f/JvVhwucj6rXtuWSKL+Fycg3HuHok/2fyOHpT0
	 DlZDiwX+wcoks+XPnK8ORjzPb3G9smZ2JjubHBbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/587] wifi: rtw89: Disable deep power saving for USB/SDIO
Date: Tue, 26 Aug 2025 13:05:20 +0200
Message-ID: <20250826110957.295859865@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit a3b871a0f7c083c2a632a31da8bc3de554ae8550 ]

Disable deep power saving for USB and SDIO because rtw89_mac_send_rpwm()
is called in atomic context and accessing hardware registers results in
"scheduling while atomic" errors.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/0f49eceb-0de0-47e2-ba36-3c6a0dddd17d@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 21e9ec8768b5..c172ef13c954 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1996,6 +1996,9 @@ static enum rtw89_ps_mode rtw89_update_ps_mode(struct rtw89_dev *rtwdev)
 {
 	const struct rtw89_chip_info *chip = rtwdev->chip;
 
+	if (rtwdev->hci.type != RTW89_HCI_TYPE_PCIE)
+		return RTW89_PS_MODE_NONE;
+
 	if (rtw89_disable_ps_mode || !chip->ps_mode_supported ||
 	    RTW89_CHK_FW_FEATURE(NO_DEEP_PS, &rtwdev->fw))
 		return RTW89_PS_MODE_NONE;
-- 
2.39.5



