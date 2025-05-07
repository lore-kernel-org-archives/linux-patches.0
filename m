Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985C829A0;
	Wed,  7 May 2025 19:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644549; cv=none; b=KQ3yuc3jSm/UEG92j4c7tnclHAYe8VZVQG9ik4HdZmpstUCVD8E/vdwCx/BwMzyiGSdxuNsTJGIARg/uvIj5+zYgGQ72d6GnMTPgRfXvDjFoSE0o+XdrHCWJ4AjrTo8HrUYdLUve5RfZgVzHahlGrcsz5/J5uEup/cBmGcbH4Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644549; c=relaxed/simple;
	bh=NqgCnTppeOUBLPQCDgSHdBvng0o4WIZJH9ZKdpbYwLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHXg/LeEK2u3+gkH8F4DAgDNzmdadarpOy6UtVnO6kLtdIiNf8QVYTwGCRmZ/zKzmwD1Hv+leGdFMXE0e1lftB4HEs06dAVYnDP2zVcb4xmVuLYAkh628jndVMYPui4A3pTGWYCRfkbF5yxjOAMMVxr+piK6D6Ruvm9aQltNebA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1L6RwDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1L6RwDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00978C4CEE2;
	Wed,  7 May 2025 19:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644549;
	bh=NqgCnTppeOUBLPQCDgSHdBvng0o4WIZJH9ZKdpbYwLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v1L6RwDdTBMqIj2D5begqgMJMNd5ziscUFwwN4MCMSJAmnIXOIxEi8DpT3fv/6UTg
	 9GTVoBEjxlxycsbxsEOrm8anpZrWCx4io+w0n4iIpSzWMLWaBRgtEw2pRmIS5nBA0b
	 0KXL4MTr4lYqpUPz3FkFSImOpN/cMF/9jrHYEWcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/164] Bluetooth: btintel_pcie: Add additional to checks to clear TX/RX paths
Date: Wed,  7 May 2025 20:39:24 +0200
Message-ID: <20250507183824.161026068@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 1c7664957e4edb234c69de2db4be1f740d2df564 ]

Due to a hardware issue, there is a possibility that the driver may miss
an MSIx interrupt on the RX/TX data path. Since the TX and RX paths are
independent, when a TX MSIx interrupt occurs, the driver can check the
RX queue for any pending data and process it if present. The same
approach applies to the RX path.

Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 3d6067927f7ea..d225f0a37f985 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -761,10 +761,8 @@ static void btintel_pcie_msix_rx_handle(struct btintel_pcie_data *data)
 	bt_dev_dbg(hdev, "RXQ: cr_hia: %u  cr_tia: %u", cr_hia, cr_tia);
 
 	/* Check CR_TIA and CR_HIA for change */
-	if (cr_tia == cr_hia) {
-		bt_dev_warn(hdev, "RXQ: no new CD found");
+	if (cr_tia == cr_hia)
 		return;
-	}
 
 	rxq = &data->rxq;
 
@@ -800,6 +798,16 @@ static irqreturn_t btintel_pcie_msix_isr(int irq, void *data)
 	return IRQ_WAKE_THREAD;
 }
 
+static inline bool btintel_pcie_is_rxq_empty(struct btintel_pcie_data *data)
+{
+	return data->ia.cr_hia[BTINTEL_PCIE_RXQ_NUM] == data->ia.cr_tia[BTINTEL_PCIE_RXQ_NUM];
+}
+
+static inline bool btintel_pcie_is_txackq_empty(struct btintel_pcie_data *data)
+{
+	return data->ia.cr_tia[BTINTEL_PCIE_TXQ_NUM] == data->ia.cr_hia[BTINTEL_PCIE_TXQ_NUM];
+}
+
 static irqreturn_t btintel_pcie_irq_msix_handler(int irq, void *dev_id)
 {
 	struct msix_entry *entry = dev_id;
@@ -827,12 +835,18 @@ static irqreturn_t btintel_pcie_irq_msix_handler(int irq, void *dev_id)
 		btintel_pcie_msix_gp0_handler(data);
 
 	/* For TX */
-	if (intr_fh & BTINTEL_PCIE_MSIX_FH_INT_CAUSES_0)
+	if (intr_fh & BTINTEL_PCIE_MSIX_FH_INT_CAUSES_0) {
 		btintel_pcie_msix_tx_handle(data);
+		if (!btintel_pcie_is_rxq_empty(data))
+			btintel_pcie_msix_rx_handle(data);
+	}
 
 	/* For RX */
-	if (intr_fh & BTINTEL_PCIE_MSIX_FH_INT_CAUSES_1)
+	if (intr_fh & BTINTEL_PCIE_MSIX_FH_INT_CAUSES_1) {
 		btintel_pcie_msix_rx_handle(data);
+		if (!btintel_pcie_is_txackq_empty(data))
+			btintel_pcie_msix_tx_handle(data);
+	}
 
 	/*
 	 * Before sending the interrupt the HW disables it to prevent a nested
-- 
2.39.5



