Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD11231854;
	Mon,  2 Jun 2025 14:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873927; cv=none; b=nHdWdIqwuBf3DwSpGyEJt2Pf3XC2wyC2mcphAyjy557coGZ4aZe7CV0HzjyCsGVmZQlEt2s09EUiwC5ZNi3HPoJ53Hm8VbcBdGlz+J5UzmkhqZEC9/fe3LnSkPkKW4qnbmflbVR3ILEts6pib/djd3zHdAzliM2KQT//VqdqmAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873927; c=relaxed/simple;
	bh=clwd3Ld7TWLE3VN0G/hzlE9+st6xKmv4cTt2o996oA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/YoTdGRJO3e2odQkUm/IGWXUg0XrAuQSZc5jm2lmZRYj/lT50SV6WiQZJrTVXC8HjBxDGcMc5Hj5NMSAJRlkYDP7nT9f7DaYmFiWQDzkntxja6B4lRGSaCiILDiSs2nghpppXcMqWam6cKEovGOwTtcb5WU89rIJEjV9jWjgR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbE3ydX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbE3ydX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF68FC4CEEB;
	Mon,  2 Jun 2025 14:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873927;
	bh=clwd3Ld7TWLE3VN0G/hzlE9+st6xKmv4cTt2o996oA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbE3ydX39/UvK74pBOfLSn+6GwZCGS5XsZtbtLRgyL+bi3B3Q9pS8X40fa56brh38
	 IbM0qqw3P87AYmQPhscprEJX00fhSro1bacwsHTmvThdtGAlwlqkDsW+bw3/22BLFa
	 Ujmp3jFqdRkaK/hxSy8c/5sHIvOYop7cLQhBZi6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soeren Moch <smoch@web.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 299/444] wifi: rtl8xxxu: retry firmware download on error
Date: Mon,  2 Jun 2025 15:46:03 +0200
Message-ID: <20250602134353.082807622@linuxfoundation.org>
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

From: Soeren Moch <smoch@web.de>

[ Upstream commit 3d3e28feca7ac8c6cf2a390dbbe1f97e3feb7f36 ]

Occasionally there is an EPROTO error during firmware download.
This error is converted to EAGAIN in the download function.
But nobody tries again and so device probe fails.

Implement download retry to fix this.

This error was observed (and fix tested) on a tbs2910 board [1]
with an embedded RTL8188EU (0bda:8179) device behind a USB hub.

[1] arch/arm/boot/dts/nxp/imx/imx6q-tbs2910.dts

Signed-off-by: Soeren Moch <smoch@web.de>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250127194828.599379-1-smoch@web.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c   | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 6e47dde938909..05e77d2bda373 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -900,9 +900,10 @@ rtl8xxxu_writeN(struct rtl8xxxu_priv *priv, u16 addr, u8 *buf, u16 len)
 	return len;
 
 write_error:
-	dev_info(&udev->dev,
-		 "%s: Failed to write block at addr: %04x size: %04x\n",
-		 __func__, addr, blocksize);
+	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_REG_WRITE)
+		dev_info(&udev->dev,
+			 "%s: Failed to write block at addr: %04x size: %04x\n",
+			 __func__, addr, blocksize);
 	return -EAGAIN;
 }
 
@@ -4073,8 +4074,14 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	 */
 	rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, fops->trxff_boundary);
 
-	ret = rtl8xxxu_download_firmware(priv);
-	dev_dbg(dev, "%s: download_firmware %i\n", __func__, ret);
+	for (int retry = 5; retry >= 0 ; retry--) {
+		ret = rtl8xxxu_download_firmware(priv);
+		dev_dbg(dev, "%s: download_firmware %i\n", __func__, ret);
+		if (ret != -EAGAIN)
+			break;
+		if (retry)
+			dev_dbg(dev, "%s: retry firmware download\n", __func__);
+	}
 	if (ret)
 		goto exit;
 	ret = rtl8xxxu_start_firmware(priv);
-- 
2.39.5



