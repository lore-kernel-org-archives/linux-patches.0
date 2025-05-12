Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBCA248F49;
	Mon, 12 May 2025 17:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072771; cv=none; b=CKiF1vU9PW/Qq7ZVEN4YeqsLCGVrQChJGxXs7lmv++CbXeRfdFATi87Ig9473IJwQSsGhCsVgehm15CJd4tKHNqa3juQMMcylCQyXsUdLBhy57VQhcI3dNi9fljelh+vMvpIYRw2HxXSJs29b0kRBvZv0+PI9dKU4Camy5XB9GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072771; c=relaxed/simple;
	bh=pO90g+a8K6EaTZbyZs7uK8qPU60qemNQaKJD3rghM6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlwPbSStOT4MUZDmt2Ry6YZw6iTaQJ/3hkeYkVxaxtb+e7t3EIE+vMXrq4MrUUw6qjE9s/oe5NpRWg2hN1I0Yn/K3a1iMXttSzUSro5Fn3T0ugANb1uUyyqTQF7dcSm65HWf2axnmMIaqXbewtJCvYmlVAH1aQWM/t1uwGx7L4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FElNFS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FElNFS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630A7C4CEE7;
	Mon, 12 May 2025 17:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072770;
	bh=pO90g+a8K6EaTZbyZs7uK8qPU60qemNQaKJD3rghM6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0FElNFS95ScoS4/oiDE5eRuU/ey8j+Kng/BF8DxeHJXdKElDB6wbv0yMNrpezyRRI
	 cL0RCaKdgVvYgwvDFaG3DZIHcINSniY/4bBwzAx5DRH0xSHeCU8f4z3r0SZL1NjM+l
	 8tjmYbRp/VwYvdOS5w3HxQlV0TyNzGTZZT8ihes4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/184] fbnic: Do not allow mailbox to toggle to ready outside fbnic_mbx_poll_tx_ready
Date: Mon, 12 May 2025 19:44:12 +0200
Message-ID: <20250512172043.815292771@linuxfoundation.org>
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

[ Upstream commit ce2fa1dba204c761582674cf2eb9cbe0b949b5c7 ]

We had originally thought to have the mailbox go to ready in the background
while we were doing other things. One issue with this though is that we
can't disable it by clearing the ready state without also blocking
interrupts or calls to mbx_poll as it will just pop back to life during an
interrupt.

In order to prevent that from happening we can pull the code for toggling
to ready out of the interrupt path and instead place it in the
fbnic_mbx_poll_tx_ready path so that it becomes the only spot where the
Rx/Tx can toggle to the ready state. By doing this we can prevent races
where we disable the DMA and/or free buffers only to have an interrupt fire
and undo what we have done.

Fixes: da3cde08209e ("eth: fbnic: Add FW communication mechanism")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/174654722518.499179.11612865740376848478.stgit@ahduyck-xeon-server.home.arpa
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c | 27 ++++++++--------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index 50d896dcbb04c..7775418316df5 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -299,10 +299,6 @@ static void fbnic_mbx_init_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
 {
 	struct fbnic_fw_mbx *mbx = &fbd->mbx[mbx_idx];
 
-	/* This is a one time init, so just exit if it is completed */
-	if (mbx->ready)
-		return;
-
 	mbx->ready = true;
 
 	switch (mbx_idx) {
@@ -322,21 +318,18 @@ static void fbnic_mbx_init_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
 	}
 }
 
-static void fbnic_mbx_postinit(struct fbnic_dev *fbd)
+static bool fbnic_mbx_event(struct fbnic_dev *fbd)
 {
-	int i;
-
 	/* We only need to do this on the first interrupt following reset.
 	 * this primes the mailbox so that we will have cleared all the
 	 * skip descriptors.
 	 */
 	if (!(rd32(fbd, FBNIC_INTR_STATUS(0)) & (1u << FBNIC_FW_MSIX_ENTRY)))
-		return;
+		return false;
 
 	wr32(fbd, FBNIC_INTR_CLEAR(0), 1u << FBNIC_FW_MSIX_ENTRY);
 
-	for (i = 0; i < FBNIC_IPC_MBX_INDICES; i++)
-		fbnic_mbx_init_desc_ring(fbd, i);
+	return true;
 }
 
 /**
@@ -737,7 +730,7 @@ static void fbnic_mbx_process_rx_msgs(struct fbnic_dev *fbd)
 
 void fbnic_mbx_poll(struct fbnic_dev *fbd)
 {
-	fbnic_mbx_postinit(fbd);
+	fbnic_mbx_event(fbd);
 
 	fbnic_mbx_process_tx_msgs(fbd);
 	fbnic_mbx_process_rx_msgs(fbd);
@@ -746,11 +739,9 @@ void fbnic_mbx_poll(struct fbnic_dev *fbd)
 int fbnic_mbx_poll_tx_ready(struct fbnic_dev *fbd)
 {
 	unsigned long timeout = jiffies + 10 * HZ + 1;
-	struct fbnic_fw_mbx *tx_mbx;
-	int err;
+	int err, i;
 
-	tx_mbx = &fbd->mbx[FBNIC_IPC_MBX_TX_IDX];
-	while (!tx_mbx->ready) {
+	do {
 		if (!time_is_after_jiffies(timeout))
 			return -ETIMEDOUT;
 
@@ -765,9 +756,11 @@ int fbnic_mbx_poll_tx_ready(struct fbnic_dev *fbd)
 			return -ENODEV;
 
 		msleep(20);
+	} while (!fbnic_mbx_event(fbd));
 
-		fbnic_mbx_poll(fbd);
-	}
+	/* FW has shown signs of life. Enable DMA and start Tx/Rx */
+	for (i = 0; i < FBNIC_IPC_MBX_INDICES; i++)
+		fbnic_mbx_init_desc_ring(fbd, i);
 
 	/* Request an update from the firmware. This should overwrite
 	 * mgmt.version once we get the actual version from the firmware
-- 
2.39.5



