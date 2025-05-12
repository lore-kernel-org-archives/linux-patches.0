Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6FD263F30;
	Mon, 12 May 2025 17:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071849; cv=none; b=HL0sIZiKp2vJMhB97mhw4lkGUgr+dPiIc/k2Ohm5sV4Q3X9RRTj+X2DK4uh7rpd4fUmNSXyJVAtdO74hp0mFIXSwF1ZuZr732s4DikjBH6QFIMJfExfkYl8fi6MRQ0t2k5gkdcILq8R9ykC6736CNZ/VM6JsC0gwn3SAtTKjKuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071849; c=relaxed/simple;
	bh=cyMCrhns4sH4XLVHBmJYl7DtmW7wJyTh9isUI8F1ArM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8qoD+x1j0xyZBerzItYywIjFqenZ2+MrG0wW02LkO97gtK2l18PTCCFYk6lBYJElK/9JiNaMxt+luy6vAvODii58Xr3d2oiWT49N806mtWQgOXLrIvCTjNtKpTknY5FpluMcVm59XbWNAVvrzWzghppEz+MWM+ktaQLUoVVCgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWzkbYB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWzkbYB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32F7C4CEE9;
	Mon, 12 May 2025 17:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071849;
	bh=cyMCrhns4sH4XLVHBmJYl7DtmW7wJyTh9isUI8F1ArM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWzkbYB7bgPJOY6j3kMFb14gibsToYbRnl6saoGdOPX928UqyNJ8/tsbsaH3YdcTC
	 /LfEpnczMgtTdUaj3WsYH/2XAokVcwxWAg3SQl2jKfJoDrazpIKvvT8iAvZP/NMmsx
	 pEZQGepAu30SAlsw1mLV7KRsNrx9z5pACWWyzeBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 050/197] fbnic: Pull fbnic_fw_xmit_cap_msg use out of interrupt context
Date: Mon, 12 May 2025 19:38:20 +0200
Message-ID: <20250512172046.428018166@linuxfoundation.org>
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

[ Upstream commit 1b34d1c1dc8384884febd83140c9afbc7c4b9eb8 ]

This change pulls the call to fbnic_fw_xmit_cap_msg out of
fbnic_mbx_init_desc_ring and instead places it in the polling function for
getting the Tx ready. Doing that we can avoid the potential issue with an
interrupt coming in later from the firmware that causes it to get fired in
interrupt context.

Fixes: 20d2e88cc746 ("eth: fbnic: Add initial messaging to notify FW of our presence")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/174654721876.499179.9839651602256668493.stgit@ahduyck-xeon-server.home.arpa
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_fw.c | 43 ++++++++--------------
 1 file changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
index da6e5ba5acaee..b804b5480db97 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -352,24 +352,6 @@ static int fbnic_fw_xmit_simple_msg(struct fbnic_dev *fbd, u32 msg_type)
 	return err;
 }
 
-/**
- * fbnic_fw_xmit_cap_msg - Allocate and populate a FW capabilities message
- * @fbd: FBNIC device structure
- *
- * Return: NULL on failure to allocate, error pointer on error, or pointer
- * to new TLV test message.
- *
- * Sends a single TLV header indicating the host wants the firmware to
- * confirm the capabilities and version.
- **/
-static int fbnic_fw_xmit_cap_msg(struct fbnic_dev *fbd)
-{
-	int err = fbnic_fw_xmit_simple_msg(fbd, FBNIC_TLV_MSG_ID_HOST_CAP_REQ);
-
-	/* Return 0 if we are not calling this on ASIC */
-	return (err == -EOPNOTSUPP) ? 0 : err;
-}
-
 static void fbnic_mbx_init_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
 {
 	struct fbnic_fw_mbx *mbx = &fbd->mbx[mbx_idx];
@@ -393,15 +375,6 @@ static void fbnic_mbx_init_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
 		/* Enable DMA reads from the device */
 		wr32(fbd, FBNIC_PUL_OB_TLP_HDR_AR_CFG,
 		     FBNIC_PUL_OB_TLP_HDR_AR_CFG_BME);
-
-		/* Force version to 1 if we successfully requested an update
-		 * from the firmware. This should be overwritten once we get
-		 * the actual version from the firmware in the capabilities
-		 * request message.
-		 */
-		if (!fbnic_fw_xmit_cap_msg(fbd) &&
-		    !fbd->fw_cap.running.mgmt.version)
-			fbd->fw_cap.running.mgmt.version = 1;
 		break;
 	}
 }
@@ -912,6 +885,7 @@ int fbnic_mbx_poll_tx_ready(struct fbnic_dev *fbd)
 {
 	unsigned long timeout = jiffies + 10 * HZ + 1;
 	struct fbnic_fw_mbx *tx_mbx;
+	int err;
 
 	tx_mbx = &fbd->mbx[FBNIC_IPC_MBX_TX_IDX];
 	while (!tx_mbx->ready) {
@@ -933,7 +907,22 @@ int fbnic_mbx_poll_tx_ready(struct fbnic_dev *fbd)
 		fbnic_mbx_poll(fbd);
 	}
 
+	/* Request an update from the firmware. This should overwrite
+	 * mgmt.version once we get the actual version from the firmware
+	 * in the capabilities request message.
+	 */
+	err = fbnic_fw_xmit_simple_msg(fbd, FBNIC_TLV_MSG_ID_HOST_CAP_REQ);
+	if (err)
+		goto clean_mbx;
+
+	/* Use "1" to indicate we entered the state waiting for a response */
+	fbd->fw_cap.running.mgmt.version = 1;
+
 	return 0;
+clean_mbx:
+	/* Cleanup Rx buffers and disable mailbox */
+	fbnic_mbx_clean(fbd);
+	return err;
 }
 
 static void __fbnic_fw_evict_cmpl(struct fbnic_fw_completion *cmpl_data)
-- 
2.39.5



