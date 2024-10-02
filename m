Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAC117B421;
	Wed,  2 Oct 2024 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876828; cv=none; b=fjT+wDsGDnS1q+Od4VsZFcV5MQKkKb8H2UUa+33ZvqhjAvtP5AcwP6mN8Efu0b8d8YEPaY1d25E60o10gsr2iw89yzrw0VVHw383safZmdf5QaIuXNBvVTEJ6a9fm66NDv4wbOfvqelj0/GC3Dm7ico9KY1dMpB5j+5HTDgQ75U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876828; c=relaxed/simple;
	bh=NrkBmT7sm8MDSDTLcHmHhN3L61o178FwzGQUNRbDz5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JULQL18Q4brqm8KuWqNr3Qxk2fCLdKfYVZFefZ1Sm8qh3No97QQ4zD9/e4VPVhc4+TdkSvcDtBEaSCXHXm/ZXPwy+Xr4O38ckYRtO7L5mt0QSuoC0i3EawEg3MAkkUKYV137KJrWq9hDgVBY58/JkuEkiHi50pYjH4AaPGB+5vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iu4U1uMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iu4U1uMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE951C4CEC2;
	Wed,  2 Oct 2024 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876828;
	bh=NrkBmT7sm8MDSDTLcHmHhN3L61o178FwzGQUNRbDz5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iu4U1uMwFBb9EpuehvyxGHhmWN+JQ7Y7xG0aItdkXnwFh/T/4rLPztWqPkReowM/6
	 eFD5ieTV+Fq57JxkcG29U7mxvQyAyjRRp13U3eLlo+agtFtwivl//ZpvZEPKIp5H9b
	 8dD8ps5Ql+VE4rS3M+RItfjGodsFoHm4OINppKFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stan Johnson <userm57@yahoo.com>,
	Finn Thain <fthain@linux-m68k.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.11 574/695] scsi: mac_scsi: Refactor polling loop
Date: Wed,  2 Oct 2024 14:59:32 +0200
Message-ID: <20241002125845.423512138@linuxfoundation.org>
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

commit 5545c3165cbc98615fe65a44f41167cbb557e410 upstream.

Before the error handling can be revised, some preparation is needed.
Refactor the polling loop with a new function, macscsi_wait_for_drq().
This function will gain more call sites in the next patch.

Cc: stable@vger.kernel.org # 5.15+
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Link: https://lore.kernel.org/r/6a5ffabb4290c0d138c6d285fda8fa3902e926f0.1723001788.git.fthain@linux-m68k.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mac_scsi.c |   80 +++++++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 38 deletions(-)

--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -208,8 +208,6 @@ __setup("mac5380=", mac_scsi_setup);
 		".previous                     \n" \
 		: "+a" (addr), "+r" (n), "+r" (result) : "a" (io))
 
