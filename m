Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9704A4A8430;
	Wed, 30 Sep 2026 18:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793028; cv=none; b=lU9skBVQGgP9J7bRk9rzywx4LINAWJxufQTbvhzVUHlJsBDkIMU0iicEncxHkZ34tcEpK2Og6z17TK47LbVkmLjjQqw9ddWFpoNEaZKYn7u7IFpptE9mFSiJPzmeGbkpmPhoGvbC5vfclCbHuZIRgwX7Qj3IAiIwtc8WnM0zAIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793028; c=relaxed/simple;
	bh=BAupECMP2iukexzt67syLSACnLmVDCKjtRx996cxOjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+piFyAw4ykFfzQwcY3/RLxLvW+KW+fJ+hjffMOGzfJ/F1yfRaf0c1UxpTH2GVN+xaFXvVm8WMa1jScGkuI3Mkt+GnpfSv3clp5v3YZFRF4nXmLpF02B32S73Ce5PSIGy0e+Ubent2mhUdjmt+tEU+pDFmuJb73WQOo+bpBoigg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihnEY97U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihnEY97U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09481F000FF;
	Wed, 30 Sep 2026 18:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793027;
	bh=LllACMnfdpWSx6PYYajV8MrRYgpVXpzLDA/gXmbJb1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ihnEY97U45/9kFZ1zlijQtl506lE4u4IhbU0UlUdH9AszUUpwj/V4ktLl34Nxe/NC
	 H6az2WSEkRivR0D7Sb5rUgn+8IJfsP1F+oLtlTLj6NYMiVOSvaU0bcl+5x5Bv2tUt/
	 TvR/u1GE/AiZ00gWCcDehE9JcrmG9mI5M451y7aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravindra <ravindra@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 109/395] Bluetooth: btintel_pcie: validate device-supplied DMA indices
Date: Wed, 30 Sep 2026 17:26:11 +0200
Message-ID: <20260930152343.002414849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Ravindra <ravindra@intel.com>

[ Upstream commit 37a11129345337efd6eef8e62b03b6348cd0dd8b ]

In btintel_pcie_msix_rx_handle(), the driver processes RX completion
descriptors (urbd1) written by the PCIe device into DMA-coherent memory.
urbd1->frbd_tag (a 16-bit field fully controlled by the device firmware
via DMA) is used directly as an array index into rxq->bufs[] without any
bounds check. rxq->bufs[] has only BTINTEL_PCIE_RX_DESCS_COUNT (64)
entries, while frbd_tag can be any value 0-65535. A malicious or
malfunctioning device can write an out-of-range frbd_tag, causing the
driver to dereference an out-of-bounds data_buf pointer.

Additionally, cr_hia is read from a DMA-shared index array also writable
by the device; if the device sets cr_hia >= rxq->count, the while-loop
never terminates because cr_tia is wrapped via modulo rxq->count and can
never equal an out-of-range cr_hia.

Add bounds validation for cr_hia and frbd_tag in the RX path, and cr_hia
in the TX path. Log invalid values with bt_dev_err before returning.

Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Ravindra <ravindra@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 8d3129aa2a1a3..3d1ed8568877c 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1018,6 +1018,11 @@ static void btintel_pcie_msix_tx_handle(struct btintel_pcie_data *data)
 
 	txq = &data->txq;
 
+	if (cr_hia >= txq->count) {
+		bt_dev_err(data->hdev, "TXQ: invalid cr_hia %u", cr_hia);
+		return;
+	}
+
 	while (cr_tia != cr_hia) {
 		data->tx_wait_done = true;
 		wake_up(&data->tx_wait_q);
@@ -1416,6 +1421,11 @@ static void btintel_pcie_msix_rx_handle(struct btintel_pcie_data *data)
 
 	rxq = &data->rxq;
 
+	if (cr_hia >= rxq->count) {
+		bt_dev_err(hdev, "RXQ: invalid cr_hia %u", cr_hia);
+		return;
+	}
+
 	/* The firmware sends multiple CD in a single MSI-X and it needs to
 	 * process all received CDs in this interrupt.
 	 */
@@ -1423,6 +1433,12 @@ static void btintel_pcie_msix_rx_handle(struct btintel_pcie_data *data)
 		urbd1 = &rxq->urbd1s[cr_tia];
 		ipc_print_urbd1(data->hdev, urbd1, cr_tia);
 
+		if (urbd1->frbd_tag >= rxq->count) {
+			bt_dev_err(hdev, "RXQ: invalid frbd_tag %u",
+				   urbd1->frbd_tag);
+			return;
+		}
+
 		buf = &rxq->bufs[urbd1->frbd_tag];
 		if (!buf) {
 			bt_dev_err(hdev, "RXQ: failed to get the DMA buffer for %d",
-- 
2.53.0



