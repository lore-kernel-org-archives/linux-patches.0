Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C0415665D;
	Mon,  6 Jan 2025 15:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177107; cv=none; b=Byv/5tu2A96MbNFJCLP9xqXIQqCzn7X3AFNRLbiQkBQBXJe6aiQCpkQAWobfC2IzNpPwsDOwd4C+7Y/weyZvpOYcN9e2ggLttD65GLRqIM7kypfx+hiMw65HAGi0lBaES6hMUZLG45t0BcJwhvTB5g1Go8+beNPkUMXv4Jx/Ebk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177107; c=relaxed/simple;
	bh=dz6uJZZcfydoizznb/G98o+For9SASDo/liIvsWif1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ojzap2eLfe3/T4ujqxV5ERi3Z0w1faAyZX1jF1/3ozuBlAU6znilNNK25Y7NkQyqcpfEnywGNYqXBlHT2dd0CB9iZb8QyrKdbBpsqdosSihB+6cEwfsMJ1UtR3T75ODmgwMlbqV7gD63IgzaFbU+Am/L6rDEmZXuYbxTkwsch74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmxEI+3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmxEI+3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBD3C4CED2;
	Mon,  6 Jan 2025 15:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177107;
	bh=dz6uJZZcfydoizznb/G98o+For9SASDo/liIvsWif1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmxEI+3Uq42LBclyqjQV+M1KBYzHvNf8ag2kcxDIQkkMTApnuV3PveqM6v8jdwb7e
	 F1Ketx16OVCU9RTmJ88MbETM3jcVe7mdJeZsDuxK1MSSwmmf/h8jyO6BYcpfgPKCho
	 MnvA8YrwUH2byAu/sBBQRiyCFAy/5Q9cvL/5DDHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Young <admiyo@os.amperecomputing.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/222] mailbox: pcc: Check before sending MCTP PCC response ACK
Date: Mon,  6 Jan 2025 16:14:16 +0100
Message-ID: <20250106151152.574254357@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Young <admiyo@os.amperecomputing.com>

[ Upstream commit 7f9e19f207be0c534d517d65e01417ba968cdd34 ]

Type 4 PCC channels have an option to send back a response
to the platform when they are done processing the request.
The flag to indicate whether or not to respond is inside
the message body, and thus is not available to the pcc
mailbox.

If the flag is not set, still set command completion
bit after processing message.

In order to read the flag, this patch maps the shared
buffer to virtual memory. To avoid duplication of mapping
the shared buffer is then made available to be used by
the driver that uses the mailbox.

Signed-off-by: Adam Young <admiyo@os.amperecomputing.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 61 +++++++++++++++++++++++++++++++++++++------
 include/acpi/pcc.h    |  7 +++++
 2 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 94885e411085..82102a4c5d68 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -269,6 +269,35 @@ static bool pcc_mbox_cmd_complete_check(struct pcc_chan_info *pchan)
 	return !!val;
 }
 
+static void check_and_ack(struct pcc_chan_info *pchan, struct mbox_chan *chan)
+{
+	struct acpi_pcct_ext_pcc_shared_memory pcc_hdr;
+
+	if (pchan->type != ACPI_PCCT_TYPE_EXT_PCC_SLAVE_SUBSPACE)
+		return;
+	/* If the memory region has not been mapped, we cannot
+	 * determine if we need to send the message, but we still
+	 * need to set the cmd_update flag before returning.
+	 */
+	if (pchan->chan.shmem == NULL) {
+		pcc_chan_reg_read_modify_write(&pchan->cmd_update);
+		return;
+	}
+	memcpy_fromio(&pcc_hdr, pchan->chan.shmem,
+		      sizeof(struct acpi_pcct_ext_pcc_shared_memory));
+	/*
+	 * The PCC slave subspace channel needs to set the command complete bit
+	 * after processing message. If the PCC_ACK_FLAG is set, it should also
+	 * ring the doorbell.
+	 *
+	 * The PCC master subspace channel clears chan_in_use to free channel.
+	 */
+	if (le32_to_cpup(&pcc_hdr.flags) & PCC_ACK_FLAG_MASK)
+		pcc_send_data(chan, NULL);
+	else
+		pcc_chan_reg_read_modify_write(&pchan->cmd_update);
+}
+
 /**
  * pcc_mbox_irq - PCC mailbox interrupt handler
  * @irq:	interrupt number
@@ -306,14 +335,7 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 
 	mbox_chan_received_data(chan, NULL);
 
-	/*
-	 * The PCC slave subspace channel needs to set the command complete bit
-	 * and ring doorbell after processing message.
-	 *
-	 * The PCC master subspace channel clears chan_in_use to free channel.
-	 */
-	if (pchan->type == ACPI_PCCT_TYPE_EXT_PCC_SLAVE_SUBSPACE)
-		pcc_send_data(chan, NULL);
+	check_and_ack(pchan, chan);
 	pchan->chan_in_use = false;
 
 	return IRQ_HANDLED;
