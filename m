Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA701946C7;
	Wed,  5 Mar 2025 17:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197028; cv=none; b=ExusXYf6MlcblelBL0ucKC5FnoRcCUmh/jd1v5oSaDVxNjTG9QN5Qy3QH4JP8EhikQXz3ABWsVUzKqDz9QT0jC0wxa5TE+h84Bb2F9vJ2vUJmzA1sWqZ5TtGSdj6DC9p+7Yoykj4Yc4wCYHgMvsPE5n62oPopAf53E/zG/i5CBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197028; c=relaxed/simple;
	bh=4KYWw379CMHmzwa9URiDpYpHrnBiPOUJsOD4YJ8bs4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUiX96BdlXeYruhQf70YVeTMcuvZvR3wjP9YxEsy8xaTus2WSmLkwpFA0P8TEWLpjstxTirY7Znx2PGuMXznG2k5abLgnHfMiEDrQ0PdHcHv6TjiJ4ghFYnDoI+ofPLxFjEtScOC9oWEhHUWBUBhOw9I9atau2Jf4t3ANY+pyTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwNQalaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwNQalaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80607C4CED1;
	Wed,  5 Mar 2025 17:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197027;
	bh=4KYWw379CMHmzwa9URiDpYpHrnBiPOUJsOD4YJ8bs4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwNQalaIxUlIk1ysZFBOdh/gEIinKrpVLXaLeSh8qAEFIfIygUNUSJJXD3c/3INwj
	 4RYxvJsbOSUXuHR495NC0SET4TF6eQxMaAuNSr+xO0CPWjbdyUw32HtrLU1Z4uIOiJ
	 du87mIc0c5r1K6RnDClpPal/nHZ8zlQ0pxhUsQug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 015/176] Bluetooth: qca: Support downloading board id specific NVM for WCN7850
Date: Wed,  5 Mar 2025 18:46:24 +0100
Message-ID: <20250305174506.073606047@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit e41137d8bd1a8e8bab8dcbfe3ec056418db3df18 ]

Download board id specific NVM instead of default for WCN7850 if board id
is available.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: a2fad248947d ("Bluetooth: qca: Fix poor RF performance for WCN6855")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btqca.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 35fb26cbf2294..513ff87a7a049 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -739,6 +739,19 @@ static void qca_generate_hsp_nvm_name(char *fwname, size_t max_size,
 		snprintf(fwname, max_size, "qca/hpnv%02x%s.%x", rom_ver, variant, bid);
 }
 
+static inline void qca_get_nvm_name_generic(struct qca_fw_config *cfg,
+					    const char *stem, u8 rom_ver, u16 bid)
+{
+	if (bid == 0x0)
+		snprintf(cfg->fwname, sizeof(cfg->fwname), "qca/%snv%02x.bin", stem, rom_ver);
+	else if (bid & 0xff00)
+		snprintf(cfg->fwname, sizeof(cfg->fwname),
+			 "qca/%snv%02x.b%x", stem, rom_ver, bid);
+	else
+		snprintf(cfg->fwname, sizeof(cfg->fwname),
+			 "qca/%snv%02x.b%02x", stem, rom_ver, bid);
+}
+
 int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 		   enum qca_btsoc_type soc_type, struct qca_btsoc_version ver,
 		   const char *firmware_name)
@@ -819,7 +832,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 	/* Give the controller some time to get ready to receive the NVM */
 	msleep(10);
 
-	if (soc_type == QCA_QCA2066)
+	if (soc_type == QCA_QCA2066 || soc_type == QCA_WCN7850)
 		qca_read_fw_board_id(hdev, &boardid);
 
 	/* Download NVM configuration */
@@ -861,8 +874,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
 				 "qca/hpnv%02x.bin", rom_ver);
 			break;
 		case QCA_WCN7850:
-			snprintf(config.fwname, sizeof(config.fwname),
-				 "qca/hmtnv%02x.bin", rom_ver);
+			qca_get_nvm_name_generic(&config, "hmt", rom_ver, boardid);
 			break;
 
 		default:
-- 
2.39.5



