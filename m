Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062E5309EEB;
	Sat, 12 Sep 2026 15:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225670; cv=none; b=n9x8bg2fS6+P7InBzwC5/p+N9CMf49LeJUpGpsHdTwGRgQBlA+AaVpIebnMSpAjgvTZDoV7kWIZx6VIDejs4DL7uBkQihuc3ScAqT9ADhNaEvce2K84orlRCpEcshg3DrUW/Ty0LSx3qt11Mv1Ofqs/cHGPjnFCuz1dc/RRrdyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225670; c=relaxed/simple;
	bh=7sweXULRf3gGwy5MuiAzGc4vRutOLPHWpcUDf/k5OXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZYKIZm1LkUWstoG8JLlWNY9otiWGWKcaVtHENBWCo8yDQjZMlksR9OO2/oggoq2foWrxlIZyxKarIRvLJEGsX/oxAn+bRlx2kgRFZuZoD+mu/DYH2xESRjHI2QQXqXPAQ4C6zZWcCK0N2BA4xJyOKJQqaXYVkzKmsDYfuMFybo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/am7Ok6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/am7Ok6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78381F00893;
	Sat, 12 Sep 2026 15:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225668;
	bh=mt6EvckXBHqCO3+VPRaKgq1iRfxQWBEldq2KNKzkItM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N/am7Ok6fOHXNbE9cLm56GL31EyDWHL5nfCGWmjfyw9wCrJ80Aap2yzHaWTCr2hQV
	 sUVj3q34ZPL2IQLZlzZzOrOfbZH42ct1dxiZGfvu4JCN7zScbJiWs6+rQfQsRWkp6M
	 x7U4tloYeBZgMBuCXNJXJg1YpOIOIB+CDIrryh8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	Adam Young <admiyo@os.amperecomputing.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1228/1424] mailbox: pcc: Always map the shared memory communication address
Date: Sat, 12 Sep 2026 09:01:00 +0200
Message-ID: <20260912065634.782729397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit fa362ffafa51b08cf8e2fcca38e056332f6b9b05 ]

Currently the shared memory communication address was mapped by the
mailbox client drivers leading to all sorts of inconsistencies.

It also has resulted in the inconsistent attributes used while mapping
the shared memory regions.

In order to remove/eliminate any issues, let us ensures the shared
memory address is always mapped and unmapped when the PCC channels are
requested and release.

We need to map them as the ACPI PCCT associates these shared memory
with each channel subspace and may need use the status or the flags in
the headers of those shared memory communication address regions to
manage the transport/channel.

Note, until all the drivers using PCC start using this mapped shmem,
there might be double mapping of the shared memory address. This
shouldn't have any impact on existing mbox client drivers.

Since there are no users of pcc_chan_ioremap() and also it is mapped
by default, we can stop exporting it and merge the functionality into
pcc_mbox_request_channel().

Acked-by: Huisong Li <lihuisong@huawei.com>
Tested-by: Huisong Li <lihuisong@huawei.com>
Tested-by: Adam Young <admiyo@os.amperecomputing.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: 3360b088175d ("mailbox: pcc: Fix command timeout due to missed interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 29 +++++++++--------------------
 include/acpi/pcc.h    |  5 -----
 2 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 1d4191cb91380..890a187fb63c7 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -372,6 +372,7 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 struct pcc_mbox_chan *
 pcc_mbox_request_channel(struct mbox_client *cl, int subspace_id)
 {
+	struct pcc_mbox_chan *pcc_mchan;
 	struct pcc_chan_info *pchan;
 	struct mbox_chan *chan;
 	int rc;
@@ -390,7 +391,14 @@ pcc_mbox_request_channel(struct mbox_client *cl, int subspace_id)
 	if (rc)
 		return ERR_PTR(rc);
 
-	return &pchan->chan;
+	pcc_mchan = &pchan->chan;
+	pcc_mchan->shmem = acpi_os_ioremap(pcc_mchan->shmem_base_addr,
+					   pcc_mchan->shmem_size);
+	if (pcc_mchan->shmem)
+		return pcc_mchan;
+
+	mbox_free_channel(chan);
+	return ERR_PTR(-ENXIO);
 }
 EXPORT_SYMBOL_GPL(pcc_mbox_request_channel);
 
@@ -419,25 +427,6 @@ void pcc_mbox_free_channel(struct pcc_mbox_chan *pchan)
 }
 EXPORT_SYMBOL_GPL(pcc_mbox_free_channel);
 
-int pcc_mbox_ioremap(struct mbox_chan *chan)
-{
-	struct pcc_chan_info *pchan_info;
-	struct pcc_mbox_chan *pcc_mbox_chan;
-
-	if (!chan || !chan->cl)
-		return -1;
-	pchan_info = chan->con_priv;
-	pcc_mbox_chan = &pchan_info->chan;
-
-	pcc_mbox_chan->shmem = acpi_os_ioremap(pcc_mbox_chan->shmem_base_addr,
-					       pcc_mbox_chan->shmem_size);
-	if (!pcc_mbox_chan->shmem)
-		return -ENXIO;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(pcc_mbox_ioremap);
-
 /**
  * pcc_send_data - Called from Mailbox Controller code. Used
  *		here only to ring the channel doorbell. The PCC client
diff --git a/include/acpi/pcc.h b/include/acpi/pcc.h
index 699c1a37b8e78..0462bb9da6513 100644
--- a/include/acpi/pcc.h
+++ b/include/acpi/pcc.h
@@ -38,7 +38,6 @@ struct pcc_mbox_chan {
 extern struct pcc_mbox_chan *
 pcc_mbox_request_channel(struct mbox_client *cl, int subspace_id);
 extern void pcc_mbox_free_channel(struct pcc_mbox_chan *chan);
-extern int pcc_mbox_ioremap(struct mbox_chan *chan);
 #else
 static inline struct pcc_mbox_chan *
 pcc_mbox_request_channel(struct mbox_client *cl, int subspace_id)
@@ -46,10 +45,6 @@ pcc_mbox_request_channel(struct mbox_client *cl, int subspace_id)
 	return ERR_PTR(-ENODEV);
 }
 static inline void pcc_mbox_free_channel(struct pcc_mbox_chan *chan) { }
-static inline int pcc_mbox_ioremap(struct mbox_chan *chan)
-{
-	return 0;
-};
 #endif
 
 #endif /* _PCC_H */
-- 
2.53.0



