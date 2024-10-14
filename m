Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5021ABEC1;
	Mon, 14 Oct 2024 15:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918367; cv=none; b=CY/5wWTnKxpp9RLva0U15DijlZXAVywGcecxNgjBTbk+idD6UPYCR+wsqrOdEpwcVJEPzc88C3dVdVU4kFWIZ8ssxXcisnRgqBP/GvBLKf3Jrx2fQafmqTp8fSuUEqJ5RXu8C4QQ+J/MUBz/FbXsjmtIwHauZLNWyel/6FFmUvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918367; c=relaxed/simple;
	bh=oLZapMAkIFcv0v1xl0E8Af4aMB1QxE1Xzvg6QgBrvhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFMLjJ7BqkSNeMf6fCGZ5qfvW93Ks536ddSTTT+XpStrDaM6Vx29PKUgdVKJmWtabcTwyEtM4uiF1KKgeQYF3xav0xPHrgMjOy4Dla6UXSTWsVvV9ys8DWI5ZLts7z6hQE+UIKuMn9XmWL9FKK9YFQoZF6Sdjxd/7GsDgH9OTrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKIFUkKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKIFUkKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD7CC4CECF;
	Mon, 14 Oct 2024 15:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918366;
	bh=oLZapMAkIFcv0v1xl0E8Af4aMB1QxE1Xzvg6QgBrvhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jKIFUkKdesKPFk+FvVhe6IjakcnRq5bVCh0lpmUd59zay+0ntl7gOCUZPQadeG4Qu
	 UXXadCbOkPNJB84Oum92MN22JDRyJeNgacb9krK+VL3kDaygh3jwUIkNk9AYWFyM2T
	 pE/goJfh69yAaI2bmWHeSq4YKEXKvUslN/v6nk4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 302/798] scsi: mac_scsi: Revise printk(KERN_DEBUG ...) messages
Date: Mon, 14 Oct 2024 16:14:16 +0200
Message-ID: <20241014141229.808541150@linuxfoundation.org>
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

commit 5ec4f820cb9766e4583df947150a6febce8da794 upstream.

After a bus fault, capture and log the chip registers immediately, if the
NDEBUG_PSEUDO_DMA macro is defined. Remove some printk(KERN_DEBUG ...)
messages that aren't needed any more.  Don't skip the debug message when
bytes == 0. Show all of the byte counters in the debug messages.

Cc: stable@vger.kernel.org # 5.15+
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://lore.kernel.org/r/7573c79f4e488fc00af2b8a191e257ca945e0409.1723001788.git.fthain@linux-m68k.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mac_scsi.c |   42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -286,13 +286,14 @@ static inline int macscsi_pread(struct N
 	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 	                              BASR_DRQ | BASR_PHASE_MATCH,
 	                              BASR_DRQ | BASR_PHASE_MATCH, 0)) {
-		int bytes;
+		int bytes, chunk_bytes;
 
 		if (macintosh_config->ident == MAC_MODEL_IIFX)
 			write_ctrl_reg(hostdata, CTRL_HANDSHAKE_MODE |
 			                         CTRL_INTERRUPTS_ENABLE);
 
-		bytes = mac_pdma_recv(s, d, min(hostdata->pdma_residual, 512));
+		chunk_bytes = min(hostdata->pdma_residual, 512);
+		bytes = mac_pdma_recv(s, d, chunk_bytes);
 
 		if (bytes > 0) {
 			d += bytes;
@@ -302,23 +303,23 @@ static inline int macscsi_pread(struct N
 		if (hostdata->pdma_residual == 0)
 			goto out;
 
-		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
-		                           BUS_AND_STATUS_REG, BASR_ACK,
-		                           BASR_ACK, 0) < 0)
-			scmd_printk(KERN_DEBUG, hostdata->connected,
-			            "%s: !REQ and !ACK\n", __func__);
 		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
 			goto out;
 
 		if (bytes == 0)
 			udelay(MAC_PDMA_DELAY);
 
-		if (bytes >= 0)
+		if (bytes > 0)
 			continue;
 
-		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
-		         "%s: bus error (%d/%d)\n", __func__, d - dst, len);
 		NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
+		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
+			 "%s: bus error [%d/%d] (%d/%d)\n",
+			 __func__, d - dst, len, bytes, chunk_bytes);
+
+		if (bytes == 0)
+			continue;
+
 		result = -1;
 		goto out;
 	}
@@ -345,13 +346,14 @@ static inline int macscsi_pwrite(struct
 	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 	                              BASR_DRQ | BASR_PHASE_MATCH,
 	                              BASR_DRQ | BASR_PHASE_MATCH, 0)) {
-		int bytes;
+		int bytes, chunk_bytes;
 
 		if (macintosh_config->ident == MAC_MODEL_IIFX)
 			write_ctrl_reg(hostdata, CTRL_HANDSHAKE_MODE |
 			                         CTRL_INTERRUPTS_ENABLE);
 
-		bytes = mac_pdma_send(s, d, min(hostdata->pdma_residual, 512));
+		chunk_bytes = min(hostdata->pdma_residual, 512);
+		bytes = mac_pdma_send(s, d, chunk_bytes);
 
 		if (bytes > 0) {
 			s += bytes;
@@ -370,23 +372,23 @@ static inline int macscsi_pwrite(struct
 			goto out;
 		}
 
-		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
-		                           BUS_AND_STATUS_REG, BASR_ACK,
-		                           BASR_ACK, 0) < 0)
-			scmd_printk(KERN_DEBUG, hostdata->connected,
-			            "%s: !REQ and !ACK\n", __func__);
 		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
 			goto out;
 
 		if (bytes == 0)
 			udelay(MAC_PDMA_DELAY);
 
-		if (bytes >= 0)
+		if (bytes > 0)
 			continue;
 
-		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
-		         "%s: bus error (%d/%d)\n", __func__, s - src, len);
 		NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
+		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
+			 "%s: bus error [%d/%d] (%d/%d)\n",
+			 __func__, s - src, len, bytes, chunk_bytes);
+
+		if (bytes == 0)
+			continue;
+
 		result = -1;
 		goto out;
 	}


