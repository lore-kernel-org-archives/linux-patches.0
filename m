Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369A929DB64;
	Sat, 12 Sep 2026 15:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228557; cv=none; b=UDywsk1Jflz+jIIAoqlZnmJt5yKT/z7y3unZ/Gol2Xi0KOfsCZZOW/nwZioDzBzkhvroaKWPF29ninI2uk9c1y1P/oGWa5lzJpXh4Jh4vz3dmHZFqlI5rkRlKeWs8UUyZM/pyW+7iKtsOhbBHYuUz0Pvcn87yTOm40FqbxrMNh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228557; c=relaxed/simple;
	bh=TuG7/Z1/r6qwLUJjNVNMg3NHlBE/GtW1k0GpDLq1sBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOGnPUWUqEvJqOH1xBdZYAefw9uii6YES2qMeL87GBzyzQABvTr0xDWnlzXBzMlgswIEvml8aHWjpQsWm8RRGZGqRlZK2S+1v52eZwh8N66RsSyQ3tQoh26VN5SZEIEFCkRLzH4xM0nrRdeMj4AAHBi66UnOBRrUPYuOA86o/CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ACsEaoEQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ACsEaoEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328111F00893;
	Sat, 12 Sep 2026 15:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228556;
	bh=XhnExHc+wFs5g3beus+j+Z1wOaiJgl0gfH1Qf/YrPqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ACsEaoEQ2V7fR8Hec4LIyzPqKtlbYKYCl7rRvleuS6FRtFNll9uEOYrFek8UiHMwc
	 urt+N0CwTufDPsvQ8azXtpKTTQoDg86s5bFcqZy3XexKcSVSwAyd2bSIrvZiZXhA/b
	 Ei7AfBaA/z79K/lrIzocjTZu5dhC22KchNEimcug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 0408/1191] scsi: qla2xxx: Use coherent DMA buffer for D_Port diagnostics
Date: Sat, 12 Sep 2026 08:52:16 +0200
Message-ID: <20260912065557.404119142@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6440,6 +6440,7 @@ qla26xx_dport_diagnostics(scsi_qla_host_
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 	dma_addr_t dd_dma;
+	void *dd;
 
 	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
 	    !IS_QLA28XX(vha->hw))
@@ -6448,15 +6449,12 @@ qla26xx_dport_diagnostics(scsi_qla_host_
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
@@ -6478,8 +6476,9 @@ qla26xx_dport_diagnostics(scsi_qla_host_
 		    "Done %s.\n", __func__);
 	}
 
-	dma_unmap_single(&vha->hw->pdev->dev, dd_dma,
-	    size, DMA_FROM_DEVICE);
+	memcpy(dd_buf, dd, size);
+
+	dma_free_coherent(&vha->hw->pdev->dev, size, dd, dd_dma);
 
 	return rval;
 }


