Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17A956741;
	Sat,  3 Feb 2024 04:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933985; cv=none; b=dV4lyOjpvRzPBN6kcxXLLfyQ1Ec0K1yu1Qsw8sHFW38YOCm4xm/hIvJsXeeUVCcPeceH3Wx4yQKJ27Wwo1f72iHVwA9VFW2vQ4Mvx8bkI1y7Me+aw+F+N+OjY8sCQaed0/DlwV1Qbvmt0ASpUldTx+oz7HGx0SWRFpFn+6bVaGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933985; c=relaxed/simple;
	bh=BNcZVunwoneIcefGu8sqSjkE4WWSVK00cDTdLxDkde0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tp12NpHJOUYvodTYgSXAtqPdg7YkI+8+N7T3XMw7EW+gHLhGlKQ+cu4hQgpm+r3cWMUZ9y9kFNbCzJ1jdabl/4uQOC0EydWI20DApJO3uMro10M4kIcv9TMKDXXvdS76HahiCA5HAdtM61uC8x+tI6zqiAxlC83HVuW4Sw4cDTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U74OnPQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U74OnPQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED60C433A6;
	Sat,  3 Feb 2024 04:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933984;
	bh=BNcZVunwoneIcefGu8sqSjkE4WWSVK00cDTdLxDkde0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U74OnPQ5uR3sFEcfZPElzDSdjYR8tE+srurhS2tHBJx3bfPa3T3SIgA1S8yLJuFa9
	 eFKA8l5o9s5zMZn77y3e95H0iqdk6XoN6PryUHsTUsVMbwWhkcvgQ+Xib1LLFsurGb
	 05xoOf0RCE8S6KJ9KfKikPMzV/gOqbp9L+5nsE1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 333/353] pds_core: Use struct pdsc for the pdsc_adminq_isr private data
Date: Fri,  2 Feb 2024 20:07:31 -0800
Message-ID: <20240203035414.321261493@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 951705151e50f9022bc96ec8b3fd5697380b1df6 ]

The initial design for the adminq interrupt was done based
on client drivers having their own adminq and adminq
interrupt. So, each client driver's adminq isr would use
their specific adminqcq for the private data struct. For the
time being the design has changed to only use a single
adminq for all clients. So, instead use the struct pdsc for
the private data to simplify things a bit.

This also has the benefit of not dereferencing the adminqcq
to access the pdsc struct when the PDSC_S_STOPPING_DRIVER bit
is set and the adminqcq has actually been cleared/freed.

Fixes: 01ba61b55b20 ("pds_core: Add adminq processing and commands")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://lore.kernel.org/r/20240129234035.69802-4-brett.creeley@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/adminq.c | 5 +++--
 drivers/net/ethernet/amd/pds_core/core.c   | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
index 5beadabc2136..68be5ea251fc 100644
--- a/drivers/net/ethernet/amd/pds_core/adminq.c
+++ b/drivers/net/ethernet/amd/pds_core/adminq.c
@@ -135,8 +135,8 @@ void pdsc_work_thread(struct work_struct *work)
 
 irqreturn_t pdsc_adminq_isr(int irq, void *data)
 {
-	struct pdsc_qcq *qcq = data;
-	struct pdsc *pdsc = qcq->pdsc;
+	struct pdsc *pdsc = data;
+	struct pdsc_qcq *qcq;
 
 	/* Don't process AdminQ when shutting down */
 	if (pdsc->state & BIT_ULL(PDSC_S_STOPPING_DRIVER)) {
@@ -145,6 +145,7 @@ irqreturn_t pdsc_adminq_isr(int irq, void *data)
 		return IRQ_HANDLED;
 	}
 
+	qcq = &pdsc->adminqcq;
 	queue_work(pdsc->wq, &qcq->work);
 	pds_core_intr_mask(&pdsc->intr_ctrl[qcq->intx], PDS_CORE_INTR_MASK_CLEAR);
 
diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index b582729331eb..0356e56a6e99 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -125,7 +125,7 @@ static int pdsc_qcq_intr_alloc(struct pdsc *pdsc, struct pdsc_qcq *qcq)
 
 	snprintf(name, sizeof(name), "%s-%d-%s",
 		 PDS_CORE_DRV_NAME, pdsc->pdev->bus->number, qcq->q.name);
-	index = pdsc_intr_alloc(pdsc, name, pdsc_adminq_isr, qcq);
+	index = pdsc_intr_alloc(pdsc, name, pdsc_adminq_isr, pdsc);
 	if (index < 0)
 		return index;
 	qcq->intx = index;
-- 
2.43.0