-#define MAC_PDMA_DELAY		32
-
 static inline int mac_pdma_recv(void __iomem *io, unsigned char *start, int n)
 {
 	unsigned char *addr = start;
@@ -274,6 +272,36 @@ static inline void write_ctrl_reg(struct
 	out_be32(hostdata->io + (CTRL_REG << 4), value);
 }
 
+static inline int macscsi_wait_for_drq(struct NCR5380_hostdata *hostdata)
+{
+	unsigned int n = 1; /* effectively multiplies NCR5380_REG_POLL_TIME */
+	unsigned char basr;
+
+again:
+	basr = NCR5380_read(BUS_AND_STATUS_REG);
+
+	if (!(basr & BASR_PHASE_MATCH))
+		return 1;
+
+	if (basr & BASR_IRQ)
+		return -1;
+
+	if (basr & BASR_DRQ)
+		return 0;
+
+	if (n-- == 0) {
+		NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
+		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
+			 "%s: DRQ timeout\n", __func__);
+		return -1;
+	}
+
+	NCR5380_poll_politely2(hostdata,
+			       BUS_AND_STATUS_REG, BASR_DRQ, BASR_DRQ,
+			       BUS_AND_STATUS_REG, BASR_PHASE_MATCH, 0, 0);
+	goto again;
+}
+
 static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
                                 unsigned char *dst, int len)
 {
@@ -283,9 +311,7 @@ static inline int macscsi_pread(struct N
 
 	hostdata->pdma_residual = len;
 
-	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
-	                              BASR_DRQ | BASR_PHASE_MATCH,
-	                              BASR_DRQ | BASR_PHASE_MATCH, 0)) {
+	while (macscsi_wait_for_drq(hostdata) == 0) {
 		int bytes, chunk_bytes;
 
 		if (macintosh_config->ident == MAC_MODEL_IIFX)
@@ -295,19 +321,16 @@ static inline int macscsi_pread(struct N
 		chunk_bytes = min(hostdata->pdma_residual, 512);
 		bytes = mac_pdma_recv(s, d, chunk_bytes);
 
+		if (macintosh_config->ident == MAC_MODEL_IIFX)
+			write_ctrl_reg(hostdata, CTRL_INTERRUPTS_ENABLE);
+
 		if (bytes > 0) {
 			d += bytes;
 			hostdata->pdma_residual -= bytes;
 		}
 
 		if (hostdata->pdma_residual == 0)
-			goto out;
-
-		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
-			goto out;
-
-		if (bytes == 0)
-			udelay(MAC_PDMA_DELAY);
+			break;
 
 		if (bytes > 0)
 			continue;
@@ -321,16 +344,9 @@ static inline int macscsi_pread(struct N
 			continue;
 
 		result = -1;
-		goto out;
+		break;
 	}
 
-	scmd_printk(KERN_ERR, hostdata->connected,
-	            "%s: phase mismatch or !DRQ\n", __func__);
-	NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
-	result = -1;
-out:
-	if (macintosh_config->ident == MAC_MODEL_IIFX)
-		write_ctrl_reg(hostdata, CTRL_INTERRUPTS_ENABLE);
 	return result;
 }
 
@@ -343,9 +359,7 @@ static inline int macscsi_pwrite(struct
 
 	hostdata->pdma_residual = len;
 
-	while (!NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
-	                              BASR_DRQ | BASR_PHASE_MATCH,
-	                              BASR_DRQ | BASR_PHASE_MATCH, 0)) {
+	while (macscsi_wait_for_drq(hostdata) == 0) {
 		int bytes, chunk_bytes;
 
 		if (macintosh_config->ident == MAC_MODEL_IIFX)
@@ -355,6 +369,9 @@ static inline int macscsi_pwrite(struct
 		chunk_bytes = min(hostdata->pdma_residual, 512);
 		bytes = mac_pdma_send(s, d, chunk_bytes);
 
+		if (macintosh_config->ident == MAC_MODEL_IIFX)
+			write_ctrl_reg(hostdata, CTRL_INTERRUPTS_ENABLE);
+
 		if (bytes > 0) {
 			s += bytes;
 			hostdata->pdma_residual -= bytes;
@@ -369,15 +386,9 @@ static inline int macscsi_pwrite(struct
 				            "%s: Last Byte Sent timeout\n", __func__);
 				result = -1;
 			}
-			goto out;
+			break;
 		}
 
-		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
-			goto out;
-
-		if (bytes == 0)
-			udelay(MAC_PDMA_DELAY);
-
 		if (bytes > 0)
 			continue;
 
@@ -390,16 +401,9 @@ static inline int macscsi_pwrite(struct
 			continue;
 
 		result = -1;
-		goto out;
+		break;
 	}
 
-	scmd_printk(KERN_ERR, hostdata->connected,
-	            "%s: phase mismatch or !DRQ\n", __func__);
-	NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
-	result = -1;
-out:
-	if (macintosh_config->ident == MAC_MODEL_IIFX)
-		write_ctrl_reg(hostdata, CTRL_INTERRUPTS_ENABLE);
 	return result;
 }
 


