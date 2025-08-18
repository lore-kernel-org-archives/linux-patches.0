Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BAF2E717D;
	Mon, 18 Aug 2025 13:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523849; cv=none; b=Wj94BudDN2DMxeagVbjClslmHfCYf4BkNrrzRluRJqWxNHFZzZ8YrpDNhsWBe2COpSaPRTTCEwGbX8j/kNHPUoyP0gkDK+xxlZmI5TQINyjLdlq31B9TkcxRyXeIiyzBt1CgaJDVfHion4isq1r+NPg+TS6QKDUHZlmz1zV9rIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523849; c=relaxed/simple;
	bh=EHXc2gTDGE6EQWO3hypoo68kh9t4KHRfLFWtv+vLH5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPgofOXVB0M/i8DRVvdYaa46ddwRy2gGqccFzEa31cblVRwxqmu5tytCQMDqWGEIEMj94L0GZ9JX1p5LLafKawHNl42efAn+hYDEf92UbYprkOJza6GNybp+H1pgqJozqr7mbaNdHrXF2bdWXD3Lhz0Mb4ZX7JRr/6XxT9pAxpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1kirx4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1kirx4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FCCC4CEEB;
	Mon, 18 Aug 2025 13:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523849;
	bh=EHXc2gTDGE6EQWO3hypoo68kh9t4KHRfLFWtv+vLH5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1kirx4h7tama0LZIvNgyDh/hhdYyyMXfFXlVvB3pN27ScVExmNkXb+z6xdGoVl21
	 NrRJIIYJfqbzyMvX36DDxFJSzGeDUDjhz4AzJiLcbV3K5SW7i9LVy+YaerZ83VynFd
	 PPL1Nno5/LIJBi31afPTYTlGBnKvfa1+Ao/teT8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 259/515] wifi: rtw89: Disable deep power saving for USB/SDIO
Date: Mon, 18 Aug 2025 14:44:05 +0200
Message-ID: <20250818124508.388367196@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 69546a039494..628b64457a17 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2788,6 +2788,9 @@ static enum rtw89_ps_mode rtw89_update_ps_mode(struct rtw89_dev *rtwdev)
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



