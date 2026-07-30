Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E9143F8CB;
	Thu, 30 Jul 2026 15:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423948; cv=none; b=cBNrmhR8+V+ChGoD6elWliwGxB89A8Q7miJi9QCYfrIIHPJUTiY9+45CNLEU7BlTQl2Hu15unqtswwrv0UH3yrwi6zPKnY6g12ihcoiBRudWrbJhFS8UBLj2jV1/x24LWkfatq5lUJlvi373COBAnodDwDcYbzve5h0OiyVTnhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423948; c=relaxed/simple;
	bh=LAaKu+lzQqijt0xZu10weO74033rkTuiCPMcx4W3+/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rV8IljjemZbSVSwmQfmy01uFLLnPDFUIt9lY2sztqpnJ7jTOtWEW0XsJXXpzaLS6YaPcBjxufGeq4V/6WcE8XmJ2k0NDgnGYNAjz3Q78eRfLDeG/6HyS6BuagerH476TlMq7FMP6nudTiHJ3353XD/P/drGjdOe386QC6fe7AH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9LdRwLR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9LdRwLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD211F000E9;
	Thu, 30 Jul 2026 15:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423947;
	bh=sCJHNy362wUL1GZU8a4Y8qcu65qlrEXZtiJscU5RNPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9LdRwLRGmG0TIy/bU39G33k0GJJ5VzNTEkhK3N6nRrcf264/lRTxjquUbxGMix02
	 QCzE2LvuMWYAbedV5SllcJNCbsF3J3y6P36W6BScPtLq6KqcshT3TruzuhbjlEOb5n
	 z44fjrpPGtRrtG/Cbp0Am+LPJFwwADw0uaCf/lEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex@shazbot.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 177/675] wifi: ath12k: Flush the posted write after writing to PCIE_SOC_GLOBAL_RESET
Date: Thu, 30 Jul 2026 16:08:27 +0200
Message-ID: <20260730141448.901712219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 55f3aa06951cac78b0206bde961c8cf11929a27a ]

ath12k_pci_soc_global_reset() tries to reset the device by writing to the
PCIE_SOC_GLOBAL_RESET register. But it doesn't do a read-back to ensure
that the write gets flushed to the device before the delay.

This may lead to the delay on the host to be insufficient, if the posted
write doesn't reach the device before the delay.

So add a read-back after writing to the PCIE_SOC_GLOBAL_RESET register and
before the delay.

Compile tested only.
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Reported-by: Alex Williamson <alex@shazbot.org>
Closes: https://lore.kernel.org/linux-pci/20260622160822.09350246@shazbot.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>
Tested-by: Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>
Link: https://patch.msgid.link/20260623141649.41087-2-manivannan.sadhasivam@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 60b8f7361b7f63..37f41635d3b00e 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -240,6 +240,8 @@ static void ath12k_pci_soc_global_reset(struct ath12k_base *ab)
 	val |= PCIE_SOC_GLOBAL_RESET_V;
 
 	ath12k_pci_write32(ab, PCIE_SOC_GLOBAL_RESET, val);
+	/* Flush the posted write to the device */
+	ath12k_pci_read32(ab, PCIE_SOC_GLOBAL_RESET);
 
 	/* TODO: exact time to sleep is uncertain */
 	delay = 10;
@@ -249,6 +251,8 @@ static void ath12k_pci_soc_global_reset(struct ath12k_base *ab)
 	val &= ~PCIE_SOC_GLOBAL_RESET_V;
 
 	ath12k_pci_write32(ab, PCIE_SOC_GLOBAL_RESET, val);
+	/* Flush the posted write to the device */
+	ath12k_pci_read32(ab, PCIE_SOC_GLOBAL_RESET);
 
 	mdelay(delay);
 
-- 
2.53.0



