Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55DD1E505;
	Mon, 12 May 2025 17:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072756; cv=none; b=GCmpwcdd/37eNa/l0PMIL/ONVRskrWu+DLr3BFTsBlapQbchEXuWdsBPKLOf0fu3iUnFDQpMvLAROzai6A4kjrNK7ekB7xFY+8n6sB1x0IgjATgBUp8/nw1h8CJ5iKw5ptHp2scYlESXcKlt/9ce7clh1bhmcqANTMlphvLyeqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072756; c=relaxed/simple;
	bh=oh4RU2ujmKHmD4aT4x9zsf6aRgW1XaRuJVE+eSlAoao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HO1kO8ZxNnMElWtmueoRlzj83KibdwWHE8ltF1CCmWp7QdKHx5zl2Rw51UiL/rZw1fsbHpS5m5P/vvIDfhcdc7Y6O3/8cCueh/jQK3zyM1r+IcZZav6TWjlcUAuBdAthpHBSpqcFn+oRpJdQw1Zyvcled4xBWPPg7NEw9GrPAWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbR876xY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbR876xY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080C4C4CEE7;
	Mon, 12 May 2025 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072755;
	bh=oh4RU2ujmKHmD4aT4x9zsf6aRgW1XaRuJVE+eSlAoao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbR876xYlo9yV+8/JihMS5aSAEyxsIwXX5CRJSkbLeOguU59zJNKAGMQ/GCb4VAJ8
	 M0pXPrzWxsO048RTbKmmpxHvjgrLMBYdiPwREE19zNhS0QqAlnVBohqKJAVNMdgLl0
	 n4IWwUJh5NmVhqaGO/se5gM0Yx/9Z0fsiFQz+z7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/184] fbnic: Gate AXI read/write enabling on FW mailbox
Date: Mon, 12 May 2025 19:44:08 +0200
Message-ID: <20250512172043.652387805@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit 3b12f00ddd08e888273b2ac0488d396d90a836fc ]

In order to prevent the device from throwing spurious writes and/or reads
at us we need to gate the AXI fabric interface to the PCIe until such time
as we know the FW is in a known good state.

To accomplish this we use the mailbox as a mechanism for us to recognize
that the FW has acknowledged our presence and is no longer sending any
stale message data to us.

We start in fbnic_mbx_init by calling fbnic_mbx_reset_desc_ring function,
disabling the DMA in both directions, and then invalidating all the
descriptors in each ring.

We then poll the mailbox in fbnic_mbx_poll_tx_ready and when the interrupt
is set by the FW we pick it up and mark the mailboxes as ready, while also
enabling the DMA.

Once we have completed all the transactions and need to shut down we call
into fbnic_mbx_clean which will in turn call fbnic_mbx_reset_desc_ring for
each ring and shut down the DMA and once again invalidate the descriptors.

Fixes: 3646153161f1 ("eth: fbnic: Add register init to set PCIe/Ethernet device config")
Fixes: da3cde08209e ("eth: fbnic: Add FW communication mechanism")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/174654718623.499179.7445197308109347982.stgit@ahduyck-xeon-server.home.arpa
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_csr.h |  2 ++
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c  | 38 +++++++++++++++++----
 drivers/net/ethernet/meta/fbnic/fbnic_mac.c |  6 ----
 3 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_csr.h b/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
index 21db509acbc15..e91b4432fddd7 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
@@ -700,8 +700,10 @@ enum {
 /* PUL User Registers */
 #define FBNIC_CSR_START_PUL_USER	0x31000	/* CSR section delimiter */
 #define FBNIC_PUL_OB_TLP_HDR_AW_CFG	0x3103d		/* 0xc40f4 */
+#define FBNIC_PUL_OB_TLP_HDR_AW_CFG_FLUSH	CSR_BIT(19)
 #define FBNIC_PUL_OB_TLP_HDR_AW_CFG_BME		CSR_BIT(18)
 #define FBNIC_PUL_OB_TLP_HDR_AR_CFG	0x3103e		/* 0xc40f8 */
+#define FBNIC_PUL_OB_TLP_HDR_AR_CFG_FLUSH	CSR_BIT(19)
 #define FBNIC_PUL_OB_TLP_HDR_AR_CFG_BME		CSR_BIT(18)
 #define FBNIC_CSR_END_PUL_USER	0x31080	/* CSR section delimiter */
 
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 612d09ea08ebb..7db68fe7df940 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -51,10 +51,26 @@ static u64 __fbnic_mbx_rd_desc(struct fbnic_dev *fbd, int mbx_idx, int desc_idx)
 	return desc;
 }
 
