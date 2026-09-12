Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69ED647CA63;
	Sat, 12 Sep 2026 16:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231556; cv=none; b=V8hGyy+5/XItxYZnnuqjQZxia9SD1p1vO7RP+v351f+kLyD+ZK/s25IKeCLjYAuLFx396s+60QOamrOv5kWlLEcMoTB3c3gSnMJylsaua0BB/WtZkpkwWF1NFKU54K9hR4J5BieCmvefIfuhxLnzKO07UF/vrQESVJz80QLEy/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231556; c=relaxed/simple;
	bh=gx0+UuMDsqZ848ojndYB9t4/1h4PDXou8oGaqcs4y7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXcwGLZ1a8I5/YgF/XzthUQwr6U3T4Csrm16vDTxvceMsROG1ZEs/z6+zofg6F0YD8SZw87EcyR4DNabjoXy5XwcbDl3C6fMTGWZEEf3PJEJ0F3qmeYWpMLB4syYZ5II1afgBFU1Za9zyD98utAgUjc6yxTwXSWOehs2KULPeaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcYJdlc0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcYJdlc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546561F000FF;
	Sat, 12 Sep 2026 16:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231552;
	bh=+ZnMRj2nAgYc+yFit1cHEkT2o8jVGwMGY5YztDgFOCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcYJdlc01p+lV3beVOTKQJHi19QGJSw9zNy2ab48OQjFICThj05octHro6I2boS2n
	 U0zcBKthOMB1VOzAETP9DKpfOqC31je4a/L0ozXRQ/WlgeD/xDsnW35Arq8HQlFnlD
	 FOsfXwEbtF3dtx8ha4x13pVa8EBtvaiI7VnElx10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1023/1191] Revert "mailbox/pcc: support mailbox management of the shared buffer"
Date: Sat, 12 Sep 2026 09:02:31 +0200
Message-ID: <20260912065611.166159312@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit f82c3e62b6b8c31d8c56415bf38658f306fda4cb ]

This reverts commit 5378bdf6a611a32500fccf13d14156f219bb0c85.

Commit 5378bdf6a611 ("mailbox/pcc: support mailbox management of the shared buffer")
attempted to introduce generic helpers for managing the PCC shared memory,
but it largely duplicates functionality already provided by the mailbox
core and leaves gaps:

1. TX preparation: The mailbox framework already supports this via
  ->tx_prepare callback for mailbox clients. The patch adds
  pcc_write_to_buffer() and expects clients to toggle pchan->chan.manage_writes,
  but no drivers set manage_writes, so pcc_write_to_buffer() has no users.

2. RX handling: Data reception is already delivered through
   mbox_chan_received_data() and client ->rx_callback. The patch adds an
   optional pchan->chan.rx_alloc, which again has no users and duplicates
   the existing path.

3. Completion handling: While adding last_tx_done is directionally useful,
   the implementation only covers Type 3/4 and fails to handle the absence
   of a command_complete register, so it is incomplete for other types.

Given the duplication and incomplete coverage, revert this change. Any new
requirements should be addressed in focused follow-ups rather than bundling
multiple behavioral changes together.

Fixes: 5378bdf6a611 ("mailbox/pcc: support mailbox management of the shared buffer")
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: 3360b088175d ("mailbox: pcc: Fix command timeout due to missed interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 102 ++----------------------------------------
 include/acpi/pcc.h    |  29 ------------
 2 files changed, 4 insertions(+), 127 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index e52197f40716f..890a187fb63c7 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -316,22 +316,6 @@ static void check_and_ack(struct pcc_chan_info *pchan, struct mbox_chan *chan)
 		pcc_chan_reg_read_modify_write(&pchan->cmd_update);
 }
 
-static void *write_response(struct pcc_chan_info *pchan)
-{
-	struct pcc_header pcc_header;
-	void *buffer;
-	int data_len;
-
-	memcpy_fromio(&pcc_header, pchan->chan.shmem,
-		      sizeof(pcc_header));
-	data_len = pcc_header.length - sizeof(u32) + sizeof(struct pcc_header);
-
-	buffer = pchan->chan.rx_alloc(pchan->chan.mchan->cl, data_len);
-	if (buffer != NULL)
-		memcpy_fromio(buffer, pchan->chan.shmem, data_len);
-	return buffer;
-}
-
 /**
  * pcc_mbox_irq - PCC mailbox interrupt handler
  * @irq:	interrupt number
@@ -343,8 +327,6 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 {
 	struct pcc_chan_info *pchan;
 	struct mbox_chan *chan = p;
-	struct pcc_header *pcc_header = chan->active_req;
-	void *handle = NULL;
 
 	pchan = chan->con_priv;
 
@@ -368,17 +350,7 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 	 * required to avoid any possible race in updatation of this flag.
 	 */
 	pchan->chan_in_use = false;
-
-	if (pchan->chan.rx_alloc)
-		handle = write_response(pchan);
-
-	if (chan->active_req) {
-		pcc_header = chan->active_req;
-		if (pcc_header->flags & PCC_CMD_COMPLETION_NOTIFY)
-			mbox_chan_txdone(chan, 0);
-	}
-
-	mbox_chan_received_data(chan, handle);
+	mbox_chan_received_data(chan, NULL);
 
 	check_and_ack(pchan, chan);
 
