Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6804D2DFA5B;
	Tue, 11 Nov 2025 01:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825033; cv=none; b=gdvlsBo6WF7l38eaFGIZkHMknjALmOIGFR6CtAneemyIaP0QQEU4fp+40DRLNHn+4LaWIwFs9QWHbHw5H/lcIH21M6qwJ0E1eoG9NpwUytFv6lqY/ZzSLlESA+ptLmSmKQ6e9UnLdRqWjrGEq16lm6fyEaVeJN1+GZgLJkwvnWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825033; c=relaxed/simple;
	bh=et1rESsdhTH/P1Ql/ia6MSuDegYOayB9QpsnvHQ1U8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7DPJEY+kbJGKqO2spc+06i8xFCYsDIMghess0S2pii/eJ09igU033yyi3alhVLhKaEBtlJJlCyPMDIdysaKapQE+8upQIPaKGAFLezFH2K7oVfc9o6JuOhh6Nmx+UIggO1F7LFdSKxMFBsAnh9D53lcHre4sJ/IQeZJNxwLjiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6U2pmKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6U2pmKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028F5C19421;
	Tue, 11 Nov 2025 01:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825033;
	bh=et1rESsdhTH/P1Ql/ia6MSuDegYOayB9QpsnvHQ1U8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6U2pmKNXt5A6fst2VqQPNJs/o/5bEV8Rl3TtS8jeOPKrhl2Z7452ra7u7UNkNm8I
	 xW/wvj7QH7J3c7/Ac4Co8yC8+zm1XnbrT57DU2NalLCt7/ojbuSRtJU+9sHqA5LoPy
	 2E1BxTXpjaBlZ8k8fSCdB0wJmTN7eNOEVNaKK2zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 633/849] scsi: ufs: core: Change MCQ interrupt enable flow
Date: Tue, 11 Nov 2025 09:43:23 +0900
Message-ID: <20251111004551.736438620@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 253757797973c54ea967f8fd8f40d16e4a78e6d4 ]

Move the MCQ interrupt enable process to
ufshcd_mcq_make_queues_operational() to ensure that interrupts are set
correctly when making queues operational, similar to
ufshcd_make_hba_operational(). This change addresses the issue where
ufshcd_mcq_make_queues_operational() was not fully operational due to
missing interrupt enablement.

This change only affects host drivers that call
ufshcd_mcq_make_queues_operational(), i.e. ufs-mediatek.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 11 +++++++++++
 drivers/ufs/core/ufshcd.c  | 12 +-----------
 include/ufs/ufshcd.h       |  1 +
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index cc88aaa106da3..c9bdd4140fd04 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -29,6 +29,10 @@
 #define MCQ_ENTRY_SIZE_IN_DWORD	8
 #define CQE_UCD_BA GENMASK_ULL(63, 7)
 
+#define UFSHCD_ENABLE_MCQ_INTRS	(UTP_TASK_REQ_COMPL |\
+				 UFSHCD_ERROR_MASK |\
+				 MCQ_CQ_EVENT_STATUS)
+
 /* Max mcq register polling time in microseconds */
 #define MCQ_POLL_US 500000
 
@@ -355,9 +359,16 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_poll_cqe_lock);
 void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba)
 {
 	struct ufs_hw_queue *hwq;
+	u32 intrs;
 	u16 qsize;
 	int i;
 
+	/* Enable required interrupts */
+	intrs = UFSHCD_ENABLE_MCQ_INTRS;
+	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_INTR)
+		intrs &= ~MCQ_CQ_EVENT_STATUS;
+	ufshcd_enable_intr(hba, intrs);
+
 	for (i = 0; i < hba->nr_hw_queues; i++) {
 		hwq = &hba->uhq[i];
 		hwq->id = i;
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bd6d1d4c82427..b6d5d135527c0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -45,11 +45,6 @@
 				 UTP_TASK_REQ_COMPL |\
 				 UFSHCD_ERROR_MASK)
 
-#define UFSHCD_ENABLE_MCQ_INTRS	(UTP_TASK_REQ_COMPL |\
-				 UFSHCD_ERROR_MASK |\
-				 MCQ_CQ_EVENT_STATUS)
-
-
 /* UIC command timeout, unit: ms */
 enum {
 	UIC_CMD_TIMEOUT_DEFAULT	= 500,
@@ -372,7 +367,7 @@ EXPORT_SYMBOL_GPL(ufshcd_disable_irq);
  * @hba: per adapter instance
  * @intrs: interrupt bits
  */
-static void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
+void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
 {
 	u32 old_val = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 	u32 new_val = old_val | intrs;
@@ -8925,16 +8920,11 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
 static void ufshcd_config_mcq(struct ufs_hba *hba)
 {
 	int ret;
-	u32 intrs;
 
 	ret = ufshcd_mcq_vops_config_esi(hba);
 	hba->mcq_esi_enabled = !ret;
 	dev_info(hba->dev, "ESI %sconfigured\n", ret ? "is not " : "");
 
-	intrs = UFSHCD_ENABLE_MCQ_INTRS;
-	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_INTR)
-		intrs &= ~MCQ_CQ_EVENT_STATUS;
-	ufshcd_enable_intr(hba, intrs);
 	ufshcd_mcq_make_queues_operational(hba);
 	ufshcd_mcq_config_mac(hba, hba->nutrs);
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a4eb5bde46e88..a060fa71b2b1b 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1321,6 +1321,7 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
 
 void ufshcd_enable_irq(struct ufs_hba *hba);
 void ufshcd_disable_irq(struct ufs_hba *hba);
+void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs);
 int ufshcd_alloc_host(struct device *, struct ufs_hba **);
 int ufshcd_hba_enable(struct ufs_hba *hba);
 int ufshcd_init(struct ufs_hba *, void __iomem *, unsigned int);
-- 
2.51.0



