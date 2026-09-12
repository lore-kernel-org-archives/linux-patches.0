Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73AF3BE643;
	Sat, 12 Sep 2026 13:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218450; cv=none; b=RXYgA4/68rgCZ07576jJu9kJse0Phv0yx7+VYZU+vc+vzGacZaBkaS4N/kVSbTjXK9H3t/5yg/cT3ESs1FmMDvi4pnuLd790Vhm8gPwpwH0bUgkewqgafzIZKEx70nuWdFafcner3LZMZ8MlmbROWL9PexiayuUPTUg0cPBumeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218450; c=relaxed/simple;
	bh=AUNbKySCqbvNdppe7nwuK44sAsQmj4nK7Gedif9XHek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZXf9RLLMjkJ09gBba+uxJ6jfmHjrYJq+1Au2thbFzxurry6Xw5RParTL9mYVEcy5bxvAycOOk0eAZ3Z9/Lr6JKjabej20nPC6+m8HRfIaWMvV8vNLxXy3dezaEr2i2AZU0l0PHzHJOkBHRsQ9nnKPMx1TRS0Sr8qTWcdfXLMNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPQ5nuQK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPQ5nuQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC32E1F000FF;
	Sat, 12 Sep 2026 13:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218448;
	bh=Vyuafvu7n9dXQNUh7VEo9Xnx+c0quhLO9mq1aPLOWEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPQ5nuQKCrMMpifKMTjy/+bS5HYRva1SZZHsq0sdVrNQoQ4rtrKvp1LLPapqvo64t
	 KzQrzM1WvOh/6KPRZFrNGCWlV5clKNB1sPCaFEChUfCrBkohnhOuWY2DWSkpLAVsP3
	 XU7zppnk/Sg3mWOTmNgW0b0MnBJUw19kOmWm7iRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	Adam Young <admiyo@os.amperecomputing.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1146/1376] mailbox: pcc: Always map the shared memory communication address
Date: Sat, 12 Sep 2026 08:59:32 +0200
Message-ID: <20260912065633.098033806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



