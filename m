Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FC61D0490;
	Wed,  2 Oct 2024 13:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875754; cv=none; b=rgAMLpKkgccrM8lz7MksDvlKEn+3it1tRmo1HDudnf7L3NL3cf0fI0oheDIjN5jUOOlYq2OicV96NKbw97m/PTJzCaGt0juby6r0GFjO9Em3oNNgjEj5VIXYOZDnEAEz91unK3pE6UR/LoGafiRa+pddSr2Yf3IHz4ghUdZdfg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875754; c=relaxed/simple;
	bh=8L1PtO5COAA8tXThKGqAQ0IYKatBtYHSEKqV/wM507s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PE/rNb0z5+aSEt22n+W2eJzmVjOouwUDv7gzDMG3iqF6/K1cqn/85Ct0oxkoMOgGMmuKtK8eiqTci9xbK2+E50hnWmeHKfKUGa0VjYuRMNMFKXytN/MPymJcZ1SYBu9VQ3BOUI4x0XxQXr3tvKiWUv3/t0/IhJWw9fgDi29dfGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qi1oMG6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qi1oMG6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D142C4CEC5;
	Wed,  2 Oct 2024 13:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875754;
	bh=8L1PtO5COAA8tXThKGqAQ0IYKatBtYHSEKqV/wM507s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qi1oMG6W2Q1f3/8X11a7+nFS0m4dRPWT2nB9+W35oNY7Pd5j/WXtlSWj5Aw/9Usgg
	 qDPYE4Yprz6D1IEcCLfBzKswO6Q358trX8ztpzLHZfRT+xa57uhnMAkfecxx2ufa06
	 g+6SP9EjYME52fKP/f8R2vTtOjONIetAimZbfefs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 209/695] scsi: NCR5380: Check for phase match during PDMA fixup
Date: Wed,  2 Oct 2024 14:53:27 +0200
Message-ID: <20241002125830.803263842@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



