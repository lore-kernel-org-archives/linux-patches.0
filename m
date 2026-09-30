Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459FB51617E;
	Wed, 30 Sep 2026 16:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787147; cv=none; b=Z5vR9UOeXuGTlWegN15AfrZwDkrVf+80g1MDTe16OO3IcNNFEL+Fq+xH+mdEhouNZZndupPHsyv3gqL5Gf1oio0WEB0gdO5pv2rxD5Ef7CzP75qm02yodJoZzYf13rWJOLLL9hj+A3PckIBsfagqOH0zc2OblmcDu/X6d6yaLug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787147; c=relaxed/simple;
	bh=LNLW5kty72SzpFFT7IYJgKJfrcY2Ih27qGj83BE2voo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLcYpCzmaMCOwr5tSpFQLEbDv6l3ygMinal+vaa7YDcna7Q7uhSKgZo7SOINdT7dSXxJXgY+epsH9nzUF167bbtxX4wQaB0Psx3OrRglt1luchXfELU1eJCUIEq7mdG0/zkBx8o7TbCVqCmcrKiQAU2rj+eGPaE/FnQoof87yKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tY48Sykk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tY48Sykk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935911F000FF;
	Wed, 30 Sep 2026 16:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787146;
	bh=4gCRjo2Wg9Slft66RpUGmO9B4OoKtVYnxfz2e00W+RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tY48SykkbKuhh1UsRFAq26zKMtCoirm7MBpTiRZ4gfJQ7jdx/yKzVI7op7coyM91x
	 f7Q6xkj5jh3bEvEVNHWts+VWqYO3iK7RCURU5uosJr0pVpoBHkP1H8hVRCpBNPL6RV
	 dhlo0E1kZbdhAO4d31IKdrmE7Z9Um6H8I7B9u8P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravindra <ravindra@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 128/457] Bluetooth: btintel_pcie: validate device-supplied DMA indices
Date: Wed, 30 Sep 2026 17:23:53 +0200
Message-ID: <20260930152348.811160413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 3262e950a6bd8..9381895dc3cf0 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1099,6 +1099,11 @@ static void btintel_pcie_msix_tx_handle(struct btintel_pcie_data *data)
 
 	txq = &data->txq;
 
+	if (cr_hia >= txq->count) {
+		bt_dev_err(data->hdev, "TXQ: invalid cr_hia %u", cr_hia);
+		return;
+	}
+
 	while (cr_tia != cr_hia) {
 		data->tx_wait_done = true;
 		wake_up(&data->tx_wait_q);
@@ -1588,6 +1593,11 @@ static void btintel_pcie_msix_rx_handle(struct btintel_pcie_data *data)
 
 	rxq = &data->rxq;
 
+	if (cr_hia >= rxq->count) {
+		bt_dev_err(hdev, "RXQ: invalid cr_hia %u", cr_hia);
+		return;
+	}
+
 	/* The firmware sends multiple CD in a single MSI-X and it needs to
 	 * process all received CDs in this interrupt.
 	 */
@@ -1595,6 +1605,12 @@ static void btintel_pcie_msix_rx_handle(struct btintel_pcie_data *data)
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