-static void fbnic_mbx_init_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
+static void fbnic_mbx_reset_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
 {
 	int desc_idx;
 
+	/* Disable DMA transactions from the device,
+	 * and flush any transactions triggered during cleaning
+	 */
+	switch (mbx_idx) {
+	case FBNIC_IPC_MBX_RX_IDX:
+		wr32(fbd, FBNIC_PUL_OB_TLP_HDR_AW_CFG,
+		     FBNIC_PUL_OB_TLP_HDR_AW_CFG_FLUSH);
+		break;
+	case FBNIC_IPC_MBX_TX_IDX:
+		wr32(fbd, FBNIC_PUL_OB_TLP_HDR_AR_CFG,
+		     FBNIC_PUL_OB_TLP_HDR_AR_CFG_FLUSH);
+		break;
+	}
+
+	wrfl(fbd);
+
 	/* Initialize first descriptor to all 0s. Doing this gives us a
 	 * solid stop for the firmware to hit when it is done looping
 	 * through the ring.
@@ -90,7 +106,7 @@ void fbnic_mbx_init(struct fbnic_dev *fbd)
 	wr32(fbd, FBNIC_INTR_CLEAR(0), 1u << FBNIC_FW_MSIX_ENTRY);
 
 	for (i = 0; i < FBNIC_IPC_MBX_INDICES; i++)
-		fbnic_mbx_init_desc_ring(fbd, i);
+		fbnic_mbx_reset_desc_ring(fbd, i);
 }
 
 static int fbnic_mbx_map_msg(struct fbnic_dev *fbd, int mbx_idx,
@@ -155,7 +171,7 @@ static void fbnic_mbx_clean_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
 {
 	int i;
 
-	fbnic_mbx_init_desc_ring(fbd, mbx_idx);
+	fbnic_mbx_reset_desc_ring(fbd, mbx_idx);
 
 	for (i = FBNIC_IPC_MBX_DESC_LEN; i--;)
 		fbnic_mbx_unmap_and_free_msg(fbd, mbx_idx, i);
@@ -297,7 +313,7 @@ static int fbnic_fw_xmit_cap_msg(struct fbnic_dev *fbd)
 	return (err == -EOPNOTSUPP) ? 0 : err;
 }
 
-static void fbnic_mbx_postinit_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
+static void fbnic_mbx_init_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
 {
 	struct fbnic_fw_mbx *mbx = &fbd->mbx[mbx_idx];
 
@@ -309,10 +325,18 @@ static void fbnic_mbx_postinit_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
 
 	switch (mbx_idx) {
 	case FBNIC_IPC_MBX_RX_IDX:
+		/* Enable DMA writes from the device */
+		wr32(fbd, FBNIC_PUL_OB_TLP_HDR_AW_CFG,
+		     FBNIC_PUL_OB_TLP_HDR_AW_CFG_BME);
+
 		/* Make sure we have a page for the FW to write to */
 		fbnic_mbx_alloc_rx_msgs(fbd);
 		break;
 	case FBNIC_IPC_MBX_TX_IDX:
+		/* Enable DMA reads from the device */
+		wr32(fbd, FBNIC_PUL_OB_TLP_HDR_AR_CFG,
+		     FBNIC_PUL_OB_TLP_HDR_AR_CFG_BME);
+
 		/* Force version to 1 if we successfully requested an update
 		 * from the firmware. This should be overwritten once we get
 		 * the actual version from the firmware in the capabilities
@@ -329,7 +353,7 @@ static void fbnic_mbx_postinit(struct fbnic_dev *fbd)
 {
 	int i;
 
-	/* We only need to do this on the first interrupt following init.
+	/* We only need to do this on the first interrupt following reset.
 	 * this primes the mailbox so that we will have cleared all the
 	 * skip descriptors.
 	 */
@@ -339,7 +363,7 @@ static void fbnic_mbx_postinit(struct fbnic_dev *fbd)
 	wr32(fbd, FBNIC_INTR_CLEAR(0), 1u << FBNIC_FW_MSIX_ENTRY);
 
 	for (i = 0; i < FBNIC_IPC_MBX_INDICES; i++)
-		fbnic_mbx_postinit_desc_ring(fbd, i);
+		fbnic_mbx_init_desc_ring(fbd, i);
 }
 
 /**
@@ -761,7 +785,7 @@ int fbnic_mbx_poll_tx_ready(struct fbnic_dev *fbd)
 		 * avoid the mailbox getting stuck closed if the interrupt
 		 * is reset.
 		 */
-		fbnic_mbx_init_desc_ring(fbd, FBNIC_IPC_MBX_TX_IDX);
+		fbnic_mbx_reset_desc_ring(fbd, FBNIC_IPC_MBX_TX_IDX);
 
 		msleep(200);
 
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_mac.c b/drivers/net/ethernet/meta/fbnic/fbnic_mac.c
index 7b654d0a6dac6..06fa65e4f35b6 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_mac.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_mac.c
@@ -79,12 +79,6 @@ static void fbnic_mac_init_axi(struct fbnic_dev *fbd)
 	fbnic_init_readrq(fbd, FBNIC_QM_RNI_RBP_CTL, cls, readrq);
 	fbnic_init_mps(fbd, FBNIC_QM_RNI_RDE_CTL, cls, mps);
 	fbnic_init_mps(fbd, FBNIC_QM_RNI_RCM_CTL, cls, mps);
-
-	/* Enable XALI AR/AW outbound */
-	wr32(fbd, FBNIC_PUL_OB_TLP_HDR_AW_CFG,
-	     FBNIC_PUL_OB_TLP_HDR_AW_CFG_BME);
-	wr32(fbd, FBNIC_PUL_OB_TLP_HDR_AR_CFG,
-	     FBNIC_PUL_OB_TLP_HDR_AR_CFG_BME);
 }
 
 static void fbnic_mac_init_qm(struct fbnic_dev *fbd)
-- 
2.39.5



