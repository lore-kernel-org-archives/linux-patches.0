Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901BA25F7A3;
	Tue, 11 Mar 2025 15:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706421; cv=none; b=IPbuSVzr2YINiLBwS3NH0O5dvlgzSVeFYCaSpjtyWyYzGV5S09GzjMRr/CKtBFeIXh53Sq2M0a0uwigkRMs2S+2r98G5dHPRxBV2DVl+Bzur/Ae7kSluXxEy9lCV+s0xcvmpEz0Ki4tueG2jynQJqEO1o9LGznZfvWCcOKa+vCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706421; c=relaxed/simple;
	bh=EguMfC6WTP5oj2X82veDdAdKwGIfy7lehTD2sQarOr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwl+L+BWGFDxXcPufoGd1kwuc/5k59zLF6k/k5Cp2KXNZxEi/5dyU8ixm28WiFh2xXePiDbEYuY9V26Tqzb+3L4ptvmffMTTRAEtGgwUhiMzuX8W8gKiVSp0L7qRrMwhuwx6/k38IZ+hOugIfkKpnM+iyKyiNPNX1I8JEWRV0mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klq+0bZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klq+0bZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18626C4CEE9;
	Tue, 11 Mar 2025 15:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706421;
	bh=EguMfC6WTP5oj2X82veDdAdKwGIfy7lehTD2sQarOr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klq+0bZfNxMEHKFnWQs6yYyaPkR3uTUg7ylrPm28ABCT+pDa0eNMKogO/wLbcI0m2
	 RvUfmxVwbWsFPN7op3wlFMncC2FzwQz2xFkzl4dWxC98MK4HxlGcl6IrszCXfahord
	 GDNBeVYFgmg/kJIiEvIzlxdMfyc7W41F1G1neK0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/462] wifi: rtlwifi: do not complete firmware loading needlessly
Date: Tue, 11 Mar 2025 15:54:38 +0100
Message-ID: <20250311145758.835073066@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c6e4fda7e431f..7e4655de30237 100644
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



