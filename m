Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E8432E757;
	Sat, 12 Sep 2026 16:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231550; cv=none; b=BispYj/8m0n8jDLKdRZMY26yj5hEz1dpBnhFUTT8I4FB0X5dlG4l6euJdMU86xxueLZGWe2Wd6ldr3BbyHTgqWS+T478yAhdUTcApWRdlzmx+tI1bc9OHwbvQcWzX68URml4im4Rg+AJihzc5rsAz5pNi7G4Sd+NYhLo+udF990=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231550; c=relaxed/simple;
	bh=4E87aSUgiuKLjZeEe4OyClQtgYM1NeWR6vTO+E6iLfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qne3oidisMQz9E9g9c3M9HEMUOWkhAbVdPHS0xbXI0PYmOu+JQetr6thkr/tsEGkoJtKZAY0/B5mpMX3ornjcIdShNV6VasjEKl16vZvKvtfasRhD9kzjLnKxw172FT2dRBaTEDWElQ5YL42NcIz6Mwt1cWlvmxB42P9C7crAWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbbgKvbK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbbgKvbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D1F1F00893;
	Sat, 12 Sep 2026 16:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231547;
	bh=EJPCSGXCQe4qUPl8Fd3dmmyLVR2tunpGiDPDxkTSeh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FbbgKvbKBmctI9EVCBr7G8ozZpL+3mkntHYgmdhaxVPslNkWd4wewUBvX/hy2Nns/
	 gY3VFLu6nfAiNKICMHlMZ1cmGL1jBY/V0dy68Cx7gRrmTPxfRgiurdUvZaaq1jmyZS
	 ktu4omz8UWtj67GunrYVV5jOpaVXXZcP19XaFRGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Young <admiyo@os.amperecomputing.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1022/1191] mailbox/pcc: support mailbox management of the shared buffer
Date: Sat, 12 Sep 2026 09:02:30 +0200
Message-ID: <20260912065611.144365009@linuxfoundation.org>
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

From: Adam Young <admiyo@os.amperecomputing.com>

[ Upstream commit 5378bdf6a611a32500fccf13d14156f219bb0c85 ]

Define a new, optional, callback that allows the driver to
specify how the return data buffer is allocated.  If that callback
is set,  mailbox/pcc.c is now responsible for reading from and
writing to the PCC shared buffer.

This also allows for proper checks of the Commnand complete flag
between the PCC sender and receiver.

For Type 4 channels, initialize the command complete flag prior
to accepting messages.

Since the mailbox does not know what memory allocation scheme
to use for response messages, the client now has an optional
callback that allows it to allocate the buffer for a response
message.

When an outbound message is written to the buffer, the mailbox
checks for the flag indicating the client wants an tx complete
notification via IRQ.  Upon receipt of the interrupt It will
pair it with the outgoing message. The expected use is to
free the kernel memory buffer for the previous outgoing message.

Signed-off-by: Adam Young <admiyo@os.amperecomputing.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: 3360b088175d ("mailbox: pcc: Fix command timeout due to missed interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 102 ++++++++++++++++++++++++++++++++++++++++--
 include/acpi/pcc.h    |  29 ++++++++++++
 2 files changed, 127 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 890a187fb63c7..e52197f40716f 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -316,6 +316,22 @@ static void check_and_ack(struct pcc_chan_info *pchan, struct mbox_chan *chan)
 		pcc_chan_reg_read_modify_write(&pchan->cmd_update);
 }
 
+static void *write_response(struct pcc_chan_info *pchan)
+{
+	struct pcc_header pcc_header;
+	void *buffer;
+	int data_len;
+
+	memcpy_fromio(&pcc_header, pchan->chan.shmem,
+		      sizeof(pcc_header));
+	data_len = pcc_header.length - sizeof(u32) + sizeof(struct pcc_header);
+
+	buffer = pchan->chan.rx_alloc(pchan->chan.mchan->cl, data_len);
+	if (buffer != NULL)
+		memcpy_fromio(buffer, pchan->chan.shmem, data_len);
+	return buffer;
+}
+
 /**
  * pcc_mbox_irq - PCC mailbox interrupt handler
  * @irq:	interrupt number
@@ -327,6 +343,8 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 {
 	struct pcc_chan_info *pchan;
 	struct mbox_chan *chan = p;
+	struct pcc_header *pcc_header = chan->active_req;
+	void *handle = NULL;
 
 	pchan = chan->con_priv;
 
@@ -350,7 +368,17 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 	 * required to avoid any possible race in updatation of this flag.
 	 */
 	pchan->chan_in_use = false;
-	mbox_chan_received_data(chan, NULL);
+
+	if (pchan->chan.rx_alloc)
+		handle = write_response(pchan);
+
+	if (chan->active_req) {
+		pcc_header = chan->active_req;
+		if (pcc_header->flags & PCC_CMD_COMPLETION_NOTIFY)
+			mbox_chan_txdone(chan, 0);
+	}
+
+	mbox_chan_received_data(chan, handle);
 
 	check_and_ack(pchan, chan);
 
@@ -394,9 +422,24 @@ pcc_mbox_request_channel(struct mbox_client *cl, int subspace_id)
 	pcc_mchan = &pchan->chan;
 	pcc_mchan->shmem = acpi_os_ioremap(pcc_mchan->shmem_base_addr,
 					   pcc_mchan->shmem_size);
