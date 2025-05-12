Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFBF1E2602;
	Mon, 12 May 2025 17:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071852; cv=none; b=FEjzM6WkeSO5MH7RCxMBToxXwkWgHrZYig96VmjPou3n7KplnuPutIY7o83LZZn4zS0e/iAMQ6vD/lIl5HSiNM0qOVrKlKtjGSveY9+ENZqmQFeABYDSaSpMHPlxlIKO+6+WFvfBvSjG0fXcLLzliM9OMS9KvuDc3kFy75jv9c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071852; c=relaxed/simple;
	bh=wGDobx84rl1u4w2CUqvA69c5Jyt+BP+ACatoKjd27nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYa+25nrpvchlGeXkh8bthRuyzENlPWb1zMvnWvnrL2w0fXJQJWwGCU/FV24uq6SxCijThPw5uh8dz8sTr5a+tVMe3nWBLEbpGLZdd+0Eb8p8RfvgxfI7CC6gLWA3n+j93u5B1YxTFLli8FP/bm1lQKGkAMXKn6XSHBE3QbStJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJ+YEwXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJ+YEwXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81453C4CEE7;
	Mon, 12 May 2025 17:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071851;
	bh=wGDobx84rl1u4w2CUqvA69c5Jyt+BP+ACatoKjd27nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJ+YEwXv9qlDu1AfX/OCPn+oWQ6nQA4xO4oCzkBeFiCHLnrT1UySEWKcWbcKi1YHG
	 EYCcp8/HCznX/6Z81UFIU0XcEu06iKLQ26tNc7CTZFKANxBE14d9pykjv97RgAfQWi
	 +h515WxaPAwBtvi6cwhh5VxzEQ5siRqOuRri5T+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 051/197] fbnic: Do not allow mailbox to toggle to ready outside fbnic_mbx_poll_tx_ready
Date: Mon, 12 May 2025 19:38:21 +0200
Message-ID: <20250512172046.469832454@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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
index b804b5480db97..9351a874689f8 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -356,10 +356,6 @@ static void fbnic_mbx_init_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
 {
 	struct fbnic_fw_mbx *mbx = &fbd->mbx[mbx_idx];
 
-	/* This is a one time init, so just exit if it is completed */
-	if (mbx->ready)
-		return;
-
 	mbx->ready = true;
 
 	switch (mbx_idx) {
@@ -379,21 +375,18 @@ static void fbnic_mbx_init_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
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
@@ -875,7 +868,7 @@ static void fbnic_mbx_process_rx_msgs(struct fbnic_dev *fbd)
 
 void fbnic_mbx_poll(struct fbnic_dev *fbd)
 {
-	fbnic_mbx_postinit(fbd);
+	fbnic_mbx_event(fbd);
 
 	fbnic_mbx_process_tx_msgs(fbd);
 	fbnic_mbx_process_rx_msgs(fbd);
@@ -884,11 +877,9 @@ void fbnic_mbx_poll(struct fbnic_dev *fbd)
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
 
@@ -903,9 +894,11 @@ int fbnic_mbx_poll_tx_ready(struct fbnic_dev *fbd)
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



