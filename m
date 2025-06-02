Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAF61FF61E;
	Mon,  2 Jun 2025 14:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873841; cv=none; b=Gfa/kdqjcjzziW+eTu4xEFkdyTNiB5NzAaXolOiHn+tzZfYR3xnL+wbnUdZltRGRZpGq0xyL7RJooxgyptl7Oz+0k4TxUyVhIhn96yNMESny53rHdLtuSJPBiqhtskYCNN1NFUILYSvnj25RwcN5qUvKEzaBrWkAI4k1pj9ZCLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873841; c=relaxed/simple;
	bh=iQUoBpREXMbog13ZMJBTwuVpSTKfYtvLBDqZizMhcBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTBoIGqAXSbDueN3dYggIiid6SnZ0zVL+XoD3ZNnN5JWvYHzsTIuJGC66Cksitw5gL+kdZNeLf8kpMYSD/1eBsx88phT1mwIggRQrdHR3IRpLO28gBBHgBh55tZB5B1I8eZA67lgPiQnot9auW0yhk8GjC7Dhy+JoID8ZwK9CVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uko1wpdg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uko1wpdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710F2C4CEEE;
	Mon,  2 Jun 2025 14:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873840;
	bh=iQUoBpREXMbog13ZMJBTwuVpSTKfYtvLBDqZizMhcBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uko1wpdgYki+1HklAqf8CfY2SQ7ZgZypWZODyXyHFXh6pwc9WQHupMCzboKk/aJxr
	 d8Hqh94Te8xJd50zNG/xTpKTzLbibCBvxjMa51KF5rgKRgUQnk1E1DTCbZ8wBmBP9F
	 Xxu3gm9+o3OA3iIffO10/f0NIM8lE8O9txfO/nx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 269/444] wifi: rtw88: Fix __rtw_download_firmware() for RTL8814AU
Date: Mon,  2 Jun 2025 15:45:33 +0200
Message-ID: <20250602134351.877661976@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

[ Upstream commit 8425f5c8f04dbcf11ade78f984a494fc0b90e7a0 ]

Don't call ltecoex_read_reg() and ltecoex_reg_write() when the
ltecoex_addr member of struct rtw_chip_info is NULL. The RTL8814AU
doesn't have this feature.

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/55b5641f-094e-4f94-9f79-ac053733f2cf@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 0c1c1ff31085c..929182424b8b8 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -783,7 +783,8 @@ static int __rtw_download_firmware(struct rtw_dev *rtwdev,
 	if (!check_firmware_size(data, size))
 		return -EINVAL;
 
-	if (!ltecoex_read_reg(rtwdev, 0x38, &ltecoex_bckp))
+	if (rtwdev->chip->ltecoex_addr &&
+	    !ltecoex_read_reg(rtwdev, 0x38, &ltecoex_bckp))
 		return -EBUSY;
 
 	wlan_cpu_enable(rtwdev, false);
@@ -801,7 +802,8 @@ static int __rtw_download_firmware(struct rtw_dev *rtwdev,
 
 	wlan_cpu_enable(rtwdev, true);
 
-	if (!ltecoex_reg_write(rtwdev, 0x38, ltecoex_bckp)) {
+	if (rtwdev->chip->ltecoex_addr &&
+	    !ltecoex_reg_write(rtwdev, 0x38, ltecoex_bckp)) {
 		ret = -EBUSY;
 		goto dlfw_fail;
 	}
-- 
2.39.5