@@ -365,14 +387,37 @@ EXPORT_SYMBOL_GPL(pcc_mbox_request_channel);
 void pcc_mbox_free_channel(struct pcc_mbox_chan *pchan)
 {
 	struct mbox_chan *chan = pchan->mchan;
+	struct pcc_chan_info *pchan_info;
+	struct pcc_mbox_chan *pcc_mbox_chan;
 
 	if (!chan || !chan->cl)
 		return;
+	pchan_info = chan->con_priv;
+	pcc_mbox_chan = &pchan_info->chan;
+	if (pcc_mbox_chan->shmem) {
+		iounmap(pcc_mbox_chan->shmem);
+		pcc_mbox_chan->shmem = NULL;
+	}
 
 	mbox_free_channel(chan);
 }
 EXPORT_SYMBOL_GPL(pcc_mbox_free_channel);
 
+int pcc_mbox_ioremap(struct mbox_chan *chan)
+{
+	struct pcc_chan_info *pchan_info;
+	struct pcc_mbox_chan *pcc_mbox_chan;
+
+	if (!chan || !chan->cl)
+		return -1;
+	pchan_info = chan->con_priv;
+	pcc_mbox_chan = &pchan_info->chan;
+	pcc_mbox_chan->shmem = ioremap(pcc_mbox_chan->shmem_base_addr,
+				       pcc_mbox_chan->shmem_size);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pcc_mbox_ioremap);
+
 /**
  * pcc_send_data - Called from Mailbox Controller code. Used
  *		here only to ring the channel doorbell. The PCC client
diff --git a/include/acpi/pcc.h b/include/acpi/pcc.h
index 9b373d172a77..699c1a37b8e7 100644
--- a/include/acpi/pcc.h
+++ b/include/acpi/pcc.h
@@ -12,6 +12,7 @@
 struct pcc_mbox_chan {
 	struct mbox_chan *mchan;
 	u64 shmem_base_addr;
+	void __iomem *shmem;
 	u64 shmem_size;
 	u32 latency;
 	u32 max_access_rate;
@@ -31,11 +32,13 @@ struct pcc_mbox_chan {
 #define PCC_CMD_COMPLETION_NOTIFY	BIT(0)
 
 #define MAX_PCC_SUBSPACES	256
+#define PCC_ACK_FLAG_MASK	0x1
 
 #ifdef CONFIG_PCC
 extern struct pcc_mbox_chan *
 pcc_mbox_request_channel(struct mbox_client *cl, int subspace_id);
 extern void pcc_mbox_free_channel(struct pcc_mbox_chan *chan);
+extern int pcc_mbox_ioremap(struct mbox_chan *chan);
 #else
 static inline struct pcc_mbox_chan *
 pcc_mbox_request_channel(struct mbox_client *cl, int subspace_id)
@@ -43,6 +46,10 @@ pcc_mbox_request_channel(struct mbox_client *cl, int subspace_id)
 	return ERR_PTR(-ENODEV);
 }
 static inline void pcc_mbox_free_channel(struct pcc_mbox_chan *chan) { }
+static inline int pcc_mbox_ioremap(struct mbox_chan *chan)
+{
+	return 0;
+};
 #endif
 
 #endif /* _PCC_H */
-- 
2.39.5



