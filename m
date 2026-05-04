Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3CC315785;
	Mon,  4 May 2026 14:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904458; cv=none; b=bBkd14D8urZ/W4xpU256op8gMDT1RIol/VEywA3/YpgLppiWAmY7BJpUNeH0/xdfL4WA6d4O2xow3pnnoF//8hW+2Z93b82fXovgcjDh3XLQki8xB6WxDAN9Wr5y6bF6RBB/9aI6jnDfOMqguGHkr4vYeFtz0m/+f4pOxMa3a5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904458; c=relaxed/simple;
	bh=ekXOpofTjeqO/VjlRPl844EP/LYjEpMGl7A/HOusN9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5667r/CLNgALtNIR1I5bAsKsgplqrev58KHXYzVEC4Um/zB0/SFI4ZpfIS3wNNgOxDKxEFBUYcXbLrZ0PqRdqrS0m577TIc5fiwIcfhppLdaKCiDVj+KjBMh9FzpktSEcu9SoyOAircPIxsTCW7Jg1Dwny2gjK37Na7GVs1QLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWapd+pU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWapd+pU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837E0C2BCB8;
	Mon,  4 May 2026 14:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904457;
	bh=ekXOpofTjeqO/VjlRPl844EP/LYjEpMGl7A/HOusN9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWapd+pURgz3zbueezq1rzWGSF/VeOEIezjlviW6eFoZiX93NFieS5niehMH508RX
	 GV5ZZJbu4H2hAN6o2t2JdJZHk/n3nf6xaS3mhIS/kG+/KXNUZze/Gp+DB5qiZjoT0r
	 01r7Kd21qfaUHbJxm0XRtc5Z6XUaknWlGJUKK2EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.12 029/215] wifi: rtw88: check for PCI upstream bridge existence
Date: Mon,  4 May 2026 15:50:48 +0200
Message-ID: <20260504135131.241002095@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1767,7 +1767,8 @@ int rtw_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* Disable PCIe ASPM L1 while doing NAPI poll for 8821CE */
-	if (rtwdev->chip->id == RTW_CHIP_TYPE_8821C && bridge->vendor == PCI_VENDOR_ID_INTEL)
+	if (rtwdev->chip->id == RTW_CHIP_TYPE_8821C &&
+	    bridge && bridge->vendor == PCI_VENDOR_ID_INTEL)
 		rtwpci->rx_no_aspm = true;
 
 	rtw_pci_phy_cfg(rtwdev);


