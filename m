Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF2F322779;
	Mon, 18 Aug 2025 13:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525590; cv=none; b=Z+vZXghPAe9mQhxWqQg1MZ2ssp+kBBdI+1e/Ju2GZWH4PPw/Kp1x5fQoITfDzV0edjTEp4t+h6VrInBrrBqlNJE6vTMqU0ezVZ62MO34KYVsxK//yWW2VUP/L/ChUnxFKNzVaz2Anfh5Xaq3YJMHiU9r/Jti6+Il5wblZqPtx8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525590; c=relaxed/simple;
	bh=gKeu5ptb65IaJm2ykD6Cdq/GiZxiWCZg8+1hGayUp1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bm2hcdHVGz9rfd5v4PaJPiysJFZpfYR81O24uT67wU0uV2Iq/SD9R0ouEXjBKPVYmBwD0fERcJxqlbqiLr16kFiE4DRQlIlenzV6Xy1fMWgfmOCp6cTt+1koKnzE4AV+2EAwwZ5XaqiZMZmgwr+BwjVaYTf+WuY762tY7rYyt6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vdg4tjt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vdg4tjt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DD7C116C6;
	Mon, 18 Aug 2025 13:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525590;
	bh=gKeu5ptb65IaJm2ykD6Cdq/GiZxiWCZg8+1hGayUp1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vdg4tjt4N+lc3I95yGKlwyfAZMQKOMhev2Uz6oXwOHzYrl1lhsK7u/yUcLz5YDBEk
	 KPdCBeWxgGsbHr1QqblhqF3dlQXIoSYn9oIl64VYQ2ixE5bdInPWKz+mfUzgMd/nKW
	 Hln2JAcnmsApAur4AHGgppE/ETKzor4cFEw5wd5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 277/570] wifi: rtw89: Disable deep power saving for USB/SDIO
Date: Mon, 18 Aug 2025 14:44:24 +0200
Message-ID: <20250818124516.523142199@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index c886dd2a73b4..894ab7ab94cc 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2839,6 +2839,9 @@ static enum rtw89_ps_mode rtw89_update_ps_mode(struct rtw89_dev *rtwdev)
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



