Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA7F55896;
	Mon, 14 Oct 2024 15:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918374; cv=none; b=pj+ikC3dJm7y14ejnrOiefePPqN/BoBtx1my/y5VgwMIYVgo+SAYYoC6QMxh8sIC1qaGB7N0dQHWI5+3zZeZCZpQfYXUCLTs0ptp3L/ZprvOnojY/kBPXYqgK6c5q5wb842lyaVMYdSuTGuLs19n0bBHH5QAq6es9RAqdAdcocc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918374; c=relaxed/simple;
	bh=byO8z8GDCwMyuoQiWh2les/Ym3IZk0QBfKVXaMmYn8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2wzPjFUmukV7S9hUkhm1Nt2+ccjWAvcY6yEJgFqiR81eLcQCuVyLevr5wBg6tvZmTss+pDiFLOWBo3CkqFvBdH9oCeCEZ+yOWodlWQVpV7RNhHhgE/3dg/OYzsnRu9dX1vrDEvugu1Zbsn0Bqt0w2PoSAqJ7+bGdQnzs9KQ+jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hoEsxKZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hoEsxKZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BEBC4CEC3;
	Mon, 14 Oct 2024 15:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918373;
	bh=byO8z8GDCwMyuoQiWh2les/Ym3IZk0QBfKVXaMmYn8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hoEsxKZ0y6vUGIc17rRZajdx2rLG03JgUm6uCOcScb1P3+sp/BukaK9/vIVcjH4hN
	 mI1TF/eyYvrVDSsWDlp+iYKcTynY9zbDG1/p0LV5wHFX4R5eelMMBXuieZQkzEAdGd
	 /q2Ob20lRc1b1I+r3WAknuB13AlZXHo+W9Kq92nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Stan Johnson <userm57@yahoo.com>
Subject: [PATCH 6.1 304/798] scsi: mac_scsi: Disallow bus errors during PDMA send
Date: Mon, 14 Oct 2024 16:14:18 +0200
Message-ID: <20241014141229.887499620@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Finn Thain <fthain@linux-m68k.org>

commit 5551bc30e4a69ad86d0d008e2f56cd59b6583476 upstream.

SD cards can produce write latency spikes on the order of a hundred
milliseconds. If the target firmware does not hide that latency during DATA
IN and OUT phases it can cause the PDMA circuitry to raise a processor bus
fault which in turn leads to an unreliable byte count and a DMA overrun.

The Last Byte Sent flag is used to detect the overrun but this mechanism is
unreliable on some systems. Instead, set a DID_ERROR result whenever there
is a bus fault during a PDMA send, unless the cause was a phase mismatch.

Cc: stable@vger.kernel.org # 5.15+
Reported-and-tested-by: Stan Johnson <userm57@yahoo.com>
Fixes: 7c1f3e3447a1 ("scsi: mac_scsi: Treat Last Byte Sent time-out as failure")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://lore.kernel.org/r/cc38df687ace2c4ffc375a683b2502fc476b600d.1723001788.git.fthain@linux-m68k.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mac_scsi.c |   44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -102,11 +102,15 @@ __setup("mac5380=", mac_scsi_setup);
  * Linux SCSI drivers lack knowledge of the timing behaviour of SCSI targets
  * so bus errors are unavoidable.
  *
- * If a MOVE.B instruction faults, we assume that zero bytes were transferred
- * and simply retry. That assumption probably depends on target behaviour but
- * seems to hold up okay. The NOP provides synchronization: without it the
- * fault can sometimes occur after the program counter has moved past the
- * offending instruction. Post-increment addressing can't be used.
+ * If a MOVE.B instruction faults during a receive operation, we assume the
+ * target sent nothing and try again. That assumption probably depends on
+ * target firmware but it seems to hold up okay. If a fault happens during a
+ * send operation, the target may or may not have seen /ACK and got the byte.
+ * It's uncertain so the whole SCSI command gets retried.
+ *
+ * The NOP is needed for synchronization because the fault address in the
+ * exception stack frame may or may not be the instruction that actually
+ * caused the bus error. Post-increment addressing can't be used.
  */
 
 #define MOVE_BYTE(operands) \
@@ -243,22 +247,21 @@ static inline int mac_pdma_send(unsigned
 	if (n >= 1) {
 		MOVE_BYTE("%0@,%3@");
 		if (result)
-			goto out;
+			return -1;
 	}
 	if (n >= 1 && ((unsigned long)addr & 1)) {
 		MOVE_BYTE("%0@,%3@");
 		if (result)
-			goto out;
+			return -2;
 	}
 	while (n >= 32)
 		MOVE_16_WORDS("%0@+,%3@");
 	while (n >= 2)
 		MOVE_WORD("%0@+,%3@");
 	if (result)
-		return start - addr; /* Negated to indicate uncertain length */
+		return start - addr - 1; /* Negated to indicate uncertain length */
 	if (n == 1)
 		MOVE_BYTE("%0@,%3@");
-out:
 	return addr - start;
 }
 
@@ -307,7 +310,6 @@ static inline int macscsi_pread(struct N
 {
 	u8 __iomem *s = hostdata->pdma_io + (INPUT_DATA_REG << 4);
 	unsigned char *d = dst;
-	int result = 0;
 
 	hostdata->pdma_residual = len;
 
@@ -343,11 +345,12 @@ static inline int macscsi_pread(struct N
 		if (bytes == 0)
 			continue;
 
-		result = -1;
+		if (macscsi_wait_for_drq(hostdata) <= 0)
+			set_host_byte(hostdata->connected, DID_ERROR);
 		break;
 	}
 
-	return result;
+	return 0;
 }
 
 static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
@@ -355,7 +358,6 @@ static inline int macscsi_pwrite(struct
 {
 	unsigned char *s = src;
 	u8 __iomem *d = hostdata->pdma_io + (OUTPUT_DATA_REG << 4);
-	int result = 0;
 
 	hostdata->pdma_residual = len;
 
@@ -377,17 +379,8 @@ static inline int macscsi_pwrite(struct
 			hostdata->pdma_residual -= bytes;
 		}
 
-		if (hostdata->pdma_residual == 0) {
-			if (NCR5380_poll_politely(hostdata, TARGET_COMMAND_REG,
-			                          TCR_LAST_BYTE_SENT,
-			                          TCR_LAST_BYTE_SENT,
-			                          0) < 0) {
-				scmd_printk(KERN_ERR, hostdata->connected,
-				            "%s: Last Byte Sent timeout\n", __func__);
-				result = -1;
-			}
+		if (hostdata->pdma_residual == 0)
 			break;
-		}
 
 		if (bytes > 0)
 			continue;
@@ -400,11 +393,12 @@ static inline int macscsi_pwrite(struct
 		if (bytes == 0)
 			continue;
 
-		result = -1;
+		if (macscsi_wait_for_drq(hostdata) <= 0)
+			set_host_byte(hostdata->connected, DID_ERROR);
 		break;
 	}
 
-	return result;
+	return 0;
 }
 
 static int macscsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,


