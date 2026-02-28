Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F406340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301072; cv=none; b=g51qakDNry/JFLCLyiUW6gxra9a8HoEWFlYPn9vhM67VxlwWdjcdsUW/kDl90UyL4QbiMTlO7xzECoE3mEDKGsj4nzdHeg7SlEopjkBHXEpYVQhHnQFLhARwxNPaQBbl0PaOVBb+RWbk/iOi0IkHuTqnKIxxHkI61GpiA7Kdcgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301072; c=relaxed/simple;
	bh=O0oY+q71A49VscNbl9kX2MbMIi7aaoURk4SYzY19jYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hex48ZtoRBbpwjdZSbLigMLu82LuE1eHR0q9kRO2tSI6Pv/PNG8qgqoRMsY9vYLxNQvhDm+6rEWQOS53ZZCigwJWjDPgTN3Fq4ykzYd26OIwJGDjpN681N8lYfwwqvffOoBvonk1RSdvZa6G3L0vxwdrvlOdGW5RGAbWVPlkaaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ItcWu2nX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ItcWu2nX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC203C19423;
	Sat, 28 Feb 2026 17:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301072;
	bh=O0oY+q71A49VscNbl9kX2MbMIi7aaoURk4SYzY19jYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ItcWu2nXjwyjSlHcF2xBZgQ9Ay09ynYfosl3g9NL1P3yqs5M5vUa8+E/krcjKZapC
	 vg2uXg3/YDi3PimSay2atShlf129XgV9cmB4DB94qb/DOVfnj9ku46rFndUVa2ABqr
	 BSKo+TPXuPy4WJ7ZIzXeXXBA8QDAFcPJ2EXgzaL7Aipr6xiOryC88pjx5wJd4zYIFu
	 NrmCzP+q8JrZcW2OA8b5lzXFedXHWyNddnlCjCDG/xSp7y1GTjLzoTzJJulz+a1Ffz
	 npEXE+zoYoNYcxts3VPabetFefpc8lp0KCO3uUp0sHEzPwyrOdF3ITcVDLGWriG8Wr
	 h7SxNShRVBgaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 217/752] wifi: rtw89: 8922a: set random mac if efuse contains zeroes
Date: Sat, 28 Feb 2026 12:38:48 -0500
Message-ID: <20260228174750.1542406-217-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

[ Upstream commit 41be33d3efc120f6a2c02d12742655f2aa09e1b6 ]

I have some rtl8922ae devices with no permanent mac stored in efuse.

It could be properly saved and/or configured from user tools like
NetworkManager, but it would be desirable to be able to initialize it
somehow to get the device working by default.

So, in the same way as with other devices, if the mac address read from
efuse contains zeros, a random mac address is assigned to at least allow
operation, and the user is warned about this in case any action needs to
be considered.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251126091905.217951-1-jtornosm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8922a.c | 22 +++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922a.c b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
index 6aa19ad259aca..757dedd1a11d5 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922a.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922a.c
@@ -636,16 +636,30 @@ static int rtw8922a_read_efuse_rf(struct rtw89_dev *rtwdev, u8 *log_map)
 static int rtw8922a_read_efuse(struct rtw89_dev *rtwdev, u8 *log_map,
 			       enum rtw89_efuse_block block)
 {
+	struct rtw89_efuse *efuse = &rtwdev->efuse;
+	int ret;
+
 	switch (block) {
 	case RTW89_EFUSE_BLOCK_HCI_DIG_PCIE_SDIO:
-		return rtw8922a_read_efuse_pci_sdio(rtwdev, log_map);
+		ret = rtw8922a_read_efuse_pci_sdio(rtwdev, log_map);
+		break;
 	case RTW89_EFUSE_BLOCK_HCI_DIG_USB:
-		return rtw8922a_read_efuse_usb(rtwdev, log_map);
+		ret = rtw8922a_read_efuse_usb(rtwdev, log_map);
+		break;
 	case RTW89_EFUSE_BLOCK_RF:
-		return rtw8922a_read_efuse_rf(rtwdev, log_map);
+		ret = rtw8922a_read_efuse_rf(rtwdev, log_map);
+		break;
 	default:
-		return 0;
+		ret = 0;
+		break;
+	}
+
+	if (!ret && is_zero_ether_addr(efuse->addr)) {
+		rtw89_info(rtwdev, "efuse mac address is zero, using random mac\n");
+		eth_random_addr(efuse->addr);
 	}
+
+	return ret;
 }
 
 #define THM_TRIM_POSITIVE_MASK BIT(6)
-- 
2.51.0

