Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A18134AC;
	Mon, 12 Aug 2024 16:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480012; cv=none; b=Y5g/5+UXQZKgHz6yMFeXEqMjZmjfA6RB7YhvWQ9xqgXAdauaq01Uxzctn0FM6QOgSUdvah/QbTBf57AqGKNh3xrrQxSMilZVcbng8iawjTBCJnvhtowKrmXFbg0Cwfqyjtwz89yg6IASP5JK2QwTFL9j+G3WdcohqI6sBKXR4r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480012; c=relaxed/simple;
	bh=LjyPXRB7jQRwZqXjO+MH1VvyWh651vdbat1ZiIjvfh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCugNmkD+t4/RpXcPQIsUZOZUGRC83Cq0G8qxWXWQLBbOz/y0GxeO5tV14ojkQAz56RgAYnqycUVFXbVYL6F5tw8mNG8qx5bqtdGri9jHeEGaH2tKgeEvE+GyC0hfbanQF7wL8NILNd0srniaFTnEVXyissEOVGm3R99HlSJV4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7qpIFt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7qpIFt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D09FC32782;
	Mon, 12 Aug 2024 16:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480012;
	bh=LjyPXRB7jQRwZqXjO+MH1VvyWh651vdbat1ZiIjvfh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7qpIFt96zlftz99nz2CYY94TrUn8rgWv/zAbSRY3oBt7+dTacVzXt62WaGDzBmqs
	 EMw/2tIsKmr0LI5FQZAOaFt/NMMp2affOoeN89crUp/XgIYU/j8PJ6G4bxhJhka9VL
	 XMchAn8D5bFdmntX0e5/h2AQ+rZtPbA8wwFtV3gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 069/263] wifi: rtw89: pci: fix RX tag race condition resulting in wrong RX length
Date: Mon, 12 Aug 2024 18:01:10 +0200
Message-ID: <20240812160149.185302929@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 94298477f81a1701fc4e1b5a0ce9672acab5dcb2 ]

Read 32 bits RX info to a local variable to fix race condition between
reading RX length and RX tag.

Another solution is to get RX tag at first statement, but adopted solution
can save some memory read, and also save 15 bytes binary code.

RX tag, a sequence number, is used to ensure that RX data has been DMA to
memory completely, so driver must check sequence number is expected before
reading other data.

This potential problem happens only after enabling 36-bit DMA.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/20240611021901.26394-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index b36aa9a6bb3fc..312b57d7da642 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -183,14 +183,17 @@ static void rtw89_pci_sync_skb_for_device(struct rtw89_dev *rtwdev,
 static void rtw89_pci_rxbd_info_update(struct rtw89_dev *rtwdev,
 				       struct sk_buff *skb)
 {
-	struct rtw89_pci_rxbd_info *rxbd_info;
 	struct rtw89_pci_rx_info *rx_info = RTW89_PCI_RX_SKB_CB(skb);
+	struct rtw89_pci_rxbd_info *rxbd_info;
+	__le32 info;
 
 	rxbd_info = (struct rtw89_pci_rxbd_info *)skb->data;
-	rx_info->fs = le32_get_bits(rxbd_info->dword, RTW89_PCI_RXBD_FS);
-	rx_info->ls = le32_get_bits(rxbd_info->dword, RTW89_PCI_RXBD_LS);
-	rx_info->len = le32_get_bits(rxbd_info->dword, RTW89_PCI_RXBD_WRITE_SIZE);
-	rx_info->tag = le32_get_bits(rxbd_info->dword, RTW89_PCI_RXBD_TAG);
+	info = rxbd_info->dword;
+
+	rx_info->fs = le32_get_bits(info, RTW89_PCI_RXBD_FS);
+	rx_info->ls = le32_get_bits(info, RTW89_PCI_RXBD_LS);
+	rx_info->len = le32_get_bits(info, RTW89_PCI_RXBD_WRITE_SIZE);
+	rx_info->tag = le32_get_bits(info, RTW89_PCI_RXBD_TAG);
 }
 
 static int rtw89_pci_validate_rx_tag(struct rtw89_dev *rtwdev,
-- 
2.43.0



