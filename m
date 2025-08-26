Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8DB187554;
	Tue, 26 Aug 2025 13:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214440; cv=none; b=FketmDb7XtNJ2drEBBzwCcA+m3chjJ6Z0vP+RA2thy6AAZ5nfEPRUUe5m8WvbB6Dc8ml37PosGhqPblgf7wY0guam8E8gJoHw9w8KZv0JnT8j6QkGttPvfTKbfXcBHxT/61E14DoGMnGbEEb5PcFApB2TT/ASjcFmy0qzDV1QJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214440; c=relaxed/simple;
	bh=DXqboIZKXZ42CGARzccnAhpFGIKrXnremqSDac6qvzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CISRNpy6nAk0DD5UxzlIIJwxYhCvaNz7E8l289Ni4qUQaWn9Iw5VSjz1DG0n94fvZTSB2cVPXypBXeLVCzsW+ymsHvecz6LAL2Gsf9XOQugd5ru/g8HM+jdIZjOqxNE8n34+8FjcaivXjDmJrR+wk9IikPC4tzeeMFynA5D8NGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6yrKxf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6yrKxf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEE7C4CEF1;
	Tue, 26 Aug 2025 13:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214440;
	bh=DXqboIZKXZ42CGARzccnAhpFGIKrXnremqSDac6qvzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6yrKxf9aBaWcF93PT0d833PeAtf0XJcEWXOwi4E1dA6C1FzHCPprHHX5E7ExB09Z
	 8orgUZO6nc88P0kDfIVmgBMXC67N74dUBzhcdXOJbv+nIwRNG3oBeih4UyPDxcL/ah
	 YSl9z8qOPU2GOsQycuuefT2TnQmGXOWdjeFIBowo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/482] wifi: rtw89: Disable deep power saving for USB/SDIO
Date: Tue, 26 Aug 2025 13:06:31 +0200
Message-ID: <20250826110934.229854994@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9e4a02a322ff..ff3a31bf3a87 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1721,6 +1721,9 @@ static enum rtw89_ps_mode rtw89_update_ps_mode(struct rtw89_dev *rtwdev)
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



