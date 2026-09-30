Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EB951C06B;
	Wed, 30 Sep 2026 17:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789148; cv=none; b=MluijKojOmbJ8mQdKF65jI7h0Y7eRM1SVqPsVfH4jE0G+qvPZ009c46mlkWlEAGC5tQsX+RBrYXz/c+MAHBfhSpHW66YZGOWrDrYznI3itj2N8J8VGm5QSsIZMGsdFNxEQWWfM4D3MGjgjvKwx3tXTRscYLgoP/8vZf15gCUwCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789148; c=relaxed/simple;
	bh=ecpNKwe6FPUVew0c3jNgTYb1JP1/MRx9TuDoVUcwFao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcPePRNyLo76yJdycukW4pDaftXKIPqRLTxpaxi/cpoHHeQ91NcwH569vYOzuKN6rmreYW4Cqik++YIhZWGBA3R/YnnBckVfIoPsQ381u4IPrlO2kLIFZdHHOtCs+ApQqwxJJ7X4LyeA0dj3D8wZHnBbxMvrc4vJmFGFZffa8As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PK8zpXGU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PK8zpXGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30741F00898;
	Wed, 30 Sep 2026 17:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789147;
	bh=7kbLVv8s8CxHdIz63rwTl999hvUZj2kYnXtw4ctqiC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PK8zpXGUCJz8tn/VtTFw96VsKu0nlMeq50VjYAZLjSvibrsrKyzZuwBihPgN+xD49
	 lBNZzoDpx9x6ckkvN3FqeXvZfzHaRoXrH0PcaC82lAP9CAQTv1vZJ1RNqAv3F8/rPM
	 bKRNokxTGJtdiV3+TkCdd5J+HKMsbo91TREBmzMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravindra <ravindra@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 375/877] Bluetooth: btintel_pcie: validate device-supplied DMA indices
Date: Wed, 30 Sep 2026 17:21:26 +0200
Message-ID: <20260930152422.767312506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index bc87ebc46f4db..9facd47ff89b9 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -513,6 +513,11 @@ static void btintel_pcie_msix_tx_handle(struct btintel_pcie_data *data)
 
 	txq = &data->txq;
 
+	if (cr_hia >= txq->count) {
+		bt_dev_err(data->hdev, "TXQ: invalid cr_hia %u", cr_hia);
+		return;
+	}
+
 	while (cr_tia != cr_hia) {
 		data->tx_wait_done = true;
 		wake_up(&data->tx_wait_q);
@@ -786,6 +791,11 @@ static void btintel_pcie_msix_rx_handle(struct btintel_pcie_data *data)
 
 	rxq = &data->rxq;
 
+	if (cr_hia >= rxq->count) {
+		bt_dev_err(hdev, "RXQ: invalid cr_hia %u", cr_hia);
+		return;
+	}
+
 	/* The firmware sends multiple CD in a single MSI-X and it needs to
 	 * process all received CDs in this interrupt.
 	 */
@@ -793,6 +803,12 @@ static void btintel_pcie_msix_rx_handle(struct btintel_pcie_data *data)
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



