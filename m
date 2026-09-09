Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CB8568FB6;
	Wed,  9 Sep 2026 14:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962878; cv=none; b=s1qKXoet6BKVKjCUmkHFt7t0uYH+BszbIrcNCwSHErmGen9ItGyCs8ofFg1ChBk74iRe6SOGDA5Ucdu5sdPyjIMgwJgeK3FNfcJyJWYEzDrC8RHnPMM4zcJXsvxXvEFkD0/eIDazMIN6/ltl0OCo2eQ8KEtcugoWfyOfi/FTQm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962878; c=relaxed/simple;
	bh=IlrueyZGZdHDvDt9wWDLleTi9W8fRTnFX8zHcPOT/0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWnu9ZQFD/WqRR3QD6xEJxSZyqhYT0xlRYDA/pgsY25juzX8D2gfAkTB+VnbqAMPtZcEU9RfU3sgF/td9c2KYHbcDp5rX50hR+WlMHv5XgDKB9xpeb/89ca1B/4HeUXD2StU+GitLkgbbJtm5JX5hlGJOxnzhdkH9iPzppz+4tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLHz3tBU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLHz3tBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339C11F00A3E;
	Wed,  9 Sep 2026 14:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962876;
	bh=+aTIdyUJs8OqGt5XYGUHeGzGrncT3A7utA6dTBOAms0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GLHz3tBUP258TM02Q5I1LM34VhVyGuN1B7yxNy/sR8d5B4b0yQ0dend7CZ+SlFuWa
	 YiizczljZlMn09wsYLRSq6lBsHGX7saiHmR4hv9rEUHoGKfTso7MdopMpRffUW1KqQ
	 03t9Juf/9FBKRrl1IWiXX9nBn/3ABkzxyeR21Qlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 443/556] scsi: qla2xxx: Use coherent DMA buffer for D_Port diagnostics
Date: Wed,  9 Sep 2026 15:42:03 +0200
Message-ID: <20260909134246.186776540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

commit 7c4f3f50d83af4545efaa99b3d0d46fb8d52031e upstream.

qla26xx_dport_diagnostics() streaming-maps the caller's result buffer with
dma_map_single(). The bsg path passes &dd->buf from the __packed struct
qla_dport_diag, where buf lands at a 2-byte offset and shares cachelines
with the surrounding options/unused fields. Mapping such a misaligned
sub-buffer violates the DMA API requirement that streaming buffers be
cacheline aligned and not share a cacheline with other data, and can
corrupt data on non-DMA-coherent architectures.

Allocate a dedicated DMA-coherent buffer inside qla26xx_dport_diagnostics()
for the mailbox command and copy the result back into the caller's buffer.
This removes the streaming map of the misaligned sub-buffer entirely; the
caller's buffer is now only a plain CPU buffer, so its packing no longer
matters.

Fixes: ec89146215d1 ("qla2xxx: Add bsg interface to support D_Port Diagnostics.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-29-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6499,6 +6499,7 @@ qla26xx_dport_diagnostics(scsi_qla_host_
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 	dma_addr_t dd_dma;
+	void *dd;
 
 	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
 	    !IS_QLA28XX(vha->hw))
@@ -6507,15 +6508,12 @@ qla26xx_dport_diagnostics(scsi_qla_host_
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x119f,
 	    "Entered %s.\n", __func__);
 
-	dd_dma = dma_map_single(&vha->hw->pdev->dev,
-	    dd_buf, size, DMA_FROM_DEVICE);
-	if (dma_mapping_error(&vha->hw->pdev->dev, dd_dma)) {
-		ql_log(ql_log_warn, vha, 0x1194, "Failed to map dma buffer.\n");
+	dd = dma_alloc_coherent(&vha->hw->pdev->dev, size, &dd_dma, GFP_KERNEL);
+	if (!dd) {
+		ql_log(ql_log_warn, vha, 0x1194, "Failed to allocate dma buffer.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
-	memset(dd_buf, 0, size);
-
 	mcp->mb[0] = MBC_DPORT_DIAGNOSTICS;
 	mcp->mb[1] = options;
 	mcp->mb[2] = MSW(LSD(dd_dma));
@@ -6537,8 +6535,9 @@ qla26xx_dport_diagnostics(scsi_qla_host_
 		    "Done %s.\n", __func__);
 	}
 
-	dma_unmap_single(&vha->hw->pdev->dev, dd_dma,
-	    size, DMA_FROM_DEVICE);
+	memcpy(dd_buf, dd, size);
+
+	dma_free_coherent(&vha->hw->pdev->dev, size, dd, dd_dma);
 
 	return rval;
 }


