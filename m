Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFA8248F49;
	Mon, 12 May 2025 17:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072768; cv=none; b=Iccj/DJWlddP9XHbCsEDzZLx2i//sazaG99LMe9ulLNpcRKIy9CTlz7NLpP6fGotAbM53a5TyMcKv1Nn4HJLCc49ZR44fgAtR3+IsU2QPqkuw7O6c01yCC6uLwQ3D7JIRbDiIXVeZkusWKJkXcd4oEA9eGvyYyukR43EYDztisY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072768; c=relaxed/simple;
	bh=M8AAhR1BpBbnIIqXN/0LSuRihcKksCWZeMP328MVR5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlN6DhEaotWVB31fBkPzJizG7iv+zFh7vJSA9AP0lilwKvlebAbW0AEoWGCHhwXjh6jkcD+yEQDG9PsiM8bVa81uIAn/VsEe/P8OixqTJOyK/yDn32QN3D/FJuZ7srBab4gU9HtqyVxScDFLoWt6+Vum7O01eVOmkx5AOQfH5CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Zc8Jcq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Zc8Jcq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B0DC4CEE7;
	Mon, 12 May 2025 17:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072767;
	bh=M8AAhR1BpBbnIIqXN/0LSuRihcKksCWZeMP328MVR5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Zc8Jcq/9V/xtE383RMv8LqlU4d0i5ABwE/Dh17eA3urZU2dd15mnGIL+X57c/Y0H
	 7BdJCE6uefYcgf8DBEymja5kWKOu2LIkEnhaBVqgXA+Sauhg8WHiEt/CAraC121TEh
	 gJWEK3vdJTCGD4I1KDndlNkBheOozkN4W9ccDrxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/184] fbnic: Pull fbnic_fw_xmit_cap_msg use out of interrupt context
Date: Mon, 12 May 2025 19:44:11 +0200
Message-ID: <20250512172043.776137806@linuxfoundation.org>
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
index 8d6af5c3a49c0..50d896dcbb04c 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_fw.c
@@ -295,24 +295,6 @@ static int fbnic_fw_xmit_simple_msg(struct fbnic_dev *fbd, u32 msg_type)
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
@@ -336,15 +318,6 @@ static void fbnic_mbx_init_desc_ring(struct fbnic_dev *fbd, int mbx_idx)
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
@@ -774,6 +747,7 @@ int fbnic_mbx_poll_tx_ready(struct fbnic_dev *fbd)
 {
 	unsigned long timeout = jiffies + 10 * HZ + 1;
 	struct fbnic_fw_mbx *tx_mbx;
+	int err;
 
 	tx_mbx = &fbd->mbx[FBNIC_IPC_MBX_TX_IDX];
 	while (!tx_mbx->ready) {
@@ -795,7 +769,22 @@ int fbnic_mbx_poll_tx_ready(struct fbnic_dev *fbd)
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
 
 void fbnic_mbx_flush_tx(struct fbnic_dev *fbd)
-- 
2.39.5



