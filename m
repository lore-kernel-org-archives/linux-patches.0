Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE2F47CC85;
	Sat, 12 Sep 2026 16:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231559; cv=none; b=XbCcSCnLbyq+U05WnQrJ1LWWKQTI8VmftRYOfT191Tkd2es0/Cvv26oskb2e5Lc7E8VbALVihe+W8Rk3FQ01sUY3JicnIDbk+HNPbh2qXjcJ0vBk3DYBfVZ/t3SES7tgI/AfAL2kXI1a6/5tcEbRYxMVaUVxbVbj5V/JULd0pjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231559; c=relaxed/simple;
	bh=/l1iLkXrwOAEsaAsHUb02a0gvJcu5/ry732nJCivLW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6/GvOi+Y3QZe6HDTeM+RBR6fM66I4kC8AG6WnCtEBINIf0u1YX+3b41cpPcxFEna+P31USnvGB06v53nQuxUAK0PNbQ4eTwK5a30CXoykyQrVjP9O72EiNgd9aN5i7zHJEizX+M5hYJjwY4DGt9x6jkT57j9WlOyrBBL27GufM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZVKGjgQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZVKGjgQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E80D1F00893;
	Sat, 12 Sep 2026 16:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231556;
	bh=bnZYznUpwGb3YB1UdDc8IvCkIaCZvCw0ouaDca2oIVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZVKGjgQrHnSEwvh/BSMlYCOm4kohDOBEFmx2nVxtQKGonOMHUF02yDSHRxtNxmVO
	 dgo/e90z2+Mb6bwFCKscQleR5OMHPpHuzSd62FL7CTgjuHixN4qUT7B76bltzRWmNJ
	 FPovCwaKIx0V2F1S5YlMlu6VxBfO25cPf8sjUu90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Adam Young <admiyo@os.amperecomputing.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1024/1191] mailbox: pcc: Fix command timeout due to missed interrupt
Date: Sat, 12 Sep 2026 09:02:32 +0200
Message-ID: <20260912065611.188288508@linuxfoundation.org>
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

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 3360b088175dc5d5c9166685836158470d00571e ]

PCC command execution can time out when a fast platform completes a
transaction and signals the platform interrupt before pcc_send_data()
marks the channel as in use. For shared platform interrupts, the type 3
handler uses chan_in_use to decide whether the interrupt belongs to the
channel. If it observes false, it ignores the completion and the caller
waits until timeout.

Publish chan_in_use before ringing the doorbell. Use WRITE_ONCE() for
the lockless flag updates and READ_ONCE() in the interrupt handler. The
following ordered I/O accessor orders the flag store before the platform
is notified.

Clear chan_in_use if ringing the doorbell fails. Otherwise, leave it set
until the interrupt handler completes the transaction, clearing it before
the mailbox core can submit another transfer.

Fixes: 3db174e478cb ("mailbox: pcc: Support shared interrupt for multiple subspaces")
Signed-off-by: Huisong Li <lihuisong@huawei.com>
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Tested-by: Adam Young <admiyo@os.amperecomputing.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 890a187fb63c7..6efeadf89db2b 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -93,12 +93,11 @@ struct pcc_chan_reg {
  * @plat_irq: platform interrupt
  * @type: PCC subspace type
  * @plat_irq_flags: platform interrupt flags
- * @chan_in_use: this flag is used just to check if the interrupt needs
- *		handling when it is shared. Since only one transfer can occur
- *		at a time and mailbox takes care of locking, this flag can be
- *		accessed without a lock. Note: the type only support the
- *		communication from OSPM to Platform, like type3, use it, and
- *		other types completely ignore it.
+ * @chan_in_use: lockless flag used by type 3 initiator subspaces to filter
+ *		platform interrupts. Only one transfer can occur at a time, but
+ *		the interrupt handler may sample the flag on another CPU, so all
+ *		accesses must use READ_ONCE() or WRITE_ONCE(). Other subspace
+ *		types do not test it.
  */
 struct pcc_chan_info {
 	struct pcc_mbox_chan chan;
@@ -333,8 +332,13 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 	if (pcc_chan_reg_read_modify_write(&pchan->plat_irq_ack))
 		return IRQ_NONE;
 
+	/*
+	 * Initiator subspaces use this flag to filter shared interrupts. Use
+	 * READ_ONCE() to sample the lockless flag written by pcc_send_data()
+	 * on another CPU.
+	 */
 	if (pchan->type == ACPI_PCCT_TYPE_EXT_PCC_MASTER_SUBSPACE &&
-	    !pchan->chan_in_use)
+	    !READ_ONCE(pchan->chan_in_use))
 		return IRQ_NONE;
 
 	if (!pcc_mbox_cmd_complete_check(pchan))
@@ -344,12 +348,12 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 		return IRQ_NONE;
 
 	/*
-	 * Clear this flag after updating interrupt ack register and just
-	 * before mbox_chan_received_data() which might call pcc_send_data()
-	 * where the flag is set again to start new transfer. This is
-	 * required to avoid any possible race in updatation of this flag.
+	 * Clear this flag after updating the interrupt ack register and before
+	 * notifying the client and mailbox core. mbox_chan_txdone() may submit
+	 * the next queued transfer and set the flag again. Use WRITE_ONCE() for
+	 * the lockless update observed by the send and interrupt paths.
 	 */
-	pchan->chan_in_use = false;
+	WRITE_ONCE(pchan->chan_in_use, false);
 	mbox_chan_received_data(chan, NULL);
 
 	check_and_ack(pchan, chan);
@@ -448,9 +452,18 @@ static int pcc_send_data(struct mbox_chan *chan, void *data)
 	if (ret)
 		return ret;
 
+	/*
+	 * Set chan_in_use before ringing the doorbell so a fast completion
+	 * interrupt is not mistaken for a shared interrupt from another
+	 * subspace. Use WRITE_ONCE() for the lockless flag update. The
+	 * ordered I/O accessor used to ring the doorbell orders this store
+	 * before the platform is notified.
+	 */
+	if (pchan->plat_irq > 0)
+		WRITE_ONCE(pchan->chan_in_use, true);
 	ret = pcc_chan_reg_read_modify_write(&pchan->db);
-	if (!ret && pchan->plat_irq > 0)
-		pchan->chan_in_use = true;
+	if (ret && pchan->plat_irq > 0)
+		WRITE_ONCE(pchan->chan_in_use, false);
 
 	return ret;
 }
-- 
2.53.0



