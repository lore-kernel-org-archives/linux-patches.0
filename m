Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9425770838;
	Mon, 23 Jun 2025 21:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715951; cv=none; b=p3F04mWSvi4KT8oH0Ca8F8FkZtcPog469kRJKa5D4FLkJrEPpRzQfV7QU7gOKoXIz4Lv//D0ZV/eLkOtEyDpPh8adxL7xH1Qu0dPApzZlTF9X5AXxf7pweBELHY0OoKA/J02iCDCmqsse5HNSX0soinP2rly8iD1uhuI/3E3ejU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715951; c=relaxed/simple;
	bh=nNI5BkSwe3sKYjGsWOPzKnzWWLck64JopXx+/2dKxUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dblHelqrBXLV2Qce1ua3izmGRe/UW8Eq828jDNn60AXeNq6ZW/ln/cQ7D24r9P9GpIptmNdqOTHBS5yP93xIMoM8mrCVhmWGVnIZIYL2kWT0CqLgeq1cLEO2hLNC51uj8LNSFeusRvR4D9Ak++WidUbZBmKBzuTnxz8Q0tKkU9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ju5jbiqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ju5jbiqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC82C4CEF2;
	Mon, 23 Jun 2025 21:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715951;
	bh=nNI5BkSwe3sKYjGsWOPzKnzWWLck64JopXx+/2dKxUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ju5jbiqL8mdcAesMiv0P2EKk38Ox4NVo6cU37wr7TRZVc4Am2XQGUYbifQ4YYSPYp
	 Y0FzkGnCVCLVNtG8rKOYaDCHwNnG/0DkysFEtwVoSgRYP7+kTkbkZnLCV52D5nZF8P
	 Xgnw3aS5SaSpMMBFrp/dTYJ/HyGC1B2lUi5O/UHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chin-Yen Lee <timlee@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Zenm Chen <zenmchen@gmail.com>
Subject: [PATCH 6.6 231/290] wifi: rtw89: pci: use DBI function for 8852AE/8852BE/8851BE
Date: Mon, 23 Jun 2025 15:08:12 +0200
Message-ID: <20250623130633.876550929@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: Chin-Yen Lee <timlee@realtek.com>

commit 9496d62f3877bc0f97b415bc04af98d092878026 upstream.

Sometimes driver can't use kernel API pci_read/write_config_byte
to access the PCI config space of above address 0x100 due to
the negotiated PCI setting. 8852AE/8852BE/8851BE provide another
way called DBI function, which belongs to WiFi mac and could
access all PCI config space for this case.

Link: https://lore.kernel.org/linux-wireless/79fe81b7db7148b9a7da2353c16d70fb@realtek.com/T/#t
Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240103012346.6822-1-pkshih@realtek.com
Signed-off-by: Zenm Chen <zenmchen@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c |   69 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/realtek/rtw89/pci.h |    1 
 2 files changed, 68 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -1822,22 +1822,87 @@ static int rtw89_write16_mdio_clr(struct
 	return 0;
 }
 
+static int rtw89_dbi_write8(struct rtw89_dev *rtwdev, u16 addr, u8 data)
+{
+	u16 addr_2lsb = addr & B_AX_DBI_2LSB;
+	u16 write_addr;
+	u8 flag;
+	int ret;
+
+	write_addr = addr & B_AX_DBI_ADDR_MSK;
+	write_addr |= u16_encode_bits(BIT(addr_2lsb), B_AX_DBI_WREN_MSK);
+	rtw89_write8(rtwdev, R_AX_DBI_WDATA + addr_2lsb, data);
+	rtw89_write16(rtwdev, R_AX_DBI_FLAG, write_addr);
+	rtw89_write8(rtwdev, R_AX_DBI_FLAG + 2, B_AX_DBI_WFLAG >> 16);
+
+	ret = read_poll_timeout_atomic(rtw89_read8, flag, !flag, 10,
+				       10 * RTW89_PCI_WR_RETRY_CNT, false,
+				       rtwdev, R_AX_DBI_FLAG + 2);
+	if (ret)
+		rtw89_err(rtwdev, "failed to write DBI register, addr=0x%X\n",
+			  addr);
+
+	return ret;
+}
+
+static int rtw89_dbi_read8(struct rtw89_dev *rtwdev, u16 addr, u8 *value)
+{
+	u16 read_addr = addr & B_AX_DBI_ADDR_MSK;
+	u8 flag;
+	int ret;
+
+	rtw89_write16(rtwdev, R_AX_DBI_FLAG, read_addr);
+	rtw89_write8(rtwdev, R_AX_DBI_FLAG + 2, B_AX_DBI_RFLAG >> 16);
+
+	ret = read_poll_timeout_atomic(rtw89_read8, flag, !flag, 10,
+				       10 * RTW89_PCI_WR_RETRY_CNT, false,
+				       rtwdev, R_AX_DBI_FLAG + 2);
+	if (ret) {
+		rtw89_err(rtwdev, "failed to read DBI register, addr=0x%X\n",
+			  addr);
+		return ret;
+	}
+
+	read_addr = R_AX_DBI_RDATA + (addr & 3);
+	*value = rtw89_read8(rtwdev, read_addr);
+
+	return 0;
+}
+
 static int rtw89_pci_write_config_byte(struct rtw89_dev *rtwdev, u16 addr,
 				       u8 data)
 {
 	struct rtw89_pci *rtwpci = (struct rtw89_pci *)rtwdev->priv;
+	enum rtw89_core_chip_id chip_id = rtwdev->chip->chip_id;
 	struct pci_dev *pdev = rtwpci->pdev;
+	int ret;
 
-	return pci_write_config_byte(pdev, addr, data);
+	ret = pci_write_config_byte(pdev, addr, data);
+	if (!ret)
+		return 0;
+
+	if (chip_id == RTL8852A || chip_id == RTL8852B || chip_id == RTL8851B)
+		ret = rtw89_dbi_write8(rtwdev, addr, data);
+
+	return ret;
 }
 
 static int rtw89_pci_read_config_byte(struct rtw89_dev *rtwdev, u16 addr,
 				      u8 *value)
 {
 	struct rtw89_pci *rtwpci = (struct rtw89_pci *)rtwdev->priv;
+	enum rtw89_core_chip_id chip_id = rtwdev->chip->chip_id;
 	struct pci_dev *pdev = rtwpci->pdev;
+	int ret;
+
+	ret = pci_read_config_byte(pdev, addr, value);
+	if (!ret)
+		return 0;
+
+	if (chip_id == RTL8852A || chip_id == RTL8852B || chip_id == RTL8851B)
+		ret = rtw89_dbi_read8(rtwdev, addr, value);
 
-	return pci_read_config_byte(pdev, addr, value);
+	return ret;
 }
 
 static int rtw89_pci_config_byte_set(struct rtw89_dev *rtwdev, u16 addr,
--- a/drivers/net/wireless/realtek/rtw89/pci.h
+++ b/drivers/net/wireless/realtek/rtw89/pci.h
@@ -42,6 +42,7 @@
 #define B_AX_DBI_WFLAG			BIT(16)
 #define B_AX_DBI_WREN_MSK		GENMASK(15, 12)
 #define B_AX_DBI_ADDR_MSK		GENMASK(11, 2)
+#define B_AX_DBI_2LSB			GENMASK(1, 0)
 #define R_AX_DBI_WDATA			0x1094
 #define R_AX_DBI_RDATA			0x1098
 