-	if (pcc_mchan->shmem)
-		return pcc_mchan;
+	if (!pcc_mchan->shmem)
+		goto err;
+
+	pcc_mchan->manage_writes = false;
 
+	/* This indicates that the channel is ready to accept messages.
+	 * This needs to happen after the channel has registered
+	 * its callback. There is no access point to do that in
+	 * the mailbox API. That implies that the mailbox client must
+	 * have set the allocate callback function prior to
+	 * sending any messages.
+	 */
+	if (pchan->type == ACPI_PCCT_TYPE_EXT_PCC_SLAVE_SUBSPACE)
+		pcc_chan_reg_read_modify_write(&pchan->cmd_update);
+
+	return pcc_mchan;
+
+err:
 	mbox_free_channel(chan);
 	return ERR_PTR(-ENXIO);
 }
@@ -427,8 +470,38 @@ void pcc_mbox_free_channel(struct pcc_mbox_chan *pchan)
 }
 EXPORT_SYMBOL_GPL(pcc_mbox_free_channel);
 
+static int pcc_write_to_buffer(struct mbox_chan *chan, void *data)
+{
+	struct pcc_chan_info *pchan = chan->con_priv;
+	struct pcc_mbox_chan *pcc_mbox_chan = &pchan->chan;
+	struct pcc_header *pcc_header = data;
+
+	if (!pchan->chan.manage_writes)
+		return 0;
+
+	/* The PCC header length includes the command field
+	 * but not the other values from the header.
+	 */
+	int len = pcc_header->length - sizeof(u32) + sizeof(struct pcc_header);
+	u64 val;
+
+	pcc_chan_reg_read(&pchan->cmd_complete, &val);
+	if (!val) {
+		pr_info("%s pchan->cmd_complete not set", __func__);
+		return -1;
+	}
+	memcpy_toio(pcc_mbox_chan->shmem,  data, len);
+	return 0;
+}
+
+
 /**
- * pcc_send_data - Called from Mailbox Controller code. Used
+ * pcc_send_data - Called from Mailbox Controller code. If
+ *		pchan->chan.rx_alloc is set, then the command complete
+ *		flag is checked and the data is written to the shared
+ *		buffer io memory.
+ *
+ *		If pchan->chan.rx_alloc is not set, then it is used
  *		here only to ring the channel doorbell. The PCC client
  *		specific read/write is done in the client driver in
  *		order to maintain atomicity over PCC channel once
@@ -444,17 +517,37 @@ static int pcc_send_data(struct mbox_chan *chan, void *data)
 	int ret;
 	struct pcc_chan_info *pchan = chan->con_priv;
 
+	ret = pcc_write_to_buffer(chan, data);
+	if (ret)
+		return ret;
+
 	ret = pcc_chan_reg_read_modify_write(&pchan->cmd_update);
 	if (ret)
 		return ret;
 
 	ret = pcc_chan_reg_read_modify_write(&pchan->db);
+
 	if (!ret && pchan->plat_irq > 0)
 		pchan->chan_in_use = true;
 
 	return ret;
 }
 
+
+static bool pcc_last_tx_done(struct mbox_chan *chan)
+{
+	struct pcc_chan_info *pchan = chan->con_priv;
+	u64 val;
+
+	pcc_chan_reg_read(&pchan->cmd_complete, &val);
+	if (!val)
+		return false;
+	else
+		return true;
+}
+
+
+
 /**
  * pcc_startup - Called from Mailbox Controller code. Used here
  *		to request the interrupt.
@@ -500,6 +593,7 @@ static const struct mbox_chan_ops pcc_chan_ops = {
 	.send_data = pcc_send_data,
 	.startup = pcc_startup,
 	.shutdown = pcc_shutdown,
+	.last_tx_done = pcc_last_tx_done,
 };
 
 /**
diff --git a/include/acpi/pcc.h b/include/acpi/pcc.h
index 0462bb9da6513..cb34b6937a74f 100644
--- a/include/acpi/pcc.h
+++ b/include/acpi/pcc.h
@@ -17,6 +17,35 @@ struct pcc_mbox_chan {
 	u32 latency;
 	u32 max_access_rate;
 	u16 min_turnaround_time;
+
+	/* Set to true to indicate that the mailbox should manage
+	 * writing the dat to the shared buffer. This differs from
+	 * the case where the drivesr are writing to the buffer and
+	 * using send_data only to  ring the doorbell.  If this flag
+	 * is set, then the void * data parameter of send_data must
+	 * point to a kernel-memory buffer formatted in accordance with
+	 * the PCC specification.
+	 *
+	 * The active buffer management will include reading the
+	 * notify_on_completion flag, and will then
+	 * call mbox_chan_txdone when the acknowledgment interrupt is
+	 * received.
+	 */
+	bool manage_writes;
+
+	/* Optional callback that allows the driver
+	 * to allocate the memory used for receiving
+	 * messages.  The return value is the location
+	 * inside the buffer where the mailbox should write the data.
+	 */
+	void *(*rx_alloc)(struct mbox_client *cl,  int size);
+};
+
+struct pcc_header {
+	u32 signature;
+	u32 flags;
+	u32 length;
+	u32 command;
 };
 
 /* Generic Communications Channel Shared Memory Region */
-- 
2.53.0



