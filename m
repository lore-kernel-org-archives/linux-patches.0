Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1762126C18;
	Wed,  5 Feb 2025 13:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763354; cv=none; b=sfv7PuSYMCzbTOdI9E9b98dwspa/SY2SAWAX/mNP/qPdi+CQE1EQmGPgKWDMHx25qo8WyqPdw+EvMIqS8/BCx65z4krdGc9Tx0bcqE+HqfA85ZZBc+yvPkCjWnnbK8POckPBlh5KghBDt5KuLRXuJv+tJ/CccYqoNcmsPA3kTkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763354; c=relaxed/simple;
	bh=k6PqeWD5gGZVewjEpmMIrZYi9ZaBVPUx1FvW9WXMaWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNQ3acxJAQcUMD5Iq9vASZzcxb1BhaBLKPb4tR2DadV63uIXxgQQCk11n/+S5iZRv3ROIpcy3QeTwZOL71yv5XqEx+KYCZjMakUQPURhmyaYNTjIyay1N3o8++cWfx0TVQr21XSpBNonwVFFJsJcEek78pls7bEKm63XXJ88jUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5ePaeIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5ePaeIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31267C4CED1;
	Wed,  5 Feb 2025 13:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763354;
	bh=k6PqeWD5gGZVewjEpmMIrZYi9ZaBVPUx1FvW9WXMaWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5ePaeIokBQWKAayuH+85nXLzNkJRYkE1lIK4YJAFkBfOkH+MMVt3FD2rNjbiIxoN
	 lMlsHgviDXATlXqMBoSYLBRgilreQgcSCzEhQTso5f2kvd8KItdgUl5yRPYX5pincK
	 HmFYhfPj3xVMrekAhwKsgTyV5UaUa5MJd7wTJSYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/393] wifi: rtlwifi: do not complete firmware loading needlessly
Date: Wed,  5 Feb 2025 14:39:28 +0100
Message-ID: <20250205134422.176657880@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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
index b118df035243c..766e43f13d3f5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2268,7 +2268,6 @@ int rtl_pci_probe(struct pci_dev *pdev,
 		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
 
 	pci_release_regions(pdev);
-	complete(&rtlpriv->firmware_loading_complete);
 
 fail1:
 	if (hw)
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 30bf2775a335b..427547de61678 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1066,7 +1066,6 @@ int rtl_usb_probe(struct usb_interface *intf,
 error_out2:
 	_rtl_usb_io_handler_release(hw);
 	usb_put_dev(udev);
-	complete(&rtlpriv->firmware_loading_complete);
 	kfree(rtlpriv->usb_data);
 	ieee80211_free_hw(hw);
 	return -ENODEV;
-- 
2.39.5



