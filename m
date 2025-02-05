Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BF21519AA;
	Wed,  5 Feb 2025 14:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764507; cv=none; b=So+OYqjZ9UmS8Om1VQAHTPEbLPoKluk3Wlvt9ZBh/Lba7om6kvavB/p812cuzwtQ5X8uE66IKN5hfOo7lSneW7sK7qU+sOkVtb0oN0kGMxKUKYMUT94eZlN8UmoOyi6bo3ALKbc1gnhBcNa3mzn/3fbGu3qkxpkvSWRt2mTVEOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764507; c=relaxed/simple;
	bh=4d/S4Ngc9Ij27qDP6NtkdpK9ChT8rg5W/4Fpt8vZuJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLVQNqZMyK6E7Hg8WDu+zo9R7O9Dk3hBDOfmTxAwVtB0EgKf0DzyuI0GLN+Y12e0unfAtX3YTzjtDC6fZkBJWmtONyepIw9xWg7BS4aEqq2abQzd4W4LeOSFIZ2cjKt/d/I+hlZvJ8Vl3NSxOPWjDMnmQeUZGj++qFy+gEY5PMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRBUT5zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRBUT5zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9928EC4CED1;
	Wed,  5 Feb 2025 14:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764507;
	bh=4d/S4Ngc9Ij27qDP6NtkdpK9ChT8rg5W/4Fpt8vZuJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRBUT5zcCtDEx/q9eznGsENU+b4afIxFzzhtCZI+CgnaPoKnNjnaygQEaA+V1KtgQ
	 ZtwxN7+3eyEYd5NYzfrpS1kJC4EAhgGMEKg+2j8N/AtccKp0a9GE79ggzBvGxBC5U7
	 nyt+aZYCX7ABBEU1adXtGcLM68Vfyc8FSxzs/Pwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 086/623] wifi: rtlwifi: do not complete firmware loading needlessly
Date: Wed,  5 Feb 2025 14:37:08 +0100
Message-ID: <20250205134459.514468499@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 11709b6c83f1a..40fc3c297a8ac 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2266,7 +2266,6 @@ int rtl_pci_probe(struct pci_dev *pdev,
 		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
 
 	pci_release_regions(pdev);
-	complete(&rtlpriv->firmware_loading_complete);
 
 fail1:
 	if (hw)
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index d37a017b2b814..c3aa0cd9ff211 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1040,7 +1040,6 @@ int rtl_usb_probe(struct usb_interface *intf,
 error_out2:
 	_rtl_usb_io_handler_release(hw);
 	usb_put_dev(udev);
-	complete(&rtlpriv->firmware_loading_complete);
 	kfree(rtlpriv->usb_data);
 	ieee80211_free_hw(hw);
 	return -ENODEV;
-- 
2.39.5



