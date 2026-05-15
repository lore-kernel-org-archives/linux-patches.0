Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7261C3FF1CD;
	Fri, 15 May 2026 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860756; cv=none; b=jqWgJ1JEeC+tNPjQ/ugc63IGnQvBrMBS6bJw7d28/0ZJyi2WeuPe7OevVo/yIPSXMIlubmPyMuoMqsO+Ot3jYtjA5N2avqhq62xRCtqa6racjoO9EucGLn0DZsDgK3pSutNFN6KEZSwpzMWA/WlW1I8ZbcjLL5e0pA5sNWXhXZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860756; c=relaxed/simple;
	bh=9hso23ufZrdlB2DImqhm21Uq+A8GEw+bldgDMtK3by0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDLgRT7YkeB+acRi2+W8nyKEydPNBeLpQEp5bTCNpGk9QrbdCBwQwQgHhMIGjKuwJFcVQynvM5/sP6/CWaPXTnesxmNOP9qPZyRkf/Icp+5Zu/irVnjnflRQ7tNl4c0sQQrJPOBJm2lYpgMvyHTDgXTMhuQ9ZwWwRyFSyEpumjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X90NZlKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X90NZlKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A56C2BCB3;
	Fri, 15 May 2026 15:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860756;
	bh=9hso23ufZrdlB2DImqhm21Uq+A8GEw+bldgDMtK3by0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X90NZlKZm3HMGXxP55ehE1ZWiRhGmLLvOqCdPIvUlexjlxpp7pZI9TEIXmXxkXQFB
	 tNHqON7VnbZgB09HmZCd+SC9fGJbkmJPgMIe/YWzMl2hxC4qpTEyI5ys/IB+J3EXOk
	 7up7kcttHxfDUoygq3wpqKnuEF3qLT6w0pyWe6PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.6 025/474] wifi: rtw88: check for PCI upstream bridge existence
Date: Fri, 15 May 2026 17:42:14 +0200
Message-ID: <20260515154715.596114417@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1749,7 +1749,8 @@ int rtw_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* Disable PCIe ASPM L1 while doing NAPI poll for 8821CE */
-	if (rtwdev->chip->id == RTW_CHIP_TYPE_8821C && bridge->vendor == PCI_VENDOR_ID_INTEL)
+	if (rtwdev->chip->id == RTW_CHIP_TYPE_8821C &&
+	    bridge && bridge->vendor == PCI_VENDOR_ID_INTEL)
 		rtwpci->rx_no_aspm = true;
 
 	rtw_pci_phy_cfg(rtwdev);


