Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7282D9EC4;
	Tue, 11 Nov 2025 01:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823203; cv=none; b=Q7zZS9KpqwdQnO1kq/Eg9XXVitTgU+XAV9lIdhfd6a/5Kd5/wUWU3bLUoCfVdqweCPV+XVd94byz/5/qyXrUcxtBzjXzyR7DhYngMj9XlyakkfmqOgwb7gGvAqt+ZRvy2rCT/V+LX18es+MyGByy7fLOlUH1b/JedQdxI9u9KmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823203; c=relaxed/simple;
	bh=4Mep6/Hc1duidYJuw/+vgLX7PDb1v8DQFUDCmEcMC50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Isr5WHOfyr0I4JSk+nSqLPlqRWNpuaQJPSA4uaSAeJv2OTEbQEqSAO+3BRNWAYXcvPHvKHyfoMazlZn7tW/bBmGgCRuH1kUpB3IOc2svfrtEYLBr5Mj0tHqqt/zQ8CfN7sCcc4WRfwmH4E3r61xd+MgJJaER5pIlREfsEuYZGCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vmskJVX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vmskJVX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A310DC19422;
	Tue, 11 Nov 2025 01:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823203;
	bh=4Mep6/Hc1duidYJuw/+vgLX7PDb1v8DQFUDCmEcMC50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vmskJVX9JFmXvXYI5mT5bIOFRlx/q/4H9FD0ibc6niHRyTbKcaAbzsXJC/eWiCB9M
	 0Z7nKWMWClgV8o0lCl+P7Cj6b75qjoVB6RZbFF0XFJOTCsML1qbtuPQkr6YTh2JiRJ
	 t7mBM5O2ZeDlGONmU3nR/F1oeaKHn1S1PeIYpvY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Oniszczuk <piotr.oniszczuk@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 196/565] wifi: rtw88: sdio: use indirect IO for device registers before power-on
Date: Tue, 11 Nov 2025 09:40:52 +0900
Message-ID: <20251111004531.337909596@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 58de1f91e033b1fface8d8948984583125f93736 ]

The register REG_SYS_CFG1 is used to determine chip basic information
as arguments of following flows, such as download firmware and load PHY
parameters, so driver read the value early (before power-on).

However, the direct IO is disallowed before power-on, or it causes wrong
values, which driver recognizes a chip as a wrong type RF_1T1R, but
actually RF_2T2R, causing driver warns:

  rtw88_8822cs mmc1:0001:1: unsupported rf path (1)

Fix it by using indirect IO before power-on.

Reported-by: Piotr Oniszczuk <piotr.oniszczuk@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/699C22B4-A3E3-4206-97D0-22AB3348EBF6@gmail.com/T/#t
Suggested-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Tested-by: Piotr Oniszczuk <piotr.oniszczuk@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250724004815.7043-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 787fa09fd063a..d6bea5ec8e24d 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -144,6 +144,10 @@ static u32 rtw_sdio_to_io_address(struct rtw_dev *rtwdev, u32 addr,
 
 static bool rtw_sdio_use_direct_io(struct rtw_dev *rtwdev, u32 addr)
 {
+	if (!test_bit(RTW_FLAG_POWERON, rtwdev->flags) &&
+	    !rtw_sdio_is_bus_addr(addr))
+		return false;
+
 	return !rtw_sdio_is_sdio30_supported(rtwdev) ||
 		rtw_sdio_is_bus_addr(addr);
 }
-- 
2.51.0



