Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4D73DE43E;
	Mon,  4 May 2026 14:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903699; cv=none; b=P4QGTIboy5uiusO7DntQzuxIgVDNVBTQSGpBLvlUY1cbURbJtiTm9E//0jzNZQq6Ks1UpRuKg+8aLIX593gw+fEQx8a24bZn3fDzi42D+pBfdLSmYQ1KmjQiqo1w1WVIsRZQpZxmH7uRLkw836lx4fBE7Z5RRF/OzMBcxFF6uQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903699; c=relaxed/simple;
	bh=EPaLAnquOPqXH7jK+fYrT1kSwKnZf+8ZxNMLp8BbTNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifa9cH5awUGe5Wh4Knbyqq8nOBRif3gTet9umN/Dx/+5Lz57F8CydId9otEfX0nO1NsSJt2f9V3vbRCYDoEWUfRx1OYFBxu+dq5dpJdXmc0N1f4PHhoeLlLfPFl0wjB2vH8rCSVrg7qnaCqCTDdzV3QC7qT66kh11+asM4NYhXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTz3mb4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTz3mb4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A060C2BCB8;
	Mon,  4 May 2026 14:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903698;
	bh=EPaLAnquOPqXH7jK+fYrT1kSwKnZf+8ZxNMLp8BbTNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTz3mb4eiP9XZsrUEwaOy8WFLLjb7f1UN/vKmRBRDesti30dQlt42HGOqV2BR04b4
	 62rKtQ0lMNc8uH57UU5xeqXFF4PHk2o8XfO34eBxfOKOiqxyxZaxq++dhrWfJkSrqt
	 6HbIGdzYXorDJy0LztMDLOdlr66IL5UggnBeixZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.18 028/275] wifi: rtw88: check for PCI upstream bridge existence
Date: Mon,  4 May 2026 15:49:28 +0200
Message-ID: <20260504135143.983941878@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


