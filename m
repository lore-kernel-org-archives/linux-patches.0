Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE01D223702;
	Mon, 10 Mar 2025 17:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628657; cv=none; b=GfM1FmagsmKvqKTn12lCXp22R0GN5scENoLrxSXPEgXKw04rBroMTEAMjukT/LO6LJhTHSIdH+qIsTOEFxDV5D0a+B/zhVr6PXcLTfQakKq787Q6ljRXQ9bg2XBQLqw77w0+dYp/itiGHTQkyGmPgMj9QHtstyVjdW9yDDzx3bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628657; c=relaxed/simple;
	bh=AM6Mjkms6ijbQ8PIWWCOvVgoI87KWETfcRXMrMPBTdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Em3T7tfv+5sb6Inb3uJQ0qbQYO4qIoIH/m4HroLKffCzO/Pn+q+Jlvw54NMMeN1HIpIymqNjJqY6Q1QQNMTIrGHbNFSGn+LVGEqMkwTxWGgKM4iDD6+6//JerKEVr1HlKsRrrZlAj6UlMvyrKI6uh1ZR8biwnVlU744raEc2Uu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0o1+uDTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0o1+uDTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75288C4CEEC;
	Mon, 10 Mar 2025 17:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628656;
	bh=AM6Mjkms6ijbQ8PIWWCOvVgoI87KWETfcRXMrMPBTdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0o1+uDTOJlOjfX8uyW6ads0VeRe9xPWsSwP285PAr+htJ1Z0tdbJQTdIm1Vv+hkEb
	 G5Bt2abXvXSi6P98VqhD4FNqrJSKOx45oQtPZr/VSfPQEtmO3ALhJTDEa0VBSdTq+F
	 BEsM2c4q6W0LHIZFObVb75iBDmUnj7vb2zEDVh0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/620] wifi: rtlwifi: do not complete firmware loading needlessly
Date: Mon, 10 Mar 2025 17:57:50 +0100
Message-ID: <20250310170546.530530200@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit e73e11d303940119e41850a0452a0deda2cc4eb5 ]

The only code waiting for completion is driver removal, which will not be
called when probe returns a failure. So this completion is unnecessary.

Fixes: b0302aba812b ("rtlwifi: Convert to asynchronous firmware load")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241107133322.855112-2-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 1 -
 drivers/net/wireless/realtek/rtlwifi/usb.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 6d9f2a6233a21..70f1cc906502b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2274,7 +2274,6 @@ int rtl_pci_probe(struct pci_dev *pdev,
 		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
 
 	pci_release_regions(pdev);
-	complete(&rtlpriv->firmware_loading_complete);
 
 fail1:
 	if (hw)
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index a8eebafb9a7ee..c2a3c88ea1fcc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1085,7 +1085,6 @@ int rtl_usb_probe(struct usb_interface *intf,
 error_out2:
 	_rtl_usb_io_handler_release(hw);
 	usb_put_dev(udev);
-	complete(&rtlpriv->firmware_loading_complete);
 	kfree(rtlpriv->usb_data);
 	ieee80211_free_hw(hw);
 	return -ENODEV;
-- 
2.39.5



