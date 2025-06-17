Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292112EE5FF;
	Tue, 17 Jun 2025 16:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177938; cv=none; b=D7suG2u5jfcBi5kmGM+DCPwFgtdgto2edflKKfRKmK/eKdg/EroNizEgMWSyV7iuidNgPXNEt3bNFlu9c2LoruLMDKpRtbCBZCsJo+0F8XQ4W0KEN2p9I8uS1CZKyzQJWcr9qVVr5SilFQHf8xlpGUWCJj3JG4KwUTMyuLGyteg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177938; c=relaxed/simple;
	bh=ekNboKFFYXbB3pqvYgYg/3KJJS6ZnCVtRsPG8UDZgwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7CjMmKB8u8YgCAoLgZnaAlT1QM3jpUgAta7NKgPvn5FRg3XJ8T+Wg9WwfsIkUKCPj47ILJXj66COcyZEWDcu8kqwgezmiZN6QEfEI9mywIKpuom6UTs2J68VoTySUZZIQDAkLQazBGsQeQngI0pa+vZPMqrVqGBmMqMppGjx1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fUMFXbCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fUMFXbCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F101C4CEE3;
	Tue, 17 Jun 2025 16:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177938;
	bh=ekNboKFFYXbB3pqvYgYg/3KJJS6ZnCVtRsPG8UDZgwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUMFXbCkeAO5xDcJFy/AXxGIDSMsx3qpXIm6IHq6LEnTzIr0zgBEtn1San5ObFajx
	 z9Flr8PV08wkrJpxV14wRTW/BzcnkYYZZvyJkKesdNj1nlT1ekpgE4RT8e5wRplxmE
	 lpEcBCITaPrBsxRe+o/2FPnmikwjOHLPx90L9JC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 421/512] Bluetooth: btintel_pcie: Increase the tx and rx descriptor count
Date: Tue, 17 Jun 2025 17:26:27 +0200
Message-ID: <20250617152436.632935442@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

[ Upstream commit 2dd711102ce69ae41f65d09c012441227d4aa983 ]

This change addresses latency issues observed in HID use cases where
events arrive in bursts. By increasing the Rx descriptor count to 64,
the firmware can handle bursty data more effectively, reducing latency
and preventing buffer overflows.

Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Kiran K <kiran.k@intel.com>
Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 24 ++++++++++++------------
 drivers/bluetooth/btintel_pcie.h |  7 +++++--
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index b8065b7ec70b6..c02d671396e24 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1148,8 +1148,8 @@ static int btintel_pcie_alloc(struct btintel_pcie_data *data)
 	 *  + size of index * Number of queues(2) * type of index array(4)
 	 *  + size of context information
 	 */
-	total = (sizeof(struct tfd) + sizeof(struct urbd0) + sizeof(struct frbd)
-		+ sizeof(struct urbd1)) * BTINTEL_DESCS_COUNT;
+	total = (sizeof(struct tfd) + sizeof(struct urbd0)) * BTINTEL_PCIE_TX_DESCS_COUNT;
+	total += (sizeof(struct frbd) + sizeof(struct urbd1)) * BTINTEL_PCIE_RX_DESCS_COUNT;
 
 	/* Add the sum of size of index array and size of ci struct */
 	total += (sizeof(u16) * BTINTEL_PCIE_NUM_QUEUES * 4) + sizeof(struct ctx_info);
@@ -1174,36 +1174,36 @@ static int btintel_pcie_alloc(struct btintel_pcie_data *data)
 	data->dma_v_addr = v_addr;
 
 	/* Setup descriptor count */
-	data->txq.count = BTINTEL_DESCS_COUNT;
-	data->rxq.count = BTINTEL_DESCS_COUNT;
+	data->txq.count = BTINTEL_PCIE_TX_DESCS_COUNT;
+	data->rxq.count = BTINTEL_PCIE_RX_DESCS_COUNT;
 
 	/* Setup tfds */
 	data->txq.tfds_p_addr = p_addr;
 	data->txq.tfds = v_addr;
 
-	p_addr += (sizeof(struct tfd) * BTINTEL_DESCS_COUNT);
-	v_addr += (sizeof(struct tfd) * BTINTEL_DESCS_COUNT);
+	p_addr += (sizeof(struct tfd) * BTINTEL_PCIE_TX_DESCS_COUNT);
+	v_addr += (sizeof(struct tfd) * BTINTEL_PCIE_TX_DESCS_COUNT);
 
 	/* Setup urbd0 */
 	data->txq.urbd0s_p_addr = p_addr;
 	data->txq.urbd0s = v_addr;
 
-	p_addr += (sizeof(struct urbd0) * BTINTEL_DESCS_COUNT);
-	v_addr += (sizeof(struct urbd0) * BTINTEL_DESCS_COUNT);
+	p_addr += (sizeof(struct urbd0) * BTINTEL_PCIE_TX_DESCS_COUNT);
+	v_addr += (sizeof(struct urbd0) * BTINTEL_PCIE_TX_DESCS_COUNT);
 
 	/* Setup FRBD*/
 	data->rxq.frbds_p_addr = p_addr;
 	data->rxq.frbds = v_addr;
 
-	p_addr += (sizeof(struct frbd) * BTINTEL_DESCS_COUNT);
-	v_addr += (sizeof(struct frbd) * BTINTEL_DESCS_COUNT);
+	p_addr += (sizeof(struct frbd) * BTINTEL_PCIE_RX_DESCS_COUNT);
+	v_addr += (sizeof(struct frbd) * BTINTEL_PCIE_RX_DESCS_COUNT);
 
 	/* Setup urbd1 */
 	data->rxq.urbd1s_p_addr = p_addr;
 	data->rxq.urbd1s = v_addr;
 
-	p_addr += (sizeof(struct urbd1) * BTINTEL_DESCS_COUNT);
-	v_addr += (sizeof(struct urbd1) * BTINTEL_DESCS_COUNT);
+	p_addr += (sizeof(struct urbd1) * BTINTEL_PCIE_RX_DESCS_COUNT);
+	v_addr += (sizeof(struct urbd1) * BTINTEL_PCIE_RX_DESCS_COUNT);
 
 	/* Setup data buffers for txq */
 	err = btintel_pcie_setup_txq_bufs(data, &data->txq);
diff --git a/drivers/bluetooth/btintel_pcie.h b/drivers/bluetooth/btintel_pcie.h
index 5f7747f334ab8..ee0eec0237afd 100644
--- a/drivers/bluetooth/btintel_pcie.h
+++ b/drivers/bluetooth/btintel_pcie.h
@@ -81,8 +81,11 @@ enum {
 /* Default interrupt timeout in msec */
 #define BTINTEL_DEFAULT_INTR_TIMEOUT_MS	3000
 
-/* The number of descriptors in TX/RX queues */
-#define BTINTEL_DESCS_COUNT	16
+/* The number of descriptors in TX queues */
+#define BTINTEL_PCIE_TX_DESCS_COUNT	32
+
+/* The number of descriptors in RX queues */
+#define BTINTEL_PCIE_RX_DESCS_COUNT	64
 
 /* Number of Queue for TX and RX
  * It indicates the index of the IA(Index Array)
-- 
2.39.5



