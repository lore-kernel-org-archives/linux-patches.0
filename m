Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9B62116E9;
	Wed,  7 May 2025 18:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644082; cv=none; b=ODSi6NLs6WA/n3xLz4+x81W0Dy+PkZEWogxxwkAThZ3akPe4s/ZoWuxmIJZAAGvd8M4Cq7CLA/LJL74M6nLseRkwFna+JOlKGLvKPU07kYQ/+sc4fuP4pYkaNq4estFKi1p2INzYrNX0Ep6lVuKeoZ5T6ZhY2pDkbnCpW/QDRgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644082; c=relaxed/simple;
	bh=eI+xvl6Qv3UeibZScHzASqOmOv9Jpq/oB2o9cR+jqIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQyiIMytHsGuI3+yyjB4uhU3UhkRZXA6derwd0Fdyld8fb0t0BQvW/bcinS7Aoh/sGSDxBhnZULhakg0PufxEz1Zml4P/EIZCZmEq8jcaid/drjHtNwKXnmPvFJ8JKFpJ365EDTxj8s3z1iyrdLz0jId8wBNgtapF5PAigD6RW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytOCfu/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytOCfu/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF891C4CEE2;
	Wed,  7 May 2025 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644082;
	bh=eI+xvl6Qv3UeibZScHzASqOmOv9Jpq/oB2o9cR+jqIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ytOCfu/MyZcM85NIGqLPsqESnrB6q1vp4H0N/TVD9hJyrVShFpCNaQTmk5cLEPI/x
	 16XFKZdUKnTPufvpz43FkDopFlIU5skwSDBtlB+tLQoYe52m83r6uwWXHNJKN0003s
	 R3+IAUgVpUFE9ubP15wIKVFWG07GtLrgHcJcFtEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 084/183] Bluetooth: btintel_pcie: Add additional to checks to clear TX/RX paths
Date: Wed,  7 May 2025 20:38:49 +0200
Message-ID: <20250507183828.235628741@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index ea9b137b1491c..1636f636fbef0 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -773,10 +773,8 @@ static void btintel_pcie_msix_rx_handle(struct btintel_pcie_data *data)
 	bt_dev_dbg(hdev, "RXQ: cr_hia: %u  cr_tia: %u", cr_hia, cr_tia);
 
 	/* Check CR_TIA and CR_HIA for change */
-	if (cr_tia == cr_hia) {
-		bt_dev_warn(hdev, "RXQ: no new CD found");
+	if (cr_tia == cr_hia)
 		return;
-	}
 
 	rxq = &data->rxq;
 
@@ -812,6 +810,16 @@ static irqreturn_t btintel_pcie_msix_isr(int irq, void *data)
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
@@ -839,12 +847,18 @@ static irqreturn_t btintel_pcie_irq_msix_handler(int irq, void *dev_id)
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