@@ -422,24 +394,9 @@ pcc_mbox_request_channel(struct mbox_client *cl, int subspace_id)
 	pcc_mchan = &pchan->chan;
 	pcc_mchan->shmem = acpi_os_ioremap(pcc_mchan->shmem_base_addr,
 					   pcc_mchan->shmem_size);
-	if (!pcc_mchan->shmem)
-		goto err;
-
-	pcc_mchan->manage_writes = false;
+	if (pcc_mchan->shmem)
+		return pcc_mchan;
 
-	/* This indicates that the channel is ready to accept messages.
-	 * This needs to happen after the channel has registered
-	 * its callback. There is no access point to do that in
-	 * the mailbox API. That implies that the mailbox client must
-	 * have set the allocate callback function prior to
-	 * sending any messages.
-	 */
-	if (pchan->type == ACPI_PCCT_TYPE_EXT_PCC_SLAVE_SUBSPACE)
-		pcc_chan_reg_read_modify_write(&pchan->cmd_update);
-
-	return pcc_mchan;
-
-err:
 	mbox_free_channel(chan);
 	return ERR_PTR(-ENXIO);
 }
@@ -470,38 +427,8 @@ void pcc_mbox_free_channel(struct pcc_mbox_chan *pchan)
 }
 EXPORT_SYMBOL_GPL(pcc_mbox_free_channel);
 
-static int pcc_write_to_buffer(struct mbox_chan *chan, void *data)
-{
-	struct pcc_chan_info *pchan = chan->con_priv;
-	struct pcc_mbox_chan *pcc_mbox_chan = &pchan->chan;
-	struct pcc_header *pcc_header = data;
-
-	if (!pchan->chan.manage_writes)
-		return 0;
-
-	/* The PCC header length includes the command field
-	 * but not the other values from the header.
-	 */
-	int len = pcc_header->length - sizeof(u32) + sizeof(struct pcc_header);
-	u64 val;
-
-	pcc_chan_reg_read(&pchan->cmd_complete, &val);
-	if (!val) {
-		pr_info("%s pchan->cmd_complete not set", __func__);
-		return -1;
-	}
-	memcpy_toio(pcc_mbox_chan->shmem,  data, len);
-	return 0;
-}
-
-
 /**
- * pcc_send_data - Called from Mailbox Controller code. If
- *		pchan->chan.rx_alloc is set, then the command complete
- *		flag is checked and the data is written to the shared
- *		buffer io memory.
- *
- *		If pchan->chan.rx_alloc is not set, then it is used
+ * pcc_send_data - Called from Mailbox Controller code. Used
  *		here only to ring the channel doorbell. The PCC client
  *		specific read/write is done in the client driver in
  *		order to maintain atomicity over PCC channel once
@@ -517,37 +444,17 @@ static int pcc_send_data(struct mbox_chan *chan, void *data)
 	int ret;
 	struct pcc_chan_info *pchan = chan->con_priv;
 
-	ret = pcc_write_to_buffer(chan, data);
-	if (ret)
-		return ret;
-
 	ret = pcc_chan_reg_read_modify_write(&pchan->cmd_update);
 	if (ret)
 		return ret;
 
 	ret = pcc_chan_reg_read_modify_write(&pchan->db);
-
 	if (!ret && pchan->plat_irq > 0)
 		pchan->chan_in_use = true;
 
 	return ret;
 }
 
-
-static bool pcc_last_tx_done(struct mbox_chan *chan)
-{
-	struct pcc_chan_info *pchan = chan->con_priv;
-	u64 val;
-
-	pcc_chan_reg_read(&pchan->cmd_complete, &val);
-	if (!val)
-		return false;
-	else
-		return true;
-}
-
-
-
 /**
  * pcc_startup - Called from Mailbox Controller code. Used here
  *		to request the interrupt.
@@ -593,7 +500,6 @@ static const struct mbox_chan_ops pcc_chan_ops = {
 	.send_data = pcc_send_data,
 	.startup = pcc_startup,
 	.shutdown = pcc_shutdown,
-	.last_tx_done = pcc_last_tx_done,
 };
 
 /**
diff --git a/include/acpi/pcc.h b/include/acpi/pcc.h
index cb34b6937a74f..0462bb9da6513 100644
--- a/include/acpi/pcc.h
+++ b/include/acpi/pcc.h
@@ -17,35 +17,6 @@ struct pcc_mbox_chan {
 	u32 latency;
 	u32 max_access_rate;
 	u16 min_turnaround_time;
-
-	/* Set to true to indicate that the mailbox should manage
-	 * writing the dat to the shared buffer. This differs from
-	 * the case where the drivesr are writing to the buffer and
-	 * using send_data only to  ring the doorbell.  If this flag
-	 * is set, then the void * data parameter of send_data must
-	 * point to a kernel-memory buffer formatted in accordance with
-	 * the PCC specification.
-	 *
-	 * The active buffer management will include reading the
-	 * notify_on_completion flag, and will then
-	 * call mbox_chan_txdone when the acknowledgment interrupt is
-	 * received.
-	 */
-	bool manage_writes;
-
-	/* Optional callback that allows the driver
-	 * to allocate the memory used for receiving
-	 * messages.  The return value is the location
-	 * inside the buffer where the mailbox should write the data.
-	 */
-	void *(*rx_alloc)(struct mbox_client *cl,  int size);
-};
-
-struct pcc_header {
-	u32 signature;
-	u32 flags;
-	u32 length;
-	u32 command;
 };
 
 /* Generic Communications Channel Shared Memory Region */
-- 
2.53.0



