Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE7E19258E;
	Wed,  3 Dec 2025 16:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780277; cv=none; b=YPHMLSp7yJqraghstFRH+Zx7gM6QukzpUNlFdlFluYOme6rkhZl6G+oRKnNM43tuEptt7/VR0J2qGcgK8CoRH0fvAd/39vbQiUzUpKTY+eDLKn/MUXV8eCoy3lvkBEnbYZdmJgRA+/2O5nQQGSPnaxYruh1B4OjaGUYoWKDd3pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780277; c=relaxed/simple;
	bh=FDbiW8RBWKYSJVpqvYBCrFaJyXNnjY77YQuYOvX5MdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+i8hn/BOyFtLnYXO3iRyGJZYC2Gyb+slaUcgM4COPZobFGLQrBPkcW4Ad40eOkwv/uJ98y194kaooULZC7dRzoXc5+D9y4f3upAIWllfBE4roPds1EpQL6vbZHwYxnbhXlIF7iAWZvv++m4/hAZnWQ0L5sCHxvCb6iqt2/bgW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9QwS9px; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9QwS9px"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E7AC4CEF5;
	Wed,  3 Dec 2025 16:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780277;
	bh=FDbiW8RBWKYSJVpqvYBCrFaJyXNnjY77YQuYOvX5MdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9QwS9pxp4BFR1PlEmhY8F4BSLW4LAJdPqDMjFlDWRP0bjQgKVyMSqkrBUaUqIkRp
	 QDS05980+UimbDDr08WOha4mP35QB40iyizjfrR/v0eefm1j+yGQ4Fkjb5Sl7ODNNj
	 LQpiauY90UGdEChc4c3PKcphqIg02DCzEn5rITI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 509/568] mailbox: pcc: Add support for platform notification handling
Date: Wed,  3 Dec 2025 16:28:31 +0100
Message-ID: <20251203152459.357352975@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 60c40b06fa68694dd08a1a0038ea8b9de3f3b1ca ]

Currently, PCC driver doesn't support the processing of platform
notification for type 4 PCC subspaces.

According to ACPI specification, if platform sends a notification
to OSPM, it must clear the command complete bit and trigger platform
interrupt. OSPM needs to check whether the command complete bit is
cleared, clear platform interrupt, process command, and then set the
command complete and ring doorbell to the Platform.

Let us stash the value of the pcc type and use the same while processing
the interrupt of the channel. We also need to set the command complete
bit and ring doorbell in the interrupt handler for the type 4 channel to
complete the communication flow after processing the notification from
the Platform.

Signed-off-by: Huisong Li <lihuisong@huawei.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Link: https://lore.kernel.org/r/20230801063827.25336-2-lihuisong@huawei.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: ff0e4d4c97c9 ("mailbox: pcc: don't zero error register")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 50 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 9 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index a44d4b3e5beb2..80310b48bfb6a 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -91,6 +91,7 @@ struct pcc_chan_reg {
  * @cmd_update: PCC register bundle for the command complete update register
  * @error: PCC register bundle for the error status register
  * @plat_irq: platform interrupt
+ * @type: PCC subspace type
  */
 struct pcc_chan_info {
 	struct pcc_mbox_chan chan;
@@ -100,12 +101,15 @@ struct pcc_chan_info {
 	struct pcc_chan_reg cmd_update;
 	struct pcc_chan_reg error;
 	int plat_irq;
+	u8 type;
 };
 
 #define to_pcc_chan_info(c) container_of(c, struct pcc_chan_info, chan)
 static struct pcc_chan_info *chan_info;
 static int pcc_chan_count;
 
+static int pcc_send_data(struct mbox_chan *chan, void *data);
+
 /*
  * PCC can be used with perf critical drivers such as CPPC
  * So it makes sense to locally cache the virtual address and
@@ -221,6 +225,34 @@ static int pcc_map_interrupt(u32 interrupt, u32 flags)
 	return acpi_register_gsi(NULL, interrupt, trigger, polarity);
 }
 
+static bool pcc_mbox_cmd_complete_check(struct pcc_chan_info *pchan)
+{
+	u64 val;
+	int ret;
+
+	ret = pcc_chan_reg_read(&pchan->cmd_complete, &val);
+	if (ret)
+		return false;
+
+	if (!pchan->cmd_complete.gas)
+		return true;
+
+	/*
+	 * Judge if the channel respond the interrupt based on the value of
+	 * command complete.
+	 */
+	val &= pchan->cmd_complete.status_mask;
+	/*
+	 * If this is PCC slave subspace channel, and the command complete
+	 * bit 0 indicates that Platform is sending a notification and OSPM
+	 * needs to respond this interrupt to process this command.
+	 */
+	if (pchan->type == ACPI_PCCT_TYPE_EXT_PCC_SLAVE_SUBSPACE)
+		return !val;
+
+	return !!val;
+}
+
 /**
  * pcc_mbox_irq - PCC mailbox interrupt handler
  * @irq:	interrupt number
@@ -236,17 +268,9 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 	int ret;
 
 	pchan = chan->con_priv;
-
-	ret = pcc_chan_reg_read(&pchan->cmd_complete, &val);
-	if (ret)
+	if (!pcc_mbox_cmd_complete_check(pchan))
 		return IRQ_NONE;
 
-	if (val) { /* Ensure GAS exists and value is non-zero */
-		val &= pchan->cmd_complete.status_mask;
-		if (!val)
-			return IRQ_NONE;
-	}
-
 	ret = pcc_chan_reg_read(&pchan->error, &val);
 	if (ret)
 		return IRQ_NONE;
@@ -262,6 +286,13 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 
 	mbox_chan_received_data(chan, NULL);
 
+	/*
+	 * The PCC slave subspace channel needs to set the command complete bit
+	 * and ring doorbell after processing message.
+	 */
+	if (pchan->type == ACPI_PCCT_TYPE_EXT_PCC_SLAVE_SUBSPACE)
+		pcc_send_data(chan, NULL);
+
 	return IRQ_HANDLED;
 }
 
@@ -698,6 +729,7 @@ static int pcc_mbox_probe(struct platform_device *pdev)
 
 		pcc_parse_subspace_shmem(pchan, pcct_entry);
 
+		pchan->type = pcct_entry->type;
 		pcct_entry = (struct acpi_subtable_header *)
 			((unsigned long) pcct_entry + pcct_entry->length);
 	}
-- 
2.51.0



