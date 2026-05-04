Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99013DB642;
	Mon,  4 May 2026 13:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903002; cv=none; b=N14E8tltqt9t/mRC7wPP5ofkuxa4E3Pt87CB15/2qeGw5mMiOXDklwtyiZAUKz0EJq1Hbwro6oNZbj4daaa5HeOhwDk2Ydqpb7CAC+3U2b7PFNnT9QiV92flRvVT3WZ8Rk3vnrgbVg9FwQ1uH8TW3TZjIsA+x9moMEzNXvsFcG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903002; c=relaxed/simple;
	bh=LFLJoOyd3G+i0scQJh4XaAcHmKZBEfh4HrdnC3/24hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPsPmbOhufkRTfeJnxvguo+6M4i+9acy3AGnBmK0wRrP1F5eqBZ5HlH4nBGNDLGHhvmGRX2yDq4GE+5RBsVLC2DV3OT7+fUa4HNpgj3CE2HHUuPVqQ+4VyC9M/TsVtE5qceYh5g3+OPwAUeNAPk08EUm2RjuMCWrB1WHuWfsbMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZpioydY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZpioydY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053E6C2BCB8;
	Mon,  4 May 2026 13:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903002;
	bh=LFLJoOyd3G+i0scQJh4XaAcHmKZBEfh4HrdnC3/24hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZpioydYgHoMgm+9uKqyUWlDQiy0L+9Msa9gdvQmEqudxPBHOP6GSmw8/B9rRVR03
	 W/yBynlCJB3nZOMqYZmaz/HyManU4dIp2uYSbu0jwaoDuXY1R516N+1fQgHyeyLJpl
	 KDohdrRc4vGVBhprNNveAzxch/VKxP2yyem8JSWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 7.0 033/307] wifi: rtw88: check for PCI upstream bridge existence
Date: Mon,  4 May 2026 15:48:38 +0200
Message-ID: <20260504135144.075884918@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit eb101d2abdcccb514ca4fccd3b278dd8267374f6 upstream.

pci_upstream_bridge() returns NULL if the device is on a root bus.  If
8821CE is installed in the system with such a PCI topology, the probing
routine will crash.  This has probably been unnoticed as 8821CE is mostly
supplied in laptops where there is a PCI-to-PCI bridge located upstream
from the device.  However the card might be installed on a system with
different configuration.

Check if the bridge does exist for the specific workaround to be applied.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Fixes: 24f5e38a13b5 ("rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260220094730.49791-1-pchelkin@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1804,7 +1804,8 @@ int rtw_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* Disable PCIe ASPM L1 while doing NAPI poll for 8821CE */
-	if (rtwdev->chip->id == RTW_CHIP_TYPE_8821C && bridge->vendor == PCI_VENDOR_ID_INTEL)
+	if (rtwdev->chip->id == RTW_CHIP_TYPE_8821C &&
+	    bridge && bridge->vendor == PCI_VENDOR_ID_INTEL)
 		rtwpci->rx_no_aspm = true;
 
 	rtw_pci_phy_cfg(rtwdev);


