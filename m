Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E4A43F097;
	Thu, 30 Jul 2026 14:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421806; cv=none; b=tZudU9SK+iNt1boxDRBiRrKFnXnuthFYCM56u7ikFBRgMDOlMsAHQbnkJk5lEWEcoXyqHOdL5aQQM9PwEB9lw3ez22xvI0OgPUqdRmpD25jZVVDmmes2snNG53kuJyUiIj2q1CEPYh7ZHK37I9zXB818X7gvCsUZAXIzHPuTXWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421806; c=relaxed/simple;
	bh=gSVCoSE/GxCt9mfTxc4ttiKdIyIDkNyKXgP7P0br7OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJxvM4iTDTBPUJI+6BtfuCy5heicMoX9R90shJU3OwJsyqZO9QIv7J12CJXynXpfLdAA0d5touaGGUflIxLQZyQ/bPnYP87SRKfdCfQ0OYFTyW5sqIFf1qMZqjmT4zlPD3LVYMbgsXgZaFc1rWz19tA5xwy7j5IE0IqtRVC35uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDbIOKXX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDbIOKXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C5A1F000E9;
	Thu, 30 Jul 2026 14:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421804;
	bh=YS7/dfov0bowMt8j2h1s62V13+2RGGdmxZDUxeF6W74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tDbIOKXXNh0POeRvIpFXWjsa4Flq9Lj2whkjKtXuoeH567vLxkFf/CpYveL5SlmSr
	 eWnSec/+taur6B98pU1Gd8/Pm3N2TVpOPJySfP6q1Vngu7HzZV38hQ/OmENXCqIQhd
	 1REJoBiLXfCGGyGSDnruWf80MzsBKDnbLfGXmHXo=
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
Subject: [PATCH 7.1 181/744] wifi: ath12k: Flush the posted write after writing to PCIE_SOC_GLOBAL_RESET
Date: Thu, 30 Jul 2026 16:07:34 +0200
Message-ID: <20260730141448.131724086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index d9a22d6afbb020..fee4129ea4055b 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -188,6 +188,8 @@ static void ath12k_pci_soc_global_reset(struct ath12k_base *ab)
 	val |= PCIE_SOC_GLOBAL_RESET_V;
 
 	ath12k_pci_write32(ab, PCIE_SOC_GLOBAL_RESET, val);
+	/* Flush the posted write to the device */
+	ath12k_pci_read32(ab, PCIE_SOC_GLOBAL_RESET);
 
 	/* TODO: exact time to sleep is uncertain */
 	delay = 10;
@@ -197,6 +199,8 @@ static void ath12k_pci_soc_global_reset(struct ath12k_base *ab)
 	val &= ~PCIE_SOC_GLOBAL_RESET_V;
 
 	ath12k_pci_write32(ab, PCIE_SOC_GLOBAL_RESET, val);
+	/* Flush the posted write to the device */
+	ath12k_pci_read32(ab, PCIE_SOC_GLOBAL_RESET);
 
 	mdelay(delay);
 
-- 
2.53.0



