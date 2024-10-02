Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3491D014A;
	Wed,  2 Oct 2024 14:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879509; cv=none; b=ZmgzC+Wzt6qrcVp5NnTN2k05Ss0VKKkyeDAjMJEgI+/oORTF9rRCOrhUEeeY2Gzl5YFlZD8/NdSAr4DRMxnmiJ2JKP+v0tbDQ9PN+rPWGEmW/f10L4z5A4uSGoIzl5K52XHCiPz7C7Wy7xYdbxhDcGPzR/pQEfwaA8pXtI1zjes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879509; c=relaxed/simple;
	bh=j22X/BU6FvLVVp7KmTNkK8tNeVaSA2iLHywXNzX62oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuRK6i3kjRNPoJ71ffnjLytVqvAyv1SJwxo44YOwe0RFl+45y3HK60ssaXPa4Rr+dC9Yqz+c+mpV9JKfjgyXPiDrG4qWqNKKk0qTDq7NqZNerQvzwd1hBQt14hTprsC374NQdhlIR1EIz646jTSd5c1egzkqfd8WwkQ0KhZruFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UjPLKM6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UjPLKM6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C9DC4CEC2;
	Wed,  2 Oct 2024 14:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879509;
	bh=j22X/BU6FvLVVp7KmTNkK8tNeVaSA2iLHywXNzX62oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjPLKM6RDejsdeY9zasegVuNT5/6AkDazIWykmF+FCYY+yzynr19v9X8u/gJzRhAS
	 eC7s/0QNHxHTfpflZw2wKnhlRwvQELEcH4htt7LRhlv69ypEHZOYgiQDO8VtNNE8wI
	 T6sVYPJVDrn3Kc4hyRDWB6C5LLGDSpa63dKPrO9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/538] scsi: NCR5380: Check for phase match during PDMA fixup
Date: Wed,  2 Oct 2024 14:56:23 +0200
Message-ID: <20241002125757.925112999@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 5768718da9417331803fc4bc090544c2a93b88dc ]

It's not an error for a target to change the bus phase during a transfer.
Unfortunately, the FLAG_DMA_FIXUP workaround does not allow for that -- a
phase change produces a DRQ timeout error and the device borken flag will
be set.

Check the phase match bit during FLAG_DMA_FIXUP processing. Don't forget to
decrement the command residual. While we are here, change shost_printk()
into scmd_printk() for better consistency with other DMA error messages.

Tested-by: Stan Johnson <userm57@yahoo.com>
Fixes: 55181be8ced1 ("ncr5380: Replace redundant flags with FLAG_NO_DMA_FIXUP")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://lore.kernel.org/r/99dc7d1f4c825621b5b120963a69f6cd3e9ca659.1723001788.git.fthain@linux-m68k.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 78 +++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index cea3a79d538e4..00e245173320c 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1485,6 +1485,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
 				unsigned char **data)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	struct NCR5380_cmd *ncmd = NCR5380_to_ncmd(hostdata->connected);
 	int c = *count;
 	unsigned char p = *phase;
 	unsigned char *d = *data;
@@ -1496,7 +1497,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
 		return -1;
 	}
 
-	NCR5380_to_ncmd(hostdata->connected)->phase = p;
+	ncmd->phase = p;
 
 	if (p & SR_IO) {
 		if (hostdata->read_overruns)
@@ -1608,45 +1609,44 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
  * request.
  */
 
-	if (hostdata->flags & FLAG_DMA_FIXUP) {
-		if (p & SR_IO) {
-			/*
-			 * The workaround was to transfer fewer bytes than we
-			 * intended to with the pseudo-DMA read function, wait for
-			 * the chip to latch the last byte, read it, and then disable
-			 * pseudo-DMA mode.
-			 *
-			 * After REQ is asserted, the NCR5380 asserts DRQ and ACK.
-			 * REQ is deasserted when ACK is asserted, and not reasserted
-			 * until ACK goes false.  Since the NCR5380 won't lower ACK
-			 * until DACK is asserted, which won't happen unless we twiddle
-			 * the DMA port or we take the NCR5380 out of DMA mode, we
-			 * can guarantee that we won't handshake another extra
-			 * byte.
-			 */
-
-			if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
-			                          BASR_DRQ, BASR_DRQ, 0) < 0) {
-				result = -1;
-				shost_printk(KERN_ERR, instance, "PDMA read: DRQ timeout\n");
-			}
-			if (NCR5380_poll_politely(hostdata, STATUS_REG,
-			                          SR_REQ, 0, 0) < 0) {
-				result = -1;
-				shost_printk(KERN_ERR, instance, "PDMA read: !REQ timeout\n");
-			}
-			d[*count - 1] = NCR5380_read(INPUT_DATA_REG);
-		} else {
-			/*
-			 * Wait for the last byte to be sent.  If REQ is being asserted for
-			 * the byte we're interested, we'll ACK it and it will go false.
-			 */
-			if (NCR5380_poll_politely2(hostdata,
-			     BUS_AND_STATUS_REG, BASR_DRQ, BASR_DRQ,
-			     BUS_AND_STATUS_REG, BASR_PHASE_MATCH, 0, 0) < 0) {
-				result = -1;
-				shost_printk(KERN_ERR, instance, "PDMA write: DRQ and phase timeout\n");
+	if ((hostdata->flags & FLAG_DMA_FIXUP) &&
+	    (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH)) {
+		/*
+		 * The workaround was to transfer fewer bytes than we
+		 * intended to with the pseudo-DMA receive function, wait for
+		 * the chip to latch the last byte, read it, and then disable
+		 * DMA mode.
+		 *
+		 * After REQ is asserted, the NCR5380 asserts DRQ and ACK.
+		 * REQ is deasserted when ACK is asserted, and not reasserted
+		 * until ACK goes false. Since the NCR5380 won't lower ACK
+		 * until DACK is asserted, which won't happen unless we twiddle
+		 * the DMA port or we take the NCR5380 out of DMA mode, we
+		 * can guarantee that we won't handshake another extra
+		 * byte.
+		 *
+		 * If sending, wait for the last byte to be sent. If REQ is
+		 * being asserted for the byte we're interested, we'll ACK it
+		 * and it will go false.
+		 */
+		if (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
+					   BASR_DRQ, BASR_DRQ, 0)) {
+			if ((p & SR_IO) &&
+			    (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH)) {
+				if (!NCR5380_poll_politely(hostdata, STATUS_REG,
+							   SR_REQ, 0, 0)) {
+					d[c] = NCR5380_read(INPUT_DATA_REG);
+					--ncmd->this_residual;
+				} else {
+					result = -1;
+					scmd_printk(KERN_ERR, hostdata->connected,
+						    "PDMA fixup: !REQ timeout\n");
+				}
 			}
+		} else if (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH) {
+			result = -1;
+			scmd_printk(KERN_ERR, hostdata->connected,
+				    "PDMA fixup: DRQ timeout\n");
 		}
 	}
 
-- 
2.43.0



